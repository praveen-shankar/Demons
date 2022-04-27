@isTest
public class Test_OpportunitywithContractManagement {
  @testSetup static void setup() {
      Opportunity opp= crm_TestDataFactory.createCargoOpportunity();
      insert opp;
      User u= crm_TestDataFactory.createUser();
      insert u;
      
  }
    static TestMethod void testOpportunity()
      {
          User u=[Select Id,Name from User limit 1] ;
          String userid= u.id;
          Opportunity o=[Select Id from Opportunity limit 1];
          Opportunity o2=OpportunitywithContractManagement.getOpportunity(o.Id);
          System.assertEquals(o2.id,o.id);
          List<User> u2=OpportunitywithContractManagement.getUser(u.Name);
          System.assertEquals(u2[0],u);
          String success=OpportunitywithContractManagement.saveOpportunity(o,userid);
         // System.assertEquals(o3,o);  
          
           AccountConversionProfileName__c  objCustomSetting1 = new AccountConversionProfileName__c ();
        objCustomSetting1.ProfileName__c='Sales excellence og nordic BID';
        objCustomSetting1.Name = 'Opportunity_allowed_Roles';
        insert objCustomSetting1 ;
          
          
           AccountConversionProfileName__c  objCustomSetting2 = new AccountConversionProfileName__c ();
        objCustomSetting2.ProfileName__c='System Administrator';
        objCustomSetting2.Name = 'Opportunity_allowed_Profiles';
        insert objCustomSetting2 ;
          OpportunitywithContractManagement.getprofilename();
          OpportunitywithContractManagement.searchDB('User', 'Id', 'Name', 4, 'Name', 'Supriya') ; 
          
      }
}