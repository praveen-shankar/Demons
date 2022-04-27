public without sharing class MonetaryTransactionsController
{
    
    // Picklistvalues ERP_target_system__c
    public static final String NAV = 'NAV';
    public static final String NPB_OEBS = 'NPB_OEBS';
    public static final String OEBS = 'OEBS';
    
    // Picklistvalues Monetary_Transaction_Line_Items__c.Type__c
  //  public static final String REGRESS = 'Regress';
  //  public static final String KREDITTNOTA = 'Credit Memo';
  
   public static final String REGRESS = 'Regress';
    public static final String KREDITTNOTA = 'Kredittnota';
    // Automatic picklist values - only used for motposts and set by the system
    
  // public static final String REGRESS_MOTPOST = 'Regress - Motpost';
  //  public static final String KREDITTNOTA_MOTPOST = 'Credit Memo - Motpost';
  
    public static final String REGRESS_MOTPOST = 'Regress - Motpost';
    public static final String KREDITTNOTA_MOTPOST = 'Kredittnota - Motpost';
    
    // Picklistvalues in Status__c
  /*  public static final String FAIL_STATUS = 'Approved - Payment failed';
    public static final String SUCCESS_STATUS_OEBS = 'Approved - to be paid in OEBS';     // Succesfully sent to OEBS
    public static final String SUCCESS_STATUS_NAV = 'Approved - to be paid in Navison';   // Succesfully sent to NAVISON
    public static final String SUCCESS_STATUS_NPB_OEBS = 'Approved - to be paid in NPB OEBS';   // Succesfully sent to NPB OEBS
    public static final String DONE_STATUS = 'Closed - paid';                    // Done message from OEBS/NAV received
    public static final String DONE = 'Closed';                                      // Done message when Transaction not sent to OEBS/NAV
    public static final String READY_STATUS = 'Approved - to be paid';                   // Approved
    public static final String ERR01 = 'Vouchers could not be created in NAV';              // Error from NAV
    public static final String ERR02 = 'Vouchers could not capitalized in NAV';               // Error from NAV
    
    */
    
    public static final String SUCCESS_STATUS_NPB_OEBS = 'Approved - to be paid in NPB OEBS';   // Succesfully sent to NPB OEBS
    
     public static final String FAIL_STATUS = 'Godkjent - utbetaling feilet';
    public static final String SUCCESS_STATUS_OEBS = 'Godkjent - utbetales i OEBS';    // Succesfully sent to OEBS
    public static final String SUCCESS_STATUS_NAV = 'Godkjent - utbetales i NAVISON';  // Succesfully sent to NAVISON
    public static final String DONE_STATUS = 'Avsluttet - utbetalt';          // Done message from OEBS/NAV received
    public static final String DONE = 'Avsluttet';                                      // Done message when Transaction not sent to OEBS/NAV
    public static final String READY_STATUS = 'Godkjent - utbetales';          // Approved
    public static final String ERR01 = 'Bilag kunne ikke opprettes i NAV';        // Error from NAV
    public static final String ERR02 = 'Bilag kunne ikke bokføres i NAV';        // Error from NAV
    
    // Status set by eConnect
    public static final String ECONNECT_PENDING_STATUS = 'Open';
    public static final String ECONNECT_DONE_STATUS = 'Closed';
    public static final String ECONNECT_ERROR_STATUS_ERR01 = 'ERR01';
    public static final String ECONNECT_ERROR_STATUS_ERR02 = 'ERR02';
    
    //public static String MANUAL_TRANSACTION_TYPE = 'Manual handling';
    
     public static String MANUAL_TRANSACTION_TYPE = 'Manuell behandling';
    //Akash
    public static final String TRANSACTION_TEXT_CASE = 'Kundeservicesak ';
    public static final String TRANSACTION_TEXT_CONTACT = ', Kontaktperson ';
    
    
    
    public static map<string, map<string, map<string, string>>> getArticleNumbersMap() 
    {
        system.debug('Loading ArticleNumbersMap from DB into a map');
        
        map<string, map<string, map<string, string>>> articleNumbersMap = new map<string, map<string, map<string, string>>>();
        for(Article_Number__c an:[select 
                                  Service_Product__r.name, 
                                  Transaction_Type__c, 
                                  Value_added_service__c, 
                                  Name, 
                                  id 
                                  FROM Article_Number__c 
                                  order by Product_art_name__r.name]) 
        {
        System.debug('=============an.Product_art_name__r.name'+an.Service_Product__r.name);
            //Gjør sjekk et annet sted -  an.Product_Name__c = KATSutilities.toUpperCase(an.Product_Name__c);
            String productName= KATSutilities.toUpperCase(an.Service_Product__r.name);
            an.Transaction_Type__c = KATSutilities.toUpperCase(an.Transaction_Type__c);
            an.Value_added_service__c = KATSutilities.toUpperCase(an.Value_added_service__c);
            
            if(!articleNumbersMap.containsKey(productName)) 
            {
                articleNumbersMap.put(productName, new map<string, map<string, string>>());
            }
            if(!articleNumbersMap.get(productName).containsKey(an.Transaction_Type__c)) 
            {
                articleNumbersMap.get(productName).put(an.Transaction_Type__c, new map<string, string>());
            }
            
            articleNumbersMap.get(productName).get(an.Transaction_Type__c).put(an.Value_added_service__c, an.Name);
        }
        return articleNumbersMap;
    }
    
    /*
* Takes in a list of transactionIds of transactions which are to be submitted to eConnect.
*/
    
    @future(callout=true)
    static public void sendPaymentForTransactions(List<Id> transactionIds) 
    {
        postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
        cs_postenNoEcServiceSendcreditmem.OUType OpUnit = new cs_postenNoEcServiceSendcreditmem.OUType();
        
        //Bhavani
        cs_postenNoEcServiceSendcreditmem.ReceivableType[] ReceivableList = new List<cs_postenNoEcServiceSendcreditmem.ReceivableType>();
        
        List<Monetary_transaction__c> transToUpdate = new List<Monetary_transaction__c>();
        List<Monetary_transaction__c> transToClose = new List<Monetary_transaction__c>();
        cs_postenNoEcServiceSendcreditmem.CreditMemoBasisCRMRequestReceiptType status;       
        Map<String,blocked_products__c> blockList = new Map<String,blocked_products__c>();
         Map<String,HDTranscation__c > blockListHD = new Map<String,HDTranscation__c>();
        blockList = blocked_products__c.getAll();
        blockListHD = HDTranscation__c.getAll();
        for(monetary_transaction__c t : [SELECT t.case__r.case_referens__c,
                                         t.case__r.account.Transaksjonskontakt__r.Email, 
                                         t.id, 
                                         t.status__c, 
                                         t.case__r.caseNumber, 
                                         t.case__r.type__c, 
                                         t.case__r.Service_Product__r.cs_Operating_Unit_Code__c,
                                         t.case__r.Service_Product__r.Name,
                                         t.case__r.code_event__r.name, 
                                         t.case__r.Code_Reason1__r.name, 
                                         t.case__r.account.crm_customer_number__c, 
                                         t.case__r.contact.name,
                                         t.case__r.Account.crm_Company_IBAN__c,
                                         t.Bank_Account_Number__c,
                                         t.case__r.Account.crm_Company_bank_name__c,
                                         t.case__r.Account.CDH_customer_number_converted__c,
                                         t.case__r.Account.CurrencyIsoCode,
                                         t.case__r.account.name,
                                         t.case__r.Account.BillingStreet,
                                         t.case__r.Account.BillingCity,
                                         t.case__r.Account.BillingState,
                                         t.case__r.Account.BillingPostalCode,
                                         t.case__r.Account.BillingCountry,
                                         t.case__r.Account.IsPersonAccount,
                                         t.case__r.Account.FirstName,
                                         t.case__r.Account.LastName,
                                         t.case__r.Accountid,
                                         t.Case__r.Account.crm_Updated_by_CDH__c,
                                         t.Transaction_approved_date__c, 
                                         t.CreatedDate, 
                                         t.Case__r.Account.crm_Company_SWIFT__c,
                                         t.ERP_target_system__c, 
                                         t.Reference__c, 
                                         t.RecordType.DeveloperName,
                                         (SELECT Name, cs_Accounting_Unit__c,
                                          Line_Amount__c, 
                                          Article_Number__c, 
                                          vare_number_NAV__c,
                                          vare_number_NAV__r.Name, 
                                          Description__c, 
                                          cargo_product_code__c, 
                                          Regress_Account__r.Transaksjonskontakt__r.Email, 
                                          Regress_Account__r.crm_customer_number__c, 
                                          Regress_Account__r.crm_Company_IBAN__c,
                                          Regress_Account__r.crm_Company_bank_name__c,
                                          Regress_Account__r.CurrencyIsoCode,
                                          Regress_Account__r.name,
                                          Regress_Account__r.crm_Company_SWIFT__c,
                                          cargo_division_code__r.unit_number_in_subsidiary__c,
                                          cargo_division_code__r.DRM_id__c,
                                          Regress_Account__r.CDH_customer_number_converted__c,
                                         Regress_Account__r.BillingStreet,
                                         Regress_Account__r.BillingCity,
                                         Regress_Account__r.BillingState,
                                         Regress_Account__r.BillingPostalCode,
                                         Regress_Account__r.BillingCountry,
                                         Regress_Account__r.IsPersonAccount,
                                         Regress_Account__r.FirstName,
                                         Regress_Account__r.LastName,
                                         Regress_Account__r.crm_Updated_by_CDH__c, 
                                          Type__c, 
                                          voucher_number__c 
                                          FROM monetary_transaction__c.Monetary_Transaction_Line_Items__r) 
                                         FROM monetary_transaction__c t 
                                         WHERE t.Id in :transactionIds]) 
        {
            Boolean block_Check = false;
            OpUnit.UnitName = t.case__r.Service_Product__r.cs_Operating_Unit_Code__c;
            //if(cs_Operating_Unit_Mapping__c.getInstance(t.cs_Operating_Units__c) != null )
            OpUnit.UnitNumber = t.case__r.Service_Product__r.cs_Operating_Unit_Code__c;
            //OpUnit.OrganizationNumber='';
            //OpUnit.ExternalReference='';
            
            //Check if there is a blocking for this product
            if(blockList.containsKey(t.case__r.Service_Product__r.Name))
            {
                //This checks if the blocked target system is the same as the target system of the Transaction.
                if( blockList.get(t.case__r.Service_Product__r.Name).ERP_System__c == t.ERP_target_system__c)
                    block_Check = true;
            }
            
            if(blockListHD.containsKey(t.case__r.Service_Product__r.Name))
            {
                //This checks if the blocked target system is the same as the target system of the Transaction.
                if( blockListHD.get(t.case__r.Service_Product__r.Name).target_System__c  == t.ERP_target_system__c)
                    block_Check = true;
                    t.IsHDTranscation__c = true;
            }
            
            
            
            if(t.status__c == READY_STATUS && !block_Check) 
            {
                //This is a system update... bypass validation rules
                t.is_system_update__c = true;
                cs_postenNoEcServiceSendcreditmem.ReceivableType rec = createPayment(t); 
                System.debug('=========rec'+rec);
                if(rec != null)
                {
                    ReceivableList.add(rec);
                }
                transToUpdate.add(t);
            }
            else
            {
                t.status__c = DONE;           //For those transaction which should not be sent to OEBS/NAV should be automatically CLOSED
                transToClose.add(t);
            }
        }
        System.debug('ReceivableList------------'+ReceivableList);
        // This block checks if we have transactions which are supposed to be sent to OEBS/NAV and processes them
        if(ReceivableList != null && ReceivableList.size() > 0)
        {
            try 
            {   //Bhavani
                status = eConnect.SendPayment(ReceivableList,OpUnit);
                // status returned from the method SendPayment is a List of type postenNoEconnectKatsPaymentevents.TransactionResponseType
                System.debug('============status'+status);
                if(status != null)
                {
                    Map<String, String> statusMap = new Map<string,string>(); // convert List into a map with id as key and status as value.
                    for(cs_postenNoEcServiceSendcreditmem.CreditMemoBasisCRMReceiptType s : status.CreditMemoBasisCRMReceipt) 
                    {
                        System.debug('----------s.CRMTransactionID'+s.CRMTransactionID);
                        System.debug('----------s.Status'+s.Status);
                        statusMap.put(s.CRMTransactionID, s.Status);
                    }
                    
                    // Sets status
                    updateTransactionStatusFromEconnect(transToUpdate, statusMap); 
                } 
                else 
                {
                    updateTransactionStatusFromEconnect(transToUpdate, null); // Sets status = FAIL_STATUS of all transactions in the list transToUpdate
                }
            }
            catch(Exception e) 
            {
                updateTransactionStatusFromEconnect(transToUpdate, null); // Sets status = FAIL_STATUS of all transactions in the list transToUpdate if call to eConnect causes exception
            }
        } 
        else if(transToUpdate != null && transToUpdate.size() > 0)
        {   
            // If transactions have been added to list transToUpdate, but list transactionsToSend is empty, set status = FAIL_STATUS of all transactions in the list transToUpdate
            updateTransactionStatusFromEconnect(transToUpdate, null); 
        }
        
        // This section checks if we have transactions which are not supposed to be sent to OEBS/NAV
        // If there are such transactions, then we close it directly
        if(transToClose != null && transToClose.size() > 0)
        {
            database.update(transToClose);
        }
    }
    
    
    /*
* Methods called by sendPaymentForTransactions
https://posten-bring--crmfull.cs89.my.salesforce.com/0PS?setupid=PermSets&retURL=%2Fui%2Fsetup%2FSetup%3Fsetupid%3DUsers */
    
    public static cs_postenNoEcServiceSendcreditmem.ReceivableType createPayment(Monetary_transaction__c t)
    {
        System.debug('----------transaction'+t);
        if(t.case__c == null || t.case__r.Account == null || t.Transaction_approved_date__c == null)
        {
            // Transaction not valid, will cause system NullPointerException.
            System.debug('----------Inside Null Block');
            return null;
        }
        cs_postenNoEcServiceSendcreditmem.ReceivableType rece = new cs_postenNoEcServiceSendcreditmem.ReceivableType();
        
        cs_postenNoEcServiceSendcreditmem.ReceivableHeaderType receHdr= new cs_postenNoEcServiceSendcreditmem.ReceivableHeaderType();
        cs_postenNoEcServiceSendcreditmem.ReceivableLineType[] ReceivableLineReceivableLine = new List<cs_postenNoEcServiceSendcreditmem.ReceivableLineType>();
        
        //added as part of CR C-07176 Integration Salesforce - OEBS ERP
        cs_postenNoEcServiceSendcreditmem.Customer_element Customerinfo = new  cs_postenNoEcServiceSendcreditmem.Customer_element();
        cs_postenNoEcServiceSendcreditmem.Address_element custBillingAddress = new cs_postenNoEcServiceSendcreditmem.Address_element();
        
        receHdr.CaseNumber           = TRANSACTION_TEXT_CASE + t.case__r.caseNumber;
        if(t.ERP_target_system__c == MonetaryTransactionsController.OEBS && t.case__r.contact != null && String.isNotBlank(t.case__r.contact.name))
        {
            receHdr.CaseNumber       = receHdr.CaseNumber + TRANSACTION_TEXT_CONTACT + t.case__r.contact.name;
        }
        receHdr.CaseCode             = t.case__r.type__c + '/' + t.case__r.code_event__r.name + '/' + t.case__r.Code_Reason1__r.name;
        receHdr.CRMTransactionID     = t.id;
        receHdr.Reference            = t.Reference__c;
        receHdr.PostingDate          = t.Transaction_approved_date__c.date();
        receHdr.DocumentDate         = t.CreatedDate.date();
        if(t.ERP_target_system__c.equalsIgnoreCase('NPB OEBS')){
            receHdr.TargetSystem         = 'NPB_OEBS';
        }else if(t.ERP_target_system__c.equalsIgnoreCase('OEBS')){
            receHdr.TargetSystem         = 'PNAS_OEBS';
        }else{
            receHdr.TargetSystem         = t.ERP_target_system__c;    
        }
        
        receHdr.OurReference         = '';
        receHdr.BankAccountNumber    = t.Bank_Account_Number__c;
        receHdr.TransactionType      = t.Type__c;
        
        /*
        if(t.recordtype.developerName =='Transaction_Regress_NPB_OEBS')
        {
        
            List<Monetary_Transaction_Line_Item__c> LineItems = t.Monetary_Transaction_Line_Items__r;
               
                if(LineItems != null)
                {
                    for(Monetary_Transaction_Line_Item__c transline : LineItems)
                    {
                    receHdr.IBANNumber           = transline.Regress_Account__r.crm_Company_IBAN__c;
                    receHdr.BankName             = transline.Regress_Account__r.crm_Company_bank_name__c;
                    receHdr.CurrencyCode         = transline.Regress_Account__r.CurrencyIsoCode;
                    receHdr.CustomerName         = transline.Regress_Account__r.name;
                    receHdr.SwiftCode            = transline.Regress_Account__r.crm_Company_SWIFT__c;
                   
                    if(t.case__r.Account.crm_Updated_by_CDH__c)
                    receHdr.CustomerNumber       = transline.Regress_Account__r.crm_customer_number__c;
                    
                    custBillingAddress.Address1 = transline.Regress_Account__r.BillingStreet;
                    custBillingAddress.City= transline.Regress_Account__r.BillingCity;
                    custBillingAddress.PostalCode = transline.Regress_Account__r.BillingPostalCode;
                    custBillingAddress.Country = transline.Regress_Account__r.BillingCountry;
                    custBillingAddress.AddressType = 'BillingAddress'; 
                    system.debug('@@@ custBillingAddress' + custBillingAddress);   
                    Customerinfo.CustomerReference = transline.Regress_Account__r.crm_customer_number__c;
                    Customerinfo.Address = custBillingAddress;
                     
                    if(transline.Regress_Account__r.IsPersonAccount)
                    {      
                    Customerinfo.PersonFirstName = transline.Regress_Account__r.FirstName;
                    Customerinfo.PersonLastName = transline.Regress_Account__r.LastName;
                    }
                    
                    else
                    {
                    Customerinfo.PersonFirstName = '';
                    Customerinfo.PersonLastName = transline.Regress_Account__r.Name;
                    }
        
            
                    if(transline.Regress_Account__r.CDH_customer_number_converted__c!=null && transline.Regress_Account__r.crm_Updated_by_CDH__c)
                    Customerinfo.PrivateCustomerNumber =transline.Regress_Account__r.CDH_customer_number_converted__c;
                    else    
                    Customerinfo.FARPartyNumber = transline.Regress_Account__r.crm_customer_number__c;
                    }    
                    
                }
                    
                    
        }
       
        
        else
        {
        receHdr.IBANNumber           = t.case__r.Account.crm_Company_IBAN__c;
        receHdr.BankName             = t.case__r.Account.crm_Company_bank_name__c;
        receHdr.CurrencyCode         = t.case__r.Account.CurrencyIsoCode;
        receHdr.CustomerName         = t.case__r.account.name;
        receHdr.SwiftCode            = t.Case__r.Account.crm_Company_SWIFT__c;
        
        if(t.case__r.Account.crm_Updated_by_CDH__c)
        receHdr.CustomerNumber       = t.case__r.account.crm_customer_number__c;
         
        
        //added as part of CR C-07176 Integration Salesforce - OEBS ERP - start
       
        custBillingAddress.Address1 = t.case__r.Account.BillingStreet;
        custBillingAddress.City= t.case__r.Account.BillingCity;
        custBillingAddress.PostalCode = t.case__r.Account.BillingPostalCode;
        custBillingAddress.Country = t.case__r.Account.BillingCountry;
        custBillingAddress.AddressType = 'BillingAddress'; 
        system.debug('@@@ custBillingAddress' + custBillingAddress);   
        Customerinfo.CustomerReference = t.case__r.account.crm_customer_number__c;
        Customerinfo.Address = custBillingAddress;
         
        if(t.case__r.Account.IsPersonAccount)
        {      
        Customerinfo.PersonFirstName = t.case__r.Account.FirstName;
        Customerinfo.PersonLastName = t.case__r.Account.LastName;
        }
        
        else
        {
        Customerinfo.PersonFirstName = '';
        Customerinfo.PersonLastName = t.case__r.Account.Name;
        }
        
            
        if(t.Case__r.Account.CDH_customer_number_converted__c!=null && t.case__r.Account.crm_Updated_by_CDH__c)
        Customerinfo.PrivateCustomerNumber =t.case__r.account.CDH_customer_number_converted__c;
        else    
        Customerinfo.FARPartyNumber = t.case__r.account.crm_customer_number__c;
        }    */
        
        
                if(t.recordtype.developerName =='Transaction_Regress_NPB_OEBS')
        {
        
            List<Monetary_Transaction_Line_Item__c> LineItems = t.Monetary_Transaction_Line_Items__r;
               
                if(LineItems != null)
                {
                    for(Monetary_Transaction_Line_Item__c transline : LineItems)
                    {
                    receHdr.IBANNumber           = transline.Regress_Account__r.crm_Company_IBAN__c;
                    receHdr.BankName             = transline.Regress_Account__r.crm_Company_bank_name__c;
                    receHdr.CurrencyCode         = transline.Regress_Account__r.CurrencyIsoCode;
                    receHdr.CustomerName         = transline.Regress_Account__r.name;
                    receHdr.SwiftCode            = transline.Regress_Account__r.crm_Company_SWIFT__c;
                   
                    if(transline.Regress_Account__r.crm_Updated_by_CDH__c)
                    receHdr.CustomerNumber       = transline.Regress_Account__r.crm_customer_number__c;
                    
                    custBillingAddress.Address1 = transline.Regress_Account__r.BillingStreet;
                    custBillingAddress.City= transline.Regress_Account__r.BillingCity;
                    custBillingAddress.PostalCode = transline.Regress_Account__r.BillingPostalCode;
                    custBillingAddress.Country = transline.Regress_Account__r.BillingCountry;
                    custBillingAddress.AddressType = 'BillingAddress'; 
                    system.debug('@@@ custBillingAddress' + custBillingAddress);   
                    Customerinfo.CustomerReference = transline.Regress_Account__r.crm_customer_number__c;
                    Customerinfo.Address = custBillingAddress;
                     
                    if(transline.Regress_Account__r.IsPersonAccount)
                    {      
                    Customerinfo.PersonFirstName = transline.Regress_Account__r.FirstName;
                    Customerinfo.PersonLastName = transline.Regress_Account__r.LastName;
                    }
                    
                    else
                    {
                    Customerinfo.PersonFirstName = '';
                    Customerinfo.PersonLastName = transline.Regress_Account__r.Name;
                    }
        
                    if(transline.Regress_Account__r.crm_Updated_by_CDH__c)
                    {   
                    Customerinfo.PrivateCustomerNumber = transline.Regress_Account__r.crm_customer_number__c;
                    //receHdr.CustomerNumber = transline.Regress_Account__r.crm_customer_number__c;
                    }
                    else if(transline.Regress_Account__r.CDH_customer_number_converted__c!=null)            
                    Customerinfo.PrivateCustomerNumber =transline.Regress_Account__r.CDH_customer_number_converted__c;
                    else    
                    Customerinfo.FARPartyNumber = transline.Regress_Account__r.crm_customer_number__c;
                    }    
                    
                }
                    
                    
        }
       
        
        else
        {
        receHdr.IBANNumber           = t.case__r.Account.crm_Company_IBAN__c;
        receHdr.BankName             = t.case__r.Account.crm_Company_bank_name__c;
        receHdr.CurrencyCode         = t.case__r.Account.CurrencyIsoCode;
        receHdr.CustomerName         = t.case__r.account.name;
        receHdr.SwiftCode            = t.Case__r.Account.crm_Company_SWIFT__c;
        
        if(t.case__r.Account.crm_Updated_by_CDH__c)
        receHdr.CustomerNumber       = t.case__r.account.crm_customer_number__c;
         
        
        //added as part of CR C-07176 Integration Salesforce - OEBS ERP - start
       
        custBillingAddress.Address1 = t.case__r.Account.BillingStreet;
        custBillingAddress.City= t.case__r.Account.BillingCity;
        custBillingAddress.PostalCode = t.case__r.Account.BillingPostalCode;
        custBillingAddress.Country = t.case__r.Account.BillingCountry;
        custBillingAddress.AddressType = 'BillingAddress'; 
        system.debug('@@@ custBillingAddress' + custBillingAddress);   
        Customerinfo.CustomerReference = t.case__r.account.crm_customer_number__c;
        Customerinfo.Address = custBillingAddress;
         
        if(t.case__r.Account.IsPersonAccount)
        {      
        Customerinfo.PersonFirstName = t.case__r.Account.FirstName;
        Customerinfo.PersonLastName = t.case__r.Account.LastName;
        }
        
        else
        {
        Customerinfo.PersonFirstName = '';
        Customerinfo.PersonLastName = t.case__r.Account.Name;
        }
        
            
        if(t.Case__r.Account.CDH_customer_number_converted__c!=null && t.case__r.Account.crm_Updated_by_CDH__c)
        Customerinfo.PrivateCustomerNumber =t.case__r.account.CDH_customer_number_converted__c;
        else    
        Customerinfo.FARPartyNumber = t.case__r.account.crm_customer_number__c;
        }  
        
        //added as part of CR C-07176 Integration Salesforce - OEBS ERP - end
        receHdr.Customer = Customerinfo;
        
        rece.ReceivableHeader = receHdr;
        ReceivableLineReceivableLine = createPaymentLineItems(t);
        rece.ReceivableLine = ReceivableLineReceivableLine;
        
        system.debug('NIKITA TEST' + rece);
        return rece;
        
    }
    
    public static cs_postenNoEcServiceSendcreditmem.ReceivableLineType[] createPaymentLineItems(Monetary_transaction__c t)
    {       
        List<Monetary_Transaction_Line_Item__c> LineItems = t.Monetary_Transaction_Line_Items__r;
        
        if(LineItems == null){ return null;}
        
        system.debug('Transaction has '  + LineItems.size() + ' line items');
        cs_postenNoEcServiceSendcreditmem.ReceivableLineType[] ReceivableLines = new list<cs_postenNoEcServiceSendcreditmem.ReceivableLineType>();
        
        Integer i = 0;
        for(Monetary_Transaction_Line_Item__c transline : LineItems)
        {
            if(String.isBlank(transline.voucher_number__c))
            { 
                // Do not submit items with voucher numbers, these have already been submitted. Voucher numbers are only filled for transaction lines to NAV who have been accepted by NAV. 
                ReceivableLines.add(new cs_postenNoEcServiceSendcreditmem.ReceivableLineType());
                
                
                ReceivableLines.get(i).RefundAmount           = String.ValueOf(transline.Line_Amount__c);
                ReceivableLines.get(i).ItemNumber       = transline.Article_Number__c;
                
                // WE NEED TO VERIFY WHICH FIELDS NAVISION NEEDS TO BE ABLE TO TREAT MOTPOSTS CORRECTLY
                if (t.ERP_target_system__c == NAV ) 
                {    
                    ReceivableLines.get(i).ItemNumber       = transline.vare_number_NAV__r.Name;
                    
                    String companyCode = '';
                    //Will cause exception if transline.cargo_division_code__r.DRM_id__c.length() is less than 8
                    if(t.ERP_target_system__c == NAV){
                        if ( !KATSutilities.isEmpty(transline.cargo_division_code__r.DRM_id__c) && transline.cargo_division_code__r.DRM_id__c.length() >= 8)
                        {  
                            companyCode = transline.cargo_division_code__r.DRM_id__c.substring(4,8); 
                        } 
                        else
                        {
                            companyCode = 'XXXX'; //Transaction will fail if Dimension1 is not of length equal 8.
                        } 
                        
                        //Merge companyCode and unitnumber for subsidiary companies
                        
                        ReceivableLines.get(i).Dimension1       = companyCode + transline.cargo_division_code__r.unit_number_in_subsidiary__c;
                    }
                    ReceivableLines.get(i).ProductCode       = transline.cargo_product_code__c;
                    ReceivableLines.get(i).RegressCustNo    = transline.Regress_Account__r.crm_customer_number__c;
                    ReceivableLines.get(i).Description      = transline.Description__c;
                    ReceivableLines.get(i).Quantity         = 1;
                    
                    if(transline.Type__c == REGRESS || transline.Type__c == REGRESS_MOTPOST)
                    {
                        if(transline.Regress_Account__c != null && transline.Regress_Account__r.Transaksjonskontakt__c != null)
                        {
                            ReceivableLines.get(i).ContactPersonEmailId        = transline.Regress_Account__r.Transaksjonskontakt__r.Email;
                        }else if (transline.Regress_Account__c != null && transline.Regress_Account__r.Transaksjonskontakt__c != null)
                        {
                            ReceivableLines.get(i).ContactPersonEmailId        = transline.Regress_Account__r.Transaksjonskontakt__r.Email;
                        }
                    }
                    else
                    {
                        ReceivableLines.get(i).ContactPersonEmailId        = t.case__r.account.Transaksjonskontakt__r.Email;
                    }
                    
                    ReceivableLines.get(i).CaseReference  = t.case__r.case_referens__c + ';'+ transline.Name.substring(3);
                }
                
                // For NPB OEBS ONLY
                
                if (t.ERP_target_system__c == NPB_OEBS) 
                {    
                    //ReceivableLines.get(i).ItemNumber       = t.case__r.Service_Product__r.Name;
                    
                    //Bhavani
                    ReceivableLines.get(i).AccountingUnitNR     = transline.cs_Accounting_Unit__c;
                    String companyCode = '';
                    
                    ReceivableLines.get(i).ProductCode       = t.case__r.Service_Product__r.Name;
                    ReceivableLines.get(i).RegressCustNo    = transline.Regress_Account__r.crm_customer_number__c;
                    ReceivableLines.get(i).Description      = transline.Description__c;
                    ReceivableLines.get(i).Quantity         = 1;
                    
                    if(transline.Type__c == REGRESS || transline.Type__c == REGRESS_MOTPOST)
                    {
                        if(transline.Regress_Account__c != null && transline.Regress_Account__r.Transaksjonskontakt__c != null)
                        {
                            ReceivableLines.get(i).ContactPersonEmailId        = transline.Regress_Account__r.Transaksjonskontakt__r.Email;
                        }
                    }
                    else
                    {
                        ReceivableLines.get(i).ContactPersonEmailId        = t.case__r.account.Transaksjonskontakt__r.Email;
                    }
                    
                    ReceivableLines.get(i).CaseReference  = t.case__r.case_referens__c + ';'+ transline.Name.substring(3);
                }
                
                if (transline.Type__c == REGRESS)
                { 
                    //NEEDS TO BE CHANGED? CONTACT NAVISION. if (transline.Type__c == REGRESS || transline.Type__c == REGRESS_MOTPOST) OR if (transline.Type__c == REGRESS || transline.Type__c == KREDITTNOTA_MOTPOST)
                    ReceivableLines.get(i).LineType     = 'RE';
                }
                
                else if (transline.Type__c == KREDITTNOTA) 
                { 
                    //NEEDS TO BE CHANGED? CONTACT NAVISION. if (transline.Type__c == KREDITTNOTA || transline.Type__c == KREDITTNOTA_MOTPOST) OR if (transline.Type__c == KREDITTNOTA || transline.Type__c == REGRESS_MOTPOST)
                    ReceivableLines.get(i).LineType     = 'CM';
                    
                }
                if(t.ERP_target_system__c == NPB_OEBS && (transline.Type__c.equalsIgnoreCase('Kompensasjon')|| transline.Type__c.equalsIgnoreCase('Erstatning')|| transline.Type__c.equalsIgnoreCase('Refusjon'))){
                        ReceivableLines.get(i).RefundAmount           = String.ValueOf(transline.Line_Amount__c*-1);
                        ReceivableLines.get(i).LineType     = 'CM';
                    }
                    
                
                i++;    //Incrementing counter
            }
        }       
        return ReceivableLines; 
    }
    
    // Methods for updating transaction status based on eConnect response
    public static void updateTransactionStatusFromEconnect(List<Monetary_transaction__c> transactionsToUpdate, Map<string,string> statusMap){
        for(monetary_transaction__c t : transactionsToUpdate){
            if(statusMap != null){
                System.debug('==========Inside Update');
                String status = statusMap.get(t.id);
                updateTransactionStatus(t, status);
            } else {
                updateTransactionStatus(t, FAIL_STATUS);
            }
        }
        system.debug('Updating transaction status based on response from eConnect');
        update transactionsToUpdate;
    }
    
    public static void updateTransactionStatus(Monetary_transaction__c t, String status){           
        if(status == FAIL_STATUS){
            t.status__c = FAIL_STATUS;
        } 
        else if(status == 'Complete' && t.ERP_target_system__c == OEBS) {
            t.status__c = SUCCESS_STATUS_OEBS;
            t.error_reason__c = '';
        }
        else if(status == 'Complete' && t.ERP_target_system__c == NAV) {
            t.status__c = SUCCESS_STATUS_NAV;
            t.error_reason__c = '';
        }
        else if(status == 'Complete' && t.ERP_target_system__c == NPB_OEBS) {
            t.status__c = SUCCESS_STATUS_NPB_OEBS;
            t.error_reason__c = '';
        }
        else {// e-mail notification is sent, a seperate workflow rule exists see "????" //TODO
            t.status__c = FAIL_STATUS;
            t.error_reason__c = 'eConnect returned not OK';
        }
    } 
    
}