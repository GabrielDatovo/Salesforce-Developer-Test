@isTest
public without sharing class NationalHolidayScheduler_tst {
    @IsTest
    static void testScheduleJob(){
        
        Test.startTest();
            NationalHolidayScheduler m = new NationalHolidayScheduler();
            String sch = '0 0 0 1 1 ?';
            String jobID = System.schedule('National Holiday Callout', sch, m);
        Test.stopTest();
        
    }
}