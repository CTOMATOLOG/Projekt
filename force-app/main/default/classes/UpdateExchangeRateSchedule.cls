public with sharing class UpdateExchangeRateSchedule implements Schedulable{
    public void execute(SchedulableContext ctx){
        System.enqueueJob(new UpdateExchangeRateWebService());
    }
}