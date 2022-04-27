global class cs_Case_to_lead {

 public case caseObjpage{get;set;}
  public case caseObj{get;set;}
 public Boolean leadalreadycreated{ get; set; }
 public boolean leadcreated {get;set;}
 public boolean leadidnull {get;set;}
 public boolean error{get;set;}
 public boolean casecannotconverted{get;set;}

    public cs_Case_to_lead(ApexPages.StandardController stdController) {
    leadcreated=false;
    leadalreadycreated= false;
    error=false;
    casecannotconverted=false;
    
        this.caseObjpage= (case)stdController.getRecord();
        
        caseObjpage=[Select id, subject,Account.ParentId, Description,AccountEmail__c, cs_lead_id__c, cs_Lead_Detail__c from Case where id=:this.caseObjpage.id];
        
        if(caseObjpage.cs_lead_id__c!=null ) {
                leadalreadycreated=true;
               
        }
        
        if(caseObjpage.cs_Lead_Detail__c !=null){
            casecannotconverted=true;
        }
            
    }
    
    public void saveLead(){
    
    Case Caseobj=[Select id, subject,cs_Case_Converted__c, recordtype.Developername, casenumber,CRMStatus__c, AccountEmail__c,AccountPhone__c, Party_number__c, LM_current_postal_address__c, LM_current_country__c,LM_current_zip_code__c,PostNumber__c, Account.name,Account.Recordtypeid, Contact.lastname,Account.ParentId from case where id=:this.caseObjpage.id];
    
    Lead leadobj=new Lead();
   
    
    if(caseobj.Account.Recordtypeid == KATSutilities.getRecordType('person_account') ){
        error=true;  
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,System.Label.cs_Person_account_error));
    
    }
    
    if(caseobj.AccountEmail__c!=null && caseobj.AccountEmail__c!='')
        leadobj.email=caseobj.AccountEmail__c;
   /* else {
        error=true;  
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,System.Label.cs_No_email_for_lead));
       
    }*/
   
     if(caseobj.AccountPhone__c!=null)
        leadobj.phone=caseobj.AccountPhone__c;    
        
     if(caseobj.account.name!=null)
        leadobj.company=caseobj.Account.name;  
        
     else if(caseobj.subject!=null)
          leadobj.company=caseobj.subject; 
          
        /*  else {
        error=true;  
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,System.Label.cs_no_account_for_lead));
        
    }*/
          
        
     if(caseobj.contact.lastname!=null)
        leadobj.lastname=caseobj.contact.lastname;  
        
      else
        leadobj.lastname=caseobj.casenumber;
        
        /* else {
        error=true;  
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,System.label.cs_no_contact_for_lead));
        
    }*/
        
       
       
     
    leadobj.status='New';
    leadobj.leadSource='Customer Service';
    
    /* Poupluate user detals on lead obkjects*/
    
    List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
    String ProfileName = PROFILE[0].Name;
    
    String rolename='';
    List<UserRole> Roles= [SELECT Id, Name FROM UserRole  WHERE Id=:userinfo.getUserRoleId() LIMIT 1];
    if(Roles.size()>0)
        rolename= Roles[0].Name;
    
    leadobj.cs_lead_createdby__c= UserInfo.getName();
    if (rolename!='')
        leadobj.cs_Lead_Conversion_User_details__c= ProfileName + ' - ' + rolename ;
    else
        leadobj.cs_Lead_Conversion_User_details__c= ProfileName;
    
    String orgno='';
   if(caseobj.Accountid !=null) {
     if(caseobj.Account.Recordtypeid == KATSutilities.getRecordType('crm_Party_level_Customer') ){
         orgno=[Select Orga__c  from Account where id=:caseobj.Accountid limit 1].orga__c;
     
     
     }
     
   }
   
   else if(caseobj.account.parentid!=null) {
    if(caseobj.Account.Recordtypeid == KATSutilities.getRecordType('business_account') ){
          orgno=[Select Orga__c  from Account where id=:caseobj.account.parentid limit 1].orga__c;
      
      }
   }  
      
     if(orgno!=null)
        leadobj.crm_organization_number__c=orgno;  
   
        
    // if(caseobj.Party_number__c!=null)
      //  leadobj.crm_organization_number__c=caseobj.Party_number__c;  
        
      if(caseobj.LM_current_postal_address__c!=null)
        leadobj.city=caseobj.LM_current_postal_address__c;    
        
      if(caseobj.LM_current_country__c!=null)
        leadobj.country=caseobj.LM_current_country__c;  
        
      if(caseobj.LM_current_zip_code__c!=null)
        leadobj.PostalCode=caseobj.LM_current_zip_code__c;   
        
       if(caseobj.PostNumber__c!=null)
        leadobj.PostalCode=caseobj.PostNumber__c;
        
      if(caseobj.AccountPhone__c!=null)
        leadobj.MobilePhone=caseobj.AccountPhone__c;   
        
        
        
        system.debug('@@desc'+ caseObjpage.description);
        
      if(caseObjpage.description!=null && caseObjpage.description!='' )
        leadobj.description=' Desc:' + caseObjpage.description;     
        
      if(caseobj.subject!=null)
        leadobj.description+= ' Subject: ' + caseobj.subject;    
        
          
      if(caseobj.casenumber!=null)
        leadobj.description+= ' Case Number: ' + caseobj.casenumber; 
        
      if(caseobj.CRMStatus__c!=null)
        leadobj.description+= ' KS-status: ' + caseobj.CRMStatus__c; 
        
         //if(caseobj.recordtype.Developername!=null)
       // leadobj.description+= ' Case Record type: ' + caseobj.recordtype.Developername; 
      
        leadobj.cs_case_Detail__c=System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+caseObj.Id;
        leadobj.cs_Case_Number__c=caseobj.casenumber;
        
        system.debug('@@@leadobj'+ leadobj);
        Database.DMLOptions dmo = new Database.DMLOptions();
dmo.assignmentRuleHeader.useDefaultRule= true;
    
     if (error==false){
    try{
                    leadobj.setOptions(dmo);
                    insert leadobj;
                    leadcreated=true;
                  
                   
      }catch(Exception e) {crm_Exception_handler.createExceptionRecords(e); }  
                
         }
         
         
         
        
        if(leadcreated){
        Lead tempobj=[Select id from lead where id=:leadobj.id];
        caseobj.cs_lead_Id__c= tempobj.id;
        caseobj.cs_Case_Converted__c='Case converted to lead';
        
         try{
                    update caseobj;
             }catch(Exception e) {crm_Exception_handler.createExceptionRecords(e); }  
        }     
           
    }

}