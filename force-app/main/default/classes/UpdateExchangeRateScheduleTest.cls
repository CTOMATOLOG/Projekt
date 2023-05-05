@isTest
public with sharing class UpdateExchangeRateScheduleTest {
    private static String CRON_EXP = '0 17 15 9 3 ? 2023';
    @isTest
    private static void testUpdateExchangeRateSchedule() {
        Test.setMock(HttpCalloutMock.class, new UpdateExchangeRateWebServiceMock());
        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new UpdateExchangeRateSchedule());
        Test.stopTest();
    }
}