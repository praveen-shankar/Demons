/* 
Date: 11 April 2019
Test class: Test class forcrm_NewCreateSegment  lightning component
*/

@isTest
public class crm_NewCreateSegment_test {
    
    @testSetup static void setup() {
        
        crm_TestDataFactory.CreateCustomSetting();
        //create party level account
        Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
        insert  partyLevelacnt;
    }
    
    static TestMethod void testCreateSegment()
    {
        System.Test.startTest();
        
        User u1 = crm_TestDataFactory.createUser();
        insert u1;
        System.runAs(u1){
            //fetch party account
            Account acc= [Select id, name from Account where name ='parent test' limit 1];
            System.assertequals(acc.Name,'parent test');
            
             Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User();
        u.Alias = 'admin';
        u.Email='admin@test.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testing';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='test@testuser1.com';
        insert u;   
            
           /* CRM_ficticous_user__mdt mdtobj= new CRM_ficticous_user__mdt();
             mdtobj.username__c ='test@testuser1.com';
             mdtobj.MasterLabel='testuser';
             mdtobj.DeveloperName ='testuser';
             insert mdtobj;*/
              
            
            
            crm_NewCreateSegment.getAllOpportunitiesServiceGroup();
            crm_NewCreateSegment.getresponsibleseller();
            
            NewSegmentWrapper wrapper= new NewSegmentWrapper();
            
            list<NewSegmentWrapper.segmentreqchange > listtemp = new List<NewSegmentWrapper.segmentreqchange >();
            
            NewSegmentWrapper.segmentreqchange obj = new NewSegmentWrapper.segmentreqchange();
          
            //obj.year='2018';
            obj.serviceGroupvalue= 'Cargo Domestic';
            obj.proposedresponsibleSeller=u.id;
            obj.chkServiceGroupvalue= true;
            String proposedSalesResponsibleManager1 =   crm_CreateSegReqFictiousUser.getproposedmanagerId( obj.proposedresponsibleSeller);
           
        listtemp.add(obj);
        
        wrapper.reqchangesegments =listtemp;
        
        String JSONString = JSON.serialize(wrapper);
        
        
       // String json= '{"accountId":acnt.id,"reqchangesegments":[{"month":"3","year":"2018","responsibleSeller":currentSalesResponsible.id,"responsibleSellermanager":currentresponsiblemanager.id,"proposedresponsibleSeller":proposedSalesResponsible.id,"proposedresponsibleSellermanager":proposedSalesResponsibleManager.id,"serviceGroupvalue":"Air","segId":segobj1.id,"flag":0}]}';
        crm_NewCreateSegment.savesegment(JSONString );  
        }
        System.Test.stopTest();  
    }
    
}