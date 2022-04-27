/*
Created By:Supriya Goel
Date: 
Calculate customer segment batch

*/

global class crm_Customersegment_Batch implements Database.batchable<sObject>,Database.Stateful{
    public string callback = ''; 
      
  
       
    global crm_Customersegment_Batch (String callback){
        this.callback = callback;   
       
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
         crm_AccountRecordTypes__c rTParty= crm_AccountRecordTypes__c.getValues('Party level Customer');
         Id PartyLevelRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTParty.crm_Record_Type_Label__c).getRecordTypeId();
              
       String query = 'Select id,  crm_segment_Logistics_Revenue_12__c,crm_segment_Post_Revenue_12__c,crm_segment_Active_FrigoDom_Customer__c,crm_segment_Active_BPX_Customer__c, crm_segment_Active_PIP_Customer__c, crm_segment_Active_PaDoren_Customer_c__c,crm_segment_Active_CargoDom_Customer__c, crm_segment_Active_Customer__c,crm_segment_Active_BPDD_Customer__c, Crm_segment_Active_Post_Customer__c, crm_segment_Active_PakkerB2C_Customer__c, crm_segment_Active_PakkerB2B_Customer__c, crm_segment_Active_ParcelsB2C_Customer__c, crm_segment_Active_ParcelsB2B_Customer__c , crm_segment_Active_Servicepakke_Customer__c from Account where RecordTypeId = :PartyLevelRecordTypeId  and (crm_segment_Logistics_Revenue_12__c!=null or crm_segment_Post_Revenue_12__c!=null or crm_segment_Active_FrigoDom_Customer__c = true  or crm_segment_Active_BPX_Customer__c= true  or crm_segment_Active_PIP_Customer__c= true or crm_segment_Active_PaDoren_Customer_c__c= true or crm_segment_Active_CargoDom_Customer__c= true or crm_segment_Active_Customer__c = true or crm_segment_Active_BPDD_Customer__c= true or Crm_segment_Active_Post_Customer__c= true or crm_segment_Active_PakkerB2C_Customer__c= true or crm_segment_Active_PakkerB2B_Customer__c= true or crm_segment_Active_ParcelsB2C_Customer__c= true or crm_segment_Active_ParcelsB2B_Customer__c = true or crm_segment_Active_Servicepakke_Customer__c =true)'; 
        return Database.getQueryLocator(query);                            
    }

    global void execute(Database.BatchableContext BC, List<Account> acclist) {
    for (Account a: acclist) {
    a.crm_segment_Active_FrigoDom_Customer__c=  false;
    a.crm_segment_Active_BPX_Customer__c= false;
    a.crm_segment_Active_PIP_Customer__c= false;
    a.crm_segment_Active_PaDoren_Customer_c__c= false;
    a.crm_segment_Active_CargoDom_Customer__c= false;
    a.crm_segment_Active_Customer__c= false;
    a.crm_segment_Active_BPDD_Customer__c= false;
    a.Crm_segment_Active_Post_Customer__c= false;
    a.crm_segment_Active_PakkerB2C_Customer__c= false;
    a.crm_segment_Active_PakkerB2B_Customer__c= false;
    a.crm_segment_Active_ParcelsB2C_Customer__c= false;
    a.crm_segment_Active_ParcelsB2B_Customer__c= false;
    a.crm_segment_Active_Servicepakke_Customer__c= false;
    a.crm_segment_Logistics_Revenue_12__c=null;
    a.crm_segment_Post_Revenue_12__c=null;
    
    
    }
    
     update acclist;
    
    }
    
     global void finish(Database.BatchableContext BC) {}
     
     }