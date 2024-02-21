public without sharing class NationalHolidayCallout {
    //method to execute callout
    @future(Callout=true)
    public static void holidayCallout(String ano, Integer statusCode) {//insert any value in statusCode, variable only used in Test scenarios
        //block of code to instantiate variables
        HttpRequest request = new HttpRequest();
        Service__mdt service = getService('Feriados');
        HttpResponse response;
        CalloutException calloutException;
        List<ResponseWrapper> lResponseWrapper = new List<ResponseWrapper>();
        List<National_Holidays__c> lNationalHoliday = new List<National_Holidays__c>();    
        String endpoint = service.Endpoint__c+ano;    

        //building service callout
        request.setEndPoint(endpoint);
        request.setMethod(service.Method__c);

        //making the callout
        try {
            if(!Test.isRunningTest()){response = new HTTP().send(request);}
            else{
                response = new HttpResponse();
                response.setStatusCode(statusCode);
                switch on statusCode {
                    when 200 {response.setBody('[{"date": "2021-01-01","name": "Confraternização mundial","type": "national"}]');}
                    when 404 {response.setBody('{"message": "Ano fora do intervalo suportado entre 1900 e 2199.","type": "feriados_error"}');}
                    when 500 {response.setBody('{"message": ""Erro ao calcular feriados.".","type": "feriados_range_error"}');}
                }
            }
            System.debug(response);
            //deserialize the response        
            if(response != null && response.getStatusCode() == 200){lResponseWrapper = (List<ResponseWrapper>) JSON.deserialize(response.getBody().replace('date','date_x'),List<ResponseWrapper>.class);}
            else if(response.getStatusCode() == 404 || response.getStatusCode() == 500){
                calloutException = new CalloutException();
                calloutException.setMessage(response.getBody());
                throw calloutException;
            }
        }
        catch (CalloutException e) {System.debug(e);} 

        System.debug(lResponseWrapper);
        //parse response to SObject
        if(!lResponseWrapper.isEmpty()){parseInformation(lNationalHoliday, lResponseWrapper);}
        System.debug(lNationalHoliday);

        try {insert as system lNationalHoliday;} 
        catch (DMLException e) {System.debug(e);}
    }
    //method to search Custom Metadata information
    public static Service__mdt getService(String developerName){
        return [SELECT Endpoint__c, Method__c FROM Service__mdt WHERE DeveloperName  =: developerName];
    }
    //method that convert deserialized response to SObject 
    private static void parseInformation(List<National_Holidays__c> lNationalHoliday, List<ResponseWrapper> lResponseWrapper) {
        National_Holidays__c nationalHoliday;
        for(ResponseWrapper responseWrapper : lResponseWrapper){
            nationalHoliday = new National_Holidays__c();
            nationalHoliday.Name = responseWrapper.name;
            nationalHoliday.Date__c = Date.valueOf(responseWrapper.date_x);
            nationalHoliday.Type__c = responseWrapper.type;
            lNationalHoliday.add(nationalHoliday);
        }
    }
    //class to deserialize response
    private class ResponseWrapper {
        String name;
        String date_x;
        String type;
    }
}