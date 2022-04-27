// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
public with sharing class Lightuser_SearchCaseController { 
    /*Variables*/
    public Case c { get; set; }
    public List<Case> caseSearchResults { get; set; }
    public String fileName {get;set;}
    public PostalUnit__c pu { get; set; }
    public PostalUnit__c pu1{ get; set; }   
    public String caseCaseNumber { get; set;}
    public String actorNumber { get; set; }
    //public String unitId { get; set; }
    //public String unitRelId {get;set; }
    public String produkt { get; set; }
    public String partyNumber { get; set; }
    public String orderNumber { get; set; }
    public String postalCodeRange { get; set; }
    public Integer totalCases{ get; set; }
    public String selectValue{ get; set; }
    
    //Boolean Variable which validates password
    public Boolean isValidPass {get; set;}
    public String pass {get; set;}
    public String error {get; set;}
    public Boolean Isactivelightuser {get;set;}
    
    /*Hack to get datepicker*/
    Case proxy = new Case(); 
    public Case getProxyObject() { return proxy; }
    private Date fromDate { get { return proxy.Booking_date__c; } set; }
    private Date toDate { get { return proxy.Distribution_date__c; } set; }
    
   @TestVisible
    private String addSearchTerm(String q, String term) {
    if(q.contains('=')|| q.contains('LIKE')|| q.contains('OR')) { q += ' AND '; }        
        q += term; 
        system.debug(q);
        return q;
    }/*End of addSearchTerm*/
    
    public Lightuser_SearchCaseController(ApexPages.StandardController stdController) {
        //this.stdController = stdController;
          Isactivelightuser =true;
       environment_settings__c env = environment_settings__c.getValues('Isactivelightuser');
        if (env != null && env.value__c == 'false')  {
              Isactivelightuser =false;  
        
        }
        c = new Case();
        pu = new PostalUnit__c();
        pu1 = new PostalUnit__c();
        caseSearchResults = new List<Case>();
        String  urlId ='';
        urlId = ApexPages.currentPage().getParameters().get('cid');

        if(urlId != null && urlId != '') {
            caseCaseNumber = urlId;
        }
            
        partyNumber = ApexPages.currentPage().getParameters().get('partyId');
        isValidPass = false;
        error = '';  
        selectValue = 'createOption';// default value for radio button
    }/*End of Lightuser_SearchCaseController*/
    
    
    //This function validates the Custom Setting password with the Password updated by the user and loggs the user In
    public void validateUser()
    {
        isValidPass = false;
        error = '';
        
        List<lightuser_Passwords__c> pass_List = new List<lightuser_Passwords__c>();
        pass_List = lightuser_Passwords__c.getAll().values();
        
        for(lightuser_Passwords__c p: pass_List)
        {
            if(p.Password__c.equals(pass))
            {
                isValidPass = true;
            }
        }
        
        if(isValidPass == false)
        {
            error = System.Label.cs_Incorrectpassword;
        }       
    }/*End of ValidateUser*/
    
    //This function opens the casedetailview if the search result is one case
    public PageReference getSingleView(String actorNumber) {
        system.debug('getSingleView()');
        try {
            String id = [SELECT id FROM Case WHERE CaseNumber = :actorNumber LIMIT 1].id;
            
            return new PageReference('/Lightuser_CaseDetailView?id=' + id + '&partyId=' + partynumber);
        } catch(Exception e) {
            
        }
        return null;
    }/*End of getSingleView*/
    
    public class LightuserException extends Exception {}
    
    /* Search case method, list all all list a case*/
    public pageReference searchForCases() {
        caseSearchResults = searchCases(20);
        
        if(!caseSearchResults.isEmpty() && caseSearchResults.size() == 1) {
            String id = caseSearchResults.get(0).Id;
            return new PageReference('/Lightuser_CaseDetailView?id=' + id + '&partyId=' + partynumber);
        }
        return null;
    }/*End of searchForCases*/
   
    public List<Case> searchCases(integer maxNumberOfRecords) {
        caseSearchResults.clear();

        /* From and To Post numbers for post number range searching */
        List<String> postNumberInterval;  
        String fPostNumber;
        String tPostNumber;
        
        /*Help variables for date search and format*/
        datetime fDate;
        datetime tDate;
        if(fromDate != null) {
            fDate = Date.newInstance(fromDate.year(),fromDate.month(),fromDate.day());
        }
        if(toDate != null) {
            tDate = Datetime.newInstance(toDate.year(),toDate.month(),toDate.day(),23,59,59);
        }
                            
        if(!KATSutilities.isEmpty(c.Created_by_Unit__c)) { c.Created_by_Unit__c = null; }
        /*Start of the string query*/
        String countQuery='SELECT COUNT() FROM case WHERE';
        String param='';
        String query = 'SELECT description, id, createddate,deviation_time_of_incident__c, toLabel(recordType.name), subject, status, caseNumber, Created_by_Unit__r.name,unit_to_blame__r.name, Account.name, Account.crm_customer_number__c, Account.ShippingPostalCode, Code_Event__r.name, Created_by_Name__c, forwardingAddress__c,Produkt__c,reason__c, Code_Reason1__r.name, Code_Reason2__r.name,Category__c FROM Case WHERE';
        
        if(!KATSutilities.isEmpty(caseCaseNumber))    { param= addSearchTerm(param, ' caseNumber LIKE \'%' + caseCaseNumber + '%\''); }
        
         /*Search for created by unit and related by unit. Both or just one at time*/
        if(pu.Name != null && pu1.Name != null) 
            { param= addSearchTerm(param, ' (Created_by_Unit__r.Name = \'' + pu.Name + '\' OR unit_to_blame__r.Name = \'' + pu1.Name + '\')');}
            else if(!KATSutilities.isEmpty(pu.Name))   { param= addSearchTerm(param, ' Created_by_Unit__r.Name = \'' + pu.Name + '\''); }
            else if(!KATSutilities.isEmpty(pu1.name))   { param= addSearchTerm(param, ' unit_to_blame__r.name = \'' + pu1.name + '\''); }
        if(!KATSutilities.isEmpty(produkt))     { param= addSearchTerm(param, ' produkt__c LIKE \'%' + produkt + '%\''); }
        if(!KATSutilities.isEmpty(orderNumber)) { param= addSearchTerm(param, ' OEBS_order_number__c LIKE \'%' + orderNumber + '%\''); }
        if(!KATSutilities.isEmpty(actorNumber)) { param= addSearchTerm(param, ' Account.crm_customer_number__c LIKE \'%' + actorNumber + '%\''); }
        
        /* C-02507 Changes to lightuser Salesforce
        * Search for from and to date. 
        * The to and from date is divided in 2 categories eventOption and createOption. This is radio buttons that user need to pick one value.
        */  if(selectValue== 'eventOption'){
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

        /*
         * artf1963596 : POB 4728 Lightuser: punkt 5
         * 06.06.2012 James McLaughlin
         *
         * Need to check the contents of the postNumberRange field and determine if we have a range,
         * and if so, what that range is.  Additionally, gracefully fail on invalid input.
         *
         * This change requires us to join Account in the query, and check on SHIPPING ADDRESS.
         *
         */
        try {
            if(!KATSutilities.isEmpty(postalCodeRange))
            {               
                /* Check for a range */
                if (postalCodeRange.contains('-'))
                {
                    
                    /* We have a range, now parse */
                    postNumberInterval = postalCodeRange.split('-', 2);
                    fPostNumber = postNumberInterval.get(0);
                    tPostNumber = postNumberInterval.get(1);
                    
                    /* Check the post numbers to make sure they are not empty. */               
                    //
                    //csphase2 supriya 26122016
                    //if(KATSutilities.isEmpty(fPostNumber) || KATSutilities.isEmpty(tPostNumber)) { throw new LightuserException('Ugyldig Postnummer Intervall.  Gyldig format er xxxx-xxxx eller xxxx'); }
                    if(KATSutilities.isEmpty(fPostNumber) || KATSutilities.isEmpty(tPostNumber)) { throw new LightuserException(System.label.cs_invalid_zipcode+'er xxxx-xxxx eller xxxx'); }
                    
                   
                            
                    param= addSearchTerm(param, ' (Account.ShippingPostalCode >= \'' + fPostNumber + '\' AND Account.ShippingPostalCode <= \'' + tPostNumber + '\')');                         
                }
                else if (postalCodeRange.contains(','))
                { 
                    /* We have a selection (0023, 0044, 0035) */
                    postNumberInterval = postalCodeRange.split(',');
                    String selection='(';
                    for(string s:postNumberInterval){
                        selection+='\''+s.trim()+'\' ';
                    }
                    selection=selection.trim();
                    selection=selection.replaceAll(' ',',');
                    selection+=')';
                    
                    param= addSearchTerm(param, ' Account.ShippingPostalCode in '+selection);                          
                }
                else
                {
                    param= addSearchTerm(param, ' Account.ShippingPostalCode = \'' + PostalCodeRange + '\''); 
                }                   
            }
        } catch (LightuserException e){
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage() ));
        }
        system.debug(param);

        if(fromDate > toDate)
        {  
           // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Til dato kan ikke være før fra dato.'));
            //cs_to_date_cannot_be_earlier
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.label.cs_to_date_cannot_be_earlier));
            return caseSearchResults;
        }
        
        if(param != null && param != '')
        {
            countQuery = countQuery + param;

            system.debug(countQuery);
            totalCases = Database.countQuery(countQuery);
        }
        else
        {
            //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Du har ikke valgt noen kriterier'));
            //Csphase2 Supriya 27122016
             KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_not_selected_criteria));
            return caseSearchResults;
        }      
        

        try
        {
            /*Search string and param string is build to an query*/
            query=query+param;
            System.debug('Query w/o parameter: ' + query);       
            
            query += ' ORDER BY createddate DESC, Account.ShippingPostalCode LIMIT 200';
            System.debug('Query with parameter: ' + query);

            /*List the query result*/
            system.debug('SelectValue is: ' + selectValue);

            // Here we fire the Query
            caseSearchResults=Database.query(query);

            // Checking if Query returned results
            if(caseSearchResults != null && caseSearchResults.isEmpty()) 
            {
               // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Ingen saker funnet, sjekk søkekriterier'));
               //Csphase2 Supriya 27122016
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.label.cs_no_issue_found));
                              
            }

        }
        catch (QueryException e)
        {
           // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Det oppsto en feil - ' + e.getMessage() ));
            //Csphase2 Supriya 27122016
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_Action_page_line1+'- ' + e.getMessage() ));
                
        } 
        return caseSearchResults;
    }/*End of searchCases*/
    
    public boolean getNumOfResults(){
    return (caseSearchResults.size()>1);
        }

    public boolean getHasCaseSearchResults() {
    system.debug(caseSearchResults.size());
    system.debug(getIsSingleView());
       return (caseSearchResults != null && !getIsSingleView());
    }/*End of getHasCaseSearchResults*/
    
    public boolean getIsSingleView() {
        String parameter = ApexPages.currentPage().getParameters().get('id');
        if(parameter != null) {
            return true;
        }
        return false;
    }/*End of getIsSingleView*/
    
    void resetCaseSearch() {
        caseCaseNumber = '';
        actorNumber = '';
        totalCases=null;
        selectValue ='';
    }/*End of resetCaseSearch*/
    
    public PageReference clearSearch() {
        resetCaseSearch();
        return new PageReference('/Lightuser_searchCase');
    }/*End of clearSearch*/

      
    public pageReference exportResultToExcel() {
        String timestamp = DateTime.now().format('ddMMyyyyhhmm');
        fileName = 'KATS'+timestamp;
        caseSearchResults = searchCases(1000);
        return new PageReference('/apex/Lightuser_CaseResults');
    }/*End of exportResultToExcel*/
   
}