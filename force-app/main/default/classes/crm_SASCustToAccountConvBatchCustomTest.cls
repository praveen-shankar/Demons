/*
Date: 03rd March  2021
Test class: Test class for the crm_SASCustomerToAccountConversionBatch
*/

@isTest
public class crm_SASCustToAccountConvBatchCustomTest{

    @testSetup static void setup() {
         
         crm_TestDataFactory.CreateCustomSetting();
         
         List<Account> accList=new List<Account>();
        
         Account acc=new Account();
         acc.RecordTypeId=crm_TestDataFactory.ProspectRecordTypeId();
         acc.Orga__c='999001';
         acc.Name='Test Account from Prospect to Party';
         accList.add(acc);
         
         Account partyacc=new Account();
         partyacc.RecordTypeId=crm_TestDataFactory.PartyRecordTypeId();
         partyacc.Orga__c='9990002';
         partyacc.Name='Test Party';
         accList.add(partyacc);
         
         Account partyacc1=new Account();
         partyacc1.RecordTypeId=crm_TestDataFactory.PartyRecordTypeId();
         partyacc1.Orga__c='9998787';
         partyacc1.Name='Test Party new';
         accList.add(partyacc1);
         
         Account parentacc=new Account();
         parentacc.RecordTypeId=crm_TestDataFactory.PartyRecordTypeId();
         parentacc.Orga__c='9990003';
         parentacc.Name='Test Account';
         insert parentacc;
         
         Account relacc=new Account();
         relacc.crm_Customer_Number__c='123453';
         relacc.RecordTypeId=crm_TestDataFactory.RelationRecordTypeId();
         relacc.ParentId=parentacc.id;
         relacc.crm_Primary_Customer_Account__c=true;
         relacc.crm_Updated_By_CDH__c=false;
         relacc.Orga__c='9990003';
         relacc.Name='Test Account';
         
         Account relacc2=new Account();
         relacc2.crm_Customer_Number__c='123459';
         relacc2.RecordTypeId=crm_TestDataFactory.RelationRecordTypeId();
         relacc2.ParentId=parentacc.id;
         relacc2.crm_Primary_Customer_Account__c=true;
         relacc2.crm_Updated_By_CDH__c=false;
         relacc2.Orga__c='9990002';
         relacc2.Name='Test Account relation';
         accList.add(relacc);
        
         Account parentacc2=new Account();
         parentacc2.RecordTypeId=crm_TestDataFactory.PartyRecordTypeId();
         parentacc2.Orga__c='9990005';
         parentacc2.Name='Test Account';
         accList.add(parentacc2);
         
         Account relationacc=new Account();
         relationacc.crm_Customer_Number__c='123455';
         relationacc.RecordTypeId=crm_TestDataFactory.RelationRecordTypeId();
         relationacc.Name='Test Orphan Acc';
         accList.add(relationacc);
         
         Account relationaccOrp=new Account();
         relationaccOrp.crm_Customer_Number__c='123456';
         relationaccOrp.RecordTypeId=crm_TestDataFactory.RelationRecordTypeId();
         relationaccOrp.Name='Test Orphan Acc2';
         accList.add(relationaccOrp);
        
         insert accList;
         
         Account relaccnew=new Account();
         relaccnew.crm_Customer_Number__c='CAP77123453';
         relaccnew.RecordTypeId=crm_TestDataFactory.RelationRecordTypeId();
         relaccnew.ParentId=partyacc1.id;
         relaccnew.crm_Primary_Customer_Account__c=true;
         relaccnew.crm_Updated_By_CDH__c=false;
         relaccnew.Orga__c='9998787';
         relaccnew.Name='Test Account';
         
         insert relaccnew;
         

    
    }
    // test method to create party and corresponding relation level accounts
    static testMethod void CreateNewPartylevel()
     {
         List<crm_SAS_Customer_Import__c> sasList=new List<crm_SAS_Customer_Import__c>();
         crm_SAS_Customer_Import__c sasObj=new crm_SAS_Customer_Import__c ();
         sasObj.crm_CUSTOMER_ORGANISATIONNUMBER__c='9gdh99ghd000';
         sasObj.crm_CUSTOMER_NUMBER__c='12345';
         sasObj.Name='Test Account';
         sasList.add(sasObj);
         
         crm_SAS_Customer_Import__c sasObj1=new crm_SAS_Customer_Import__c ();
         sasObj1.crm_CUSTOMER_ORGANISATIONNUMBER__c='9gdh99ghd000';
         sasObj1.crm_CUSTOMER_NUMBER__c='BLNOCMP12341';
         sasObj1.Name='Test Account 2';
         sasList.add(sasObj1);
         
         crm_SAS_Customer_Import__c sasObj3=new crm_SAS_Customer_Import__c ();
         sasObj3.crm_CUSTOMER_ORGANISATIONNUMBER__c='9gdh99ghd000';
         sasObj3.crm_CUSTOMER_NUMBER__c='123456';
         sasObj3.Name='Test Account 3';
         sasList.add(sasObj3);
         
         crm_SAS_Customer_Import__c sasObjnew=new crm_SAS_Customer_Import__c ();
         sasObjnew.crm_CUSTOMER_ORGANISATIONNUMBER__c='9gdh99ghd000';
         sasObjnew.crm_CUSTOMER_NUMBER__c='123453000';
         sasObjnew.Name='Test Account 4';
         sasList.add(sasObjnew);
         
         
         insert sasList;
         
         System.Test.startTest();
         crm_SASCustomerToAccountConvCustomBatch batchObj=new crm_SASCustomerToAccountConvCustomBatch(sasList.get(0).id);
         DataBase.executebatch(batchObj);
         System.Test.StopTest();
         
        // List<Account> accList=[Select id, Name from Account where Orga__c='999000' ];
         //System.assertequals(5,accList.size());
     }
     
     // test method to convert existing prospect to party and created child relation account
      static testMethod void CreatePartylevelFromProspect()
     {
         List<crm_SAS_Customer_Import__c> sasList=new List<crm_SAS_Customer_Import__c>();
         crm_SAS_Customer_Import__c sasObj1=new crm_SAS_Customer_Import__c ();
         sasObj1.crm_CUSTOMER_ORGANISATIONNUMBER__c='999001';
         sasObj1.crm_CUSTOMER_NUMBER__c='123451';
         sasObj1.Name='Test Account';
         sasList.add(sasObj1);
         
         crm_SAS_Customer_Import__c sasObjp=new crm_SAS_Customer_Import__c ();
         sasObjp.crm_CUSTOMER_ORGANISATIONNUMBER__c='999001';
         sasObjp.crm_CUSTOMER_NUMBER__c='1234519';
         sasObjp.Name='Test Account2';
         sasList.add(sasObjp);
         insert sasList; 
         
         System.Test.startTest();
         crm_SASCustomerToAccountConvCustomBatch batchObj=new crm_SASCustomerToAccountConvCustomBatch(sasList.get(0).id);
         DataBase.executebatch(batchObj);
         System.Test.StopTest();
         
         Account updatedacc=[Select id,name,RecordTypeId from Account where Orga__c='999001' LIMIT 1];
         System.assertequals(crm_TestDataFactory.PartyRecordTypeId(),updatedacc.RecordTypeId );
         
         Account relationAcc=[Select id, Name,RecordTypeid, ParentId ,crm_Customer_Number__c,Orga__c from Account where crm_Customer_Number__c='123451' and RecordTypeid=:crm_TestDataFactory.RelationRecordTypeId() ];
         System.assertequals(updatedacc.id,RelationAcc.ParentId);
         
     }
     //test method to create relation level accouts for existing party account
      static testMethod void CreateRelationLevel()
     {
         //CreateRelationLevel
         crm_SAS_Customer_Import__c sasObj2=new crm_SAS_Customer_Import__c ();
         sasObj2.crm_CUSTOMER_ORGANISATIONNUMBER__c='9990002';
         sasObj2.crm_CUSTOMER_NUMBER__c='123452';
         sasObj2.Name='Test Account';
         insert sasObj2; 
         
         System.Test.startTest();
         crm_SASCustomerToAccountConvCustomBatch batchObj=new crm_SASCustomerToAccountConvCustomBatch(sasObj2.id);
         DataBase.executebatch(batchObj);
         System.Test.StopTest();
         
         Account relationAcc=[Select id,Name,ParentId from Account where Orga__c='9990002' and crm_Customer_Number__c='123452' LIMIT 1];
         Account partyAcc=[Select id,Name from Account where Orga__c='9990002' and RecordTypeId=:crm_TestDataFactory.PartyRecordTypeId() LIMIT 1];
         System.AssertEquals(partyAcc.id,relationAcc.ParentId);
    
     }
     
     //test method to update existing relation level account
      static testMethod void UpdateRelationLevel()
     {
         //UpdateRelationLevel
         crm_SAS_Customer_Import__c sasObj3=new crm_SAS_Customer_Import__c ();
         sasObj3.crm_CUSTOMER_ORGANISATIONNUMBER__c='9990003';
         sasObj3.crm_CUSTOMER_NUMBER__c='123453';
         sasObj3.Name='Test Relation Account';
         sasObj3.crm_HOMEPAGE__c='testacc.com';
         insert sasObj3; 
         
         System.Test.startTest();
         crm_SASCustomerToAccountConvCustomBatch batchObj=new crm_SASCustomerToAccountConvCustomBatch(sasObj3.id);
         DataBase.executebatch(batchObj);
         System.Test.StopTest();
         
         Account Updatedacc=[Select id,Name,Website from Account where Orga__c='9990003' and crm_Customer_Number__c='123453' LIMIT 1];
         System.AssertEquals('testacc.com',Updatedacc.Website); 
        
     
     }
     
     //test method to create orphan relation account if org number is blank
     testMethod Static void CreateOrphanRelationAccount()
     {
         List<crm_SAS_Customer_Import__c> sasList=new List<crm_SAS_Customer_Import__c>();     
         crm_SAS_Customer_Import__c sasObj4=new crm_SAS_Customer_Import__c ();
         sasObj4.crm_CUSTOMER_NUMBER__c='123454';
         sasObj4.Name='Test Account';
         sasObj4.crm_HOMEPAGE__c='testacc.com';
         
         sasList.add(sasObj4);
         
         crm_SAS_Customer_Import__c sasObj6=new crm_SAS_Customer_Import__c ();
         sasObj6.crm_CUSTOMER_NUMBER__c='BLNOCMP123453';
         sasObj6.Name='Upsated Test Account';
         sasObj6.crm_HOMEPAGE__c='testacc.com';
         sasList.add(sasObj6);
         
         crm_SAS_Customer_Import__c sasObjorg=new crm_SAS_Customer_Import__c ();
         sasObjorg.crm_CUSTOMER_NUMBER__c='123453';
         sasObjorg.crm_CUSTOMER_ORGANISATIONNUMBER__c='0000000';
         sasObjorg.Name='Upsated Test Account';
         sasObjorg.crm_HOMEPAGE__c='testacc.com';
         sasList.add(sasObjorg);
         insert sasList;
         
         System.Test.startTest();
         crm_SASCustomerToAccountConvCustomBatch batchObj=new crm_SASCustomerToAccountConvCustomBatch(sasList.get(2).id);
         DataBase.executebatch(batchObj);
         System.Test.StopTest();
     
        // Account acc=[Select id, Name, ParentId from Account where crm_Customer_Number__c='123454' LIMIT 1];
        // System.Assertequals(null,acc.ParentId);
     }
     
     // test method to check if and orphan account exists, associate it with existing party if matching org number is present
     testMethod Static void AssociateRelationAccountToParty()
     {   
          
         crm_SAS_Customer_Import__c sasObj5=new crm_SAS_Customer_Import__c ();
         sasObj5.crm_CUSTOMER_ORGANISATIONNUMBER__c='9990005';
         sasObj5.crm_CUSTOMER_NUMBER__c='123455';
         sasObj5.Name='Test Relation Account';
         sasObj5.crm_HOMEPAGE__c='testacc.com';
         insert sasObj5; 
         
         System.Test.startTest();
         crm_SASCustomerToAccountConvCustomBatch batchObj=new crm_SASCustomerToAccountConvCustomBatch(sasObj5.id);
         DataBase.executebatch(batchObj);
         System.Test.StopTest();
         
         Account childacc=[Select id, Name, ParentId from Account where crm_Customer_Number__c=:'123455' and Orga__c='9990005' LIMIT 1];
         System.Assert(childacc.ParentId!=null,'Success');
         
       
     }
     
   /*  static testMethod void deparentRelationAccount()
     {
         crm_SAS_Customer_Import__c sasObj5=new crm_SAS_Customer_Import__c ();
         sasObj5.crm_CUSTOMER_NUMBER__c='123459';
         sasObj5.Name='Test Relation Account';
         sasObj5.crm_HOMEPAGE__c='testacc.com';
         insert sasObj5; 
         
         System.Test.startTest();
         crm_SASCustomerToAccountConvCustomBatch batchObj=new crm_SASCustomerToAccountConvCustomBatch(sasObj5.id);
         DataBase.executebatch(batchObj);
         System.Test.StopTest();
         
         Account childacc=[Select id, Name, ParentId from Account where crm_Customer_Number__c=:'123459' LIMIT 1];
         System.Assert(childacc.ParentId==null,'Success');
     }*/
     
      static testMethod void ReparentRelationAccount()
     {
         crm_SAS_Customer_Import__c sasObj5=new crm_SAS_Customer_Import__c ();
         sasObj5.crm_CUSTOMER_NUMBER__c='CAP77123453';
         sasObj5.crm_CUSTOMER_ORGANISATIONNUMBER__c='9990002';
         sasObj5.Name='Test Relation Account';
         sasObj5.crm_HOMEPAGE__c='testacc.com';
         insert sasObj5; 
         
         System.Test.startTest();
         crm_SASCustomerToAccountConvCustomBatch batchObj=new crm_SASCustomerToAccountConvCustomBatch(sasObj5.id);
         DataBase.executebatch(batchObj);
         System.Test.StopTest();
         
         Account childacc=[Select id, Name, Orga__c from Account where crm_Customer_Number__c=:'CAP77123453' LIMIT 1];
         System.Assert(childacc.Orga__c=='9990002','Success');
     }
     
     static testMethod void ReparentRelationToNewParty()
     {
         crm_SAS_Customer_Import__c sasObjParty=new crm_SAS_Customer_Import__c ();
         sasObjParty.crm_CUSTOMER_ORGANISATIONNUMBER__c='99997979';
         sasObjParty.crm_CUSTOMER_NUMBER__c='123453';
         sasObjParty.Name='Test Account 5';
         insert sasObjParty;
         
         System.Test.startTest();
         crm_SASCustomerToAccountConversionBatch batchObj=new crm_SASCustomerToAccountConversionBatch();
         DataBase.executebatch(batchObj);
         System.Test.StopTest();
         
     }
     
     //test method to invokeand cover exception code
     static testMethod void runNegativeTestCases() {
            
         crm_SAS_Customer_Import__c sasObj6=new crm_SAS_Customer_Import__c ();
         sasObj6.crm_CUSTOMER_ORGANISATIONNUMBER__c='9990006';
         sasObj6.crm_CUSTOMER_NUMBER__c='123456';
         sasObj6.crm_HOMEPAGE__c='testacc.com';
         sasObj6.Name='Test Negative';
         sasObj6.crm_DUNSNR__c='test123456789123456789123';
         insert sasObj6;   
           
         try
         {
             System.Test.startTest();
             crm_SASCustomerToAccountConvCustomBatch batchObj=new crm_SASCustomerToAccountConvCustomBatch(sasObj6.id);
             DataBase.executebatch(batchObj);
             System.Test.StopTest();
         }
         catch(Exception e)
         {
             System.assert(e.getMessage().contains('Insert failed. First exception on row 0; first error: STRING_TOO_LONG, DUNS nummer:') ,e.getMessage() ); 
         }
             
     }
}