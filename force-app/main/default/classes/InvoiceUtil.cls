// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
public with sharing class InvoiceUtil {

    @future(callout=true) 
    static public void sendUpdateNote(List<ID> idlist) {
        postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
        postenNoT20056Katsdunningstopservice.Result_element respons;
        
        List<Invoice__c> invoices = [SELECT Id, Name, Description__c, status__c, message_from_navision__c, LastModifiedBy.Name, Case__c, Case__r.CaseNumber, Case__r.Account.crm_customer_number__c, unit__r.DRM_id__c, Type_nr__c, exclude_reminder__c FROM Invoice__c WHERE id= :idlist];
        
        for(Invoice__c i : invoices) {
            
            String CompanyCode          = i.unit__r.DRM_id__c.substring(4,8);
            String CustomerNo           = i.Case__r.Account.crm_customer_number__c;
            String Description          = i.Case__r.CaseNumber + ';' + i.Description__c;
            Date DocumentDate           = system.today();
            String DocumentNo           = i.Name;
            Boolean ExcludeReminder     = i.exclude_reminder__c;
            String Type_x               = i.Type_nr__c;
            String ExecutiveOfficer     = 'KUN;' + i.LastModifiedBy.Name;
            
            try {
                respons = eConnect.UpdateNote(CompanyCode, CustomerNo, Description, DocumentDate, DocumentNo, ExcludeReminder, Type_x, ExecutiveOfficer);
                system.debug('eConnect respons: ' + respons);
            }
            catch(Exception e) {
                system.debug('eConnect Exception: ' + e.getMessage());
                // CSPhase2 , Dinesh , 28/12/2016
                // Translation not needed for the below picklist alue
                i.status__c = 'eConnect Exception';
                i.exclude_reminder__c = !ExcludeReminder;
            }
            
            if(respons != null && respons.Success) {
                i.exclude_reminder__c = ExcludeReminder;
                i.message_from_navision__c = respons.Message;
                if(ExcludeReminder){
                   // CSPhase2 , Dinesh , 28/12/2016
                   // i.status__c = 'Vellykket - purrestopp opprettet';
                   i.status__c = 'Successful - dunning stop created';
                } else {
                    // CSPhase2 , Dinesh , 28/12/2016
                    // i.status__c = 'Vellykket - purrestopp opphevet';
                    i.status__c = 'Successful - dunning repealed';
                }
            }
            else if(respons != null && !respons.Success) {
                i.exclude_reminder__c = !ExcludeReminder;
                i.message_from_navision__c = respons.Message;
                if(ExcludeReminder){
                    // CSPhase2 , Dinesh , 28/12/2016
                    // i.status__c = 'Ikke vellykket - opprettelse av purrestopp feilet';
                  //  i.status__c = 'Ikke vellykket - opprettelse av purrestopp feilet';
                    i.status__c= 'Unsuccessful - creation of dunning stop failed';

                } else {
                    // CSPhase2 , Dinesh , 28/12/2016
                    // i.status__c = 'Ikke vellykket - opphevelse av purrestopp feilet';
                    i.status__c = 'Unsuccessful - repeal of dunning stop failed';
                }
            }
        }
        createCaseComment(invoices);
        update invoices;
    }
    
    private static void createCaseComment(List<Invoice__c> invoices){
        List<CaseComment> commentList = new List<CaseComment>();
        for(Invoice__c i : invoices) {
                CaseComment com = new CaseComment();
                com.ParentId = i.Case__c;
                String body = System.Label.cs_Invoice + i.Name + System.Label.cs_sentTONavision + i.status__c + '.\r\n';
                body += System.Label.cs_NameUser + i.LastModifiedBy.Name + '.\r\n';
                body += System.Label.cs_describe+': ' + i.Description__c + '.\r\n';
                body += System.Label.cs_MsgNavision + i.message_from_navision__c + '.';
                com.CommentBody = body; 
                commentList.add(com);
        }
        if(commentList.size() > 0) {
            insert commentList;
        }
    }

}