@isTest
public with sharing class AccountLWCControllerTest {
    @TestSetup
    static void makeData(){
        Account newAccount = new Account(Name = 'TestAccount');
        insert newAccount;
        List<Contact> newContactsList = new List<Contact>();
        newContactsList.add(new Contact(LastName='Test', Email = 'Test@gmail.com', AccountId = newAccount.Id));
        newContactsList.add(new Contact(LastName='Test2', Email = 'Test2@gmail.com', AccountId = newAccount.Id));
        insert newContactsList;
        List<Custom_Task__c> newTasksList = new List<Custom_Task__c>();
        newTasksList.add(new Custom_Task__c(Name = 'Test1', Description__c = 'Desc1', Account__c = newAccount.Id));
        newTasksList.add(new Custom_Task__c(Name = 'Test2', Description__c = 'Desc2', Account__c = newAccount.Id));
        insert newTasksList;

    }
    @isTest
    private static void getReletedContactsTest() {
        //given
        Account testAccount = [SELECT Id, Name FROM Account LIMIT 1];
        List<Contact> returnedContactList = new List<Contact>();
        //when
        Test.startTest();
        returnedContactList = AccountLWCController.getReletedContacts(testAccount.Id);
        Test.stopTest();
        //then
        System.assert(!returnedContactList.isEmpty(),'Test result list is empty');
        System.assertEquals(2, returnedContactList.size(), 'Count contacts is wrong, expected 2, but was '+returnedContactList.size());
        for (Contact contact_i : returnedContactList) {
            System.assertEquals(testAccount.Id, contact_i.AccountId, 'Contact has wrong relation with not expected Account');
        }
    }
    @isTest
    private static void deleteContactSuccessTest() {
        //given
        Account testAccount = [SELECT Id, Name FROM Account LIMIT 1];
        List<Contact> testContactsList = [SELECT Id, AccountId FROM Contact WHERE AccountId = :testAccount.Id];
        //when
        Test.startTest();
        AccountLWCController.deleteContact(testContactsList.get(0));
        Test.stopTest();
        //then
        List<Contact> resultContactsList = [SELECT Id, AccountId FROM Contact WHERE AccountId = :testAccount.Id];
        System.assertNotEquals(testContactsList.size(), resultContactsList.size(), 'Test list size after delete wasn`t changed');
        for (Contact contact_i : resultContactsList) {
            System.assertNotEquals(testContactsList.get(0).Id, contact_i.Id, 'Expected contact was not deleted');
        }

    }
    @isTest
    private static void deleteContactUnsuccessTest() {
        //given
        Account testAccount = [SELECT Id, Name FROM Account LIMIT 1];
        List<Contact> testContactsList = [SELECT Id, AccountId FROM Contact WHERE AccountId = :testAccount.Id];
        AccountLWCController.deleteContact(testContactsList.get(0));
        //when
        Test.startTest();
        try{
            AccountLWCController.deleteContact(testContactsList.get(0));
            system.assert(false, 'Should have thrown an exception');
        }catch(Exception e){
        }
        Test.stopTest();
    }
    @isTest
    private static void getReletedTaskTest() {
        //given
        Account testAccount = [SELECT Id, Name FROM Account LIMIT 1];
        Test.startTest();
        List<Custom_Task__c> response = AccountLWCController.getReletedTasks(testAccount.Id);
        Test.stopTest();
        System.assertEquals(2, response.size());

    }
    @isTest
    private static void getReletedTaskTestUnsuccess() {
        //given
        Test.startTest();
        try{
            List<Custom_Task__c> response = AccountLWCController.getReletedTasks('');
            system.assert(false, 'Should have thrown an exception');
        }catch(Exception e){
        }
        Test.stopTest();
    }

    @isTest
    private static void deleteTaskSuccessTest() {
        //given
        Account testAccount = [SELECT Id, Name FROM Account LIMIT 1];
        List<Custom_Task__c> testTaskList = [SELECT Id, Account__c FROM Custom_Task__c WHERE Account__c = :testAccount.Id];
        //when
        Test.startTest();
        AccountLWCController.deleteTask((testTaskList.get(0)).Id);
        Test.stopTest();
        //then
        List<Custom_Task__c> resultTaskList = [SELECT Id, Account__c FROM Custom_Task__c WHERE Account__c = :testAccount.Id];
        System.assertNotEquals(testTaskList.size(), resultTaskList.size(), 'Test list size after delete wasn`t changed');
        for (Custom_Task__c contact_i : resultTaskList) {
            System.assertNotEquals((testTaskList.get(0)).Id, contact_i.Id, 'Expected contact was not deleted');
        }

    }
    @isTest
    private static void deleteTaskUnsuccessTest() {
        //given
        Account testAccount = [SELECT Id, Name FROM Account LIMIT 1];
        List<Custom_Task__c> testTaskList = [SELECT Id, Account__c FROM Custom_Task__c WHERE Account__c = :testAccount.Id];
        AccountLWCController.deleteTask((testTaskList.get(0)).Id);
        //when
        Test.startTest();
        try{
            AccountLWCController.deleteTask((testTaskList.get(0)).Id);
            system.assert(false, 'Should have thrown an exception');
        }catch(Exception e){
        }
        Test.stopTest();
    }
}