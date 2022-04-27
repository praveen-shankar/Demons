/*
Created By:Supriya Goel
Date:12 oct 2019 
Test class for crm_schedulercasecleanuprecords2
*/

@isTest
public class Delete_EDIErrorLogsSchedulableTest{

    static testMethod void test(){
               
        System.schedulableContext SC;
        Delete_EDIErrorLogsSchedulable sch = new Delete_EDIErrorLogsSchedulable();
        sch.execute(SC);
    }
}