/*
Created By: Supriya Goel
Object  :rev line
Date: 7th july  2016
Helper class for Rev line Trigger

*/

public class crm_revenuelineTriggerHelper {
      Public static Boolean firstCall = true;
    // method to update last_updated_time__c
     public static void checkIfUpdated(List<crm_Revenue_Line__c> triggerNewList ,Map<Id, crm_Revenue_Line__c> triggeroldMap){
      /*  List<crm_Revenue_Line__c> triggerNewList = (List<crm_Revenue_Line__c>)triggerNewValues;
        List<crm_Revenue_Line__c> triggerOldList = (List<crm_Revenue_Line__c>)triggerOldValues;
        
        
        set<String> fieldSets = Schema.SObjectType.crm_Revenue_Line__c.fields.getMap().keySet();
        list<String> allFields = new list<String>(fieldSets);
                      
        System.debug('Testing');
        Integer i = 0, j=0;
        while( j < allFields.size()){
            if(i < triggerNewList.size() && triggerOldList[i].get(allFields[j])!= triggerNewList[i].get(allFields[j])){
                triggerNewList[i].Last_Updated_Time__c = System.now();
                i++;
                j = 0;
            }
           j++;     
        }
        System.debug('new : '+ triggerNewList);*/
        
        
      
        for (crm_Revenue_Line__c rev: triggerNewList  ){
        crm_Revenue_Line__c oldRev=  triggeroldMap.get(rev.id);
        
          System.debug('new : '+ rev);
          
            System.debug('old: '+ oldRev);
        if(rev.crm_Account__c != oldRev.crm_Account__c ||  rev.crm_Agreement__c != oldRev.crm_Agreement__c  ||   rev.crm_Amount__c != oldRev.crm_Amount__c  || rev.crm_e_commerce_KAM__c != oldRev.crm_e_commerce_KAM__c  ||  rev.crm_Group_KAM__c != oldRev.crm_Group_KAM__c  ||  rev.crm_Product__c != oldRev.crm_Product__c ||rev.crm_Responsible_Seller__c != oldRev.crm_Responsible_Seller__c  ||    rev.crm_Revenue_Type__c != oldRev.crm_Revenue_Type__c ||  rev.crm_Transaction_Date__c!= oldRev.crm_Transaction_Date__c  )
           
           {
           
           rev.Last_Updated_Time__c= system.now();
          
           
           }
        
        }
        
      
        
    }//end of method
    
    public static void updateIfDeleted(List<crm_Revenue_Line__c> listTriggerOld){
        System.debug('listTriggerOld--------------'+listTriggerOld);
        Set<Id> setRevenueIds = new Set<Id>();
        List<crm_Revenue_Line__c> lstUpdatedRevenueLine = new List<crm_Revenue_Line__c>();
        
        if(listTriggerOld.size() > 0){
        
            for (crm_Revenue_Line__c rev: listTriggerOld){
                setRevenueIds.add(rev.Id);
            
            }
            
            for(crm_Revenue_Line__c objRevenueLine : [Select Id, Last_Updated_Time__c from crm_Revenue_Line__c where Id IN :setRevenueIds]){
            objRevenueLine.Last_Updated_Time__c= system.now();
            lstUpdatedRevenueLine.add(objRevenueLine) ;
            System.debug('rev--------------'+objRevenueLine.Last_Updated_Time__c);
            }
        
            System.debug('lstUpdatedRevenueLine--------------'+lstUpdatedRevenueLine);
            if(lstUpdatedRevenueLine.size() > 0){
               System.debug('lstUpdatedRevenueLine----update----------'+lstUpdatedRevenueLine);
                update lstUpdatedRevenueLine;
            }
        }
        
        
       
        
    
    }
        
}