/*  Author: Rajeev Shekhar
    Created for EDI Admin Interface Project
    Interface must be switched on from custom setting
*/

public with sharing class crm_edi_IntegrationController {
    
    public static calloutResponse makeCallout(String ediRecId,String systemName) {
        //Perform callout if the switch is ON
        environment_settings__c env = environment_settings__c.getValues('EDI_InterfaceSwitch');
        calloutResponse response = new calloutResponse();        
        String actionType = null;
        
        if ((env != null && env.value__c == 'true') || Test.isRunningTest()) {
            Edi_Information__c[] ediData = [SELECT Id, Name, crm_Account__c, crm_Account__r.Orga__c, crm_Account__r.crm_Updated_by_CDH__c, Active__c, Customer_Number__c, EDI_Files_Approved__c,EDI_Files_Tested__c,EDI_Identificator__c,ID__c, E_mail_for_LM_error_notifications__c,End_Date__c,
                                           Equipment_Type_Qualifier__c,Expected_Number_of_Shipments_Letters__c,Extra_1__c,Extra_2__c,Extra_3__c,Extra_4__c,Extra_5__c,File_Transfer__c,File_Transfer_Detail__c,ID_Domain__c,ID_Format__c,ID_Subscriber__c,Integration_Type__c, Inbound_Message_Type__c, 
                                           Kvalificator__c, Labels_Approved__c, LM_Report_Selection__c, Message_Format__c, My_Bring_ID__c,Number_Series_Assigned_By__c,
                                           Outbound_Message_Type__c,Path__c,Prefix__c,Type__c,Qualificator_api__c,Return_Addresses_for_Bulk_Split_Products__c,Serial_Number_Details__c,Serial_Numbers_Assigned__c,Sender_Address_for_Parcels_to_Norway__c,Service_Family__c,Service_Family_Comments__c,
                                           Start_Date__c,Status__c, TA_Solution_at_Vendor__c, TA_Vendor__c FROM Edi_Information__c WHERE ID = :ediRecId Limit 1];
            
            if(ediData != null && ediData.size() >0) {
                Edi_Information__c edirow = ediData.get(0);
                Boolean activeOrNot = edirow.Active__c;
                if(!activeOrNot) actionType = 'delete';
                EDI_System_Status__c[] ediSystemRecord = [SELECT Id, Name, EDI__c,Message_Sent_After_Data_Change__c, Message_Sent__c, System_Name__c, Timestamp__c, Transaction_ID__c, Error_Message__c,
                                                         Details__c,Status__c,StatusCode__c,Summary__c,IdSubscriber__c FROM EDI_System_Status__c Where EDI__c = :edirow.Id And System_Name__c = :systemName];
                if(ediSystemRecord.size() > 0) {           
                    crm_EdiInformationWrapper wrapper = new crm_EdiInformationWrapper();
                    crm_EdiInformationWrapper.cls_ediInfo ediinfo = new crm_EdiInformationWrapper.cls_ediInfo();
                    crm_EdiInformationWrapper.cls_header ediheader = new crm_EdiInformationWrapper.cls_header();
                    
                    if(actionType != 'delete' && ediSystemRecord[0].Message_Sent__c)
                        actionType = 'update';
                    else if(actionType != 'delete' && !ediSystemRecord[0].Message_Sent__c) 
                        actionType = 'insert';
                        
                    String endPoint = getEndpoint(systemName,actionType);
                    Boolean makeCallout = true;
                    
                    //Unique transaction Id
                    String tId = ediRecId + String.valueOf(Datetime.now().getTime()) + String.valueOf(Math.abs(Crypto.getRandomLong()));
                    
                    ediheader.MessageId = tId;
                    ediheader.MessageMode = 'REST';
                    ediheader.Action = actionType;
                    ediheader.FirstProcessedTimestamp = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ssZ');//Datetime format yyyy-MM-dd'T'HH:mm:ssZ
                    ediheader.ProcessedTimestamp = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ssZ');//Datetime format yyyy-MM-dd'T'HH:mm:ssZ;
                    ediheader.SourceSystemTimestamp = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ssZ');//Datetime format yyyy-MM-dd'T'HH:mm:ssZ;
                    ediheader.SourceCompany = 'Posten';
                    ediheader.SourceSystem = 'Salesforce';
                    ediheader.SourceSystemUser = Userinfo.getUserId();
                    ediheader.SourceSystemRef = systemName + '-' + edirow.EDI_Identificator__c;                    
                    
                    ediinfo.CustomerNumber = edirow.Customer_Number__c;
                    ediinfo.OrganizationNumber = edirow.crm_Account__r.Orga__c;
                    ediinfo.CustomerSource = edirow.crm_Account__r.crm_Updated_by_CDH__c ? 'CDH' : 'NON-CDH';
                    ediinfo.Active = edirow.Active__c;
                    ediinfo.EDIFilesApproved = edirow.EDI_Files_Approved__c;
                    ediinfo.EDIFilesTested = edirow.EDI_Files_Tested__c;
                    ediinfo.EDIIdentificator = edirow.EDI_Identificator__c;
                    ediinfo.E_mail_for_LM_error_notifications = edirow.E_mail_for_LM_error_notifications__c;
                    if(edirow.End_Date__c != null)
                        ediinfo.EndDate = String.valueOf(edirow.End_Date__c.year()) + '-' + String.valueOf(edirow.End_Date__c.month()).leftPad(2, '0') + '-' + String.valueOf(edirow.End_Date__c.day()).leftPad(2, '0');
                    ediinfo.EquipmentTypeQualifier = edirow.Equipment_Type_Qualifier__c;
                    ediinfo.ExpectedNoOfShipmentLetters = edirow.Expected_Number_of_Shipments_Letters__c;
                    ediinfo.extra1 = edirow.Extra_1__c;
                    ediinfo.extra2 = edirow.Extra_2__c;
                    ediinfo.extra3 = edirow.Extra_3__c;
                    ediinfo.extra4 = edirow.Extra_4__c;
                    ediinfo.extra5 = edirow.Extra_5__c;
                    ediinfo.FileTransfer = edirow.File_Transfer__c;
                    ediinfo.FileTransferDetail = edirow.File_Transfer_Detail__c;
                    ediinfo.CompleteEDIIdent = edirow.EDI_Identificator__c + edirow.Qualificator_api__c;
                    ediinfo.InboundMessageType = edirow.Inbound_Message_Type__c;
                    ediinfo.IntegrationType = edirow.Integration_Type__c;
                    ediinfo.Kvalificator = edirow.Qualificator_api__c;
                    ediinfo.LabelsApproved = edirow.Labels_Approved__c;
                    ediinfo.LMReportSelection = edirow.LM_Report_Selection__c;
                    ediinfo.MessageFormat = edirow.Message_Format__c; 
                    ediinfo.NumberSeriesAssignedBy = edirow.Number_Series_Assigned_By__c;    
                    ediinfo.ReturnAddForBulkSplitProduct = edirow.Return_Addresses_for_Bulk_Split_Products__c;
                    ediinfo.SenderAddForParcelsToNorway = edirow.Sender_Address_for_Parcels_to_Norway__c;
                    ediinfo.SerialNumberDetails = edirow.Serial_Number_Details__c;
                    ediinfo.SerialNumbersAssigned = edirow.Serial_Numbers_Assigned__c;
                    ediinfo.ServiceFamily = edirow.Service_Family__c;
                    ediinfo.ServiceFamilyComments = edirow.Service_Family_Comments__c;
                    if(edirow.Start_Date__c != null)
                        ediinfo.StartDate = String.valueOf(edirow.Start_Date__c.year()) + '-' + String.valueOf(edirow.Start_Date__c.month()).leftPad(2, '0') + '-' + String.valueOf(edirow.Start_Date__c.day()).leftPad(2, '0');
                    ediinfo.Status = edirow.Status__c;
                    ediinfo.TAVendor = edirow.TA_Vendor__c;
                    ediinfo.TASolution = edirow.TA_Solution_at_Vendor__c;
                    ediinfo.SalesforceRowId = edirow.Id;                     
                    ediinfo.SystemName = systemName;
                    ediinfo.ActionType = actionType;
                    if(edirow.Outbound_Message_Type__c != null) {                                                                            
                        List<String> olist = new List<String>();
                        olist = edirow.Outbound_Message_Type__c.split(';');
                        olist.sort();
                        ediinfo.OutboundMessageType = String.Join(olist,';');
                    }

                    wrapper.EDIInformation = ediinfo;
                    
                    if(systemName == 'MB') {
                        crm_EdiInformationWrapper.cls_MB ediinfoMB = new crm_EdiInformationWrapper.cls_MB();
                        if(edirow.My_Bring_ID__c == null) makeCallout = false;
                        if((edirow.ID_Format__c != null && edirow.ID_Format__c.contains('IM')) || (edirow.ID_Domain__c != null && edirow.ID_Domain__c.contains('IM'))) makeCallout = false;
                        ediinfoMB.MyBringID = edirow.My_Bring_ID__c;
                        ediinfoMB.IdFormat = (edirow.ID_Format__c + ';' + edirow.ID_Domain__c).remove('null').removeStart(';').removeEnd(';');//Concatenated for eConnect
                        ediinfoMB.IdDomain = edirow.ID_Domain__c;
                        ediinfoMB.EdiIdentity = edirow.EDI_Identificator__c;                     
                        ediinfoMB.Path = 'FromBring\\';                        
                        if(edirow.ID_Format__c != null && edirow.ID_Domain__c != null) {
                            ediinfoMB.Prefix = 'RECEIPT-;STATUS-';
                        } else if(edirow.ID_Format__c == null && edirow.ID_Domain__c != null) {
                            ediinfoMB.Prefix = 'STATUS-';
                        } else if(edirow.ID_Format__c != null && edirow.ID_Domain__c == null) {
                            ediinfoMB.Prefix = 'RECEIPT-';
                        }
                        ediinfoMB.Type= edirow.Type__c;
                        ediinfoMB.IdSubscriber = ediSystemRecord[0].IdSubscriber__c;
                        wrapper.EdiInformation.EdiInformation_MB = ediinfoMB;
                    }
                                          
                    wrapper.header = ediheader;
                                                                       
                    //Creating instance of HttpRequest
                    String wrapperBody = JSON.serialize(wrapper);
                    HttpRequest req = new HttpRequest();
                    req.setBody(wrapperBody);
                    req.setEndpoint(endPoint);
                    req.setHeader('Content-Type', 'application/json;charset=utf-8');
                    req.setHeader('MessageId', tId);
                    req.setMethod('POST');
                    req.setTimeout(15000);
                    System.debug('Request payload: '+ wrapperBody);
                    String responseBody = null;
                    Map<String, Object> resparams = new Map<String, Object>();
                    Http http = new Http();
                    //Final callout
                    try {
                        HTTPResponse res = null;
                        if(makeCallout) res = http.send(req);
                        if(res != null) responseBody = res.getBody();
                        System.debug('Httpresponse from eConnect: '+ res);
                        System.debug('Httpresponse responseBody from eConnect: '+ responseBody);                                                                          
                        if (res != null && res.getStatus() == 'OK' && res.getStatusCode() == 200) {
                            if(String.IsNotBlank(responseBody)) {
                                resparams = (Map<String, Object>)JSON.deserializeUntyped(responseBody);
                                String statusEConnect = (String) resparams.get('Status');//Getting the Status of the callout
                                if(statusEConnect == 'ERROR') {
                                    updateSystemStatus(tId,resparams,ediSystemRecord[0],'ERROR',systemName);
                                    response.status = 'NOT_OK';
                                    response.message = 'Error: ' + (String) resparams.get('Summary');
                                } else if(statusEConnect == 'SUCCESS') {
                                    updateSystemStatus(tId,resparams,ediSystemRecord[0],'SUCCESS',systemName);
                                    response.status = 'OK';
                                    response.message = System.Label.edi_sentToEconnect;
                                }                                
                            } else {
                                response.status = 'NOT_OK';
                                response.message = 'Error: eConnect returned an empty response.';
                            }                            
                        } else {
                            updateSystemStatus(tId,ediSystemRecord[0],res);
                            response.status = 'NOT_OK';
                            if(res != null)
                                response.message = 'Error occured while calling eConnect: ' + res.getStatus();
                            else response.message = 'Error occured while calling eConnect. Please contact Salesforce or eConnect team.';    
                            if(makeCallout == false && systemName == 'MB' && edirow.My_Bring_ID__c == null) {
                                response.message = 'Error: ' + System.Label.edi_MyBringIDMBIntegration;
                            }
                            if(makeCallout == false && systemName == 'MB' && ((edirow.ID_Format__c != null && edirow.ID_Format__c.contains('IM')) || (edirow.ID_Domain__c != null && edirow.ID_Domain__c.contains('IM')))) {
                                response.message = 'Error: ' + System.Label.edi_MyBringIDMBIntegration2;
                            }    
                        }    
                    } catch(Exception general) {
                            response.status = 'NOT_OK';
                            response.message = 'Technical exception occured while calling eConnect: ' + general.getMessage();
                            updateSystemStatus(tId,ediSystemRecord[0],general);                            
                    } 
                } else {
                    response.status = 'NOT_OK';
                    response.message = System.Label.edi_SystemNotConfigured;
                }       
            }
         } else {
             response.status = 'NOT_OK';
             response.message = System.Label.edi_econnectDown;    
         }
         return response;    
    }
    
    //Method to update system status record
    private static void updateSystemStatus(String tId,Map<String, Object> resparams,EDI_System_Status__c ediSys,String type,String sName) {
        if(resparams.containsKey('Message')) {
            String msg = (String) resparams.get('Message');
            ediSys.Error_Message__c = msg;
            if(sName == 'LM') ediSys.Details__c = createNewLMErrorMessages(msg);
        }   
        if(resparams.containsKey('Status')) {    
            ediSys.Status__c = (String) resparams.get('Status');
        }   
        if(resparams.containsKey('Code')) {      
            ediSys.StatusCode__c = (String) resparams.get('Code');
        }   
        if(resparams.containsKey('Summary')) {          
            ediSys.Summary__c = (String) resparams.get('Summary');
        }   
        if(sName == 'MB' && resparams.containsKey('Details')) {          
            ediSys.Details__c = (String) resparams.get('Details');
        }
        if(sName == 'MB' && resparams.containsKey('IdSubscriber') && (String) resparams.get('IdSubscriber') != null) {         
            ediSys.IdSubscriber__c = (String) resparams.get('IdSubscriber');
        }   
        ediSys.Transaction_ID__c = tId;
        ediSys.Timestamp__c = Datetime.now();
        if(type == 'SUCCESS') {
            if(!ediSys.Message_Sent__c) ediSys.Message_Sent__c = true;
            ediSys.Message_Sent_After_Data_Change__c = true;
        }
        Database.DMLOptions op = new Database.DMLOptions();
        op.allowFieldTruncation = true;
        ediSys.setOptions(op);
        update ediSys;                  
    }
    
    //Method to update system status record
    private static void updateSystemStatus(String tId,EDI_System_Status__c ediSys,HttpResponse res) {
        if(res != null) {
            ediSys.Error_Message__c = res.getStatus();    
            ediSys.Status__c = 'ERROR';      
            ediSys.StatusCode__c = String.valueOf(res.getStatusCode());          
            ediSys.Summary__c = res.getStatus();         
            ediSys.Details__c = res.getStatus();
            ediSys.Transaction_ID__c = tId;
            ediSys.Timestamp__c = Datetime.now();
            Database.DMLOptions op = new Database.DMLOptions();
            op.allowFieldTruncation = true;
            ediSys.setOptions(op);
            update ediSys;
        }                  
    }
    
    //Method to update system status record
    private static void updateSystemStatus(String tId,EDI_System_Status__c ediSys,Exception res) {
        ediSys.Error_Message__c = res.getTypeName();    
        ediSys.Status__c = 'ERROR';      
        ediSys.StatusCode__c = res.getTypeName();          
        ediSys.Summary__c = res.getMessage();         
        ediSys.Details__c = res.getStackTraceString();
        ediSys.Transaction_ID__c = tId;
        ediSys.Timestamp__c = Datetime.now();
        Database.DMLOptions op = new Database.DMLOptions();
        op.allowFieldTruncation = true;
        ediSys.setOptions(op);
        update ediSys;                  
    }
    
    //Method to return valid endpoint based on system name and action type    
    private static String getEndpoint(String systemName,String actionType) {
        String ep = null;
        if(systemName == 'LM' && actionType == 'insert') {
            ep = 'callout:crm_EDIAdmin_LM_eConnect_createEndpoint';
        }
        else if(systemName == 'LM' && actionType == 'update') {
            ep = 'callout:crm_EDIAdmin_LM_eConnect_updateEndpoint';
        }
        else if(systemName == 'LM' && actionType == 'delete') {
            ep = 'callout:crm_EDIAdmin_LM_eConnect_deleteEndpoint';
        }
        else if(systemName == 'MB' && actionType == 'insert') {
            ep = 'callout:crm_EDIAdmin_MB_eConnect_createEndpoint';
        }
        else if(systemName == 'MB' && actionType == 'update') {
            ep = 'callout:crm_EDIAdmin_MB_eConnect_updateEndpoint';
        }
        else if(systemName == 'MB' && actionType == 'delete') {
            ep = 'callout:crm_EDIAdmin_MB_eConnect_deleteEndpoint';
        }
      return ep;  
    }
    
    //Method to return the LM error message against each LM code
    private static String getLMError(String code) {
        Map<String,String> errorMap = new Map<String,String>{
            '00' => System.Label.edi_LM_status00,
            '01' => System.Label.edi_LM_status01,
            '02' => System.Label.edi_LM_status02,
            '03' => System.Label.edi_LM_status03,
            '10' => System.Label.edi_LM_status10,
            '12' => System.Label.edi_LM_status12
        };
     return errorMap.get(code);
    }
    
    //Method to replace LM Codes by text
    private static String createNewLMErrorMessages(String msg) {
        if(msg == null) return null;    
        return msg.replace('00',getLMError('00')).replace('01',getLMError('01')).replace('02',getLMError('02')).replace('03',getLMError('03')).
            replace('10',getLMError('10')).replace('12',getLMError('12'));
    }
         
    public class calloutResponse {
         @AuraEnabled public String status;
         @AuraEnabled public String message;        
    }
}