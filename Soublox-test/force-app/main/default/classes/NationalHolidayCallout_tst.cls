@isTest
public without sharing class NationalHolidayCallout_tst {
    @IsTest
    static void testStatus200(){
        Test.startTest();
            NationalHolidayCallout.holidayCallout(String.valueOf(System.today().year()),200);
        Test.stopTest();
    }
    @IsTest
    static void testStatus404(){
        Test.startTest();
            NationalHolidayCallout.holidayCallout(String.valueOf(System.today().year()),404);
        Test.stopTest();
    }
    @IsTest
    static void testStatus500(){
        Test.startTest();
            NationalHolidayCallout.holidayCallout(String.valueOf(System.today().year()),500);
        Test.stopTest();
    }
}