/* Created By: Supriya
Date: 14th feb 2018
Test class: Test class for the crm_CreatePartyFromProspect
*/

@isTest
public class crm_CreatePartyFromProspectTest {

 @testSetup static void setup() {
    crm_TestDataFactory.CreateCustomSetting();
    
      //create relation level accounts  
        Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelacnt1.crm_Customer_Number__c='123456blnoc';
        relationLevelacnt1.orga__c='1234567';        
        relationLevelacnt1.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
        insert  relationLevelacnt1;
        
        
        Account Prospect1=crm_TestDataFactory.createProspectAccount();
         Prospect1.orga__c='1234567';
         insert Prospect1;
        
        Account relationLevelacnt2= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelacnt2.orga__c='44555';
        relationLevelacnt2.crm_Customer_Number__c='123456';
        relationLevelacnt2.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
        insert  relationLevelacnt2;
        
          Account Prospect2=crm_TestDataFactory.createProspectAccount();
         Prospect2.orga__c='44555';
         insert Prospect2;
        
        
        Account relationLevelacnt3= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelacnt3.orga__c='5566';
        relationLevelacnt3.crm_Customer_Number__c='1234567blnoc';
        relationLevelacnt3.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
        relationLevelacnt3.crm_Revenue_This_Year__c=900;
        insert  relationLevelacnt3;
        
          Account Prospect3=crm_TestDataFactory.createProspectAccount();
         Prospect3.orga__c='5566';
         insert Prospect3;
        
        
                   
        }
        
         testMethod static void methodTest(){
            System.Test.StartTest();
            crm_CreatePartyFromProspect  batchObj=new crm_CreatePartyFromProspect('test');
            Database.ExecuteBatch(batchObj);
            System.Test.StopTest();
         
         
         }
    


}