/* Created By: Supriya Goel
Date: 21 july  2016
Test class: Test class for account trigger helper  
*/

@isTest()
public class crm_AccountTriggerHelperTest{

@testSetup static void setup() {

       crm_TestDataFactory.CreateCustomSetting();
       //create party level account
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
       partyLevelacnt.crm_Lead_mapped_field__c = '1';
       insert  partyLevelacnt;
    
       
       update partyLevelacnt;
       
       //create relation level account
       Account relationLevelacnt= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt.parentId=partyLevelacnt.id;
       insert  relationLevelacnt;
    
    //create Prospect account
    Account prosLevelacnt= crm_TestDataFactory.createProspectAccount();
    insert  prosLevelacnt;
    Account prosLevelacnt2= crm_TestDataFactory.createProspectAccount();
    prosLevelacnt2.crm_Lead_mapped_field__c = '1';
    insert  prosLevelacnt2;
    
    Account prosLevelacnt3= crm_TestDataFactory.createProspectAccount();
    prosLevelacnt3.name='testprospect';
    //prosLevelacnt3.crm_Lead_mapped_field__c = '1';
    insert  prosLevelacnt3;
    
    /*Account prosLevelacnt4= crm_TestDataFactory.createProspectAccount();
    prosLevelacnt4.name='testprospect';
    
    insert  prosLevelacnt4;
    prosLevelacnt4.crm_Lead_mapped_field__c = '1';
    
    Update prosLevelacnt4;*/
     
       }
    
    static testmethod void changestatustest(){
     Account partylevel =[Select id,name,crm_Customer_Status_Role_3__c from Account where name ='parent test' limit 1 ];
             
       Account relationlevel =[Select id,name,crm_Customer_Status_Role_3__c from Account where name ='test account' limit 1 ];
       relationlevel.parentid= partylevel.id ;
        relationlevel.crm_Customer_Number__c = 'sfef4e5r3454t34fg34t345';
       update relationlevel;   
        
       Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt1.parentId=partylevel.id;
       insert  relationLevelacnt1;
        
        partylevel.crm_Customer_Status_Role_3__c = 'I';
        update partylevel;
        
        
    }
    
    static testmethod void testcustConversion(){
        environment_settings__c env = new environment_settings__c ();
        env.Name = 'AgeementMasterInterfaceSwitch';
        env.value__c='true';
        insert env;
        
        environment_settings__c env1 = new environment_settings__c ();
        env1.Name = 'ConvertCustomerInterfaceSwitch';
        env1.value__c='true';
        insert env1;
        Account partylevel =[Select id,name,Customer_Converted__c,crm_Customer_Status_Role_3__c from Account where name ='parent test' limit 1 ];
        partylevel.Customer_Converted__c='Converted';
        update partylevel;
              
        Contact c = crm_TestDataFactory.createContact();
        c.accountid=partylevel.id;
        insert c;
        
        RecordType opprt = [Select Id From RecordType Where SObjectType = 'Opportunity' And DeveloperName = 'Business_Delivery'];
        Opportunity opp = new Opportunity(Name='Opportunity Test',StageName='New Opportunity',crm_Opp_Service_Family__c='Business Parcel',crm_Opp_Service_Group__c='Business Delivery',
                                          AccountId=partylevel.Id,crm_Primary_Opportunity_Contact__c=c.id,CurrencyIsoCode='NOK',RecordtypeId=opprt.Id,CloseDate=Date.today()+5);
        insert opp;
        
        Test.startTest();
        opp.stagename ='Closed Won'   ;
        opp.crm_reason_won__c ='Price';
        opp.Amount=500;
        opp.crm_Close_Behaviour__c='Create';
        opp.crm_Agreement_Start_Date__c = date.today();
        opp.crm_Agreement_End_Date__c = date.today().adddays(10);
        
        Update opp;
        opp.crm_Verified_by_Contract_Management__c= true;
        update opp;
        
       Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt1.parentId=partylevel.id;
       insert  relationLevelacnt1;
        
        partylevel.crm_Customer_Status_Role_3__c= 'I';
        update partylevel;     
        
        test.stopTest();
        
    }
       
       static testMethod void testrelationcount(){
       Account partylevel =[Select id,name from Account where name ='parent test' limit 1 ];
             
       Account relationlevel =[Select id,name from Account where name ='test account' limit 1 ];
       relationlevel.parentid= partylevel.id ;
       update relationlevel;
       
       Account partylevel2 = crm_TestDataFactory.createPartylevelAccount();
       insert  partylevel2 ;
       
       //create relation level account
       Account relationlevel2 = crm_TestDataFactory.createRelationlevelAccount();
       relationlevel2.parentId=partylevel2.id;
       insert  relationlevel2;
       
       Account partylevel3 = crm_TestDataFactory.createPartylevelAccount();
       insert  partylevel3 ;
       
       relationlevel2.parentId=partylevel.id;
       update relationlevel2;
       
       delete relationlevel2;
       
       //crm_AccountRecordTypes__c rTParty= crm_AccountRecordTypes__c.getValues('Party level Customer');
       //Id PartyLevelRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTParty.crm_Record_Type_Label__c).getRecordTypeId();
       
       crm_AccountRecordTypes__c rTProspect= crm_AccountRecordTypes__c.getValues('Prospect');
        
        Id ProspectRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.Label.Crm_Prospect).getRecordTypeId();    
           
       account prospect=[Select id, name, recordtypeid,crm_Shipping_City__c,crm_Shipping_Country__c from  Account where name= 'testprospect'];
       prospect.recordtypeid= ProspectRecordTypeId ;
              
       update prospect;
        
       prospect=[Select id, name, recordtypeid,crm_Shipping_City__c,crm_Shipping_Country__c from  Account where name= 'testprospect']; 
       prospect.crm_Shipping_City__c = 'test';
       prospect.crm_Shipping_Country__c = 'Norway';
       prospect.crm_Shipping_Zip_Postal_Code__c ='test';
       prospect.crm_Shipping_State_Province__c='test';
       prospect.crm_Shipping_Street__c = 'test';
       prospect.crm_Billing_City__c = 'test';
       prospect.crm_Billing_Country__c = 'Norway';
       prospect.crm_Billing_State_Province__c = 'test';
       prospect.crm_Billing_Street__c = 'test';
       prospect.crm_Billing_Zip_Postal_Code__c = 'test';
       update prospect;
       
     } 
    static testMethod void testSetPartyConverted(){
       Account partylevel1 = crm_TestDataFactory.createPartylevelAccount();
       partylevel1.CreatedDate = system.today();
        partylevel1.crm_Updated_by_CDH__c = true;
       insert  partylevel1 ;
    }
    
    static testMethod void setPartyConvertedFromProspect(){
    	environment_settings__c env = new environment_settings__c ();
        env.Name = 'PartyConvertedFromProspectSwitch';
        env.value__c='true';
        insert env;
        
        Account prospectlevel1 = crm_TestDataFactory.createProspectAccount();
        prospectlevel1.CreatedDate = system.today();
        insert prospectlevel1;
        
        prospectlevel1.recordTypeid= crm_TestDataFactory.PartyRecordTypeId();
        prospectlevel1.Customer_Converted__c = 'Converted';
        prospectlevel1.crm_Updated_by_CDH__c = true;
        update prospectlevel1;
    }
       }