@isTest
public class crm_SetdetailsonOpportunity_BatchTest {
  @testSetUp
    static void insertData(){
        
    //create party level account   
    crm_TestDataFactory.CreateCustomSetting();
    Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
    partyLevelacnt.Customer_Converted__c='Converted';
    insert  partyLevelacnt; 
    
    //create relation level accounts  
    Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
    relationLevelacnt1.parentId=partyLevelacnt.id;
    relationLevelacnt1.crm_Customer_Number__c='12345';
    //relationLevelacnt1.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
    insert  relationLevelacnt1;
     
    User user1 = crm_TestDataFactory.createUser('owner','owner');
    insert user1;
        
      Contact c = crm_TestDataFactory.createContact();
        c.accountid=partyLevelacnt.id;
        c.email='testopp@test.com';
        insert c;
        
        
    crm_Agreement__c agr= crm_TestDataFactory.createAgreement();
    agr.crm_Account__c = partyLevelacnt.id;
    agr.crm_Status__c ='Active';
    agr.crm_Agreement_Service_Family__c ='Pakker B2C';
    agr.crm_Agreement_Service_Group__c='Parcels – Domestic Norway';
     agr.OwnerId=user1.id;
     agr.crm_Agreement_Primary_Contact__c=c.id;
    insert agr;
        
        
        
       Opportunity oppold = new Opportunity();
         string RecordTypeId = [Select Id From RecordType where sobjecttype = 'Opportunity' and name ='Parcels Domestic Norway' limit 1].Id;  
        oppold.accountId=partyLevelacnt.id;
        oppold.name='Parcels – Domestic Norway';
        oppold.CloseDate=date.today().addDays(20);
        oppold.StageName='New Opportunity';
        oppold.crm_Opp_Service_Group__c='Parcels – Domestic Norway';
        oppold.crm_Opp_Service_Family__c='Pakker B2C';
        oppold.crm_Probability__c= '25';
        oppold.recordtypeid=RecordTypeId ; 
        oppold.OwnerId=user1.id;
        oppold.crm_Primary_Opportunity_Contact__c=c.id;
        insert oppold;
        
         Opportunity oppold1 = new Opportunity();
         oppold1.accountId=partyLevelacnt.id;
        oppold1.name='Parcels – Domestic Norway';
        oppold1.CloseDate=date.today().addDays(20);
        oppold1.StageName='New Opportunity';
        oppold1.crm_Opp_Service_Group__c='Parcels – Domestic Norway';
        oppold1.crm_Opp_Service_Family__c='Pakker B2B';
        oppold1.crm_Probability__c= '25';
        oppold1.recordtypeid=RecordTypeId ; 
        oppold1.OwnerId=user1.id;
        oppold1.crm_Primary_Opportunity_Contact__c=c.id;
        insert oppold1;
        
       crm_segment__c segobj1= crm_TestDataFactory.createSegment();
    segobj1.crm_Account__c= partyLevelacnt.id;
    segobj1.crm_Service_Group__c ='Parcels – Domestic Norway';
    segobj1.crm_Sales_Responsible__c =user1.id;
    insert segobj1;  
    }
    
     testMethod static void newoppinsert()
     {
         Contact con=[Select id, accountid  from Contact where email='testopp@test.com' limit 1];
         
        Opportunity oppnew = new Opportunity();
         string RecordTypeId = [Select Id From RecordType where sobjecttype = 'Opportunity' and name ='Delivery to Consumer' limit 1].Id;  
        oppnew.accountId=con.accountid;
        oppnew.name='Delivery to consumer';
        oppnew.CloseDate=date.today().addDays(20);
        oppnew.StageName='New Opportunity';
        oppnew.crm_Opp_Service_Group__c='Delivery to consumer';
        oppnew.crm_Opp_Service_Family__c='Home Delivery Parcel';
        oppnew.crm_Probability__c= '25';
        oppnew.recordtypeid=RecordTypeId ;       
        oppnew.External_Id_from_P11__c='123123';
        insert oppnew;
         
          Opportunity oppnew1 = new Opportunity();
         string RecordTypeId1 = [Select Id From RecordType where sobjecttype = 'Opportunity' and name ='Delivery to Consumer' limit 1].Id;  
        oppnew1.accountId=con.accountid;
        oppnew1.name='Delivery to consumer1';
        oppnew1.CloseDate=date.today().addDays(20);
        oppnew1.StageName='New Opportunity';
        oppnew1.crm_Opp_Service_Group__c='Delivery to consumer';
        oppnew1.crm_Opp_Service_Family__c='Parcel to Pick-up Point';
        oppnew1.crm_Probability__c= '25';
        oppnew1.recordtypeid=RecordTypeId1 ;       
        oppnew1.External_Id_from_P11__c='12312312';
        insert oppnew1;
         
         
          Opportunity oppnew2 = new Opportunity();
         string RecordTypeId2 = [Select Id From RecordType where sobjecttype = 'Opportunity' and name ='Business Delivery' limit 1].Id;  
        oppnew2.accountId=con.accountid;
        oppnew2.name='Delivery to consumer1';
        oppnew2.CloseDate=date.today().addDays(20);
        oppnew2.StageName='New Opportunity';
        oppnew2.crm_Opp_Service_Group__c='Business Delivery';
        oppnew2.crm_Opp_Service_Family__c='Business Parcel';
        oppnew2.crm_Probability__c= '25';
        oppnew2.recordtypeid=RecordTypeId2 ;       
        oppnew2.External_Id_from_P11__c='1231231212';
        insert oppnew2;
         
         crm_SetdetailsonOpportunity_Batch obj= new crm_SetdetailsonOpportunity_Batch();

         
         Database.executeBatch(obj);
         
     }
    
}