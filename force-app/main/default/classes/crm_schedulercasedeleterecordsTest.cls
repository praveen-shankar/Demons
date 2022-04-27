/*
Created By:Supriya Goel
Date:31 jan 2019
Test class for crm_schedulercasedeleterecords 
*/

@isTest
public class crm_schedulercasedeleterecordsTest{

    static testMethod void test(){
    
    QueueSobject queue = [Select QueueId from QueueSobject where Queue.DeveloperName = 'anonymize_cases' and SobjectType='Case' limit 1];
     Case_Anonymisation_Days__c datesetting = new Case_Anonymisation_Days__c();
        datesetting.Name = 'Default';
        datesetting.Number_Of_Days__c = 1277;
        datesetting.QueueId__c = queue.QueueId;
        datesetting.queue_name__c = 'anonymize_cases';
        insert datesetting;
        
    System.schedulableContext SC;
    crm_schedulercasedeleterecords sch = new crm_schedulercasedeleterecords ();
    sch.execute(SC);
    }
}