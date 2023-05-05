@isTest
public with sharing class SearchControllerTest {
    @TestSetup
    static void makeData(){
        Account newAccount = new Account(Name = 'TestAccount');
        insert newAccount;
        List<Contact> newContactsList = new List<Contact>();
        newContactsList.add(new Contact(LastName='Test', Email = 'Test@gmail.com', AccountId = newAccount.Id));
        newContactsList.add(new Contact(LastName='Test2', Email = 'Test2@gmail.com', AccountId = newAccount.Id));
        insert newContactsList;
    }
    @isTest
    private static void getNameFieldTest() {
        //given
        String result;
        //when
        Test.startTest();
        result = SearchController.getNameField('Account');
        Test.stopTest();
        //then
        System.assertEquals('Name', result, 'Name field is not as expected');
    }
    @isTest
    private static void getObjectLabelTest() {
        //given
        String result;
        //when
        Test.startTest();
        result = SearchController.getObjectLabel('Product2');
        Test.stopTest();
        //then
        System.assertEquals('Equipment', result, 'Label is not as expected');
    }
    @isTest
    private static void findInAllFieldsSuccessTest() {
        //given
        list<Id>idList = new list<Id>();
        idList.add([SELECT Id, Name FROM Account].Id);
        Test.setFixedSearchResults(idList);
        //when
        Test.startTest();
        List<Object> resultList = SearchController.findInAllFields('Test', 'Account', SearchController.getNameField('Account'));
        Test.stopTest();
        //then
        System.assert(!resultList.isEmpty(), 'Result list is empty');
        System.assertEquals(1, resultList.size());

    }
    @isTest
    private static void findInAllFieldsUnsuccessTest() {

        //when
        Test.startTest();
        List<Object> resultList = SearchController.findInAllFields('', 'Account', SearchController.getNameField('Account'));
        Test.stopTest();
        //then
        System.assertEquals(null, resultList);

    }
}