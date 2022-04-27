/* Created By: Supriya Goel
Date: 30th july 2019
Test class: seent via conga field 
*/

@isTest()
public class crm_sentToConga_BatchTest{

@testSetup static void setup() {
    
        RecordType partyrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'crm_Party_level_Customer'];
        RecordType opprt = [Select Id From RecordType Where SObjectType = 'Opportunity' And DeveloperName = 'Business_Delivery'];
        Account acc = new Account(Name='Party',Orga__c='2348274724',RecordTypeId=partyrt.Id);
        insert acc;
        acc.Template_Sent_Via_Conga__c = false;
        acc.crm_conv_Customer_state__c ='Standard agreement';
        acc.crm_Conv_Converison_Heat__c ='Heat B - September 2019';
        update acc;
        
        Opportunity opp = new Opportunity(Name='Opportunity Test',StageName='New Opportunity',crm_Opp_Service_Family__c='Business Parcel',crm_Opp_Service_Group__c='Business Delivery',
                                          AccountId=acc.Id,CurrencyIsoCode='NOK',New_Service_Group__c=true,RecordtypeId=opprt.Id,CloseDate=Date.today()+5);
        insert opp;
    
        Opportunity opp1 = new Opportunity(Name='Opportunity Test1',StageName='New Opportunity',crm_Opp_Service_Family__c='Cargo Domestic Norway',crm_Opp_Service_Group__c='Business Delivery',
                                          AccountId=acc.Id,CurrencyIsoCode='NOK',New_Service_Group__c=true,RecordtypeId=opprt.Id,CloseDate=Date.today()+5);
        insert opp1;
        
        }
        
         static testMethod void testconga(){
             crm_sentToConga_Batch acb = new crm_sentToConga_Batch(); 
            System.Test.startTest();
            Database.executeBatch(acb);    
        
        System.Test.stopTest(); 
    }
    
  }