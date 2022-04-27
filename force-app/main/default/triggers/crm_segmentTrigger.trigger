/*
Created By: Supriya Goel
Object:Segment object
Date: sprint 5
To change the responsible seller for revenue line if the sales responsible field is changed

*/

trigger crm_segmentTrigger on crm_Segment__c (after update , before update, before insert ) {

     if( Trigger.isInsert  && Trigger.isBefore){
           //update/insert  division records  
         crm_segmentTriggerHelper.MapDivisionRecordonInsert(Trigger.new);  
         
     }
     

    if(Trigger.isUpdate && Trigger.isBefore){
    
         crm_segmentTriggerHelper.MapDivisionRecordonUpdate(Trigger.new);  
            
           List<crm_Segment__c>  segmentList= new List<crm_Segment__c>();   
            
           for(crm_Segment__c seg: Trigger.new){
                crm_Segment__c oldseg = Trigger.oldMap.get(seg.Id);
                           
                if(oldseg.crm_Sales_Responsible__c!= seg.crm_Sales_Responsible__c)
                    segmentList.add(seg);
                }
              
        crm_segmentTriggerHelper.updateResponsibleSelleronRev(segmentList);    
    }

}