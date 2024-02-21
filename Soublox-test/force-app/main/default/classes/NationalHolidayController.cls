public without sharing class NationalHolidayController {
    @AuraEnabled
    public static String getNationalHoliday() {
        NationalHolidayWrapper nationalHolidayWrapper = new NationalHolidayWrapper();

        List<National_Holidays__c > lNationalHolidays = [SELECT Name, Date__c FROM National_Holidays__c WHERE CALENDAR_YEAR(Date__c) =: System.today().year() ORDER BY Date__c ASC];

        for (National_Holidays__c nationalHoliday : lNationalHolidays) {
            if(nationalHoliday.Date__c >= System.today()){
                nationalHolidayWrapper.name = nationalHoliday.Name;
                nationalHolidayWrapper.date_x = nationalHoliday.Date__c.format();
                if(nationalHoliday.Date__c == System.today()){nationalHolidayWrapper.isHoliday = true;}
                else {
                    nationalHolidayWrapper.isHoliday = false;
                    nationalHolidayWrapper.remainingDays = (system.today()).daysBetween(Date.valueOf(nationalHoliday.Date__c));
                }
                break;
            }
        }
        
        return JSON.serialize(nationalHolidayWrapper);
    }


    private class NationalHolidayWrapper {
        String name;
        String date_x;
        Boolean isHoliday;
        Integer remainingDays;
    }
}