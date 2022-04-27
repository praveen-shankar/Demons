public class NewPibController {
    
    Public string TemplateName{get;set;}
    public cs_case_pib_messages__c pibobj{get;set;}    
    public boolean flag{get;set;}   
    public Case caseObj {get;set;}   
    Public list<SelectOption> Items{get;set;}
    public EmailTemplate templateId{get;set;}    
    public string postalunit{get;set;}
    
    public NewPibController(ApexPages.StandardController stdcontroller) {
        if (pibobj == null){
            pibobj = new cs_case_pib_messages__c();    
            pibobj= (cs_case_pib_messages__c)stdcontroller.getRecord();
            pibobj.cs_pib_case__c = ApexPages.currentPage().getParameters().get('caseid'); 
            caseObj = [select id,unit_to_blame__c from case where id=:ApexPages.currentPage().getParameters().get('caseid')];
            pibobj.category__c ='New';
            postalunit ='';
            
            if(caseObj.unit_to_blame__c !=null){
                postalunit = [select id,email__c,Name from PostalUnit__c where id=:caseObj.unit_to_blame__c limit 1].Name;               
                pibobj.cs_related_to_postal_unit_c__c = postalunit;
            }
        } 
        
        items = new List<SelectOption>();
        Items.add(new SelectOption('none','--None--'));
        
        //added custom metadata type for folder -PIB Melding
        PIBFolder_Setting__mdt folderid = [select FolderId__c from PIBFolder_Setting__mdt where DeveloperName like '%PIB_Meldinger%' limit 1];
        
        for(EmailTemplate templist : [SELECT Name,Subject,TemplateType,Description,FolderId FROM EmailTemplate where FolderId = :folderid.FolderId__c]) {
            system.debug('~~inside constructor');
            Items.add(new SelectOption(templist.Id,templist.Name));                 
        }      
    }
    
    public List<SelectOption> getStatus(){
        
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = cs_case_pib_messages__c.category__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
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
            if(pibobj.cs_subject__c!=null){
                insert pibobj;
                PageReference pf = new PageReference('/'+pibobj.id);
                pf.setRedirect(true);
                return pf;
            }
            else {
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.cs_pib_subject));
                return null;
            }
            
        } catch(exception ex){
            
            ApexPages.addMessages(ex);
            return null;
        } 
        
    }
    
    public PageReference TemplateLists() {
        
        Case c = [select id, casenumber, Produkt__c,reciever_name__c,reciever_address__c,reciever_zip_code__c,reciever_postal_address__c,shipper_name__c,shipper_address__c,shipper_postal_address__c,shipper_country__c,shipper_zip_code__c,Shipment_identification__c,LatestCaseComment__c,Description,content_description__c,unit_to_blame__c from Case where id =:pibobj.cs_pib_case__c];
        System.debug('~~case::'+c);
        system.debug('template name : '+ TemplateName);
        if (!TemplateName.contains('none')){
            
            templateId = [Select id,HtmlValue,body,subject from EmailTemplate where id =:TemplateName limit 1];
            system.debug('template : ' + templateId);
            string emailbody = '';
            emailbody = templateId.Body;
            system.debug('email Body: ' + emailbody);
            emailbody = emailbody.replace('{!Case.Produkt__c}', c.Produkt__c!= null ? c.Produkt__c : '');
            emailbody = emailbody.replace('{!Case.Shipment_identification__c}', c.Shipment_identification__c!= null ? c.Shipment_identification__c : '');
            emailbody = emailbody.replace('{!Case.reciever_name__c}', c.reciever_name__c!= null ? c.reciever_name__c : '');
            emailbody = emailbody.replace('{!Case.reciever_address__c}', c.reciever_address__c!= null ? c.reciever_address__c : '');
            emailbody = emailbody.replace('{!Case.reciever_zip_code__c}', c.reciever_zip_code__c!= null ? c.reciever_zip_code__c : '');
            emailbody = emailbody.replace('{!Case.reciever_postal_address__c}', c.reciever_postal_address__c!= null ? c.reciever_postal_address__c : '');
            emailbody = emailbody.replace('{!Case.shipper_name__c}', c.shipper_name__c!= null ? c.shipper_name__c : '');
            emailbody = emailbody.replace('{!Case.shipper_postal_address__c}', c.shipper_postal_address__c!= null ? c.shipper_postal_address__c : '');
            emailbody = emailbody.replace('{!Case.shipper_address__c}', c.shipper_address__c!= null ? c.shipper_address__c : '');
            //emailbody = emailbody.replace('{!Case.Shipper_CountryCode__c}', c.Shipper_CountryCode__c!= null ? c.Shipper_CountryCode__c : '');
            emailbody = emailbody.replace('{!Case.shipper_country__c}', c.shipper_country__c!= null ? c.shipper_country__c : '');
            emailbody = emailbody.replace('{!Case.shipper_zip_code__c}', c.shipper_zip_code__c!= null ? c.shipper_zip_code__c : '');
            emailbody = emailbody.replace('{!Case.LatestCaseComment__c}', c.LatestCaseComment__c!= null ? c.LatestCaseComment__c : '');
            emailbody = emailbody.replace('{!Case.Description}', c.Description!= null ? c.Description : '');
            emailbody = emailbody.replace('{!Case.content_description__c}', c.content_description__c!= null ? c.content_description__c : '');
            emailbody = emailbody.replace('{!Case.CaseNumber}', c.CaseNumber!= null ? c.CaseNumber : '');
            
            String subject = '';
            subject = templateId.subject;
            subject = subject.replace('{!Case.CaseNumber}', c.CaseNumber!= null ? c.CaseNumber : '');
            subject = subject.replace('{!Case.Shipment_identification__c}', c.Shipment_identification__c!= null ? c.Shipment_identification__c : '');
            
            pibobj.cs_subject__c = subject;
            pibobj.cs_description__c = emailbody;           
        }
        else{
            flag =false; 
            pibobj.cs_subject__c ='';
            pibobj.cs_description__c = '';
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