@isTest
global with sharing class UpdateExchangeRateWebServiceMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        System.assertEquals('GET', request.getMethod());
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
        response.setBody('[{"ccy":"EUR","base_ccy":"UAH","buy":"39.40000","sale":"40.40000"},{"ccy":"USD","base_ccy":"UAH","buy":"37.85000","sale":"38.35000"}]');
        return response;
    }
}