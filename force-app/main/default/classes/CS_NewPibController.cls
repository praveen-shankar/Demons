public class CS_NewPibController{
    
  
     @AuraEnabled
   public static  Map<String, String> loadtemplates() {
 Map<String, String> options  = new Map<String, String>();
 
   PIBFolder_Setting__mdt folderid = [select FolderId__c from PIBFolder_Setting__mdt where DeveloperName like '%PIB_Meldinger%' limit 1];
        
        for(EmailTemplate templist : [SELECT Name,Subject,TemplateType,Description,FolderId FROM EmailTemplate where FolderId = :folderid.FolderId__c]) {
            system.debug('~~inside constructor');
            options.put(templist.Id,templist.Name);                 
        }  
         return options;    
        
    } 
    
     @AuraEnabled
   public static  Map<String, String> getStatus(){
        
        Map<String, String>  options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult = cs_case_pib_messages__c.category__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple) {
           if (f.isDefaultValue()) {
                options.put(f.getLabel(), f.getValue());
            }    
           
        }  
       
        for( Schema.PicklistEntry f : ple) {
           if (!f.isDefaultValue()) {
                options.put(f.getLabel(), f.getValue());
            }    
           
        }  
        return options;
    }
    
       @AuraEnabled
 public static Case loadCaseDetails(String caseId) {
 Case caseobj= new Case();
  try {
   caseobj= [SELECT Id, CaseNumber,Description  FROM Case WHERE Id = :caseId ];
                     
                } catch(QueryException qe) {
                    }
           
                return caseobj;
                
   }
    @AuraEnabled
 public static cs_case_pib_messages__c loadTemplatedetails(String caseId, String templateId ) {
 Case caseobj= new Case();
  cs_case_pib_messages__c pibobj = new cs_case_pib_messages__c();  
   EmailTemplate tempobj= new EmailTemplate ();
   
     Case c = [select id, casenumber, Produkt__c,reciever_name__c,reciever_address__c,reciever_zip_code__c,reciever_postal_address__c,shipper_name__c,shipper_address__c,shipper_postal_address__c,shipper_country__c,shipper_zip_code__c,Shipment_identification__c,LatestCaseComment__c,Description,content_description__c,unit_to_blame__c from Case where id =:caseId];
        System.debug('~~case::'+c);
      
        if (!templateId.contains('none')){
            
            tempobj= [Select id,HtmlValue,body,subject from EmailTemplate where id =:templateId limit 1];
            system.debug('template : ' + templateId);
            string emailbody = '';
            emailbody = tempobj.Body;
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
            subject = tempobj.subject;
            subject = subject.replace('{!Case.CaseNumber}', c.CaseNumber!= null ? c.CaseNumber : '');
            subject = subject.replace('{!Case.Shipment_identification__c}', c.Shipment_identification__c!= null ? c.Shipment_identification__c : '');
            
            pibobj.cs_subject__c = subject;
            pibobj.cs_description__c = emailbody;           
        }
        else{
           
            pibobj.cs_subject__c ='';
            pibobj.cs_description__c = '';
        }
        return pibobj ;   
    }
    
   @AuraEnabled
 public static string addPIBfn(String caseId, String subject, String emailbody, String notifydistrictmanager, String status)  {
 cs_case_pib_messages__c pibobj = new cs_case_pib_messages__c(); 
 System.debug('in save');
    pibobj.cs_subject__c = subject;
    pibobj.cs_description__c = emailbody; 
    pibobj.cs_pib_case__c= caseId;
    pibobj.category__c= status;
    pibobj.Notification_to_District_manager__c= notifydistrictmanager;
    
    System.debug(pibobj);
    try{
     insert pibobj;
    }Catch(Exception e) {
    return e.getMessage();
    }
    
   return 'Success';
 
 }
    
  }//end of class