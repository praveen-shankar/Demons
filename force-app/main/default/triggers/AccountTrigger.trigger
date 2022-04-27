trigger AccountTrigger on Account (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    TriggerDispatcher.Entry('Account', trigger.IsBefore, trigger.IsDelete, trigger.isAfter,
                                    trigger.IsInsert, trigger.IsUpdate, trigger.IsExecuting, 
                                    trigger.new, trigger.newmap, trigger.old, trigger.oldmap);
                                    
      //code to count the sum of relation accounts on party level                              
      
   /* if ((Trigger.IsInsert) || (Trigger.IsUndelete)  )
     {
         crm_AccountTriggerHelper.CountRelation(Trigger.New);
     }*/
     
  /*  if (Trigger.IsUpdate && Trigger.IsAfter){
     System.debug('@@ in trigger update')    ;
     crm_AccountTriggerHelper.CountRelationUpdate(Trigger.New, Trigger.old);
     }
     
     if (Trigger.IsDelete && Trigger.IsAfter)
     {
         crm_AccountTriggerHelper.CountRelation(Trigger.Old);
     }*/
     
      if(test.isRunningTest()){
        crm_OpptyTriggerSetting__c objOppCustomSetting = new crm_OpptyTriggerSetting__c();
        objOppCustomSetting.crm_Oppty_Trigger_Status__c=true;
        objOppCustomSetting.Name = 'Account';
        insert objOppCustomSetting;
        }
     
       crm_OpptyTriggerSetting__c  OpptyTriggerSetting=  crm_OpptyTriggerSetting__c.getValues('Account');
    Boolean IsTriggerON= OpptyTriggerSetting.crm_Oppty_Trigger_Status__c;
    
    if(IsTriggerON)
    {  
     
     
      Map<String,Schema.RecordTypeInfo> rtMapByName = Account.SObjectType.getDescribe().getRecordTypeInfosByName();
      Id partyRecordtypeId = rtMapByName.get(System.Label.crm_Party_level_Customer).getRecordTypeId();
      Id relationRecordtypeId = rtMapByName.get(System.Label.crm_Relation_level_Customer).getRecordTypeId();
       //Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
       //Id prospectRecordTypeId = rtMapByName.get(System.Label.Prospect_Customer).getRecordTypeId();
       String prospectRecordTypeId = System.Label.Prospect_Customer; 
         
    if(Trigger.IsInsert && Trigger.isBefore && !System.IsBatch()){
        crm_AccountTriggerHelper.updateAddress(trigger.New,trigger.OldMap,true);
    }else if (Trigger.IsUpdate && Trigger.isBefore && !System.IsBatch())
    {
        crm_AccountTriggerHelper.updateAddress(trigger.New,trigger.OldMap,false);
    }
     if (Trigger.IsUpdate && Trigger.isBefore){ 
         crm_AccountTriggerHelper.checkIfUpdated(trigger.New,trigger.Old);
        crm_AccountTriggerHelper.IsLeadUpdated(trigger.New,trigger.OldMap);
     
     }
     
     //**Added By Rajeev to convert ISO Country code to Country name
     //**Date-06/10/2016
     
     if((Trigger.IsInsert && Trigger.IsBefore) || (Trigger.IsUpdate && Trigger.IsBefore)){    
         Map<String,String> countriesMap = new Map<String,String>();
        
         for(crm_ISO_Country_Codes__c c : crm_ISO_Country_Codes__c.getAll().values())
             countriesMap.put(c.crm_ISO_Country_Code__c,c.crm_Country__c);
         Set<String> availableDropDowns = new Set<String>();
         for(Schema.PicklistEntry p : Account.crm_ISO_Countrycode_for_Customer_Company__c.getDescribe().getPicklistValues())
             availableDropDowns.add(p.getValue());     
         for(Account a : trigger.new){
            if((a.RecordTypeId == partyRecordtypeId || a.RecordTypeId == relationRecordtypeId) && (String.isNotBlank(a.crm_ISO_Countrycode_for_Customer_Company__c))){         
              if(countriesMap.containsKey(a.crm_ISO_Countrycode_for_Customer_Company__c.toUpperCase()))
                  a.crm_ISO_Countrycode_for_Customer_Company__c = countriesMap.get(a.crm_ISO_Countrycode_for_Customer_Company__c.toUpperCase());
              else if(trigger.isUpdate && !availableDropDowns.contains(a.crm_ISO_Countrycode_for_Customer_Company__c.capitalize()) && !countriesMap.containsKey(a.crm_ISO_Countrycode_for_Customer_Company__c.toUpperCase()))
                  a.crm_ISO_Countrycode_for_Customer_Company__c = trigger.oldMap.get(a.Id).crm_ISO_Countrycode_for_Customer_Company__c;
              else if(trigger.isInsert && !availableDropDowns.contains(a.crm_ISO_Countrycode_for_Customer_Company__c.capitalize()) && !countriesMap.containsKey(a.crm_ISO_Countrycode_for_Customer_Company__c.toUpperCase()))
                  a.crm_ISO_Countrycode_for_Customer_Company__c = null;      
            }
         }   
     }
     
     
       if(Trigger.IsInsert && Trigger.IsBefore)
       {
         crm_AccountTriggerHelper.countPrimaryaccount(trigger.New);
           crm_AccountTriggerHelper.showrelationbelowparty(trigger.New);
           
           
           }
     
     if(Trigger.IsUpdate && Trigger.IsBefore){
        List<User> userList= [Select id from user where alias='aadmi' limit 1];
         crm_AccountTriggerHelper.countPrimaryaccountUpdate(trigger.newMap,trigger.OldMap);
         crm_AccountTriggerHelper.showrelationbelowparty(trigger.New);
         for (Account a: trigger.new) {
         System.debug('***'+trigger.oldmap);
         System.debug('***'+trigger.new);
             Account oldAccount =  trigger.oldmap.get(a.id);
             if(a.recordtypeid == partyRecordtypeId && oldAccount.recordtypeid == prospectRecordTypeId ){
                 a.mark_account_for_shared_Contact__c=true;
                 if (userList!= null && userList.size()>0) 
                     a.ownerid= userlist[0].id;
                 }
             if(a.Do_not_want_custom_clearance__c != trigger.oldMap.get(a.Id).Do_not_want_custom_clearance__c){
                 system.debug('account - '+a);
                 crm_AccountTriggerHelper.sendPersonPreferenceToPB(a,trigger.oldMap.get(a.Id));
             }
             if(!(a.disqualified__c) && (trigger.oldMap.get(a.Id).disqualified__c)){
                 system.debug('account - '+a);
                 crm_AccountTriggerHelper.sendDisqalifiedStatusToPB(a,trigger.oldMap.get(a.Id));
             }
             
             
             
         }
      }
      //Added by supriya
      //26th oct 2018
      //Process builder failed for Account status
        if(Trigger.IsInsert && Trigger.IsAfter)
         crm_AccountTriggerHelper.enqueueOpportunityAgreementMaster(trigger.New);
      
      //Added for Agreement master project
     //Rajeev Shekhar 06-03-2018
     if(Trigger.IsUpdate && Trigger.IsAfter){
      List<Account> Acntlist= new List<Account>();
        for (Account a: trigger.new) {
            Account oldAccount =  trigger.oldmap.get(a.id);
             if(a.recordtypeid == partyRecordtypeId && a.crm_Customer_Status_Role_3__c!=oldAccount.crm_Customer_Status_Role_3__c) {
                   Acntlist.add(a);          
         }
         }
          if (Acntlist.size()>0)
           crm_AccountTriggerHelper.ChangeCustomerStatus(Acntlist);
           
           }
         
        if(Trigger.IsUpdate && Trigger.IsAfter){
            crm_AccountTriggerHelper.sendEmailOppOwnerPartyInactivation(trigger.New,trigger.oldMap);
             crm_AccountTriggerHelper.setPartyConvertedFromProspect(trigger.New,trigger.oldMap);
            Set<Id> accIds = New Set<Id>();
            for(Account acc : trigger.new){
                if(acc.Not_updated_from_trigger__c){
                    accIds.add(acc.Id);
                }
            }
         crm_AccountTriggerHelper.setUpdatedByTriggerCheck(accIds);

        }
                  
     //Added for Agreement master project
     
     //Added by Rajeev Shekhar for Customer conversion interface on 09-April-2018
        if(trigger.isUpdate && trigger.isAfter){
            System.debug('crm_AccountTriggerHelper.isFirstTime'+crm_AccountTriggerHelper.isFirstTime);
            if(crm_AccountTriggerHelper.isFirstTime){
                crm_AccountTriggerHelper.isFirstTime = false;
                  crm_AccountTriggerHelper.initiateCustomerConversion(trigger.new,trigger.oldMap); 
            }
           
        }
        
       
       //Added by Jainam Shah for Incident Resoltuion on 04-Feb-2019   E2-SD024466794     E2-SD024475945 
    
    if(trigger.isInsert && trigger.isAfter)
    {
       
        
        for(Account a:trigger.new)
        {
            
            System.debug('trigger.new-P11------'+trigger.new);
            String getDateFromSetting = Label.AccountTrigger_Octoberfirst2020;
            String[] lstPartsOfDate = getDateFromSetting .split('@@@');
            Datetime dt = datetime.newInstance(Integer.valueOf(lstPartsOfDate[0]), Integer.valueOf(lstPartsOfDate[1]), Integer.valueOf(lstPartsOfDate[2]));
            System.debug('dt-P11------'+dt);
        
            if(a.recordtypeid == relationRecordtypeId && a.crm_Primary_Customer_Account__c!=true && a.parentid !=null)
            crm_AccountTriggerHelper.setPrimaryRelation(trigger.new);
            
            if(a.recordtypeid == partyRecordtypeId && a.crm_Updated_by_CDH__c == true  && a.CreatedDate >= dt){
                    
                crm_AccountTriggerHelper.setPartyConverted(trigger.new);
                    
            }
        }
    }
     
    }
    }