public with sharing class MyBringCaseCommentsController {
    
    Public string templatelist{get;set;}
    public MyBring_Conversation__c mbcon{get;set;} 
    public Case caseObj {get;set;} 
    public List<SelectOption> options{get;set;}
    public EmailTemplate templateId{get;set;}    
    public MyBringCaseCommentsController(ApexPages.StandardController controller) {
        if (mbcon== null){
            
            mbcon= new MyBring_Conversation__c ();    
            mbcon= (MyBring_Conversation__c )controller.getRecord();
            // String str = System.currentPageReference().getParameters().get('retURL').substring(1,16);
            //Id myId = (Id)str;
            //System.debug( myId ); 
            mbcon.Case__c= ApexPages.currentPage().getParameters().get('caseid');
            System.debug( mbcon.Case__c); 
            caseObj = [select id,Email__c from case where id=:ApexPages.currentPage().getParameters().get('caseid')];
            
        }
    }
    public List<SelectOption> getCountriesSelectList() {
        options = new List<SelectOption>();
        options.add(new SelectOption('', '-- Select One --'));        
        
        // Find all the countries in the custom setting
        Map<String, CaseCommentTemplates__c> templates= CaseCommentTemplates__c.getAll();
        
        // Sort them by name
        List<String> templateNames = new List<String>();
        templateNames.addAll(templates.keySet());
        templateNames.sort();
        
        // Create the Select Options.
        for (String templateName : templateNames) {
            CaseCommentTemplates__c template= templates.get(templateName);
            options.add(new SelectOption(template.Template_Name__c, template.Template_Label__c));
        }
        return options;
    }
    public PageReference save(){
        return null;
    }
    public PageReference cancel(){
        PageReference pf = new PageReference('/'+caseObj.id);
        pf.setRedirect(true);
        return pf;
    }
    
    public PageReference save1(){
        
        try{
            if(mbcon.Template_Name__c!=null){
                insert mbcon;
                PageReference pf = new PageReference('/'+mbcon.id);
                pf.setRedirect(true);
                return pf;
            }
            else {
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.mbcon_Template_Name_c));
                return null;
            }
            
        } catch(exception ex){
            
            ApexPages.addMessages(ex);
            return null;
        } 
        
    }
    public PageReference TemplateLists() {
        Case c = [select id, subject,casenumber, Produkt__c,reciever_name__c,reciever_address__c,reciever_zip_code__c,reciever_postal_address__c,shipper_name__c,shipper_address__c,shipper_postal_address__c,shipper_country__c,shipper_zip_code__c,Shipment_identification__c,LatestCaseComment__c,Description,content_description__c,unit_to_blame__c from Case where id =:mbcon.Case__c];
        System.debug('~~case::'+c);
        system.debug('template name : '+ templatelist);
        if (!templatelist.contains('none')){
            
            templateId = [Select id,HtmlValue,body,subject from EmailTemplate where DeveloperName =:templatelist limit 1];
            system.debug('template : ' + templateId);
            string emailbody = '';
            emailbody = templateId.Body;
            String sub='';
            sub=templateId.subject;
            system.debug('email Body: ' + emailbody);         
            Map<String, Schema.SObjectField> objfieldMap = Case.sObjectType.getDescribe().fields.getMap();
            for(Schema.SObjectField Field : objfieldMap.Values())
            {
                Schema.DescribeFieldResult fieldResult = Field.getDescribe();
                String strfieldName =  fieldResult.getName() ; 
                String temp = '{!Case.'+ strfieldName+'}'; //no case.body
                String temp1= 'c.' +strfieldName;    
                if ((emailbody.contains(temp))|| (sub.contains(temp)))
                {
                    System.debug(temp + ' :: '  + temp1 );
                    System.debug('Logging issues 1') ; 
                    if((String)c.get(strfieldName )!=null)
                    { 
                    system.debug('case value'+(String)c.get(strfieldName));
                    emailbody = emailbody.replace(temp,(String)c.get(strfieldName)); 
                    sub=sub.replace(temp,(String)c.get(strfieldName)); 
                    }
                    else
                    {
                    System.debug('Inside NULL of case fields');
                        emailbody = emailbody.replace(temp,''); 
                        sub=sub.replace(temp,''); 
                    }
                }
                
                
            }
            if ((emailbody.contains('{!case.body}'))|| (sub.contains('{!case.body}}')))
            {
                system.debug('Inside Case.body');
                // String blank= '';  
                emailbody = emailbody.replace('{!case.body}',''); 
                
                sub=sub.replace('{!case.body}',''); 
                
            } 
            User u=[SELECT Id, Signature,professional_signature__c FROM User where Id =:UserInfo.getUserId() ];
            System.debug('~~User::'+u);
            Map<String, Schema.SObjectField> userobjfieldMap = User.sObjectType.getDescribe().fields.getMap();
            for(Schema.SObjectField userField : userobjfieldMap.Values())
            {
                Schema.DescribeFieldResult userfieldResult = userField.getDescribe();
                String userstrfieldName =  userfieldResult.getName() ; 
                String temp2 = '{!User.'+ userstrfieldName+'}';
                String temp3= 'u.' +userstrfieldName;    
                if ((emailbody.contains(temp2))|| (sub.contains(temp2)))
                {
                    System.debug(temp2 + ' :: '  + temp3 );
                    System.debug('Logging issues 2') ;       
                    system.debug('user value'+(String)u.get(userstrfieldName));
                    if((String)u.get(userstrfieldName)!=null)
                    {
                        System.debug('Inside NoT NULL');
                        emailbody = emailbody.replace(temp2,(String)u.get(userstrfieldName)); 
                        sub=sub.replace(temp2,(String)u.get(userstrfieldName));
                    }
                    else
                    {
                        System.debug('Inside NULL');
                        emailbody = emailbody.replace(temp2,''); 
                        sub=sub.replace(temp2,'');  
                    }
                }               
            }
           
            List<EmailMessage> elist=[SELECT Id, CreatedDate, FromAddress, Subject, ToAddress, CcAddress,TextBody,MessageDate FROM EmailMessage where parentId =:caseObj.Id order by createdDate desc limit 1];
            System.debug('~~EmailMessage::'+elist);
            if(elist.size()>0 ){
                Map<String, Schema.SObjectField> emailobjfieldMap = EmailMessage.sObjectType.getDescribe().fields.getMap();
                for(Schema.SObjectField emailField : emailobjfieldMap.Values())
                {
                    Schema.DescribeFieldResult emailfieldResult = emailField.getDescribe();
                    String emailstrfieldName =  emailfieldResult.getName() ; 
                    String temp4 = '{!EmailMessage.'+ emailstrfieldName+'}'; //no case.body
                    String temp5= 'e.' +emailstrfieldName;    
                    if ((emailbody.contains(temp4))|| (sub.contains(temp4)))
                    {
                        System.debug(temp4 + ' :: '  + temp5 );
                        System.debug('Logging issues 3') ;  
                        if(String.valueOf(elist[0].get(emailstrfieldName))!= null){
                            system.debug('EmailMessage value'+(String.valueOf(elist[0].get(emailstrfieldName))));
                            emailbody = emailbody.replace(temp4,(String.valueOf(elist[0].get(emailstrfieldName)))); 
                            sub=sub.replace(temp4,(String.valueOf(elist[0].get(emailstrfieldName)))); 
                        }
                        else{
                            system.debug('EmailMessage value'+(''));
                            emailbody = emailbody.replace(temp4,''); 
                            sub=sub.replace(temp4,''); 
                        }
                       
                    }
                    
                    
                }
            }
            else
            {
                 Map<String, Schema.SObjectField> emailobjfieldMap = EmailMessage.sObjectType.getDescribe().fields.getMap();
                for(Schema.SObjectField emailField : emailobjfieldMap.Values())
                {
                    Schema.DescribeFieldResult emailfieldResult = emailField.getDescribe();
                    String emailstrfieldName =  emailfieldResult.getName() ; 
                    String temp4 = '{!EmailMessage.'+ emailstrfieldName+'}'; //no case.body
                  //  String temp5= 'e.' +emailstrfieldName;    
                    if ((emailbody.contains(temp4))|| (sub.contains(temp4)))
                    {
                        System.debug(temp4 + ' :: ');
                        System.debug('Logging issues 4') ;  
                       // system.debug('EmailMessage value'+(String.valueOf(e.get(emailstrfieldName))));
                        emailbody = emailbody.replace(temp4,''); 
                        sub=sub.replace(temp4,''); 
                    }
                    
                    
                }
            }
                
            
            
            mbcon.Email_body__c = emailbody; 
            mbcon.Template_Name__c =templatelist;
            mbcon.Subject__c=sub;
        }
            
        else{
            //flag =false; 
            mbcon.Case__c ='';
            mbcon.Email_body__c  = '';
        }
        return null;   
    }
    public PageReference SaveandNew(){
        save();
        String str = ApexPages.currentPage().getUrl().subStringAfter('/');//.substringBefore('?');
        system.debug('str::'+str);
        return new PageReference('/apex/' + str).setRedirect(true);  
        
    }    
    
    
    
    
}