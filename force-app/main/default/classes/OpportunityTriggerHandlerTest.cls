@isTest
public with sharing class OpportunityTriggerHandlerTest {
    final static String START_STAGE_NAME = 'Prospecting';
    final static String CLOSED_WON_STAGE_NAME = 'Closed won';
    //Id pricebookId = Test.getStandardPricebookId();
    @TestSetup
    static void makeData(){
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        List<Product2> newProductsList = new List<Product2>();
        newProductsList.add(new Product2(Cost__c = 100, Replacement_Part__c = true, Name = 'Engine', Lifespan_Months__c = 100, Current_Inventory__c = 5, Warehouse_SKU__c = '1203012', Maintenance_Cycle__c = 30 ,IsActive = true));
        newProductsList.add(new Product2(Cost__c = 200, Replacement_Part__c = true, Name = 'Wheels', Lifespan_Months__c = 100, Current_Inventory__c = 5, Warehouse_SKU__c = '1203013', Maintenance_Cycle__c = 30 ,IsActive = true));
        insert newProductsList;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = newProductsList.get(0).Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        List<Opportunity> newOpportunitiesList = new List<Opportunity>();
        newOpportunitiesList.add(new Opportunity(Name = 'Test opportunity 1', AccountId = testAccount.id, StageName = START_STAGE_NAME, Pricebook2Id = Test.getStandardPricebookId()));
        newOpportunitiesList.add(new Opportunity(Name = 'Test opportunity 2', AccountId = testAccount.id, StageName = START_STAGE_NAME, Pricebook2Id = Test.getStandardPricebookId()));
        insert newOpportunitiesList;
    }
    @isTest
    private static void closeDateWhenCreateTest() {
        //given
        Account testAccount = [SELECT id FROM Account LIMIT 1];
        List<Opportunity> newOpportunitiesList = new List<Opportunity>();
        for (Integer i = 0; i < 10; i++) {
            newOpportunitiesList.add(new Opportunity(Name = 'Test '+i, AccountId = testAccount.id, StageName = START_STAGE_NAME));
        }
        //when
        Test.startTest();
        insert newOpportunitiesList;
        Test.stopTest();
        //then
        List<Opportunity> OpportunitiesCheckingList = [SELECT id, Name, StageName, AccountId, CloseDate FROM Opportunity];
        for (Opportunity OpportunitiesChecking_i : OpportunitiesCheckingList) {
            System.assertEquals(Date.today().addMonths(3), OpportunitiesChecking_i.CloseDate, 'Trigger work wrong date!');
            System.assertEquals(START_STAGE_NAME, OpportunitiesChecking_i.StageName, 'Trigger work wrong with stage name!');
            System.assertEquals(testAccount.id, OpportunitiesChecking_i.AccountId, 'Trigger work wrong with account id!');
        }
    }
    @isTest
    private static void changedStageNameToClosedWonTest() {
        //given
        Account testAccount = [SELECT id FROM Account LIMIT 1];
        List<Opportunity> opportunitiesList = [SELECT id, StageName FROM Opportunity];
        List<Product2> equipmentsList = [SELECT id, Cost__c, Replacement_Part__c, Lifespan_Months__c, Current_Inventory__c FROM Product2];
        PricebookEntry pricebookEntry = [SELECT id FROM PricebookEntry WHERE Pricebook2Id = :Test.getStandardPricebookId()];
        //Connect opportunity with equipmentsList
        List<OpportunityLineItem> opportunityLineItemsList = new List<OpportunityLineItem>();
        opportunityLineItemsList.add(new OpportunityLineItem(Product2Id = equipmentsList.get(0).id, OpportunityId = opportunitiesList.get(0).id, Quantity = 1, TotalPrice = 200, PricebookEntryId = pricebookEntry.id));
        insert opportunityLineItemsList;
        //when
        for(Opportunity opportunities_i: opportunitiesList){
            opportunities_i.StageName = CLOSED_WON_STAGE_NAME;
        }
        Test.startTest();
        Database.update(opportunitiesList, false);
        Test.stopTest();
        //then
        System.assertEquals(1, [SELECT id, StageName FROM Opportunity WHERE StageName =: CLOSED_WON_STAGE_NAME].size());
    }
    @isTest
    private static void createNewOrdersTest() {
        //given
        Opportunity opportunity = [SELECT id, StageName FROM Opportunity LIMIT 1];
        List<Product2> equipmentsList = [SELECT id, Cost__c, Replacement_Part__c, Lifespan_Months__c, Current_Inventory__c FROM Product2];
        List<OpportunityLineItem> opportunityLineItemsList = new List<OpportunityLineItem>();
        PricebookEntry pricebookEntry = [SELECT id FROM PricebookEntry WHERE Pricebook2Id = :Test.getStandardPricebookId()];
        opportunityLineItemsList.add(new OpportunityLineItem(Product2Id = equipmentsList.get(0).id, OpportunityId = opportunity.id, Quantity = 1, TotalPrice = 200, PricebookEntryId = pricebookEntry.id));
        opportunityLineItemsList.add(new OpportunityLineItem(Product2Id = equipmentsList.get(1).id, OpportunityId = opportunity.id, Quantity = 1, TotalPrice = 200, PricebookEntryId = pricebookEntry.id));
        insert opportunityLineItemsList;

        //when
        opportunity.StageName = CLOSED_WON_STAGE_NAME;

        Test.startTest();
        update opportunity;
        Test.stopTest();
        //then
        List<Order> ordersList = [SELECT id FROM Order];
        List<OrderItem> orderItemsList = [SELECT id, Created_from_Opportunity_Item__c FROM OrderItem];
        System.assertEquals(1, ordersList.size());
        System.assertEquals(2, orderItemsList.size());
        for(OrderItem orderItem_i: orderItemsList){
            System.assertEquals(opportunity.id, orderItem_i.Created_from_Opportunity_Item__c);
        }

    }

}