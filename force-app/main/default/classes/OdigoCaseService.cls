/**
* The primary class that create case and find the correct routing based on skill from Odigo
* Search for customer locally
* Modified by Rajeev Shekhar
**/

public with sharing class OdigoCaseService {
  
  @RemoteAction
  public static PageReference OdigoCaseService(String sid,String phn,String CFid,String iphn,String callref){
        System.debug('Parameters are :' + sid + '-' + phn + '-' + CFid + '-' + iphn + '-' + callref);
        String callerId = phn;
        String folderId = CFid;
        String callerSkill = sid;
        String intPhNum = iphn;
        String cdsId = null;
        String cdsRecType = null;
        String recTypeId = null;
        Map<String,String> rtMap = new Map<String,String>();
        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();
        String accountListId = null;
        String contactListId = null;
        String hiddenQueue = null;
        Id postalunit = null;
        Id queueDetail = null;
        
        //Query the CDS Service based on Skill ID
        callerSkill = callerSkill.toUpperCase();
        
        /*Special case for OPPLAERING because there is already a record with same name in CDS service object and there is a unique check based on name.
          This code can be removed if the name conflict is removed in the table.
        */
        Object OPPLAERING = 'OPPLAERING';
        if(callerSkill.equals(OPPLAERING)) callerSkill = 'B_OPPLAERING';
        
        CDS_Service__c[] cds_service = [SELECT Id, queueDetails__c,Auto_Search_PostUnit__c,Auto_Search_Customer__c,queueDetails__r.queue_id__c, Def_Rec_Type__c, CDS_Service_Group_Name__c 
                                       FROM CDS_Service__c WHERE CDS_Service_Group_Name__c = :callerSkill And Odigo__c = true LIMIT 1];
        
        /**
        * Return the correct queue 
        **/
        if(cds_service.size() > 0){
            cdsId = cds_service[0].Id;
            cdsRecType = cds_service[0].Def_Rec_Type__c;
            queueDetail = cds_service[0].queueDetails__c;
            if(cds_service[0].Auto_Search_PostUnit__c)
                postalunit = KATSutilities.getPostalUnitbyPhone(callerId);      
        }

        for(RecordType r : [Select Id, DeveloperName FROM RecordType WHERE sObjectType = 'Case']){
            rtMap.put(r.DeveloperName,r.Id);
        }
        
        if(String.isNotBlank(cdsRecType)){
            recTypeId = rtMap.get(cdsRecType);
        }else{
            recTypeId = rtMap.get(Label.CDS_Default_RecType);
        }

        //if recTypeId is still null, it means there is an exception while fetching the RecordTypeId
        //Use default RecordTypeId to avoid exception
        if(recTypeId == null) recTypeId = rtMap.get(Label.CDS_Default_RecType);
            
       /**
       * Search Contact by callerId
       **/
        if (String.isNotBlank(callerId) && callerId.length() > 2 && cds_service.size()>0 && cds_service[0].Auto_Search_Customer__c) {
            String allNums = KATSutilities.getAllPossiblePhoneNumbers(callerId);
            List<List<SObject>> searchList = [FIND :allNums IN PHONE FIELDS RETURNING Account(Id, Name,crm_Updated_by_CDH__c, CRMStatus__c Where RecordType.DeveloperName IN ('person_account','business_account') Order By CreatedDate ASC),
                                              Contact(Id, AccountId, Account.CRMStatus__c,  Account.crm_Updated_by_CDH__c Where Account.RecordType.DeveloperName IN ('person_account','business_account') Order By CreatedDate ASC)];
            if (searchList != null && searchList.size() > 0) {
                accounts = ((List<Account>)searchList[0]);
                     if (searchList.size() > 1) {
                          contacts = ((List<Contact>)searchList[1]);
                     }
            }
        }
                

        if(contactListId == null) {
            for(Contact c : contacts){
                if(c.Account.crm_Updated_by_CDH__c){    
                    contactListId = c.Id;
                    accountListId = c.AccountId;
                    break;
                 }else{
                    contactListId = c.Id;
                    accountListId = c.AccountId; 
                 }      
            }
        }
        
        if(accountListId == null){
            for(Account a: accounts){
                if(a.crm_Updated_by_CDH__c){
                    accountListId = a.Id;
                    break;
                 }else{
                    accountListId = a.Id; 
                 } 
            }
        }
           
    
        /**
        * Case creation
        **/     
        Case newCase = new Case (Status = 'Under behandling',
                   SuppliedPhone = callerId.replaceFirst('^0+', ''),
                   AccountId = accountListId,
                   ContactId = contactListId,
                   Origin = 'Telefon',
                   RecordTypeId = recTypeId,
                   OwnerId = Userinfo.getUserId(),
                   CDS_Service__c = cdsId,
                   unit_to_blame__c = postalunit,
                   unread_action__c = false,
                   case_new_Comment__c = false,
                   get_Queue_Defaults__c = false,
                   Odigo_Call_Id__c = callref
                   );
        
        
        if(String.isNotBlank(queueDetail)){
            QueueDetails__c[] queueDetailRec = [Select Id,Entitlement__c,Business_Hours__c,Code_Event__c,Code_Event__r.Name,Service_Product__c,OwnerId,Owner.Name,
                                           Service_Product__r.Name,Code_Reason1__c,Code_Reason1__r.Name,Code_Reason2__c From QueueDetails__c Where Id = :queueDetail];
            newCase.EntitlementId = queueDetailRec[0].Entitlement__c;
            newCase.BusinessHoursId = queueDetailRec[0].Business_Hours__c;
            newCase.hidden_queue_id__c = queueDetailRec[0].OwnerId;
            newCase.hidden_queue_name__c = queueDetailRec[0].Owner.Name;
            newCase.hidden_owner_type__c = 'User';
            CaseController.setHenvendelsestypeDefaults(newCase,queueDetailRec.get(0));
        }
        
        Pagereference pgref = null;
        String key = Case.sObjectType.getDescribe().getKeyPrefix();
        try{
            insert newCase;
            if(String.isNotBlank(newCase.Id)){
                pgref = new ApexPages.StandardController(newCase).view().setRedirect(true);
            }
            else
                pgref = new Pagereference('/' + key + '/e?retURL=%2F' + key + '%2Fo&ent=Case&RecordType=' + recTypeId);    
        }Catch(Exception e){
            System.debug('Exception occured in OdigoCaseService class. '+e);
            ExceptionController.createErrorRecord(e,e.getMessage());
            pgref = new Pagereference('/' + key + '/e?retURL=%2F' + key + '%2Fo&ent=Case&RecordType=' + recTypeId);
        }      
      
      return pgref;
                
    }

        
}