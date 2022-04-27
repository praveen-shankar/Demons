global class crm_batchEmailNotification implements Database.batchable<sObject>,Database.Stateful{

    global Double lead_owner_days=0;
    global Double lead_mngr_days=0;
    global Map<Id,List<Lead>> LeadManagerEmailMap= new Map<Id,List<Lead>>();
    public string callback = ''; 
    global crm_batchEmailNotification(String callback){
    this.callback = callback;   
    crm_lead_notification_days__c businessDays= crm_lead_notification_days__c.getValues('Business Days');
    //check if CS not null else assign default values  
      
        if (businessDays!=null ){
            lead_owner_days= businessDays.crm_Lead_Owner_Default_days__c;
            lead_mngr_days= businessDays.crm_Lead_Manager_Default_days__c;
        }
        else{
             lead_owner_days= 3;
             lead_mngr_days=5;
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
      //  String query = 'Select id,Name,FirstName ,crm_Business_Days__c,Rating, crm_Default_Manager_Hours__c, crm_Default_Owner_Hours__c,Industry, LastModifiedDate, CreatedBy.Email,CreatedBy.Name,Owner.email,Owner.name,crm_Owner_Manager_Id__c, crm_last_modified_status_datetime__c, AnnualRevenue, LeadSource,Status from lead where Status not in (\'Closed - Disqualified\',\'Closed - Converted\') and  crm_last_modified_status_datetime__c!=null and isconverted=false';
      //Query changed as a defect E2-IM012073201 - Error on Lead Escalation rule
        String query = 'Select id,Name,FirstName ,crm_Business_Days__c,Rating, crm_Default_Manager_Hours__c, crm_Default_Owner_Hours__c,Industry, LastModifiedDate, CreatedBy.Email,CreatedBy.Name,Owner.email,Owner.name,crm_Owner_Manager_Id__c, crm_last_modified_status_datetime__c, AnnualRevenue, LeadSource,Status from lead where Status in (\'New\') and  crm_last_modified_status_datetime__c!=null and isconverted=false';
        return Database.getQueryLocator(query);                    
    }
      
    global void execute(Database.BatchableContext BC, List<Lead> leadlist) {
                            
        List<Messaging.SingleEmailMessage> allemails = new List<Messaging.SingleEmailMessage>();
        //set the timezone
        Integer i = Timezone.getTimeZone('Asia/Calcutta').getOffset(System.now())/1000;
        datetime startingtime = system.now();
        String FORM_HTML_START = '<HTML><BODY>';
        String FORM_HTML_END = '</BODY></HTML>';
        
        string pdfContent = '' + FORM_HTML_START;
        try{         
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault=true];
        } catch(Exception e) { crm_Exception_handler.createExceptionRecords(e);}
        DateTime startDate  = System.now();
        for(Lead leadtemp : leadlist){  
                    
            /* if lead is not handled for3 days  mark the checkbox as true*/
            if (leadtemp.OwnerID.getsobjecttype() == User.sobjecttype) {
                if(leadtemp.crm_Business_Days__c>= lead_owner_days){
                    leadtemp.crm_Default_Owner_Hours__c=true;
                }
                
            /* if lead is not handled for 5 days hours*/ 
            if(leadtemp.crm_Business_Days__c>= lead_mngr_days){
                leadtemp.crm_Default_Manager_Hours__c=true;//mark the checkbox true
                List<Lead> templeadList= new List<Lead>();
             
                if(leadtemp.crm_Owner_Manager_Id__c!=null){
                if(LeadManagerEmailMap.containsKey(leadtemp.crm_Owner_Manager_Id__c)) {
              
                    templeadList=LeadManagerEmailMap.get(leadtemp.crm_Owner_Manager_Id__c);
                    templeadList.add(leadtemp);
                    LeadManagerEmailMap.put(leadtemp.crm_Owner_Manager_Id__c,templeadList);
                }
                
                else{
             
                    templeadList.add(leadtemp);
                    LeadManagerEmailMap.put(leadtemp.crm_Owner_Manager_Id__c,templeadList);
                    }
                }
            }
        }//check if the lead owner is user  
    }//end of for     
       try{   
        Database.update(leadlist, false);
        } catch(Exception e) {crm_Exception_handler.createExceptionRecords(e); }                  
        if (LeadManagerEmailMap.size()>0){
           
            Map<Id,User > ManagerMap = new Map<Id, user>();
            List<User> MngrList=[Select id, email, FirstName,Name  from User where id in :LeadManagerEmailMap.keySet() ];
           
            for (User u : MngrList){
               ManagerMap.put(u.id,u) ;
           
            }
                       
            for (Id key : LeadManagerEmailMap.keySet()) {
                User mngr= ManagerMap.get(key);
                String name='';
                if(mngr.Name!=null){
                    name=mngr.Name;
                }
                else {
                    name='User';
                }
                             
                List<Lead> leadMngrlist= LeadManagerEmailMap.get(key);
                pdfContent = '' + FORM_HTML_START;
                    pdfContent = pdfContent + '<div>Dear '+name+' ,</div>';
                    pdfContent = pdfContent + '<div><br/><br/>Following Leads are unhandled for more then '+lead_mngr_days+' days; Please take necessary Action.</div><br/><br/> ';
                    pdfContent = pdfContent +'<table border="1" width="1000" valign="bottom" font size="1" font-family:"sans-serif" bgcolor="#D3D3D3">';
                    pdfContent = pdfContent +'<tr><td width="30" align ="center"><b>Lead Name</b></td><td width="15" align ="center"><b>Lead AnnualRevenue</b></td><td width="10" align ="center"><b>Lead Status</b></td><td width="15%" align ="center"><b>Lead Created By</b></td><td width="10%" align ="center"><b>Lead Rating</b></td><td width="10%" align ="center"><b>Lead Source</b></td><td width="10%" align ="center"><b>Lead Industry</b></td></tr>';
                    for(Lead leadtemp : leadMngrlist)    {  
                  
                        decimal revenue;
                        string rating;
                        string leadsource;
                        string industry;
                        
                        if(leadtemp.AnnualRevenue==null){
                            revenue=0.00;
                        }
                        else {
                            revenue=leadtemp.AnnualRevenue;
                        }
                        
                        if(leadtemp.Rating==null) {
                                rating='';
                        }
                        else {
                            rating=leadtemp.Rating;
                        } 
                        if(leadtemp.leadsource==null) {
                                leadsource='';
                        }
                        else {
                            leadsource=leadtemp.leadsource;
                        } 
                        if(leadtemp.industry==null) {
                                industry='';
                        }
                        else {
                            industry=leadtemp.industry;
                        } 
                       
                        pdfContent = pdfContent +'<tr font size="1" align="center" bgcolor="#FFFFFF"><td width="30"><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+leadtemp.id+'">'+ leadtemp.Name +'</a></td><td width="15">' +revenue+'</td><td width="10">' +leadtemp.Status+'</td><td width="15">'+leadtemp.CreatedBy.name+''+'</td><td width="10">'+rating+'</td><td width="10">'+leadsource+'</td><td width="10">'+industry+'</td></tr>';
                         
                    } //end of table creation for same manger
                    pdfContent=pdfcontent+'</table>'; 
                    pdfContent = pdfContent + '<div><br/><br/>Thanks,<br/>Salesforce, Posten & Bring'; 
                
                    Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
                    string owaemailid;
                    String[] toAddresses = new list <string>{mngr.Email}; 
                    String subject ='Escalation Unhandled Lead Report';
                    email.setSubject(subject);
                    email.setToAddresses( toAddresses );
                    email.sethtmlBody( pdfContent);   
                    for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress]) {
                        owaemailid= owa.id;
                       
                    }
                    email.setOrgWideEmailAddressId(owaemailid);
                    allemails.add(email);   
          
                }//end of map for            
                            
                 
            }//end of >o if
           try{
            Messaging.SendEmailResult [] r = Messaging.sendEmail(allemails);
            } catch(Exception e) {      crm_Exception_handler.createExceptionRecords(e); }
        }
        
      global void finish(Database.BatchableContext BC) {
      String str = '';
        AsyncApexJob[] a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ApexClass.Name from AsyncApexJob where Id =:bc.getJobId() ];
        
        if(callback != '' && callback != null)
           str += callback + '\n';
        if(a != null && a.size() > 0){
                    str += a[0].ApexClass.Name + ' ( '+ a[0].Id + ' ' + a[0].status + ')  processed ' + a[0].TotalJobItems + ' batches with '+ a[0].NumberOfErrors + ' failures.';
                }
        
                  
        //send mail 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List < string > toAddress = new List < string > ();
        environment_settings__c emailnotifications = environment_settings__c.getValues('BatchEmailNotification');
        List < String > valuesList1 = new List < String > ();
        if (emailnotifications != null && emailnotifications.value__c != null) 
        valuesList1 = emailnotifications.value__c.split(',');
     
       for (String emailuser:valuesList1 )
            toAddress.add(emailuser);  
       //below code will send an email to User about the status
        mail.setToAddresses(toAddress);
        mail.setSenderDisplayName('Posten');
        mail.setSubject('Summary for batch classes -Lead unhandled notification ');
        mail.setPlainTextBody(str);
        
        // Send the email for the developer reference
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });          
        
        
                    
    } 

    
}