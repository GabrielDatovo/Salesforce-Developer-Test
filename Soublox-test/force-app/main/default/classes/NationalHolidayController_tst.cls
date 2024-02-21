@isTest
public without sharing class NationalHolidayController_tst {
    @TestSetup
    static void makeData(){
        List<National_Holidays__c > lNationalHolidays = new List<National_Holidays__c>();
        National_Holidays__c nationalHoliday;

        for (Integer i = 0; i < 12; i++) {
            nationalHoliday = new National_Holidays__c();
            nationalHoliday.Name = 'test '+String.valueOf(i);
            nationalHoliday.Date__c = Date.newInstance(System.today().year(), i++, 30);
            lNationalHolidays.add(nationalHoliday);
        }

        insert as system nationalHoliday;
    }

    @IsTest
    static void testController(){
        Test.startTest();
            NationalHolidayController.getNationalHoliday();
        Test.stopTest();
    }

}