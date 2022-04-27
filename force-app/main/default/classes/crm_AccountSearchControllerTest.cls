/* Created By: Supriya goel
Date: 4 may  2016
Test class: Test class for the account search
*/

@isTest
public class crm_AccountSearchControllerTest{

 @testSetup static void setup() {
       //create party level account
       crm_TestDataFactory.CreateCustomSetting();
         //BusinessStreet, BusinessCity, BillingState, BusinessPostalCode,  BusinessCountry,
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
       partyLevelacnt.crm_bus_addr_City__c='Oslo';
       partyLevelacnt.crm_Company_Group_Name__c='ABB';
       partyLevelacnt.crm_bus_addr_Street__c='Park Street';
       partyLevelacnt.crm_bus_addr_Zip_Code__c='578394';
       partyLevelacnt.crm_bus_addr_Country__c='Norway';
       insert  partyLevelacnt;
       }

    static TestMethod void testAccountSearch()
    {
        Account partyLevelacnt= [Select id from Account where name ='parent test' limit 1];
        crm_AccountSearchController myclass=new crm_AccountSearchController();
        myclass.orgNo='9890233';
        myclass.AccountName='parent test';
        myclass.BusinessCity='Oslo';
        myclass.CompanyGroupName='Capgemini';
        myclass.BusinessStreet='Park Street';
        myclass.BusinessPostalCode='578394';
        myclass.BusinessCountry='Norway';
        
        myclass.refreshPageSize();
   
    }
     static TestMethod void testAccountSearchParameterBlank()
    {
        crm_AccountSearchController myclass=new crm_AccountSearchController();
        myclass.orgNo='';
        myclass.AccountName='';
        myclass.BusinessCity='';
        myclass.CompanyGroupName='';
        myclass.BusinessStreet='';
        myclass.BusinessPostalCode='';
        myclass.BusinessCountry='';
        
        myclass.refreshPageSize();
    } 
    
}