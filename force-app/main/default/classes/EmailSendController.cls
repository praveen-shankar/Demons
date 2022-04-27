public class EmailSendController {
  
    @AuraEnabled 
    public static void sendMailMethod(String mMail ,String mSubject ,String mbody, Id contactid){
    
     List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
  
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
       List<String> sendTo = new List<String>();
       sendTo.add(mMail);
       mail.setToAddresses(sendTo);
       //mail.setReplyTo('noreply@gmail.com'); // change it with your mail address.
      // mail.setSenderDisplayName('salesforce User'); 
       mail.setSubject(mSubject);
       mail.setHtmlBody(mbody); 
       mails.add(mail);
       Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);                                
                              if (results[0].success) 
                                { 
                                
                                 updateconsent(contactid, true);
                                }
                               else{
                                   updateconsent(contactid, false);
                               }
                           
        
   }   
    
    @AuraEnabled
    public static string getContact(id contactid) {
          return [select Id, Name,email from Contact where id =: contactid].email;     
    } 
    
    
  @AuraEnabled     
   public static string getBody(id contactid) {
      
      user u = [select id,name from user where id=:UserInfo.getUserid() limit 1 ];
      EmailTemplate Englishtempid = [Select id,HtmlValue,body,subject,DeveloperName from EmailTemplate where DeveloperName ='MarketingProfileCenter_Template_English'];
      EmailTemplate Norweigntemid = [Select id,HtmlValue,body,subject,DeveloperName from EmailTemplate where DeveloperName ='MarketingProfileCenter_Template_Norweigian']; 
      string emailbody ='';
       
       If(UserInfo.getLanguage() == 'no') {         
           emailbody = Norweigntemid.HtmlValue;
       }
       else{          
           emailbody = Englishtempid.HtmlValue;
       }
       emailbody = emailbody .replace('{!Contact.Id}', contactid);
       emailbody = emailbody .replace('{!User.Name}',u.name);
      
       return emailbody;
   } 
    
    
  @AuraEnabled     
   public static string getsubject() {
      
      EmailTemplate Englishtempid = [Select id,HtmlValue,body,subject,DeveloperName from EmailTemplate where DeveloperName ='MarketingProfileCenter_Template_English'];
      EmailTemplate Norweigntemid = [Select id,HtmlValue,body,subject,DeveloperName from EmailTemplate where DeveloperName ='MarketingProfileCenter_Template_Norweigian']; 
      string subject ='';
       
       If(UserInfo.getLanguage() == 'no') {         
           subject = Norweigntemid.subject;
       }
       else{          
           subject = Englishtempid.subject;
       }
             
       return subject;
   }     
    @AuraEnabled     
        public static boolean updateConsent(Id contactid , Boolean emailStatus) {
            Contact c=[Select Id,Consent_Count__c from Contact where id =: contactid];
           // user u = [select  from user where id=:UserInfo.getUserid() limit 1 ];
           if(c.Consent_Count__c ==null)
               c.Consent_Count__c=1;
            else
            c.Consent_Count__c=c.Consent_Count__c+1;
            update c;  
            System.debug(c);
            Email_Result_for_Consent__c e=new Email_Result_for_Consent__c();
            e.Contact__c=c.Id;
            e.CreatedById=UserInfo.getUserid();
            if (emailStatus){
            e.Status__c='Success';    
            }
            else{
            e.Status__c='Failure';    
            }        
            insert e;
            return true;  
        }
}