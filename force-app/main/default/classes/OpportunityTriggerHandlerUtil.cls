public with sharing class OpportunityTriggerHandlerUtil {
    final static String CLOSED_WON_STAGE = 'Closed won';
    final static String ERROR_MSG_NO_PRODUCTS = 'This opportunity must have products!';
    final static String DRAFT_STATUS = 'Draft';
    public static void closeDateHandler(Map<id, Opportunity> pOldMap, List<Opportunity> pNewOpportunitiesList) {
        for (Opportunity opportunity_i : pNewOpportunitiesList) {
                opportunity_i.CloseDate = Date.today().addMonths(3);
        }
    }
    public static void changedStageNameToClosedWon(Map<id, Opportunity> pOldMap, List<Opportunity> pNewOpportunitiesList) {
        List<AggregateResult>  aggregateResultList= [SELECT Count(Product2Id) sumProducts, OpportunityId FROM OpportunityLineItem WHERE OpportunityId IN :pNewOpportunitiesList GROUP BY OpportunityId];
        Map<Id,Integer> opportunityEquipmentCountMap = new Map<Id,Integer>();
        List<OpportunityLineItem> equipmentsInOpportunityList = [SELECT Product2Id, OpportunityId FROM OpportunityLineItem WHERE OpportunityId IN :pNewOpportunitiesList];
        for (AggregateResult aggRes_i : aggregateResultList) {
            opportunityEquipmentCountMap.put((id)aggRes_i.get('OpportunityId'), Integer.valueOf(aggRes_i.get('sumProducts')));
        }
        for (Opportunity opportunity_i : pNewOpportunitiesList) {
            if(pOldMap.get(opportunity_i.id).StageName != CLOSED_WON_STAGE 
                && opportunity_i.StageName == CLOSED_WON_STAGE){
                if (opportunityEquipmentCountMap.get(opportunity_i.id) == null)
                    opportunity_i.addError(ERROR_MSG_NO_PRODUCTS);
                else
                    opportunity_i.CloseDate = Date.today();
            }
        }
    }
    public static void createNewOrders(Map<id, Opportunity> pOldMap, List<Opportunity> pNewOpportunitiesList){
        Map<id, Opportunity> newOpportunitiesMap = new Map<id, Opportunity>();
        for(Opportunity opportunity_i: pNewOpportunitiesList){
            newOpportunitiesMap.put(opportunity_i.id,opportunity_i);
        }
        PricebookEntry pricebookEntry = [SELECT id FROM PricebookEntry WHERE Pricebook2Id = :pNewOpportunitiesList.get(0).Pricebook2Id Limit 1];
        List<OpportunityLineItem> equipmentsInOpportunityList = [SELECT Product2Id, OpportunityId, Quantity, ListPrice, UnitPrice FROM OpportunityLineItem WHERE OpportunityId IN :pNewOpportunitiesList];
        Map<id,Order> newOrdersToOpportunityMap = new Map<id,Order>();
        List<OrderItem> itemsForOrdersList = new List<OrderItem>();
        for (Opportunity opportunity_i : pNewOpportunitiesList) {
            if(pOldMap.get(opportunity_i.id).StageName != CLOSED_WON_STAGE && opportunity_i.StageName == CLOSED_WON_STAGE)
                newOrdersToOpportunityMap.put(opportunity_i.id, new Order(OpportunityId = opportunity_i.id, Pricebook2Id = opportunity_i.Pricebook2Id, AccountId = opportunity_i.AccountId, Status = DRAFT_STATUS, effectiveDate = Date.today()));
        }
        insert newOrdersToOpportunityMap.values();
        for(OpportunityLineItem equipment_i: equipmentsInOpportunityList){
            if(pOldMap.get(equipment_i.OpportunityId).StageName != CLOSED_WON_STAGE 
                            && newOpportunitiesMap.get(equipment_i.OpportunityId).StageName == CLOSED_WON_STAGE){
                itemsForOrdersList.add(
                    new OrderItem(
                        Product2Id = equipment_i.Product2Id
                        , OrderId = newOrdersToOpportunityMap.get(equipment_i.OpportunityId).id
                        , Quantity = equipment_i.Quantity
                        , UnitPrice = equipment_i.UnitPrice
                        , PricebookEntryId = pricebookEntry.id
                        , Created_from_Opportunity_Item__c = equipment_i.OpportunityId
                        , ListPrice = equipment_i.ListPrice
                    )
                );
            }
        }
        insert itemsForOrdersList;
    }
}