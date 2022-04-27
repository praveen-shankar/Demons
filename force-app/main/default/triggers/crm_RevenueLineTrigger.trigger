/*
Created By: Supriya Goel
Object  :Revenue line
Date: 7 July 2016
to calculate the revenue this year on Party level account
*/
trigger crm_RevenueLineTrigger  on crm_Revenue_Line__c (before update , before delete) {

  if(test.isRunningTest()){
        crm_OpptyTriggerSetting__c objOppCustomSetting = new crm_OpptyTriggerSetting__c();
        objOppCustomSetting.crm_Oppty_Trigger_Status__c=true;
        objOppCustomSetting.Name = 'Revenueline';
        insert objOppCustomSetting;
        
        crm_OpptyTriggerSetting__c objRevenueLineDeleteSetting = new crm_OpptyTriggerSetting__c();
        objRevenueLineDeleteSetting.crm_Oppty_Trigger_Status__c=true;
        objRevenueLineDeleteSetting.Name = 'RevenueLineDeleteSwitch';
        insert objRevenueLineDeleteSetting ;
        }
     
       crm_OpptyTriggerSetting__c  OpptyTriggerSetting=  crm_OpptyTriggerSetting__c.getValues('Revenueline');
    Boolean IsTriggerON= OpptyTriggerSetting.crm_Oppty_Trigger_Status__c;
    
    if(IsTriggerON)
    {  

   
        //in case of before update
        if(Trigger.isBefore && Trigger.isUpdate){
            crm_revenuelineTriggerHelper.checkIfUpdated(Trigger.new, Trigger.oldMap);
        }
    
    }
    
    crm_OpptyTriggerSetting__c  revenueLineDeleteSetting=  crm_OpptyTriggerSetting__c.getValues('RevenueLineDeleteSwitch');
    Boolean IsRevenueLineDeleteSwitchON = revenueLineDeleteSetting.crm_Oppty_Trigger_Status__c;
    
    if(IsRevenueLineDeleteSwitchON)
    {  
    
        if(Trigger.isBefore && Trigger.isDelete){
          if(crm_revenuelineTriggerHelper.firstCall){
            crm_opportunityTriggerHelper.firstCall = false;
            System.debug('listTriggerOld------trigger--------'+Trigger.old);
            crm_revenuelineTriggerHelper.updateIfDeleted(Trigger.old);
          }
          
        }
    }
   
}