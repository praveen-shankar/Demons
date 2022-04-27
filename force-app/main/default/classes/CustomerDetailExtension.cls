//CS-Phase 2-Akshata Asukar-03/01/2017- Replaced all occurences of party_number__c with crm_customer_number__c
public class CustomerDetailExtension {
    
    private final Account acct;
    
    private String customerType;
    
    public String OEBS { get{ return environment_settings__c.getInstance('OEBSorderFallbackURL').value__c; } }
    
    private postenNoEconnectUtilities eConnect;
    
    public EConnectWrapper_GetCustomerData eConnectData { get; set; }
    
    public String[] InformationType{get;set;}
    
    private KATSutilities.Timer timer { get{if(timer == null) timer = new KATSutilities.Timer();return this.timer; }set;}
    
    /* Logic for the contact persistency buttons */
    public integer selectedContactsElementsIndex { set; get; } 
    public PageReference persistContact() {
        system.debug('Persisting the contact selected');
        /* Contact should not be retrieved from Caesar
        if(DataPersistencyController.maintainContact(contactsElements.contactElements.get(selectedContactsElementsIndex), acct.id)) {
            return new ApexPages.StandardController(acct).view();
        }
        */
        return null;
    }
    
    public EConnectWrapper_GetCustomerData.OrganizationParty organizationCustomer { get { 
        system.debug('CustomerDetailExtension - Get businessCustomer');
        if(eConnectData != null) {
            return eConnectData.organizationParty;
        } return null; }
    }
    
    public EConnectWrapper_GetCustomerData.PersonParty privateCustomer { get {
        system.debug('CustomerDetailExtension - Get privateCustomer');
        if(eConnectData != null) { 
        
       
            return eConnectData.PersonParty;
        } return null; }
    }
    
    public EConnectWrapper_GetCustomerData.InvoiceElement Invoicesdata { get{ 
    system.debug('CustomerDetailExtension - Get Invoices');
        if(eConnectData != null) {
            return eConnectData.invoiceElements; 
        }return null; }
    }
    
    public EConnectWrapper_GetCustomerData.ForwardingElement Forwardings{ get{ 
    system.debug('CustomerDetailExtension - Get Forwardings');
        if(eConnectData != null) {
            return eConnectData.forwardingElements ; 
        }return null; }
    }
    
    public EConnectWrapper_GetCustomerData.OrderElement Orders{ get{ 
    system.debug('CustomerDetailExtension - Get orders');
        if(eConnectData != null) {
            return eConnectData.OrderElements ; 
        }return null; }
    }
    
    public EConnectWrapper_GetCustomerData.AddressElement addressElements { get{
        if(eConnectData != null) {
            if(customerType == 'person_account' && eConnectData.PersonParty != null) { 
                system.debug('CustomerDetailExtension - Private get addressElements');
                return privateCustomer.addressElements; 
            }
            else if(customerType == 'business_account' && eConnectData.OrganizationParty != null) { 
                system.debug('@@CustomerDetailExtension - Organization get addressElements@@'+organizationCustomer.addressElements);
                return organizationCustomer.addressElements;
            }
        }
        return null; }
    }
    
    public EConnectWrapper_GetCustomerData.CommunicationElement communicationElements { get{
        system.debug('CustomerDetailExtension - communicationElements');
        if(eConnectData != null) {
            if(customerType == 'person_account' && eConnectData.PersonParty != null) {
                system.debug('CustomerDetailExtension - Private get communicationElements');
                return privateCustomer.communicationElements;
            }
            else if(customerType == 'business_account' && eConnectData.OrganizationParty != null) {
                system.debug('CustomerDetailExtension - Organization get communicationElements');
                return organizationCustomer.communicationElements;
            }
        }
        return null; }
    }
    
    public EConnectWrapper_GetCustomerData.ForwardingElement forwardingElements { get{
        if(eConnectData != null) {
            if(customerType == 'person_account' && eConnectData.PersonParty != null) {
                system.debug('~~CustomerDetailExtension - Private get forwardingElements');
                return privateCustomer.forwardingElements;
            }
            else if(customerType == 'business_account' && eConnectData.OrganizationParty != null) {
                system.debug('~~~CustomerDetailExtension - Organization get forwardingElements');
                return organizationCustomer.forwardingElements;
            }
            else if(eConnectData.invoiceElements!=null && (eConnectData.PersonParty==null && eConnectData.OrganizationParty==null))
            {
               return Forwardings;
            }
        }
        return null; }
    }
    
    public EConnectWrapper_GetCustomerData.InvoiceElement invoiceElements { get{
                         
        if(eConnectData != null) {
            if(customerType == 'person_account' && eConnectData.PersonParty.invoiceElements.invoiceTypes[0].InvoiceNumber != '-') {
                system.debug('CustomerDetailExtension - Private get invoiceElements'+eConnectData.PersonParty.invoiceElements);
                return privateCustomer.invoiceElements;
            }
            else if(customerType == 'business_account' && eConnectData.OrganizationParty.invoiceElements.invoiceTypes[0].InvoiceNumber != '-') {
                system.debug('~~~CustomerDetailExtension - Organization get invoiceElements'+ eConnectData.OrganizationParty.invoiceElements);
                return organizationCustomer.invoiceElements;
            }             
            else if(eConnectData.invoiceElements!=null) //&& (eConnectData.PersonParty.invoiceElements==null && eConnectData.OrganizationParty.invoiceElements==null))
            {    

               return Invoicesdata ;
            }
            
            
           /* system.debug('CustomerDetailExtension - Blank record');
                return Invoicesdata;*/ 
            
        }
       // return econnectData.invoiceElements; }
       return null;}
    }
    
    public EConnectWrapper_GetCustomerData.OrderElement orderElements { get{
        if(eConnectData != null) {
            if(customerType == 'person_account' && eConnectData.PersonParty.orderElements.orderTypes[0].OrderNumber != '-') {
                system.debug('~~~CustomerDetailExtension - Private get orderElements');
                //system.debug(privateCustomer.orderElements);
                return privateCustomer.orderElements;
            }
            else if(customerType == 'business_account' && eConnectData.OrganizationParty.orderElements.orderTypes[0].OrderNumber != '-') {
                system.debug('~~~CustomerDetailExtension - Organization get orderElements');
                return organizationCustomer.orderElements;
            }
            else if(eConnectData.invoiceElements!=null) //&& (eConnectData.PersonParty==null && eConnectData.OrganizationParty==null))
            {
               return Orders;
            }
        }
        return null; }
    }
    
   /* public EConnectWrapper_GetCustomerData.ContactsElement contactsElements { get{
        system.debug('CustomerDetailExtension - communicationElements');
        if(eConnectData != null) {
            if(customerType == 'business_account' && eConnectData.OrganizationParty != null) {
                system.debug('CustomerDetailExtension - Organization get ContactsElement');
                return organizationCustomer.contactsElements;
            }
        }
        return null; }
    }*/
    
    /*public EConnectWrapper_GetCustomerData.DivisionElement divisionElements { get{
        system.debug('CustomerDetailExtension - divisionElements');
        if(eConnectData != null) {
            if(customerType == 'business_account' && eConnectData.OrganizationParty != null) {
                system.debug('CustomerDetailExtension - Organization get divisionElements');
                return organizationCustomer.divisionElements;
            }
        }
        return null; }
    }*/
    
    public CustomerDetailExtension(ApexPages.StandardController stdController) {
        timer.startTimer();
        if (!Test.isRunningTest())stdController.addFields(new List<String>{'crm_Updated_by_CDH__c'});
        this.acct = (Account)stdController.getRecord();
       
        try {
            customerType = KATSutilities.getRecordType([SELECT RecordTypeId FROM Account WHERE Id = :acct.Id LIMIT 1].RecordTypeId);
        } catch (System.QueryException qe){
            system.debug('CustomerDetailExtension - Could not find customer type: ' + qe.getMessage() );
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_Unable_to_find_Customer+' - ' + qe.getMessage() ));
            //CSPhase2, 16122016, Supriya ->Added the labels 
        }
        eConnect = new postenNoEconnectUtilities();
        requestData();
        
        timer.stopTimer();
    }
    
  
    public void requestData() {
        system.debug('CustomerDetailExtension - requestData');
       
        try {
            if(acct.crm_customer_number__c == null || acct.crm_customer_number__c == '') {
                eConnectData = null;
                system.debug('CustomerDetailExtension - requestData - no partyNumber...');
                
                //throw new CustomerDetailExtensionException('Kunden mangler aktørnummer eller aktørnummeret finnes ikke i baksystemet. Kan ikke hente data fra baksystemene');   
                //  CSPhase2, 16122016, Supriya ->Added the labels 
                throw new CustomerDetailExtensionException(System.Label.cs_Participant_number_missing_Error);   
            }
           if(test.isRunningTest()) {
                
                eConnectData= null; // Manually assigned in test
                
            }  else{     
                InformationType=new String[]{'InvoiceDetails','OrderDetails','ForwardingDetails','CustomerDetails'} ;
                
               InformationType=new String[]{'InvoiceDetails','OrderDetails','ForwardingDetails','CustomerDetails'} ;
                postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType reponse=new postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType();
                if(acct.crm_Updated_by_CDH__c){  
                    reponse=eConnect.getCustomer(null, acct.crm_customer_number__c,InformationType );
                    
                 }   
                else{
                       reponse=eConnect.getCustomer(acct.crm_customer_number__c,null,InformationType );                 
                }    
                
               if(reponse.PersonParty==null && reponse.OrganizationParty==null && reponse.Forwardings==null  && reponse.Orders==null  && reponse.Invoices==null)
               {    
                  
                  KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.cs_No_customers_with_party_number +' '+ acct.crm_customer_number__c ));
               }
               else
               {    
                   
                    eConnectData = new EConnectWrapper_GetCustomerData(reponse);
               }
            }
            system.debug('CustomerDetailExtension - requestData - ' + this.eConnectData);
        } catch (Calloutexception coe) {
            system.debug('CustomerDetailExtension - requestData - No connection to eConnect - ' + coe.getMessage());
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_Connection_to_eConnect_failed+ '- ' + coe.getMessage() ));
            // CSPhase2, 16122016, Supriya ->Added the labels 
        } catch (CustomerDetailExtensionException cdee) {
            system.debug('CustomerDetailExtension - requestData - ' + cdee.getMessage());
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, cdee.getMessage() ));
        } catch (Exception e) {
            system.debug('CustomerDetailExtension - requestData - ' + e.getMessage());
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.cs_No_customers_with_party_number + acct.crm_customer_number__c ));
            // CSPhase2, 16122016, Supriya ->Added the labels 
        }
    }
    
    public class CustomerDetailExtensionException extends Exception {}
    
    public boolean getHasEConnectData() {
        if((eConnectData != null && eConnectData.personParty != null) || (eConnectData != null && eConnectData.organizationParty != null)) {
            system.debug('CustomerDetailExtension - getHasEConnectData - true');
            return true;
        }
        system.debug('CustomerDetailExtension - getHasEConnectData - false');
        system.debug('CustomerDetailExtension - getHasEConnectData - eConnectData = ' + econnectData);
        if(econnectData != null) {
            system.debug('CustomerDetailExtension - getHasEConnectData - eConnectData.personParty = ' + econnectData.personParty);
            system.debug('CustomerDetailExtension - getHasEConnectData - eConnectData.organizationParty = ' + econnectData.organizationParty);
        }
        return false;
    }
    
    public static EConnectWrapper_GetCustomerData.ForwardingElement SetFStatusAsPerLang(EConnectWrapper_GetCustomerData.ForwardingElement Forwarding)
    {
        return null;
    }
   /* public static EConnectWrapper_GetCustomerData.PersonParty SetStatusAsPerLang(EConnectWrapper_GetCustomerData.PersonParty Person)
    {
        if(Person.Status=='Gyldig' || Person.Status=='Valid')
             Person.Status=System.Label.cs_Valid;
        else if(Person.Status=='Død' || Person.Status=='Dead')
             Person.Status=System.Label.cs_Dead;
        else if(Person.Status=='Konkurs' || Person.Status=='Bankrupt')
             Person.Status=System.Label.cs_Bankrupt;
        else if(Person.Status=='Duplikat' || Person.Status=='Duplicate')
             Person.Status=System.Label.cs_Duplicate;
        else if(Person.Status=='Forsvunnet' || Person.Status=='Disappeared')
             Person.Status=System.Label.cs_Disappeared; 
        else if(Person.Status=='Fusjonert' || Person.Status=='Merged')
             Person.Status=System.Label.cs_Merged;   
        else if(Person.Status=='Likvidert' || Person.Status=='Liquidated')
             Person.Status=System.Label.cs_Liquidated; 
        else   if(Person.Status=='Opphørt' || Person.Status=='Ceased to exist')
             Person.Status=System.Label.cs_Ceased_to_exist; 
        else   if(Person.Status=='Aktive' || Person.Status=='Active')
             Person.Status=System.Label.cs_Active;
        else  if(Person.Status=='Inaktive' || Person.Status=='Inactive')
             Person.Status=System.Label.cs_Inactive;     
               
             return Person;
    }*/
    

    static testMethod void coverageTest() {
       Account a = new Account();
        a.LastName = 'Name';
        a.RecordTypeId = KATSutilities.getRecordType('person_account');
        a.crm_customer_number__c = 'CDEtest123';
        KATSutilities.upsertAsSystem(a);
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        CustomerDetailExtension cde = new CustomerDetailExtension(sc);
        cde.eConnectData =  new EConnectWrapper_GetCustomerData(mock_Crmgetcustome.getPrivateAccount());
       
        EConnectWrapper_GetCustomerData.OrganizationParty organization = cde.organizationCustomer;
        EConnectWrapper_GetCustomerData.PersonParty person = cde.privateCustomer;
        EConnectWrapper_GetCustomerData.AddressElement addressElement = cde.addressElements;
        EConnectWrapper_GetCustomerData.CommunicationElement CommunicationElement = cde.communicationElements;
        EConnectWrapper_GetCustomerData.ForwardingElement ForwardingElement = cde.forwardingElements;
        EConnectWrapper_GetCustomerData.InvoiceElement InvoiceElement = cde.invoiceElements;
        EConnectWrapper_GetCustomerData.OrderElement OrderElement = cde.orderElements;
       // EConnectWrapper_GetCustomerData.DivisionElement divisionElement = cde.divisionElements;
      
        
     Account a2 = new Account();
        a2.Name = 'Name';
        a2.RecordTypeId = KATSutilities.getRecordType('business_account');
        a2.crm_customer_number__c = '1234';
        KATSutilities.upsertAsSystem(a2);
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(a2);
        CustomerDetailExtension cde2 = new CustomerDetailExtension(sc2);
         System.assert( !cde2.getHasEConnectData()); // Data is not loadet yet
        cde2.eConnectData=   new EConnectWrapper_GetCustomerData(mock_Crmgetcustome.getBusinessAccount());
        
        EConnectWrapper_GetCustomerData.OrganizationParty organization2 = cde2.organizationCustomer;
        EConnectWrapper_GetCustomerData.PersonParty person2 = cde2.privateCustomer;
        EConnectWrapper_GetCustomerData.AddressElement addressElement2 = cde2.addressElements;
        EConnectWrapper_GetCustomerData.CommunicationElement CommunicationElement2 = cde2.communicationElements;
        EConnectWrapper_GetCustomerData.ForwardingElement ForwardingElement2 = cde2.forwardingElements;
        EConnectWrapper_GetCustomerData.InvoiceElement InvoiceElement2 = cde2.invoiceElements;
        EConnectWrapper_GetCustomerData.OrderElement OrderElement2 = cde2.orderElements;
        //EConnectWrapper_GetCustomerData.DivisionElement divisionElement2 = cde2.divisionElements;
        //EConnectWrapper_GetCustomerData.ContactsElement contactElement2 = cde2.contactsElements;
        
       //System.assert( cde.getHasEConnectData());
       //System.assert( cde2.getHasEConnectData());
       cde2.selectedContactsElementsIndex=0;
      PageReference p2= cde2.persistContact();
       //System.assertNotEquals(p2,null);
    
    
    
        // Test of empty accounts/econnect data to cover error handling
  
        //EConnectWrapper_GetCustomerData.ContactsElement contactElement = cde.contactsElements; // Calling for a contacts element on person contacts should return null
        //System.assertEquals(contactElement, null);
        
        Account a3 = new Account();
        a3.Name = 'Name';
        a3.RecordTypeId = KATSutilities.getRecordType('business_account');
        a3.crm_customer_number__c =null;
       KATSutilities.upsertAsSystem(a3);
        
        ApexPages.StandardController sc3 = new ApexPages.StandardController(a3);
        CustomerDetailExtension cde3 = new CustomerDetailExtension(sc3);
        
        System.assert(!cde3.getHasEConnectData());
        
        System.assertEquals(cde3.organizationCustomer, null);
        System.assertEquals(cde3.privateCustomer, null);
        System.assertEquals(cde3.addressElements, null);
        System.assertEquals(cde3.communicationElements, null);
        System.assertEquals(cde3.forwardingElements, null);
        System.assertEquals(cde3.invoiceElements, null);
        System.assertEquals(cde3.orderElements, null);
       // System.assertEquals(cde3.divisionElements, null);
       
  
    }

}