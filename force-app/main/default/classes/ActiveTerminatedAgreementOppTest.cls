@isTest
public class ActiveTerminatedAgreementOppTest {
	 testMethod static void getOpportunityRecordToDeleteTest(){
        Test.startTest();
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
                
            Opportunity oppObj = new Opportunity();
             string RecordTypeId = [Select Id From RecordType where sobjecttype = 'Opportunity' and name ='Parcels Domestic Norway' limit 1].Id;  
             oppObj.accountId=partyLevelacnt.id;
             oppObj.name='Parcels – Domestic Norway';
             oppObj.CloseDate=date.today().addDays(20);
             oppObj.StageName='New Opportunity';
             oppObj.crm_Opp_Service_Group__c='Parcels – Domestic Norway';
             oppObj.crm_Opp_Service_Family__c='Pakker B2C';
             oppObj.crm_Probability__c= '25';
             oppObj.recordtypeid=RecordTypeId ; 
             oppObj.OwnerId=user1.id;
             oppObj.crm_Primary_Opportunity_Contact__c=c.id;
             insert oppObj;
         Test.stopTest();
         ActiveTerminatedAgreementOpportunities.getOpportunityRecordToDelete(oppObj.Id); 
         
     }
}