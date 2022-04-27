//// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
public class Lightuser_ReportWizardController
{
    public list<Case> caseList {get; set;}
    
    public Case searchParameterHolder {get;set;}
    //public String relUnitId {get; set;}
    //public String creUnitId {get; set;}
    public String fileName {get;set;}
    public string deviation_postal_nmb_range {get; set;}
    public PostalUnit__c pu { get; set; }
    public PostalUnit__c pu1{ get; set; }
    public integer totalCases{ get; set; }
    public String selectValue{ get; set; }
    public Boolean Isactivelightuser {get;set;}

    //Hack to get datepicker
    Case proxy = new Case(); 
    public Case getProxyObject() { return proxy; }
    private Date fromDate { get { return proxy.Booking_date__c; } set; }
    private Date toDate { get { return proxy.Distribution_date__c; } set; }
    
    private string query {get;set;}
    
    public Lightuser_ReportWizardController() 
    {
        Isactivelightuser =true;
        environment_settings__c env = environment_settings__c.getValues('Isactivelightuser');
        if (env != null && env.value__c == 'false')  {
              Isactivelightuser =false;  
        
        }
        
        searchParameterHolder = new Case();
        caseList = new list<Case>();
        pu = new PostalUnit__c();
        pu1 = new PostalUnit__c();
        totalCases = 0;
        selectValue ='createOption';
    }
        
    public pageReference clearSearch()
    {
        searchParameterHolder = new Case();
        proxy.Booking_date__c = null;
        proxy.Distribution_date__c = null;
        pu.name = null;
        pu1.name = null;
        totalCases = 0;
        deviation_postal_nmb_range = null;
        caseList.clear();
        selectValue = 'createOption';
        return null;
    }
    
    public pageReference exportResultToExcel()
    {
        String timestamp = DateTime.now().format('ddMMyyyyhhmm');
        fileName = 'KATS'+timestamp;
        caseList = searchCases(1000);
        return new PageReference('/apex/Lightuser_Report');
    }
        
    public pageReference searchForCases()
    {
        caseList = searchCases(20);
        return null;
    }
        
    public list<Case> searchCases(Integer maxNumberOfRecords)
    {
        totalCases = 0;         //Resetting the value of the totalCases integer
        String countQuery='SELECT count() FROM Case WHERE (recordType.developerName = \'deviation_case\'  OR recordType.developerName = \'Gjenligg\') ';
        String param='';
        query = 'SELECT LastModifiedBy.Name,'
                +'Shipment_identification__c,'
                +'Shipment_number__c,'
                +'Parent.CaseNumber,'
                +'Waiting_for_unit__r.Name,'
                +'PO_Amount__c,'
                +'Division__c,'
                +'Created_by_Name__c,'
                +'Created_by_Unit__r.Name,'
                +'Unit_to_blame__r.Name,'
                +'Case.deviation_time_of_incident__c,'
                +'Subject,'
                +'tolabel(RecordType.Name),'
                +'Owner.Name,'
                +'CaseNumber,'
                +'Status,'
                +'Priority,'
                +'CreatedDate,'
                +'date_to_be_resumed__c,'
                +'Service_Product__r.Name,'
                +'Code_Event__r.Name,'
                +'Code_Reason1__r.name,'
                +'Code_Reason2__r.name,'
                +'measures__c,'
                +'deviation_route__c,'
                +'description,'
                +'Account.Name,'
                +'Account.crm_customer_number__c,'
                +'Account.ShippingStreet,'
                +'Account.ShippingPostalCode,'
                +'Account.ShippingCity,'
                +'Account.ShippingCountry,'
                +'Contact.Name,'
                //Distribusjon
                +'deviation_postal_nmb_from__c,'
                +'deviation_postal_nmb_to__c,'
                +'deviation_nmb_households__c,'
                +'deviation_affected_address__c,'
                +'deviation_affected_postal_nmb__c,'
                //Terminal
                +'Letter_priority__c,'
                +'deviation_depature_spread__c,'
                +'deviation_shipments_nmb__c'
                +' FROM Case WHERE (recordType.developerName = \'deviation_case\' OR recordType.developerName = \'Gjenligg\') ';
                            
                if(searchParameterHolder != null) 
                {
                    /*Postal unit and related unit search*/
                    if(pu.Name != null && pu1.Name != null) { param= addSearchTerm(param, ' (Case.Created_by_Unit__r.Name = \'' + pu.Name + '\' OR Case.unit_to_blame__r.Name = \'' + pu1.Name + '\')');}
                        else {
                            if(String.isNotBlank(pu.name))   { param= addSearchTerm(param, ' Case.Created_by_Unit__r.Name = \'' + pu.Name + '\''); }
                            if(String.isNotBlank(pu1.name))   { param= addSearchTerm(param, ' Case.unit_to_blame__r.name = \'' + pu1.name + '\''); }
                        }
                                
                                /*Postnumber search*/
                                if(String.isNotBlank(deviation_postal_nmb_range))
                                {
                                    if(deviation_postal_nmb_range.contains('-'))
                                    {
                                        /** We have a range (0023-0050) */
                                        String[] numbers=deviation_postal_nmb_range.split('-');
                                        if(numbers.size()==2){
                                                String minNumber=numbers.get(0);
                                                String maxNumber=numbers.get(1);
                                                
                                                // Search in interval and Serach in excact number
                                                param = addSearchTerm(param, '((deviation_postal_nmb_from__c >=\''+minNumber+'\' and deviation_postal_nmb_to__c <= \''+maxNumber+'\' and deviation_postal_nmb_from__c != null and deviation_postal_nmb_to__c != null) OR (deviation_affected_postal_nmb__c>=\''+minNumber+'\' and deviation_affected_postal_nmb__c<=\''+maxNumber+'\'))');
                                        }
                                    }
                                    else if(deviation_postal_nmb_range.contains(','))
                                    {  
                                        /* We have a selection (0023, 0044, 0035) */
                                        List<String> postNumberInterval = deviation_postal_nmb_range.split(',');
                                        String selection='(';
                                        for(string s:postNumberInterval){
                                            // Check for invalid numbers
                                            try{
                                                Integer.valueOf(s);
                                            }
                                            //catch(Exception ex){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Ugyldig input'+ex));}
                                            //CSphase2 Supriya 26122016
                                            catch(Exception ex){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_Invalid_input+ex));}
                                                        
                                            selection+='\''+s.trim()+'\' '; 
                                        }
                                        selection=selection.trim();
                                        selection=selection.replaceAll(' ',',');
                                        selection+=')';
                                        // Exact postalnumber search         
                                        param = addSearchTerm(param, ' deviation_affected_postal_nmb__c in '+selection);
                                    }
                                    else if(deviation_postal_nmb_range.length()==4)
                                    {
                                        // Søker på ett nummer. Skal søke etter saker på dette nummeret og saker hvor nummeret ligger i et interval
                                        param = addSearchTerm(param, '((deviation_postal_nmb_from__c!=\'\' AND deviation_postal_nmb_from__c <=\''+deviation_postal_nmb_range+'\' AND deviation_postal_nmb_to__c!=\'\' AND deviation_postal_nmb_to__c >= \''+deviation_postal_nmb_range+'\' and deviation_postal_nmb_from__c != null and deviation_postal_nmb_to__c != null) OR deviation_affected_postal_nmb__c=\''+deviation_postal_nmb_range+'\')');
                                    }
                                    else { //??
                                    }
                                }

                            }/*End for searchparameterholder if*/
                            //Fix for dates
                             /* C-02507 Changes to lightuser Salesforce
        Search for from and to date. 
        The to and from date is divided in 2 categories eventOption and createOption. This is radio buttons that user need to pick.
        */
        datetime fDate;
        datetime tDate; 
         if(fromDate != null) {
            fDate = Date.newInstance(fromDate.year(),fromDate.month(),fromDate.day());
        }
        if(toDate != null) {
            tDate = Datetime.newInstance(toDate.year(),toDate.month(),toDate.day(),23,59,59);
        }

            if(selectValue== 'eventOption'){
                if(fromDate != null && toDate != null) {
                param= addSearchTerm(param, ' (deviation_time_of_incident__c >= :fDate AND deviation_time_of_incident__c <= :tDate)');
                } else {
                    if(fromDate != null) { param= addSearchTerm(param, ' deviation_time_of_incident__c >= :fDate');}
                    if(toDate != null)   { param= addSearchTerm(param, ' deviation_time_of_incident__c <= :tDate');}
                    } 
                }
            if(selectValue == 'createOption'){
                if(fromDate != null && toDate != null) {
                param= addSearchTerm(param, ' (createddate >= :fDate AND createddate <= :tDate)');
                } else {
                    if(fromDate != null) { param= addSearchTerm(param, ' createddate >= :fDate');}
                    if(toDate != null)   { param= addSearchTerm(param, ' createddate <= :tDate');}
                    }
                }

                            
                    System.debug('Param:'+param);
                    query=query+param;
                    System.debug('Query:'+query); 
                    
                    countQuery=countQuery+ param;    
                    System.debug('Count:'+countQuery);  
                    totalCases =Database.countQuery(countQuery);
                    query += ' LIMIT ' + maxNumberOfRecords;
            
            //Remove single quotes to prevent SOQL injection
            //query = String.escapeSingleQuotes(query);
            try 
            {
                //if(fromDate > toDate){KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Til dato kan ikke være før fra dato.'));}
                //if(totalCases<1) {KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Ingen saker funnet, sjekk søkekriterier'));}
                //Csphase2 supriya 26122016
                  if(fromDate > toDate){KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_to_date_cannot_be_earlier));}
                if(totalCases<1) {KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_no_issue_found));}
                //if(selectValue == null || fromDate != null){KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Husk å velge dato type før søk på dato.'));}
            } 
            catch(QueryException e)
            {
                //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Det oppsto en feil - ' + e.getMessage() ));
                 //Csphase2 supriya 26122016
                 KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_Action_page_line1+' - ' + e.getMessage() ));
                    
            } 
            
            return (list<Case>)Database.query(query);
            
    }
    /*End of searchCases*/
        
    @TestVisible 
    private String addSearchTerm(String q, String term) 
    {
        q += ' AND ' + term;            
        return q;
    }
}