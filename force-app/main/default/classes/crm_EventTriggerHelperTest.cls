/*
Created By: Dinesh kumar
Object  :Event
Date: 03 May 2016
Test class for the EventTriggerHelper class

*/


@isTest

public class crm_EventTriggerHelperTest{

@testSetup static void setup() {

         crm_TestDataFactory.CreateCustomSetting(); 
       //create party level account
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt;
       
       //create EVENT
        Event eventObj= crm_TestDataFactory.createEvent();
        eventObj.whatid=partyLevelacnt.id;
    	eventObj.crm_event_completed__c=true;
        eventObj.crm_NPS_Status__c='';
        insert eventObj;
       
       }

   static testMethod void test(){
        
       Event e=[Select id, Subject, StartDateTime from Event where Subject ='Call' limit 1]; 
       System.assertequals(e.Subject,'Call');
       e.StartDateTime = System.today()-5; 
       update e;   
    }
    
   
}