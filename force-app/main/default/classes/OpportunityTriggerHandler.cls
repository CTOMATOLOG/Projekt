public with sharing class OpportunityTriggerHandler extends TriggerHandler{
    protected override void beforeInsert() {
        OpportunityTriggerHandlerUtil.closeDateHandler(null, Trigger.new);
    }
    protected override void beforeUpdate(){
        OpportunityTriggerHandlerUtil.changedStageNameToClosedWon((Map<Id,Opportunity>)Trigger.oldMap, Trigger.new);
    }
    protected override void afterUpdate(){
        OpportunityTriggerHandlerUtil.createNewOrders((Map<Id,Opportunity>)Trigger.oldMap, Trigger.new);
    }
}