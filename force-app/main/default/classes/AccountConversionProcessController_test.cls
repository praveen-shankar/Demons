@isTest
public class AccountConversionProcessController_test {
    
      @testSetup static void setup() {
     
      }
    
    static TestMethod void UpdateAccount(){
        
       crm_TestDataFactory.CreateCustomSetting();
         //BusinessStreet, BusinessCity, BillingState, BusinessPostalCode,  BusinessCountry,
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt;
       AccountConversionProfileName__c profilenames = new AccountConversionProfileName__c ();
       profilenames.name = 'Profiles';
       profilenames.ProfileName__c = 'Guest CRM Sales Manager';
       insert profilenames;
       
        partyLevelacnt.crm_Conv_Customer_Conversion_Group__c ='Kun pakke til hentested';
        partyLevelacnt.crm_Conv_Total_Revenue__c = 100;
            partyLevelacnt.crm_Conv_Converison_Heat__c ='Heat X - TBD';
            partyLevelacnt.crm_Conv_Order_Channel__c ='test';
            partyLevelacnt.crm_Conv_Start_Date__c =Date.today().addDays(-1);
            partyLevelacnt.crm_conv_Count_Org_No_in_group__c =1;
            partyLevelacnt.crm_conv_Customer_state__c ='Standard agreement';
            partyLevelacnt.crm_cov_ListOrg_no_in_group__c ='1';
             partyLevelacnt.crm_conv_Conversion_comment__c ='test';
            partyLevelacnt.crm_EDI_API_status__c ='Ikke oppdatert';
           update partyLevelacnt;
            
    AccountCoversionProcessController.getAccount(partyLevelacnt.id);
    AccountCoversionProcessController.getConverisonHeat();
    AccountCoversionProcessController.getConvCustomerConversionGroupc();
    AccountCoversionProcessController.getAccountRecord(partyLevelacnt);
    AccountCoversionProcessController.getCoversionProcess();
    AccountCoversionProcessController.getConversionFlag(partyLevelacnt.id);
    AccountCoversionProcessController.getCustomerState();
    AccountCoversionProcessController.getprofilename();
    AccountCoversionProcessController.getConnectedAgreement();
    AccountCoversionProcessController.getCustomerStatus();
    AccountCoversionProcessController.gethidecomponent(partyLevelacnt.id);
    AccountCoversionProcessController.getEDIStatus();
    AccountCoversionProcessController.getApiStatus();
       
    }

}