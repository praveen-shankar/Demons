/*
Created By:supriya goel
Date: 20 jan 2017 
test class for lead to case

*/

@isTest

public class cs_lead_to_caseTest{

    @testSetup static void setup() {
    
      Lead leadobj= new lead();
      leadobj.lastname='Test';
      leadobj.company='test company';
      leadobj.email='test@test.com';
      leadobj.status='New';
      leadobj.phone='123456';
      leadobj.crm_Customer_Requirement__c='Test';
      leadobj.city='testcity';
     // leadobj.country='india';
      leadobj.state='Test state';
      leadobj.PostalCode ='123';
      leadobj.street='test';
      leadobj.fax='11111';
      leadobj.leadsource='Web';
      leadobj.crm_organization_number__c='111';
      
      insert leadobj;
    
    }
    
      static testMethod void converttocasetest(){
     
        Lead leadobj= [select id from lead where lastname='Test' limit 1];
        
              
        System.Test.startTest();   
        ApexPages.StandardController sc = new ApexPages.standardController(leadobj);
        cs_leadtocase obj = new cs_leadtocase (sc);
        obj.saveCase();
        
        System.Test.stopTest();    

        }
        
        static testMethod void converttocasetest1(){
        
         Case c = new Case();
         insert c;
     
        Lead leadobj = new lead(lastname='testlead', company='test' , email='test@test.com');
        leadobj.cs_case_Id__c=c.id;
        insert leadobj;
       
        
              
        System.Test.startTest();   
        ApexPages.StandardController sc = new ApexPages.standardController(leadobj);
        cs_leadtocase obj = new cs_leadtocase (sc);
        obj.saveCase();
        
        System.Test.stopTest();    

        }


}