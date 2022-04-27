@isTest
public class AccountConversionCustomViewCltr_Test {
    
    @testSetup static void setup() {
       //create party level account
       crm_TestDataFactory.CreateCustomSetting();
         //BusinessStreet, BusinessCity, BillingState, BusinessPostalCode,  BusinessCountry,
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
        partyLevelacnt.name= 'Test Account';
        partyLevelacnt.Customer_Converted__c='Converted';
        partyLevelacnt.crm_Conv_Conversion_Process__c ='Auto';
        partyLevelacnt.crm_Conv_Converison_Heat__c ='Heat X - TBD';
        partyLevelacnt.crm_Conv_Start_Date__c  =System.today();
        partyLevelacnt.Customer_Price_Ready__c =true;
        partyLevelacnt.Agreement_Proposition_Ready__c =true;    
        partyLevelacnt.Conversion_Ready__c  = true;
        
       insert  partyLevelacnt;
       
       Account partyLevelacnt1= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt1;
      
       Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt1.parentId=partyLevelacnt1.id;
       insert  relationLevelacnt1;
       
       User u = crm_TestDataFactory.createUser();
       insert u;
       
       
        crm_Segment__c segobj1= crm_TestDataFactory.createSegment();
        segobj1.crm_Account__c= partyLevelacnt.id;
        segobj1.crm_Service_Group__c ='Cargo Domestic';
        segobj1.crm_Sales_Responsible__c =u.id;
        insert segobj1; 
        
        crm_Segment__c segobj2= crm_TestDataFactory.createSegment();
        segobj2.crm_Account__c= relationLevelacnt1.id;
        segobj2.crm_Service_Group__c ='Post';
        segobj2.crm_Sales_Responsible__c =u.id;
        insert segobj2;  
        
        Contact cont1=crm_TestDataFactory.createContact();
        cont1.accountid=partyLevelacnt.id;
        insert cont1;
        
        Contact cont2=crm_TestDataFactory.createContact();
        cont2.accountid=partyLevelacnt.id;
        
         
         try
            {
               insert cont2;
            }
            catch(Exception e)
            {
                System.assert(e.getMessage().contains('You\'re creating a duplicate record'));
            }
        
       }
    
      static TestMethod void testMyCustomers()
      {
          crm_segment__c seg= [Select id, crm_Sales_Responsible__c  from crm_segment__c where crm_Service_Group__c ='Cargo Domestic' limit 1];
        User u= [Select id from User where id=:seg.crm_Sales_Responsible__c]; 
        
        System.runAs(u) {
          
           AccountConversionCustomViewCltr.getAllAccounts();
            AccountConversionCustomViewCltr.getConversionProcessPicklist();
            AccountConversionCustomViewCltr.getConversionHeatPicklist();
            AccountConversionCustomViewCltr.getConvertedCustomerPicklist();
            AccountConversionCustomViewCltr.fetchAccount('Test','Auto',system.today(),'Heat X - TBD','Converted',true, true,true);
        }
      }
    
    

}