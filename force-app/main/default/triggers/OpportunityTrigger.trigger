trigger OpportunityTrigger on Opportunity (before insert, before update, after update) {
    OpportunityTriggerHandler opportunityTriggerHandler = new OpportunityTriggerHandler();
    opportunityTriggerHandler.run();
}