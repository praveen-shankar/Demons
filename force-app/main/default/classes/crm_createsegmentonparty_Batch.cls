/*
Created By:Supriya Goel
Date: 22nd August 2019
Batch to create segments on converred customers*/


global class crm_createsegmentonparty_Batch  implements Database.batchable<sObject>,Database.Stateful{
 public string id= '';


global Database.QueryLocator start(Database.BatchableContext BC){
      crm_AccountRecordTypes__c rTparty = crm_AccountRecordTypes__c.getValues('Party level Customer');
      Id partyLevelRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTparty.crm_Record_Type_Label__c).getRecordTypeId();
      String convertedStatus='Converted';
      
   
      String query = 'Select id, Is_Segment_Created__c , Customer_Converted__c  from Account where  RecordTypeId = :partyLevelRecordTypeId and Is_Segment_Created__c = false and Customer_Converted__c =:convertedStatus  '; 
     
      return Database.getQueryLocator(query);                      
    }
    
     global void execute(Database.BatchableContext BC, List<Account> acclist) {
     List<crm_Segment__c> responsibleSellerList= new List<crm_Segment__c>();
     
       List<String> SGList = new List<String>();
       crm_Opportunity_Record_Type__mdt[] recordTypes = [SELECT Id, DeveloperName, MasterLabel, crm_Id__c FROM crm_Opportunity_Record_Type__mdt where crm_IsNew__c=true];
       for(crm_Opportunity_Record_Type__mdt o : recordTypes){
         SGList.add(o.MasterLabel);
         
       }
       
       Set<Id> Accids= new Set<Id>();
        for (Account a: acclist){
            Accids.add(a.id);
        
        }
       
        String Responsiblesellerid; 
         environment_settings__c env1 = environment_settings__c.getValues('Ufordelte kunder logistikk norge');
          if (env1 != null && env1.value__c != '') {
           List < User > AdminUserList = [Select id from user where username =: env1.value__c limit 1];
           if (AdminUserList.size() > 0) {
            Responsiblesellerid = AdminUserList[0].id;
           }
          }
                
        
        List<crm_Segment__c> responsibleSellerListparty= new List<crm_Segment__c>();
        system.debug('@@responsibleSellerListparty -- >'+responsibleSellerListparty);
        
        String sg='Parcels – Domestic Norway';
        
        responsibleSellerListparty =[Select id, crm_Service_Group__c , crm_Account__c, crm_Sales_Responsible__c from crm_Segment__c where crm_Account__c in :Accids and  crm_Service_Group__c = :sg];
        Map<id,crm_Segment__c > AcctSegmentMap =   new Map<Id, crm_Segment__c>();
        
        for (crm_Segment__c seg: responsibleSellerListparty ){
            AcctSegmentMap.put(seg.crm_Account__c, seg);
            system.debug('@@AcctSegmentMap -- >'+AcctSegmentMap);
        
        }
        
         for (Account a: acclist){
           for (String s: SGList){
               if(s != 'Cargo Domestic Sweden'){
           			crm_Segment__c segobj = new crm_Segment__c();
             		segobj.crm_Account__c = a.id;
             		segobj.crm_Service_Group__c =s;
               
                	if(AcctSegmentMap.containskey(a.id) && !String.isBlank(AcctSegmentMap.get(a.id).crm_Sales_Responsible__c)){
                 		segobj.crm_Sales_Responsible__c = AcctSegmentMap.get(a.id).crm_Sales_Responsible__c ;
                	}
                	else{
                        segobj.crm_Sales_Responsible__c = Responsiblesellerid;
                	}
                   
                   responsibleSellerList.add(segobj);
               }
           
           }
           
        }
        
        system.debug(responsibleSellerList);
        insert responsibleSellerList;
      for (Account a: acclist){
            a.Is_Segment_Created__c= true;
        
        }
        
         update acclist;
     
     
     }
     
      global void finish(Database.BatchableContext BC) {
           
      }
      
      }