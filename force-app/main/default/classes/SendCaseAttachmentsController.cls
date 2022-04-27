//@Author - Rajeev
//****Controller to forward attachments from Case Object ***//
//****Visualforce page (ForwardCaseAttachments) of this controller is overridden by "Forward Attachments" custom button on Case object. ***
//****Test method in "SendCaseAttachmentsController_test" class.
//****Contains wrapper classes.

public with sharing class SendCaseAttachmentsController{

    
    //Initializations
    public Case cases{get;set;}//***sObject initialization
    public ApexPages.StandardController controller{get;set;}//***StandardController initialization
    public List<caseAttachmentWrapper> caseAttachments{get;set;}//***List of wrapper class to show Case attachments with a checkbox
    public Set<String> emailSet;//***Set of email set created to avoid duplicates.
    public List<wrapEmailsToShow> wrapEmailsToShowList{get;set;}//***List of wrapper class to show email ids in the pageBlockTable
    public String emails{get;set;}//***This variable stores the input email from the user.
    public String message{get;set;}//***This variable stores the email body
    public String subjectline{get;set;}//***This variable stores subject of the email
    public Integer counter;//***Variable to count number of emails added
    public Boolean errormsg{get;set;}//***This variable renders the error message if the provided email id is invalid
    public Boolean isdisabled{get;set;}//***This variable disables the "Forward Attachment" and "Add Email" commandButton when there are no attachments.
    public Boolean noEmailAddress{get;set;}//***Highlights the field with an error message when user sends email without adding email id
    public Boolean deletionDisabled{get;set;}//***Disables the delete attachment button when there are no attachments
    public Decimal totalFileSize;//***Captures the total size of the attachments to send
    public Map<Id,Decimal> fileSizeMap{get;set;}//***Stores the Map of Attachment Id and correspnding size
    public String totalFileSizeToDisplay{get;set;}//***Captures the total size of the attachments to send and displays on VF page
    public Decimal selectedAttachmentSize;//***Captures total size of the attachments. Shouldn't be greater than 3 MB.
    public Integer maxSize;//***Holds the maximum size of attachemnts that can be selected
    public String threadId;//***ThreadId of the related Case record
    public String toEmailIds;//***Holds the To Address to insert as a CaseComment
    public String attachmentNames;//***Holds attachment names to insert as CaseComment
    public List<String> toAddressesList;
    public Boolean flag = true;
    
    
    
    //***Property to display page block tables to show added emails
    public Boolean renderPageBlockTable{
        get{
            if(renderPageBlockTable == null)
                renderPageBlockTable = false;
           return (wrapEmailsToShowList.size() > 0);     
           }
       set;
      }
      
      
      
    //***Property to display case attachments page block tables to show added emails
    public Boolean renderPageBlockAttachmentsTable{
        get{
            if(renderPageBlockAttachmentsTable == null)
                renderPageBlockAttachmentsTable = false; 
           return (caseAttachments.size() > 0);     
           }
       set;
      }     
    
    
    
    //***Constructor***
    //***Invokes method to display the related attachments of the Case record
    public SendCaseAttachmentsController(ApexPages.StandardController controller){
        this.controller = controller;
        if(!Test.isRunningTest()) 
         controller.addFields(new List<String>{'Subject','Description','case_referens__c'});
         cases = (Case)controller.getRecord();
         
         if(cases.case_referens__c != null)
          threadId = cases.case_referens__c;
         else
          threadId = '';
          
         errormsg = false;
         isdisabled = false;
         deletionDisabled = false;
         noEmailAddress = false;
         totalFileSize = 0;
         totalFileSizeToDisplay = '';
         maxSize = Integer.valueOf(environment_settings__c.getValues('default_email_size').value__c);

       //***Captures the details to show data pre-populated on the VF page  
       if(cases.description != null)
         message = cases.description;
       //***Captures the details to show data pre-populated on the VF page
       if(cases.subject != null)
         subjectline = cases.subject;
        
        emailSet = new Set<String>();
        fileSizeMap = new Map<Id,Decimal>();
        caseAttachments = new List<caseAttachmentWrapper>();
        wrapEmailsToShowList = new List<wrapEmailsToShow>();
        counter = 0;
        
        //***This method queries case attachments on page load
        queryAttachments();
       
       //***Displays page message when no attachments are present
       if(caseAttachments.size() == 0){
         sendPageMessage(ApexPages.Severity.INFO,System.Label.Case_no_attchment);
          isdisabled = true;
          deletionDisabled = true;
       }
    }

    
    
    //***Query the related attachments, less than 3 MB of size
    //***Getting maximum email size from Custom Settings.
    public void queryAttachments(){
        if(maxSize != null){ 
         for(Attachment a : [Select Id, Body, BodyLength, Name, Description, ParentId, ContentType from Attachment where ParentId = :cases.Id and BodyLength < :maxSize]){
            fileSizeMap.put(a.Id,a.BodyLength);
            caseAttachments.add(new caseAttachmentWrapper(a));
           } 
        }   
     }

    
    
    //***Add Emails to list. Is invoked on "Add Emails" button click. 
    public void addEmails(){
        for(String s : emails.split(',')){
         //***Invoking method that validates the email Id before adding in the table.
         if(isUserEmailValid(s)){
          errormsg = false;
           noEmailAddress = false;
            if(!emailSet.contains(s)){
             wrapEmailsToShowList.add(new wrapEmailsToShow(s,counter));//***Creating wrapper of email and a counter.
              counter = counter + 1;
               emailSet.add(s);//***Adding to set and checking to avoid duplicates
               emails = '';
              }else{
                  sendPageMessage(ApexPages.Severity.INFO,System.Label.case_emai_already_added);
              } 
           }
            else{
             errormsg = true;   
          }
      }
    }
    

    
    //***Remove particular row of list
    //***Is invoked by "Delete" commandLink in the pageBlocktable
    public void removeEmails(){
         List<String> toStayInSet = new List<String>();
         errormsg = false;
         wrapEmailsToShowList.remove(Integer.valueOf(ApexPages.CurrentPage().getParameters().get('rowToBeDeleted')));
         for(wrapEmailsToShow emailId : wrapEmailsToShowList)
             toStayInSet.add(emailId.emailrow);
              emailSet.retainAll(toStayInSet);//***This keeps the set in sync with the list so as to compare accurately.   
         for(Integer i=0;i<wrapEmailsToShowList.size();i++)
             wrapEmailsToShowList[i].rowcounter= i;
             counter = counter - 1;
     }
    
    
   

    //***Send emails to added addresses. Uses the wrapper class lists to get email ids and attachment records.
    //***Also sets page messages in case of exception and failure in validation rules.
    public PageReference sendEmailsToAddresses(){
         PageReference pageref;
         selectedAttachmentSize = 0;
         errormsg = false;
         Map<String,String> failedObjects = new Map<String,String>();
         Set<String> toAddressesSet = new Set<String>();
         toAddressesList = new List<String>();
         List<Messaging.SingleEmailMessage> theemails = new List<Messaging.SingleEmailMessage>(); 
         List<Attachment> attachments = new List<Attachment>();
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
         
         for(wrapEmailsToShow emailId : wrapEmailsToShowList)
             toAddressesSet.add(emailId.emailrow); 
             
         toAddressesList.addAll(toAddressesSet);
         
         toEmailIds = '';
         attachmentNames = '';
         
         for(String s : toAddressesList){
             if(checkInteration())
               toEmailIds = toEmailIds + s;
             else
               toEmailIds = toEmailIds + ',' + s;
            } 
         
         flag = true;
         
         for(caseAttachmentWrapper record : caseAttachments){
            if(record.check){
                attachments.add(record.att);
                  selectedAttachmentSize = selectedAttachmentSize + (record.att.BodyLength);
                if(checkInteration()){
                  attachmentNames = attachmentNames + record.att.Name;
                }else{
                  attachmentNames = attachmentNames + ',' + record.att.Name;
              } 
           }
         }
         
         flag = true;
         
         String replyToAddress = '';
         Map<String,environment_settings__c> envMap = environment_settings__c.getAll();
         if(envMap.containsKey('replyToEmail'))
         {
            if(envMap.get('replyToEmail').value__c != null && envMap.get('replyToEmail').value__c != '')
                replyToAddress = envMap.get('replyToEmail').value__c;   
         }
         else
            replyToAddress = 'noReply@Salesforce.com';
           
           
         mail.setToAddresses(toAddressesList);
         mail.setSubject(subjectline + ' ' + threadId);
         mail.setHtmlBody(formatEmailBody(message));
         mail.setReplyTo(replyToAddress);
         mail.setSenderDisplayName('Salesforce.com');
         mail.setFileAttachments(createEmailAttachments(attachments));
         theemails.add(mail);
        
         if(toAddressesList.size() == 0){
            sendPageMessage(ApexPages.Severity.WARNING,System.Label.Case_add_email_address);
            noEmailAddress = true;
            pageref = null;
          } 
         else if(selectedAttachmentSize > maxSize){
            sendPageMessage(ApexPages.Severity.ERROR,System.Label.case_max_att_size);
            pageref = null;
          }
         else{
         try{ 
             if(Limits.getLimitEmailInvocations() < 11){
         for(Messaging.SendEmailResult result : Messaging.sendEmail(theemails,false)){ 
             if(!result.isSuccess()){
                for(Messaging.SendEmailError error : result.getErrors()){
                     failedObjects.put(error.getTargetObjectId(),error.getMessage());
                }
             }else{
              createCaseComment();
             }
            }
          }
         }Catch(EmailException e){
               System.debug('Exception Occured: '+e.getMessage());
               ApexPages.addMessages(e);
               pageref = null;
        }
        pageref =  new PageReference('/' + controller.getId());
      }
     
     return pageref;
    }
    
    
    
    
    //***Method to create CaseComment whenever an email is sent successfully
    private void createCaseComment(){
        CaseComment comment = new CaseComment(ParentId = cases.Id,IsPublished = false,CommentBody = createCaseCommentBody());
        insert comment;
    }
    
    
    
    //***Method to create CaseComment comment body
    private String createCaseCommentBody(){
        String body = '';
        body += 'Message : Case Attachment Forwarded '  + Message + '\n';
        body += 'User : ' + UserInfo.getName() +'\n';
        body += 'To : ' + toEmailIds + '\n';
        body += 'Attachments : ' + attachmentNames;
    
      return body;    
    }
    
    
    
    //***Calculate attachment size and displays on the VF page.   
    public void calculateAttachmentSize(){
        String attachmentId = ApexPages.currentPage().getParameters().get('AttId');
        String checkValue = ApexPages.currentPage().getParameters().get('checkValue');
            if(checkValue == 'true')
                totalFileSize = (totalFileSize + fileSizeMap.get(attachmentId));
            else
                totalFileSize = (totalFileSize - fileSizeMap.get(attachmentId));
                totalFileSizeToDisplay = KATS_ConversionUtility.FileSizeToString(totalFileSize.longValue());
    }
    
    
    
    //***Method to format email body.
    public string formatEmailBody(String message){
         String emailstring = '';
          for(Integer i=0;i<message.split('\n').size();i++){
            emailstring = emailstring + message.split('\n')[i] + '<br/>';
          } 
       return emailstring;
    }
    
    

     //***Method to set page messages based on severity.
     public void sendPageMessage(ApexPages.Severity severity,String message){
          ApexPages.addMessage(new ApexPages.Message(severity,message));
       }
     
    
    
    //***Create email attachments. This is further utilized with SingleEmailMessage to send these attachments in the email.
    public List<Messaging.EmailFileAttachment> createEmailAttachments(List<Attachment> attachments){
        List<Messaging.EmailFileAttachment> filestoattach = new List<Messaging.EmailFileAttachment>();
         for(Attachment a : attachments){
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
             efa.setBody(a.body);
              efa.setFileName(a.Name);
               efa.setContentType(a.ContentType);
                filestoattach.add(efa);
             }   
         return filestoattach; 
    }
    
    
    
    
    //***Go back to the Case record
    public PageReference goBackToCaseRecord(){
        return new PageReference('/' + controller.getId());
    }
    
    
    
    //***Add attachments to the case record
    public PageReference addAttachmentsToThisCase(){
        return new PageReference('/p/attach/NoteAttach?pid='+controller.getId()+'&parentname='+cases.CaseNumber+'&retURL=%2Fapex/ForwardCaseAttachments?Id='+controller.getId());

    }
    
    
    
    //***Determine attachment size 
    public Integer getAttachmentSize(){
        return caseAttachments.size();
    }
    
    
    
    
    //***Method to validate the format of email Id.
    public boolean isUserEmailValid(String userEmail) {
        Boolean flag = false;
         if(userEmail != null) {
            String  emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
               flag =  Pattern.compile(emailRegex).matcher(userEmail.trim()).matches();
          }
        return flag;
    }
    
    
    
    //***Returns true/false on basis of iteration
    private Boolean checkInteration(){
         if(flag){
           flag  = false;
            return true;
         }else{
             return flag;
          }   
    }
    
    
    //***Wrapper class to wrap Email id with a counter to count email ids
    //***This helps to add and remove rows of email from the pageBlockTable
    public class wrapEmailsToShow{
        public string emailrow{get;set;}
        public Integer rowcounter{get;set;}
        
        public wrapEmailsToShow(String emailrow,Integer rowcounter){
            this.emailrow = emailrow;
            this.rowcounter = rowcounter;
        }
    
    }
    
    
    
    //***Wrapper class to wrap Attachments with a boolean variable
    //***This boolean variable is used to identify the selected record
    public class caseAttachmentWrapper{
        public Attachment att{get;set;}
        public boolean check{get;set;}
        public Decimal eachRecordSize{get;set;}
        public String eachRecordSizeToDisplay{get;set;}
          
        public caseAttachmentWrapper(Attachment att){
            this.att = att;
            eachRecordSize = att.BodyLength;
            eachRecordSizeToDisplay = KATS_ConversionUtility.FileSizeToString(eachRecordSize.longValue());
            check = false;
        }
    }
    
    
}
//*****END*****//