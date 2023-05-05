public with sharing class AccountLWCController {
    @AuraEnabled
    public static List<Contact> getReletedContacts(Id pAccountId) {
        return (List<Contact>)[SELECT Id, Name, LastName, Email, Phone, AccountId FROM Contact WHERE AccountId = :pAccountId];
    }
    @AuraEnabled
    public static void deleteContact(Contact pContact){
        try {
            delete pContact;
        } catch (Exception e) {
            throw new AuraHandledException('You can`t delete this record because: '+e.getMessage());
        }
    }
    @AuraEnabled
    public static List<Custom_Task__c> getReletedTasks(Id pAccountId){
        try {
            return (List<Custom_Task__c>)[SELECT Id, Name, Description__c, CreatedDate FROM Custom_Task__c WHERE Account__c = :pAccountId ORDER BY CreatedDate];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static void deleteTask(Id pTask){
        try {
            Custom_Task__c taskToDelete = new Custom_Task__c(Id = (Id)pTask);
            delete taskToDelete ;
        } catch (Exception e) {
            throw new AuraHandledException('You can`t delete this record because: '+e.getMessage());
        }
    }
}