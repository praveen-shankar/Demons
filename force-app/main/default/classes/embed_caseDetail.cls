// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
public class embed_caseDetail {
    
    //Dispute
    
    public Boolean show{get;set;}
    public Dispute_Invoice__c disputeObj{get;set;}
    public String messageBtn{get;set;}
    Public Boolean closedDispute{get;set;}
    postenNoEconnectDisputeinvoic.OUType OperatingUnit;
    public String UnitName{get;set;}
    public String UnitNumber{get;set;}
    public String OrganizationNumber{get;set;}
    public String ExternalReference{get;set;}
    public Integer Invoice_Id{get;set;}
    Decimal DisputeAmount;
    String Comments;
    String ReasonCode;
    public String reason { get; set; }
    public List<SelectOption> options {get;set;}
    public boolean raised{get;set;}
    public String recordTypeDev{get;set;}
    public boolean showDisputeButton{get;set;}
    
    //Dispute
    
    
    public Case c;
    public boolean changeAddressFlag {get;set;}
    public String customerType;
    public boolean hasEConnectData;
    public boolean viewInvoiceData {get; set;}
    private postenNoEconnectUtilities eConnect { get; set; }
    public EConnectWrapper_GetCustomerData eConnectData { get; set; }
    public EConnectWrapper_GetCustomerData.ForwardingElement Forwardings{ get{ return eConnectData.forwardingElements ; } }
    public EConnectWrapper_GetCustomerData.InvoiceElement Invoicesdata { get{ return eConnectData.invoiceElements; } }
    public EConnectWrapper_GetCustomerData.OrganizationParty organizationCustomer { get{ return eConnectData.organizationParty; } }
    public EConnectWrapper_GetCustomerData.PersonParty privateCustomer { get{ return eConnectData.PersonParty; } }
    //Strings to hold the height of various sections of embed_changeAddressCaseDetails.page and embed_invoiceCaseDetails.page
    public String addr_TabSection {get; set;}
    public String addr_MsgSection {get; set;}
    public String inv_TabSection {get; set;}
    
    public String invNumber {get; set;}    // Variable to store invoice number to save as PDF
    
    public EConnectWrapper_GetCustomerData.ForwardingElement forwardingElements 
    { 
        get
        {
            if(eConnectData != null)
            {
                /*if(customerType == 'person_account' && eConnectData.PersonParty != null)
{ 
return privateCustomer.forwardingElements;
}
else if(customerType == 'business_account' && eConnectData.organizationParty != null)
{
return organizationCustomer.forwardingElements;
}*/
                
                if(eConnectData.forwardingElements!=null)
                {
                    return eConnectData.forwardingElements;
                }
            }
            //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Fant ingen kunde data');
            //CSPhase2, Supriya , 19122016->Added the labels
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_No_customer_data);
            return null; 
        }
    }
    
    
    public EConnectWrapper_GetCustomerData.InvoiceElement invoiceElements
    {
        get
        {
            if(eConnectData != null)
            {
                /* if(customerType == 'person_account' && eConnectData.PersonParty != null)
{
system.debug('embed_caseDetail - Private get invoiceElements');
return privateCustomer.invoiceElements;
}

else if(customerType == 'business_account' && eConnectData.organizationParty != null)
{
system.debug('embed_caseDetail - Organization get invoiceElements');
return organizationCustomer.invoiceElements;
}*/
                if(eConnectData.invoiceElements!=null)
                {
                    return Invoicesdata ;
                }
            }
            //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Fant ingen kunde data');
            //CSPhase2, Supriya , 19122016->Added the labels
            
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_No_customer_data);
            return null;
        }
    }
    
    public embed_caseDetail(ApexPages.StandardController stdController) 
    {   
        raised = false;   
        show = TRUE; 
        showDisputeButton = false;
        this.c = (Case)stdController.getRecord();
        c = [SELECT id, Account.crm_Updated_by_CDH__c,accountId, RecordType.DeveloperName, CaseNumber, Account.crm_customer_number__c, view_Backend_Invoices__c, Status, Produkt__c, change_address_ref_no__c, RecordTypeId FROM Case WHERE id = :c.Id LIMIT 1];
        recordTypeDev = c.RecordType.DeveloperName;
            
        //Check if we need an expanded page or restricted height page based on the URL paramter expanded
        String exp = System.currentPagereference().getParameters().get('expanded');
        if(c.change_address_ref_no__c==null ||c.change_address_ref_no__c=='')
        {
            changeAddressFlag = false;
        }
        
        else
        {
            changeAddressFlag = true;
        }
        
        if(exp == null || exp == '')
        {
            addr_TabSection = 'height:250px;';
            addr_MsgSection = 'height:60px;';
            inv_TabSection = 'height:300px;';
        }
        else if(exp == 'true')
        {
            addr_TabSection = '';
            addr_MsgSection = '';
            inv_TabSection = '';
        }
        
        viewInvoiceData = false;
        invNumber = null;
        
        try 
        {
            if(c.AccountId == null) 
            {
                throw new EmbededCaseDetailException();
            }
            customerType = KATSutilities.getRecordType([SELECT RecordTypeId FROM Account WHERE Id = :c.AccountId LIMIT 1].RecordTypeId);
            
        } 
        catch (System.QueryException qe)
        {
            system.debug('embed_caseDetail - Could not find customer type: ' + qe.getMessage() );
            //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Fant ikke ut kundetypen - ' + qe.getMessage() ));
            //CSPhase2, Supriya , 19122016->Added the labels
            
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_Unable_Customer_Type+ ' - ' + qe.getMessage() ));
        } 
        catch (EmbededCaseDetailException e) 
        {
            system.debug('embed_caseDetail - Could not find customer: ' + e.getMessage() );
            //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Kunde mangler' ));
            //CSPhase2, Supriya , 19122016->Added the labels
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_Customer_missing));
            
        }
        
       
                 try{    
                    requestData();
                     }

                   Catch(System.CalloutException e) 
                    {    
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Request time out : Backend system took too long to process the request'));
                         
                    }

                Catch(Exception e) 
                    {
                    crm_Exception_handler.createExceptionRecords(e);    
                    }
        
        //If the field 'Vis fakturaer' is tagged on the case as true, then only this section should perform a callout
        //Setting the boolean variable based on the information in the case.
        if(c.view_Backend_Invoices__c && (eConnectData != null))
        {
            viewInvoiceData = true;
        }
        
        
        
        //Dispute
        
    }
    
    public boolean getHasEConnectData()
    {
        if(c.AccountId != null && eConnectData != null)
        {
            return true;
        }
        return false;
    }
    
    private void requestData() 
    {
        try
        {
            eConnect = new postenNoEconnectUtilities();
            String partyNumber = c.Account.crm_customer_number__c;
            String adresse = '';
            if(String.isNotEmpty(partyNumber))
            {
                String[] InformationType=new String[]{'InvoiceDetails','ForwardingDetails'};
                
                try{
                if(c.Account.crm_Updated_by_CDH__c)
                    eConnectData = new EConnectWrapper_GetCustomerData(eConnect.getCustomer(null, partyNumber,InformationType ));
                else
                    eConnectData = new EConnectWrapper_GetCustomerData(eConnect.getCustomer( partyNumber,null,InformationType ));    
                }
                
                Catch(System.CalloutException e) 
                    {
                        if(e.getMessage().contains('IO Exception: Read timed out'))
                         {   
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Request time out : Backend system took too long to process the request'));
                         }  
                    }
                
                system.debug('@@@forwarding'+eConnectData.forwardingElements);
                system.debug('@@@invoiceElements '+eConnectData.invoiceElements );
            }
            
        } 
        catch (Exception e)
        {
            eConnectData = null;
            //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Fant ingen kunde data');
            //CSPhase2, Supriya , 19122016->Added the labels
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_No_customer_data);
        }
    }
    
    public class EmbededCaseDetailException extends Exception {}
    
    
    // This function will accept the Invoice number as parameter
    // And Save the Invoice PDF as attachment on the CASE
    public PageReference downloadInvoicePDF()
    {
        // Checking if we have received information via eConnect
        if(eConnectData != null && String.isNotBlank(invNumber))
        {
            EConnectWrapper_GetCustomerData.InvoiceElement invoices = new EConnectWrapper_GetCustomerData.InvoiceElement();
            
            // Checking if the customer returned is a Person or Business customer and pickup the required invoice details
            /*if(customerType == 'person_account' && eConnectData.PersonParty != null)
{
invoices = privateCustomer.invoiceElements;
}
else if(customerType == 'business_account' && eConnectData.organizationParty != null)
{
invoices = organizationCustomer.invoiceElements;
}*/
            
            if(eConnectData.invoiceElements!=null)
            {
                invoices=Invoicesdata ;
            }
            if(invoices != null)
            {
                // Looping through the list to find the invoice number we need and other details
                for(EConnectWrapper_GetCustomerData.InvoiceType inv: invoices.invoiceTypes)
                {
                    if(inv.InvoiceNumber.equals(invNumber))
                    {
                        String fileName = System.Label.cs_Invoice+'_' + inv.InvoiceNumber + '_' + c.CaseNumber;
                        Boolean check = KATSutilities.addInvoiceToCase(inv.ItellaURI,fileName,'pdf',c.Id);
                        
                        if(check == false)
                        {
                            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_InvoiceError2));
                        }
                        else
                        {
                            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, System.Label.cs_InvoiceError3 + fileName ));
                        }
                    }
                    
                }
            }
            else
            {
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_InvoiceError4));
            }
        }
        else
        {
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_InvoiceError1 + invNumber));
        }
        return null;
    }
    
    
    // Dispute Page
    
    
    
    
    
    
    
    public void requestDispute()
    {   
        try{
            
            OperatingUnit =  new postenNoEconnectDisputeinvoic.OUType();
            OperatingUnit.UnitName = UnitName ;
            OperatingUnit.UnitNumber = UnitNumber;
            OperatingUnit.OrganizationNumber = OrganizationNumber;
            OperatingUnit.ExternalReference = ExternalReference;
            
            //Response object
            postenNoEconnectDisputeinvoic.DisputeInvoiceResponseType response=new postenNoEconnectDisputeinvoic.DisputeInvoiceResponseType();
            postenNoEconnectUtilities postenEconnect = new postenNoEconnectUtilities();
            DisputeAmount = disputeObj.Dispute_Amount__c; 
            Comments = disputeObj.Dispute_Comment__c;
            
            //Sending request to Create or update Dispute

            response=postenEconnect.sendDispute(OperatingUnit,Invoice_Id,invNumber,System.Today(),DisputeAmount,Comments, reason);
            System.debug('@@respone++'+response);
            
            if(response != null && response.DisputeResponse != null ){
                if(response.DisputeResponse.Status.equalsIgnoreCase('F')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING ,response.DisputeResponse.Status));
                }else if(String.isEmpty(response.DisputeResponse.Status)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING ,response.DisputeResponse.Status));
                }else  if(response.DisputeResponse.Status.equalsIgnoreCase('E')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, response.DisputeResponse.Status));
                }else{
                    try{
                        if(!String.isEmpty(reason))
                            disputeObj.Dispute_Reason__c = reason;
                        disputeObj.Name = invNumber ;
                        upsert disputeObj;
                        System.debug('disputeObjdisputeObj'+disputeObj);
                        raised = false;
                    }Catch(Exception e){
                        crm_Exception_handler.createExceptionRecords(e);
                    }
                }
            }
            
        }catch(Exception exp){
            System.debug('----------------'+exp);
            String exceptionMessage = NULL;
            if(exp.getTypeName().containsIgnoreCase('System.CalloutException') && exp.getMessage().containsIgnoreCase('IO Exception: Read timed out'))
                exceptionMessage = Label.crm_Connection_Timeout;
            else if(exp.getTypeName().containsIgnoreCase('System.CalloutException')) exceptionMessage = System.Label.crm_convert_to_customer;
            else exceptionMessage = Label.crm_Processing_Failed;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,exceptionMessage));
        }
    }
    
    public void closeDispute(){
        if(String.isEmpty(disputeObj.Close_Dispute_Comment__c)){
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.Error, System.Label.cs_comments_to_close));
        }else{
            requestDispute();
            closedDispute = true;
            messageBtn = System.Label.cs_Dispute_message_1 ;
            raised = false;
            Show = true;
        }
    }
    
    
    public void raiseDispute(){
        disputeObj = new Dispute_Invoice__c();
        options = new List<SelectOption>();
        closedDispute = false;
        options.add(new SelectOption('FFKU',System.Label.cs_Wrong_customer ));
        options.add(new SelectOption('FFRA',System.Label.cs_Incorrect_discount ));
        options.add(new SelectOption('IKFA',System.Label.cs_Incorrect_agreement));
        options.add(new SelectOption('MREF',System.Label.cs_Missing_PO_number_reference));
        options.add(new SelectOption('FFPR',System.Label.cs_Wrong_price));
        options.add(new SelectOption('REFT',System.Label.cs_Awaiting_refunding_from_customs ));
        options.add(new SelectOption('ANNE',System.Label.cs_Miscellaneous ));
        options.add(new SelectOption('VKRE',System.Label.cs_Awaiting_credit_memo ));
        
        List<Dispute_Invoice__c> tempDis =  new List<Dispute_Invoice__c>();
        tempDis = [select id,Dispute_Amount__c ,Dispute_Comment__c,Close_Dispute_Comment__c from Dispute_Invoice__c where Name=:invNumber Limit 1];
        
        if(tempDis != null && tempDis.size() > 0){
            disputeObj = tempDis[0];
            disputeObj.Dispute_Amount__c = 0;
            if(!String.isEmpty(tempDis[0].Close_Dispute_Comment__c)){
                closedDispute = true;
                messageBtn = System.Label.cs_Dispute_message_1 ;
            }
            show = false;
        }else{
            show = true;
        }
        raised = true;
    }
    
    public void BackToCase(){
        show = true;
        raised = false;
    }
    
}