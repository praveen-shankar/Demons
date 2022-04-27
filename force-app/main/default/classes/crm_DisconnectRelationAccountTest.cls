@isTest
public class crm_DisconnectRelationAccountTest {
    
    //create party level account   
    @testSetup static void setup() {    
        crm_TestDataFactory.CreateCustomSetting();
        Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
        partyLevelacnt.Orga__c='12345';
        insert  partyLevelacnt; 
        
        Account partyLevelacnt1= crm_TestDataFactory.createPartylevelAccount();
        partyLevelacnt1.Orga__c='67890';
        insert  partyLevelacnt1; 
        
        //create relation level accounts  
        Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelacnt1.parentId=partyLevelacnt.id;
        relationLevelacnt1.crm_Customer_Number__c='22222';
        //relationLevelacnt1.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
        insert  relationLevelacnt1;
        
        Account relationLevelacnt2= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelacnt2.parentId=partyLevelacnt.id;
        relationLevelacnt2.crm_Customer_Number__c='33333';
        //relationLevelacnt2.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
        insert  relationLevelacnt2;
        
        relationLevelacnt2.parentId = partyLevelacnt1.id;
        update relationLevelacnt2;
        
                
    }
    
      testMethod static void DisconnectRelAccount()
    {
        System.Test.StartTest();
        crm_DisconnectRelationAccount batchObj=new crm_DisconnectRelationAccount('test');
        Database.ExecuteBatch(batchObj);
        System.Test.StopTest();
    }
}