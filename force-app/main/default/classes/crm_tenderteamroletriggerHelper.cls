/*
Created By: Supriya Goel
Object  :nderteamrole
Date: 22 August 2017
*/

    public class crm_tenderteamroletriggerHelper{

    public static void sharerecord(list<crm_Tender_Team_Role__c> TeamRoleList){    
      
     Map<id, Id> Tendermap = new Map<id, Id>();
     for (crm_Tender_Team_Role__c  teamrole:  TeamRoleList){
      Tendermap.put( teamrole.crm_User__c,teamrole.crm_Tender__c) ;
    
 
     }
 List<crm_Tender__Share> tenderShareList = new List<crm_Tender__Share>();
  for (id userid : TenderMap.keyset() ){
     crm_Tender__Share jobShr  = new crm_Tender__Share();
     jobShr.ParentId = TenderMap.get(userid);
     jobShr.UserOrGroupId = userid;
     jobShr.AccessLevel = 'Edit';
     jobShr.RowCause = 'Manual'; 
     tenderShareList.add(jobShr); 
  
  
  }
  
  List<Database.SaveResult>  srList = Database.insert(tenderShareList,false);
for( Database.SaveResult sr: srList ){


if(sr.isSuccess()){
         // Indicates success
        System.debug('@@@ success');
      }
      else {
         // Get first save result error.
         Database.Error err = sr.getErrors()[0];
         
         // Check if the error is related to trival access level.
         // Access level must be more permissive than the object's default.
         // These sharing records are not required and thus an insert exception is acceptable. 
         if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  
                  err.getMessage().contains('AccessLevel')){
            // Indicates success.
            System.debug('@@@ success1 ');
         }
         else{
            // Indicates failure.
            System.debug('@@@ fail');
         }
       }
    }
    
    
    }
     
    
    
    }