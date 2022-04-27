/*
Created By: Supriya Goel
Object  :share the segment change request with managers
Date: 5th sept 2018 
*/

    public without sharing class crm_segChangeRequestTriggerHelper{
    
     public static void sharerecord(list<Segment_Change_Request__c  > reqList ){
     
     Map<Id,Set<Id>> shareaccessMap = new Map<Id, Set<id>>(); 
     
    Set<Id> reqids= new Set<id>();
    for ( Segment_Change_Request__c   req: reqList ){
        Set<Id> tempSet= new Set<Id>();
         tempset.add(req.Proposed_Sales_Responsible_Manager__c); 
         tempset.add(req.Current_Sales_Responsible_Manager__c); 
        
     
     
        shareaccessMap.put(req.id, tempset);
      
     
       
    
    }
     System.debug('shareaccessMap' + shareaccessMap);      


List<Segment_Change_Request__Share> reqShareList = new List<Segment_Change_Request__Share>();
        for (String reqid: shareaccessMap.keyset()){
           set<id> tempids= new Set<id>();
          if (shareaccessMap.containskey(reqid)) {
             tempids= shareaccessMap.get(reqid) ;
          
          }
           for (String userid: tempids){
        
        
             Segment_Change_Request__Share jobShr  = new Segment_Change_Request__Share();
             jobShr.ParentId = reqid;
             jobShr.UserOrGroupId = userid;
             jobShr.AccessLevel = 'Read';
             jobShr.RowCause = 'Manual'; 
             reqShareList.add(jobShr); 
        
        }
     }   
                
       System.debug('reqShareList' + reqShareList);
        
        List<crm_Exception__c> errorlogs=new List<crm_Exception__c>();
        
          if(reqShareList.size()>0)
                {              
                       //Insert all new party accounts
                        List<Database.SaveResult>  srList = Database.insert(reqShareList,false);
                           for(Integer i = 0; i < srList.size(); i++)
                           {
                          
                                if(srList [i].isSuccess()==false)
                                {   
                                    for(Database.Error err : srList [i].getErrors()) {
                                     crm_Exception__c ex=new crm_Exception__c();
                                     if(err.getMessage().length()>255)
                                     {
                                     err.getMessage().abbreviate(252);
                                     }
                                     ex.crm_Message__c=err.getMessage();
                                     ex.crm_Dml_Field_Names__c=String.valueof(err.getFields());
                                     ex.crm_Stack_Trace__c='record not shared :'+srList [i].id;
                                     errorlogs.add(ex);
                                     }
    
                                }
                              }
                               
                            }
                            
                             insert errorlogs;
                                 
 
    
    }
    
      public static void checkapprover(list<Segment_Change_Request__c  > reqList, Map<id,Segment_Change_Request__c> oldmap){
      
       Set<Id> reqids = new Set<Id>();
       for (Segment_Change_Request__c req: reqList  ){
        Segment_Change_Request__c  oldobj= oldmap.get(req.Id);
     if(oldobj.Status__c != req.Status__c && (req.Status__c == 'Partially Approved' ||req.Status__c == 'Approved' || req.Status__c == 'Rejected'  ) ) 
            reqids.add(req.id);
            }
            
       //for 
       //set<reqlist >
       
       List<ProcessInstance> plist=[ SELECT Id,IsDeleted,LastActorId,ProcessDefinitionId,Status,TargetObjectId, (SELECT ID, ProcessNodeId, StepStatus,
TargetObjectId,ActorId,OriginalActorId,ProcessInstanceId FROM StepsAndWorkitems where StepStatus ='Pending') FROM ProcessInstance
where ProcessInstance.TargetObjectId in :reqids];

Map<Id, Id> targetactorMap= new Map<Id, Id>();
 for (ProcessInstance p: plist) {
   
     for (ProcessInstanceHistory  b: p.StepsAndWorkitems ){
   
            targetactorMap.put(p.TargetObjectId, b.OriginalActorId);
          
            }
        }
         String adminProfileid ='';
        environment_settings__c adminProfilelist = environment_settings__c.getValues('SystemadminProfileid');
         if (adminProfilelist !=null )
                  adminProfileid = adminProfilelist.value__c;
                 
          else 
          
               adminProfileid =[Select id from Profile where name='System Administrator' limit 1].id;      

            system.debug('###targetactorMap' + targetactorMap);
            for (Segment_Change_Request__c req: reqList  ){
            if(Userinfo.getProfileid()!=adminProfileid) {               
                if(targetactorMap.containskey(req.id) && Userinfo.getuserid()!= targetactorMap.get(req.id)  ){ //
             req.adderror('Only the current approver and system admin can approve/reject the record');
             break;
               }
               }
      
      }
     
    
   }
   }