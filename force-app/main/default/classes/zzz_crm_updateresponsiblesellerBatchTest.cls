@isTest
public class zzz_crm_updateresponsiblesellerBatchTest {
    @testSetUp
    static void insertData(){
        
    //create party level account   
    crm_TestDataFactory.CreateCustomSetting();
    Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
    //partyLevelacnt.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
    partyLevelacnt.name='Testparty';
    insert  partyLevelacnt; 
    
    //create relation level accounts  
    Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
    relationLevelacnt1.parentId=partyLevelacnt.id;
    relationLevelacnt1.crm_Customer_Number__c='12345';
    //relationLevelacnt1.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
    insert  relationLevelacnt1;
        
    Account relationLevelacnt2= crm_TestDataFactory.createRelationlevelAccount();
    relationLevelacnt2.parentId=partyLevelacnt.id;
    relationLevelacnt2.crm_Customer_Number__c='67890';
    //relationLevelacnt2.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
    insert  relationLevelacnt2;
    
    //create four user
    User currentSalesResponsibleManager = crm_TestDataFactory.createUser('currentSalesResponsibleManager','curU');
    insert currentSalesResponsibleManager;
        
    User proposedSalesResponsibleManager = crm_TestDataFactory.createUser('proposedSalesResponsibleManager','curM');
    insert proposedSalesResponsibleManager;
        
    User currentSalesResponsible = crm_TestDataFactory.createUser('currentSalesResponsible','propU');
    currentSalesResponsible.ManagerId = currentSalesResponsibleManager.id;
    insert currentSalesResponsible;
        
    User proposedSalesResponsible = crm_TestDataFactory.createUser('proposedSalesResponsible','propM');
    proposedSalesResponsible.ManagerId = proposedSalesResponsibleManager.id;
    insert proposedSalesResponsible;
        
    //create product
    Product2 Prod1=crm_TestDataFactory.createProduct();
    prod1.crm_ERP_Product_ID__c ='C200';
    prod1.crm_global_Service_Area__c ='Logistics';
    prod1.crm_global_Service_Group__c ='Air';
    prod1.crm_global_Service_Family__c='Air';
    insert Prod1;
    
    Product2 Prod2=crm_TestDataFactory.createProduct();
    prod2.crm_ERP_Product_ID__c ='C201';
    prod2.crm_global_Service_Area__c ='Logistics';
    prod2.crm_global_Service_Group__c ='Express';
    prod2.crm_global_Service_Family__c='Express';
    insert Prod2;
    
    //insert segments
    crm_segment__c segobj1= crm_TestDataFactory.createSegment();
    segobj1.crm_Account__c= partyLevelacnt.id;
    segobj1.crm_Service_Group__c ='Air';
    segobj1.crm_Sales_Responsible__c =currentSalesResponsible.id;
    insert segobj1;  
    
    //insert segments
    crm_segment__c segobj2=crm_TestDataFactory.createSegment();
    segobj2.crm_Account__c= partyLevelacnt.id;
    segobj2.crm_Service_Group__c ='Express';
    segobj2.crm_Sales_Responsible__c =currentSalesResponsible.id;
    insert segobj2;  
    
    crm_segment__c segobj3= crm_TestDataFactory.createSegment();
    segobj3.crm_Account__c= relationLevelacnt1.id;
    segobj3.crm_Service_Group__c ='Post';
    segobj3.crm_Sales_Responsible__c =currentSalesResponsible.id;
    insert segobj3;  
    
    //insert rev lines in case of update scenario
    crm_Revenue_Line__c revLineObj=new crm_Revenue_Line__c();
    revLineObj.crm_Account__c = relationLevelacnt1.id;
    revLineObj.crm_Product__c = prod1.id;
    revLineObj.crm_Transaction_Date__c =Date.newInstance(2019, 7, 1) ;
    revLineObj.crm_Amount__c = 1000;
    insert revLineObj;
    
    //insert rev lines
    crm_Revenue_Line__c revLineObj1=new crm_Revenue_Line__c();
    revLineObj1.crm_Account__c = relationLevelacnt1.id;
    revLineObj1.crm_Product__c = prod1.id;
    revLineObj1.crm_Transaction_Date__c =System.today();
    revLineObj1.crm_Amount__c = 1000;
    insert revLineObj1;
        
    //insert forecast
    crm_Forecast__c obj= new crm_Forecast__c();
    obj.crm_Customer__c= partyLevelacnt.id;
    obj.crm_Date__c= Date.newInstance(2019, 8, 1) ;
    obj.crm_Product__c = prod1.id;
    obj.Target_Responsible__c = currentSalesResponsible.id;
    obj.crm_Target_Value__c = 100;
    obj.Target_Category__c ='Forecast';
    insert obj ; 
 

     
    //insert Segment_Change_Request__c
    Segment_Change_Request__c changeReq = new Segment_Change_Request__c();
    changeReq.Customer__c = partyLevelacnt.id;
    changeReq.Start_Date__c = System.today().adddays(-5);
    changeReq.Status__c = 'Approved';
    changeReq.Service_Group__c = 'Air';
    changeReq.Current_Sales_Responsible__c = currentSalesResponsible.id;
    changeReq.Proposed_Sales_Responsible__c = proposedSalesResponsible.id;
    insert changereq;
        

    Segment_Change_Request__c changeReq1 = new Segment_Change_Request__c();
    changeReq1.Customer__c = partyLevelacnt.id;
    changeReq1.Start_Date__c = System.today().adddays(-10);
    changeReq1.Status__c = 'Approved';
    changeReq1.Service_Group__c = 'Express';
    changeReq1.Current_Sales_Responsible__c = currentSalesResponsible.id;
    changeReq1.Proposed_Sales_Responsible__c = proposedSalesResponsible.id;
    insert changeReq1;
    
    Segment_Change_Request__c changeReq2 = new Segment_Change_Request__c();
    changeReq2.Customer__c = partyLevelacnt.id;
    changeReq2.Start_Date__c = System.today().adddays(-100);
    changeReq2.Status__c = 'Completed';
    changeReq2.Service_Group__c = 'Air';
    changeReq2.Current_Sales_Responsible__c = currentSalesResponsible.id;
    changeReq2.Proposed_Sales_Responsible__c = proposedSalesResponsible.id;
    insert changeReq2;
    
      Segment_Change_Request__c changeReq3 = new Segment_Change_Request__c();
    changeReq3.Customer__c = partyLevelacnt.id;
    changeReq3.Start_Date__c = System.today().adddays(-10);
    changeReq3.Status__c = 'Submitted';
    changeReq3.Service_Group__c = 'Offshore';
    changeReq3.Current_Sales_Responsible__c = currentSalesResponsible.id;
    changeReq3.Proposed_Sales_Responsible__c = proposedSalesResponsible.id;
    insert changeReq3;
    
    //insert environment setting
    environment_settings__c setting  = new environment_settings__c();
    setting.name = 'SystemadminProfileid';
    String Profileid =[Select id from Profile where name='System Administrator' limit 1].id;
    setting.value__c = Profileid;
    insert setting;
    
    }
    testMethod static void segmentchangereqTest()
    {
    
        System.Test.StartTest();
        crm_updateresponsibleseller_Batch batchObj=new crm_updateresponsibleseller_Batch();
        Database.ExecuteBatch(batchObj);
        System.Test.StopTest();
    }
    
    testmethod static void segchangereqpagetest(){
    
        Segment_Change_Request__c  obj= [Select id, Service_Group__c from Segment_Change_Request__c   where Service_Group__c  ='Air' limit 1];
    
        ApexPages.StandardController sc = new ApexPages.standardController(obj);
        crm_responsiblesellerController cont= new crm_responsiblesellerController(sc);
        cont.updateobjects();
          
    }
    
    testmethod static void component_testmethod(){
    
        Account acnt = [Select id from Account where name ='Testparty' limit 1];
        
    
        crm_CreateSegmentRegChange.getSegments(acnt.id);
        
        crm_segment__c segobj1 =[Select id, crm_Service_Group__c from crm_segment__c where crm_Service_Group__c ='Air' limit 1];
        List<String> selectedlists= new List<String>();
        selectedlists.add(segobj1.crm_Service_Group__c) ;        
        
        crm_CreateSegmentRegChange.getSegmentList(segobj1.id);
        
        crm_CreateSegmentRegChange.getSegmentCompleted();
        crm_CreateSegmentRegChange.getSegmentNotApproved();
        crm_CreateSegmentRegChange.getSegmentToBeApproved();
        crm_CreateSegmentRegChange.getSegmentApproved();
        crm_CreateSegmentRegChange.getmonth();
        crm_CreateSegmentRegChange.getyear();
        
        
        //create admin user
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
        u.UserName='testresponsible@testuser1.com';
        u.crm_User_Type__c='Sales';
        insert u;   
    
        
        crm_CreateSegmentRegChange.searchDB('User','Name','Id',4,'Name','Test');
        crm_CreateSegmentRegChange.initiateBatch(selectedlists);
        crm_CreateSegmentRegChange.approverecordsfn(selectedlists);
        
        User currentresponsiblemanager=[Select id, alias from User where alias='curU' limit 1];
        User proposedSalesResponsibleManager = [Select id, alias from User where alias='curM' limit 1];
        User currentSalesResponsible = [Select id, alias from User where alias='propU' limit 1];
        User proposedSalesResponsible = [Select id, alias from User where alias='propM' limit 1];
        
        system.runAs(currentresponsiblemanager){
         crm_CreateSegmentRegChange.getSegmentToBeApproved();
        
        }
        
        crm_segment__c segobj2 =[Select id, crm_Service_Group__c from crm_segment__c where crm_Service_Group__c ='Post' limit 1];
        
        SegmentWrapper wrapper= new SegmentWrapper();
        wrapper.accountId= acnt.id;
        
        List<SegmentWrapper.segmentreqchange> listtemp = new   List<SegmentWrapper.segmentreqchange>();
        
        SegmentWrapper.segmentreqchange obj = new SegmentWrapper.segmentreqchange();
        obj.month='3';
        //obj.year='2018';
        obj.responsibleSeller= currentSalesResponsible.id;
        obj.responsibleSellermanager=currentresponsiblemanager.id;
        obj.proposedresponsibleSeller = proposedSalesResponsible.id;
        obj.proposedresponsibleSellermanager=proposedSalesResponsibleManager.id;
        obj.serviceGroupvalue ='Post';
        obj.segId= segobj2.id;
       
        listtemp.add(obj);
        
        wrapper.reqchangesegments=listtemp;
        
        String JSONString = JSON.serialize(wrapper);
         
          
        
        
        
        
       // String json= '{"accountId":acnt.id,"reqchangesegments":[{"month":"3","year":"2018","responsibleSeller":currentSalesResponsible.id,"responsibleSellermanager":currentresponsiblemanager.id,"proposedresponsibleSeller":proposedSalesResponsible.id,"proposedresponsibleSellermanager":proposedSalesResponsibleManager.id,"serviceGroupvalue":"Air","segId":segobj1.id,"flag":0}]}';
        crm_CreateSegmentRegChange.savesegment(JSONString );  
        
              
          
    }
}