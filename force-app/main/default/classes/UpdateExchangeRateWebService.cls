public with sharing class UpdateExchangeRateWebService implements Queueable{
    @future(callout=true)
    public static void doUpdateExchengeRate() {
        PrivatBank_Api_Setting__c apiSettings = PrivatBank_Api_Setting__c.getOrgDefaults();
        List<Exchange_Rate__c> exchangeRateList = Exchange_Rate__c.getall().values();
        NamedCredential privatEndpoint = [SELECT DeveloperName, Endpoint FROM NamedCredential WHERE DeveloperName = 'PrivatBank' LIMIT 1];
        Map<String, Exchange_Rate__c> ISOCodeToExchengeRateMap = new Map<String, Exchange_Rate__c>();
        for (Exchange_Rate__c exchange_i : exchangeRateList) {
            ISOCodeToExchengeRateMap.put(exchange_i.ISO_Code__c,exchange_i);
        }
        List<Exchange_Rate__c> exchangeRateResultList = new List<Exchange_Rate__c>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(privatEndpoint.Endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
            List<object> returnedResponseList = (List<object>) JSON.deserializeUntyped(response.getBody());
            List<Map<String, Object>> resultList = new List<Map<String, Object>>();
            for(Object response_i: returnedResponseList){
                resultList.add((Map<String, Object>)response_i);
            }

            for (Map<String, Object> result_i : resultList){
                try {
                    ISOCodeToExchengeRateMap.get((String)result_i.get('ccy')).Rate__c = Decimal.ValueOf(String.valueOf(result_i.get('buy')));
                    exchangeRateResultList.add(ISOCodeToExchengeRateMap.get((String)result_i.get('ccy')));
                } catch (Exception e) {
                    exchangeRateResultList.add(new Exchange_Rate__c(Name = (String)result_i.get('ccy')
                    , ISO_Code__c = (String)result_i.get('ccy')
                    , Rate__c= Decimal.ValueOf(String.valueOf(result_i.get('buy')))));
                }

            }
            upsert exchangeRateResultList;

        }

    }
    public void execute(QueueableContext context) {
        doUpdateExchengeRate();
    }
}