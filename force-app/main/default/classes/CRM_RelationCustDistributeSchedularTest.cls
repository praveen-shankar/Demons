@isTest
public class CRM_RelationCustDistributeSchedularTest{  

    public static testmethod void first1(){
        Test.startTest();
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        String jobId = System.schedule('Test', CRON_EXP, new CRM_RelationCustomersDistributeSchedular() );   
        Test.stopTest();
    }  

}