/* Created By: Supriya
Date: 21 nov 2017
Test class: Test class for the crm_setprimayrelationAccount_Batch
*/

@isTest
public class crm_setprimayrelationAccount_BatchTest{

    @testSetup static void setup() {
    crm_TestDataFactory.CreateCustomSetting();
     Profile P = [Select id from Profile where name='System Administrator'];
     String orgId = UserInfo.getOrganizationId();
    
        User cdhUser= new User();
        cdhUser.lastname='test1';
        cdhUser.profileid=p.id;
        cdhUser.Email = 'cdhUser@test.com';
        cdhUser.Username = 'cdhuser@test.com'+orgId;
        cdhUser.CompanyName = 'TEST';
        cdhUser.Title = 'title';
        cdhUser.Alias = 'alias';
        cdhUser.TimeZoneSidKey = 'America/Los_Angeles';
        cdhUser.EmailEncodingKey = 'UTF-8';
        cdhUser.LanguageLocaleKey = 'en_US';
        cdhUser.LocaleSidKey = 'en_US';
        insert cdhUser;
        
        User batchUser= new User();
        batchUser.lastname='test1';
        batchUser.profileid=p.id;
        batchUser.Email = 'batchUser@test.com';
        batchUser.Username = 'batchUser@test.com'+orgId;
        batchUser.CompanyName = 'TEST';
        batchUser.Title = 'title';
        batchUser.Alias = 'alias';
        batchUser.TimeZoneSidKey = 'America/Los_Angeles';
        batchUser.EmailEncodingKey = 'UTF-8';
        batchUser.LanguageLocaleKey = 'en_US';
        batchUser.LocaleSidKey = 'en_US';
        insert batchUser;
      
        List<environment_settings__c> settingList=new List<environment_settings__c>();
        environment_settings__c  CDHUserId=new environment_settings__c();
        CDHUserId.Name='CDHUserId';
        CDHUserId.value__c=[Select  id from User where email='cdhUser@test.com'].id;
        settingList.add(CDHUserId);
        
        environment_settings__c  BatchjobUserId=new environment_settings__c();
        BatchjobUserId.Name='BatchjobUserId';
        BatchjobUserId.value__c=[Select  id from User where email='batchUser@test.com'].id;
        settingList.add(BatchjobUserId);
        
       
        insert settingList;
        Account partyLevelacnt1= crm_TestDataFactory.createPartylevelAccount();
        Account partyLevelacnt2= crm_TestDataFactory.createPartylevelAccount();
        Account partyLevelacnt3= crm_TestDataFactory.createPartylevelAccount();
        System.RunAs(cdhuser) {
          
        partyLevelacnt1.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
        partyLevelacnt1.orga__c ='12345';
        insert  partyLevelacnt1;
            
        partyLevelacnt2.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
        partyLevelacnt2.orga__c ='1234567';
        insert  partyLevelacnt2;
            
         partyLevelacnt3.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
        partyLevelacnt3.orga__c ='123456799';
        insert  partyLevelacnt3;    
        }
     
        //create relation level accounts  
        Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelacnt1.parentId=partyLevelacnt1.id;
        relationLevelacnt1.crm_Customer_Number__c='123456blnoc';
        relationLevelacnt1.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
        insert  relationLevelacnt1;
        
        Account relationLevelacnt2= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelacnt2.parentId=partyLevelacnt1.id;
        relationLevelacnt2.crm_Customer_Number__c='123456';
        relationLevelacnt2.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
        insert  relationLevelacnt2;
        
        Account relationLevelacnt3= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelacnt3.parentId=partyLevelacnt2.id;
        relationLevelacnt3.crm_Customer_Number__c='1234567blnoc';
        relationLevelacnt3.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
        relationLevelacnt3.crm_Revenue_This_Year__c=900;
        insert  relationLevelacnt3;
        
        Account relationLevelacnt4= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelacnt4.parentId=partyLevelacnt2.id;
        relationLevelacnt4.crm_Customer_Number__c='12345689bbb';
        relationLevelacnt4.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
        relationLevelacnt4.crm_Revenue_This_Year__c=1900;
        insert relationLevelacnt4;
        
         Account relationLevelacnt5= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelacnt5.parentId=partyLevelacnt3.id;
        relationLevelacnt5.crm_Customer_Number__c='78755577';
        relationLevelacnt5.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
        relationLevelacnt5.crm_Primary_Customer_Account__c=true;
        insert relationLevelacnt5;
    
    }
    
      testMethod static void setprimaryaccountTest()
    {
        System.Test.StartTest();
        crm_setprimayrelationAccount_Batch  batchObj=new crm_setprimayrelationAccount_Batch('test');
        Database.ExecuteBatch(batchObj);
        System.Test.StopTest();
    
   }
   
    }