/*
Created By: Supriya Goel
Object  :Agreement
Date: 28 march 2016
Trigger  for Agreement to create task  for user 
Update the agreement id in the  opportunity record
Update status to active if the agreement start date is today
update the agreeemnent sart dates in Opportunities if the agreement start date changes

*/

    trigger crm_agreementTrigger on crm_Agreement__c (after insert, after update, before insert, before update) {
    
     if(test.isRunningTest()){
        crm_OpptyTriggerSetting__c objOppCustomSetting = new crm_OpptyTriggerSetting__c();
        objOppCustomSetting.crm_Oppty_Trigger_Status__c=true;
        objOppCustomSetting.Name = 'Agreement';
        insert objOppCustomSetting;
    }
    crm_OpptyTriggerSetting__c  OpptyTriggerSetting=  crm_OpptyTriggerSetting__c.getValues('Agreement');
    Boolean IsTriggerON= OpptyTriggerSetting.crm_Oppty_Trigger_Status__c;
    
    if(IsTriggerON)
    {       
         //to update the opportunity record and add the agreement id
        if(Trigger.isInsert && Trigger.isAfter){
             List<crm_agreement__c> updateagrid= new list<crm_agreement__c>();
         
            crm_agreementTriggerHelper.UpdateAgreementIdinOpp(Trigger.new);
           //  crm_agreementTriggerHelper.SetAgrNRSD(Trigger.new);
        } 
        //to create task when agreement is created
        if(Trigger.isInsert && Trigger.isAfter  || Trigger.isUpdate && Trigger.isAfter){
        System.debug('###in agm 1');
        Set<Id> AccntIds = new Set<Id>();
           // crm_agreementTriggerHelper.CreateTask(Trigger.oldMap , Trigger.new);
            
            for (crm_Agreement__c agr : Trigger.new){
                if(agr.crm_status__c =='Active')
                    AccntIds.add(agr.crm_account__c) ;
            }
            
            
            crm_agreementTriggerHelper.SetAccountValues(AccntIds);
        }   
        
       
        
        //Update the agreement status to active if the agreement start date is today
        if(Trigger.isInsert && Trigger.isBefore  ) { // || Trigger.isUpdate && Trigger.isBefore 
        System.debug('###in agm 3');
           // crm_agreementTriggerHelper.UpdateAgreementStatus(Trigger.new);
            List<crm_Agreement__c> agrsetLookup=  new List<crm_Agreement__c>();
            crm_agreementTriggerHelper.UpdateLookupfield(Trigger.new);
            
        }
     if(Trigger.isUpdate && Trigger.isBefore  ) { 
           System.debug('###in agm 4'); 
         crm_agreementTriggerHelper.UpdateLookupfield(Trigger.new);
           
        }
        
          if(Trigger.isUpdate && Trigger.isAfter)   {
          Set<Id>  AgrIds = new  Set<Id> ();
              Set<Id> AccntIds = new Set<Id>();
              for (crm_Agreement__c agr : Trigger.new){
               crm_agreement__c oldAgr= Trigger.oldMap.get(agr.Id);
                   if(agr.crm_status__c =='Active')
                       AccntIds.add(agr.crm_account__c) ; 
                   if(agr.crm_status__c =='Terminated' && oldAgr.crm_status__c!= agr.crm_status__c)
                      AgrIds.add(agr.id);   
            }
            crm_agreementTriggerHelper.SetAccountValues(AccntIds);
           
              //Added by Supriya Master agreement change                
            //if opp is updated after closed won and was earlier verified by contract management and status was callout finished
             environment_settings__c env = environment_settings__c.getValues('AgeementMasterInterfaceSwitch');
             if(env != null && env.value__c == 'true' && AgrIds.size()>0){
                 crm_agreementTriggerHelper.sendToPriceEngine(AgrIds);
            }
         
         }
         
  }
  }      
        //US-809 if agreement start date is changed , update agreement start dates for all the linked opp    
       /* if(Trigger.isUpdate && Trigger.isAfter)   {
       
            List<crm_Agreement__c> agrList=  new List<crm_Agreement__c>();
            for (crm_Agreement__c agr : Trigger.new){
                 crm_Agreement__c oldagr= Trigger.oldMap.get(agr.id);
                if (oldagr.crm_Agreement_Start_Date__c!= agr.crm_Agreement_Start_Date__c){
                    agrList.add(agr);
                }
            
            }
            
            if (agrList.size()>0){
                crm_agreementTriggerHelper.UpdateOpportunityStartdates(Trigger.new);
            }    
        }//no need for this user will update opp date instead of agr date

        

    }*/