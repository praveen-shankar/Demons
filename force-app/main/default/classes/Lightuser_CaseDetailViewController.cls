// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c

public with sharing class Lightuser_CaseDetailViewController { 

    public CaseDetails caseDetail { get; set; }
    public String test { get; set; }
    public Boolean Isactivelightuser {get;set;}
    
       public Lightuser_CaseDetailViewController(ApexPages.StandardController controller) {
       String id = ApexPages.currentPage().getParameters().get('id');
       Isactivelightuser =true;
       environment_settings__c env = environment_settings__c.getValues('Isactivelightuser');
        if (env != null && env.value__c == 'false')  {
              Isactivelightuser =false;  
        
        }
       
        test = id;
                if(id!=null && id!=''){
       /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        Case c = [SELECT LastModifiedBy.Name,
                        Shipment_identification__c,
                        Shipment_number__c,
                        Parent.CaseNumber,
                        Waiting_for_unit__r.Name,
                        PO_Amount__c,
                        Division__c,
                        Created_by_Name__c,
                        Created_by_Unit__r.Name,
                        unit_to_blame__r.Name,
                        Subject, toLabel(RecordType.Name),
                        Owner.Name,
                        CaseNumber,
                        Status,
                        tolabel(Priority),
                        CreatedDate,
                        date_to_be_resumed__c,
                        Type__c,
                        Service_Product__r.Name,
                        Code_Event__r.name,
                        deviation_time_of_incident__c,
                        //reason__c,
                        Code_Reason1__r.name,
                        Code_Reason2__r.name,
                        measures__c,
                        deviation_route__c,
                        description,
                        change_address_ref_no__c,
                        forwardingAddress__c,
                        Account.Name,
                        Account.crm_customer_number__c,
                        Account.ShippingStreet,
                        Account.ShippingPostalCode,
                        Account.ShippingCity,
                        Account.ShippingCountry,
                        Account.other_adress__c,
                        Contact.Name,
                        //Distribusjon
                        deviation_postal_nmb_from__c,
                        deviation_postal_nmb_to__c,
                        deviation_nmb_households__c,
                        deviation_affected_address__c,
                        deviation_affected_postal_nmb__c,
                        //Terminal
                        Letter_priority__c,
                        deviation_depature_spread__c,
                        deviation_shipments_nmb__c
                    FROM Case
                    WHERE id = :id LIMIT 1];
        caseDetail = new CaseDetails(c);
    }
}

    public PageReference newCaseWithSomeDataFromLastCase() {
        String id = ApexPages.currentPage().getParameters().get('id');
       /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */ 
        LIST<Case> cc = [SELECT id, subject, Created_by_Unit__r.name, RecordTypeId, Code_Event__c, Created_by_Name__c, Service_Product__c FROM Case WHERE id =:id];  //ADDED SERVICE PRODUCT FOR SALES
        
        if (cc.size() > 0)
        {
            Case c1 = cc.get(0);
            //return new PageReference('/Lightuser_CreateCase?user=' + c1.Created_by_Name__c + '&unit=' + c1.Created_by_Unit__r.name + '&record=' + c1.RecordTypeID + '&prod=' + c1.ProductId + '&kat=' + c1.Code_Event__c); COMMENTED FOR SALES
            return new PageReference('/Lightuser_CreateCase?user=' + c1.Created_by_Name__c + '&unit=' + c1.Created_by_Unit__r.name + '&record=' + c1.RecordTypeID + '&prod=' + c1.Service_Product__c + '&kat=' + c1.Code_Event__c);
        }   
        
        return null; 
    }
    
    public class CaseDetails {
        //Create case object for using in a outputField for description
        //It has to be a SF object
        //05.01.2012 aolsen
        public Case myCase { get; set; }
        
        public String subject { get; set; }
        public String recordType { get; set; }
        public String caseOwner { get; set; }
        public String caseNumber { get; set; }
        public String status { get; set; }
        public String priority { get; set; }
        public String createdDate { get; set; }
        public String dateToBeResumed { get; set; }
        public String type_c { get; set; }
        public String produkt { get; set; }
        public String category { get; set; }
        public String reason { get; set; }
        public String reason2 {get; set;}
        public String measures { get; set; }
        public String deviation_route { get; set; }
        public String changeAddressRefNo { get; set; }
        public String previousAddress { get; set; }
        public String newAddress { get; set; }
        public String CreatedByName { get; set; }
        public String CreatedByUnit { get; set; }
        public String division { get; set; }
        public String description { get; set; }
        public String POAmount { get; set; }
        public String WaitingForUnit { get; set; }
        public String deviationDate {get; set;}
        public String parentCase { get; set; }
        public String lastModifiedBy { get; set; }
        public string RelatedUnit{get; set;}
        public String shipmentNumber { get; set; }//Sendingsnummer
        public String shipmentIdentification { get; set; }//kollinummer
        
        //Distribusjon
        public String postalNmbFrom { get; set; }
        public String postalNmbTo { get; set; }
        public String nmbHouseholds { get; set; }
        public String affectedAddress { get; set; }
        public String affectedPostalNmb { get; set; }
        
        //Terminal
        public String letterPriority { get; set; }
        public String depatureSpread { get; set; }
        public String shipmentsNmb { get; set; }
        
        public String accountName { get; set; }
        public String accountPartyNumber { get; set; }
        public String accountShippingStreet { get; set; }
        public String accountShippingPostalCode { get; set; }
        public String accountShippingCity { get; set; }
        public String accountShippingCountry { get; set; }
        public string accountOtherAddress{ get; set; }

        public String contactName { get; set; }
        
        public boolean showChangeAddress { get; set; }

        
        public List<String> getAddressLines(){
            if(accountOtherAddress!=null){
            return accountOtherAddress.split('\r\n');
            }
            else {
                return new List<String>{'Ingen Adresse'};
            }
        }

        public CaseDetails(Case c) {
            //Use of SF object 
            //05.01.12 aolsen
            myCase = c;
            if(!KATSutilities.isEmpty(c.CaseNumber))        {this.caseNumber = c.CaseNumber; }
            if(!KATSutilities.isEmpty(c.Subject))           {this.subject = c.Subject; }

            if(c.RecordType.Name != null)                   {this.recordType = c.RecordType.Name; }
            if(c.Owner.Name != null)                        {this.caseOwner = c.Owner.Name; }
            
            if(c.Created_by_Unit__r.Name != null)           {this.CreatedByUnit = c.Created_by_Unit__r.Name; }
            if(c.unit_to_blame__c != null)                  {this.RelatedUnit = c.unit_to_blame__r.Name;}
            if(c.LastModifiedBy.Name != null)               {this.lastModifiedBy = c.LastModifiedBy.Name; }

            if(c.Division__c != null)                       {this.division = c.Division__c; }
            if(!KATSutilities.isEmpty(c.Created_by_Name__c)){this.CreatedByName =c.Created_by_Name__c; }

            if(!KATSutilities.isEmpty(c.type__c))           {this.type_c = c.Type__c; }
            if(c.createdDate != null)                       {this.createdDate = c.createdDate.format('dd.MM.yyyy HH:mm'); }
            if(c.deviation_time_of_incident__c != null)     {this.deviationDate = c.deviation_time_of_incident__c.format('dd.MM.yyyy HH:mm'); }

            if(!KATSutilities.isEmpty(c.Code_Event__r.name))        {this.category = c.Code_Event__r.name; }
            if(!KATSutilities.isEmpty(c.Status))            {this.status = c.Status; }

            if(!KATSutilities.isEmpty(c.Code_Reason1__r.name))          {this.reason = c.Code_Reason1__r.name; }
            if(c.Code_Reason2__c != null)                   {this.reason2 = c.Code_Reason2__r.name; }
            if(!KATSutilities.isEmpty(c.Priority))          {this.priority = c.Priority; }

            if(!KATSutilities.isEmpty(c.Service_Product__r.Name))      {this.produkt = c.Service_Product__r.Name; }/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
            if(String.isNotEmpty(c.measures__c))            {this.measures = c.measures__c; }
            
            if(String.isNotEmpty(c.deviation_route__c))     {this.deviation_route = c.deviation_route__c; }
            if(c.Parent.CaseNumber != null)                 {this.parentCase = c.Parent.caseNumber; }
            
            if(c.PO_Amount__c != null)                      {this.POAmount = c.PO_Amount__c.toPlainString(); }
            if(c.date_to_be_resumed__c != null)             {this.dateToBeResumed = c.date_to_be_resumed__c.format('dd.MM.yyyy HH:mm'); }
            
            if(!KATSutilities.isEmpty(c.change_address_ref_no__c))  {this.changeAddressRefNo = c.change_address_ref_no__c; }
            if(!KATSutilities.isEmpty(c.Waiting_for_unit__r.Name))  {this.WaitingForUnit = c.Waiting_for_unit__r.Name; }

            if(!KATSutilities.isEmpty(c.description))   {this.description = c.description; }
            
            //Distribusjon
            if(String.isNotEmpty(c.deviation_postal_nmb_from__c)){this.postalNmbFrom = c.deviation_postal_nmb_from__c;}
            if(String.isNotEmpty(c.deviation_postal_nmb_to__c)){this.postalNmbTo = c.deviation_postal_nmb_to__c;}
            if(c.deviation_nmb_households__c != null){this.nmbHouseholds = '' + c.deviation_nmb_households__c;}
            if(String.isNotEmpty(c.deviation_affected_address__c)){this.affectedAddress = c.deviation_affected_address__c;}
            if(String.isNotEmpty(c.deviation_affected_postal_nmb__c)){this.affectedPostalNmb = c.deviation_affected_postal_nmb__c;}
            
            //Terminal
            if(String.isNotEmpty(c.Letter_priority__c)){this.letterPriority = c.Letter_priority__c;}
            if(String.isNotEmpty(c.deviation_depature_spread__c)){this.depatureSpread = c.deviation_depature_spread__c;}
            if(c.deviation_shipments_nmb__c != null){this.shipmentsNmb = '' + c.deviation_shipments_nmb__c;}
            
            //Account
            if(!KATSutilities.isEmpty(c.Account.crm_customer_number__c))   {this.accountPartyNumber = c.Account.crm_customer_number__c; }
            if(!KATSutilities.isEmpty(c.Account.Name))  {this.accountName = c.Account.Name; }
            if(!KATSutilities.isEmpty(c.Contact.Name))  {this.contactName = c.Contact.Name; }
            
            if(!KATSutilities.isEmpty(c.Account.ShippingStreet))    {this.accountShippingStreet = c.Account.ShippingStreet; }
            if(!KATSutilities.isEmpty(c.Account.ShippingPostalCode)){this.accountShippingPostalCode = c.Account.ShippingPostalCode; }           
            if(!KATSutilities.isEmpty(c.Account.ShippingCity))      {this.accountShippingCity = c.Account.ShippingCity; }
            if(!KATSutilities.isEmpty(c.Account.ShippingCountry))   {this.accountShippingCountry = c.Account.ShippingCountry; }
            if(!KATSutilities.isEmpty(c.Account.other_adress__c))   {this.accountOtherAddress = c.Account.other_adress__C; }
            
            if(!KATSutilities.isEmpty(c.Shipment_number__c))        { this.shipmentNumber = c.Shipment_number__c; }
            if(!KATSutilities.isEmpty(c.Shipment_identification__c)){ this.shipmentIdentification = c.Shipment_identification__c; }
            
                        //if(String.isEmpty(c.)){this.}
                        
                        
                        //Added by Tor Håkon 12.06.2012
                        showChangeAddress = false;
                        
                        if(!KATSutilities.isEmpty(c.forwardingAddress__c)
                                && !KATSutilities.isEmpty(changeAddressRefNo)) {
                                
                                showChangeAddress = true;
                                ForwardingAddressChange__c fac = [SELECT id,
                                                                                                                fromStreet__c,
                                                                                                                fromPostalCode__c,
                                                                                                                fromCity__c,
                                                                                                                toStreet__c,
                                                                                                                toPostalCode__c,
                                                                                                                toCity__c
                                                                                                                FROM ForwardingAddressChange__c
                                                                                                                WHERE id = :c.forwardingAddress__c LIMIT 1];
                                
                                this.previousAddress = fac.fromStreet__c+' '+fac.fromPostalCode__c+' '+fac.fromCity__c;
                                this.newAddress = fac.toStreet__c+' '+fac.toPostalCode__c+' '+fac.toCity__c;
                        }
                }
        }
}