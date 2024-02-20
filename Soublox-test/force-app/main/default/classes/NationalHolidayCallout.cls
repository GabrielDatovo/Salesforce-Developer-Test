public without sharing class NationalHolidayCallout {
    @future(Callout=true)
    public static void holidayCallout(String ano) {
        HttpRequest request = new HttpRequest();
        Service__mdt service = getService('Feriados');
        String endpoint = service.Endpoint__c+ano;
        request.setEndPoint(endpoint);
        request.setMethod(service.Method__c);
        HttpResponse response;
        List<ResponseWrapper> lResponseWrapper;
        List<National_Holidays__c> lNationalHoliday = new List<National_Holidays__c>();

        try {response = new HTTP().send(request);} 
        catch (CalloutException e) {System.debug(e);}
        
        if(response != null){lResponseWrapper = (List<ResponseWrapper>) JSON.deserialize(response.getBody().replace('date','date_x'),List<ResponseWrapper>.class);}

        System.debug(lResponseWrapper);

        if(!lResponseWrapper.isEmpty()){parseInformation(lNationalHoliday, lResponseWrapper);}

        System.debug(lNationalHoliday);
    }

    public static Service__mdt getService(String developerName){
        return [SELECT Endpoint__c, Method__c FROM Service__mdt WHERE DeveloperName  =: developerName];
    }

    public static void parseInformation(List<National_Holidays__c> lNationalHoliday, List<ResponseWrapper> lResponseWrapper) {
        National_Holidays__c sNationalHoliday;
        for(ResponseWrapper responseWrapper : lResponseWrapper){
            sNationalHoliday = new National_Holidays__c();
            sNationalHoliday.Name = responseWrapper.name;
            sNationalHoliday.Date__c = Date.valueOf(responseWrapper.date_x);
            sNationalHoliday.Type__c = responseWrapper.type;
            lNationalHoliday.add(sNationalHoliday);
        }
    }

    public class ResponseWrapper {
        String name;
        String date_x;
        String type;
    }
}