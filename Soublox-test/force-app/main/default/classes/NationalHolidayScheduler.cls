global without sharing class NationalHolidayScheduler implements Schedulable {
    global void execute(SchedulableContext sc){NationalHolidayCallout.holidayCallout(String.valueOf(System.today().year()), 0);} //calling the Webservice using the year of today when this job starts
}

//snippet to schedule the job
/*NationalHolidayScheduler m = new NationalHolidayScheduler();
String sch = '0 0 0 1 1 ?';
String jobID = System.schedule('National Holiday Callout', sch, m);*/