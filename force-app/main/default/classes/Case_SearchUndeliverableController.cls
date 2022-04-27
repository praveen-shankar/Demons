/*
*       This class is a controller for Case_SearchUndeliverable.page
*
*/

public class Case_SearchUndeliverableController {


    public Case c{ get; set; }
    private Case exsistingCase;

    public String undeliverableId{ get; set; }
    public boolean HasUndeliverable { get { return getHasUndeliverable(); } set; }


    //Hack to get datepicker
    Case proxy = new Case();
    public Case getProxyObject() { return proxy; }
    private Date fromDate { get { return proxy.Booking_date__c; } set; }
    private Date toDate { get { return proxy.Distribution_date__c; } set; }

    public String outerDescription { get; set; }
    public String innerDescription { get; set; }
    public String record { get; set; }
    public String undeliverableNumber { get; set; }
    public List<SelectOption> records { get; set; }
    //
    public String status { get; set; }
    public List<SelectOption> statuses { get; set; }
    //
    public List<UndeliverableResults> results { get; set; }

    public List<List<SObject>> result{ get; set; }
    public List<UndeliverableShipment__c> undeliverable{ get; set; }

    public String shipTo { get; set; }
    public String comment { get; set; }
    public Integer maxCommentLength { get { return 250; } set; }


    /*
    *   CONSTRUCTOR
    *
    *   Construct the parameters for the visualforce page and the search
    *   If a case id is supplied in the url this case is loaded and it populates some of the fields in the visualforce page.
    */
    public Case_SearchUndeliverableController(){
                c = new Case();
        c.RecordTypeId = KATSUtilities.getRecordType('complaint');

        //Look for existing case
        String id = ApexPages.currentPage().getParameters().get('id');
        if(id != null && id != '') {
                try{
                                                exsistingCase = [SELECT id, Shipment_identification__c, Shipment_number__c, Vekt_Min__c, Vekt_Maks__c, shipper_name__c, shipper_address__c, shipper_postal_address__c, shipper_zip_code__c, shipper_country__c, reciever_Name__c, reciever_Address__c, reciever_Postal_Address__c, reciever_Zip_Code__c, reciever_Country__c, external_description__c, content_description__c FROM Case WHERE id = :id LIMIT 1];
                        c.Shipment_identification__c = exsistingCase.Shipment_identification__c;
                        c.Shipment_number__c = exsistingCase.Shipment_number__c;
                        c.Vekt_Min__c = exsistingCase.Vekt_Min__c;
                        c.Vekt_Maks__c = exsistingCase.Vekt_Maks__c;
                        //c.external_description__c = exsistingCase.external_description__c;
                        //c.content_description__c = exsistingCase.content_description__c;
                } catch(QueryException qe) {
                        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Kunne ikke laste den opprinnelige saken'));
                }
        }

        results = new List<UndeliverableResults>();

        this.result = new  List<List<SObject>>();
        this.undeliverable = new List<UndeliverableShipment__c>();

                //SelectOption entry: value is the String that is returned to the controller if the option is selected by a user, label is the String that is displayed to the user as the option choice
        this.statuses = new List<SelectOption>();
        //Need To Change
        Schema.DescribeFieldResult F = UndeliverableShipment__c.status__c.getDescribe();
        List <Schema.PicklistEntry> opts = F.getPicklistValues();
        for(Schema.PicklistEntry opt : opts){
                statuses.add(new SelectOption(opt.getValue(),opt.getLabel()));
        }
       // statuses.add(new SelectOption('Alle','Alle statuser'));
        //CSPhase2, 16122016, Supriya ->Added the labels 
       statuses.add(new SelectOption('Alle',System.label.cs_All_states));

        this.records = new List<SelectOption>();
        //records.add(new SelectOption('','--Alle--'));
        //CSPhase2, 16122016, Supriya ->Added the labels 
        
        records.add(new SelectOption('','--'+ System.label.cs_All+'--'));
        
       // records.add(new SelectOption('Registrert','Registrert'));
      //  records.add(new SelectOption('Uregistrert','Uregistrert'));
       // records.add(new SelectOption('Los_gjenstand','Løs gjenstand'));
       //CSPhase2, 16122016, Supriya ->Used standard functionality to display picklist 
       records.add(new SelectOption('Registrert',System.Label.cs_Registered));
      records.add(new SelectOption('Uregistrert',System.Label.cs_Unregistered));
       records.add(new SelectOption('Los_gjenstand',System.Label.cs_LooseItem));
        /*Schema.DescribeFieldResult F1 = UndeliverableShipment__c.undeliverable_type__c.getDescribe();
        List <Schema.PicklistEntry> opts1 = F1.getPicklistValues();
        for(Schema.PicklistEntry opt : opts1){
                records.add(new SelectOption(opt.getValue(),opt.getLabel()));
        }*/
    }

    private UndeliverableShipment__c getUndeliverableObject(String undeliverableId) {
        try {
                return [SELECT id, Case__c, Kommentar__c, Levert_til__c FROM UndeliverableShipment__c WHERE id =: undeliverableId LIMIT 1];
        } catch (system.Queryexception e) {
            //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Noe gikk galt under lagring av sak - Kunne ikke finne den ubesørgelige gjenstanden'));
             //CSPhase2, 16122016, Supriya ->Added label
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.label.cs_Something_went_wrong));
            
        }
        return null;
    }

    //Return a PageReference object for the undeliverable shipment page.
    public PageReference viewUndeliverable() {
        try{
            PageReference undeliverablePage = new ApexPages.StandardController(getUndeliverableObject(undeliverableId)).view();
            undeliverablePage.setRedirect(true);
            return undeliverablePage;
            }
        catch(System.NullPointerException e){
            //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Noe gikk galt under lagring av sak - Kunne ikke finne den ubesørgelige gjenstanden'));
             //CSPhase2, 16122016, Supriya ->Added label
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.label.cs_Something_went_wrong));
        } return null;
    }

    //Upsert case and return a PageReference object to the edit view of the case
    public PageReference storeAndGoToCase() {
        Case caseToStore = storeCase();
        if(caseToStore != null) {
                PageReference casePage = new PageReference('/' + caseToStore.id + '/e?retURL=' + caseToStore.id);
                return casePage;
        }
        //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Kunne ikke gå til saken'));
        //CSPhase2, 16122016, Supriya ->Added label
        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.label.cs_Error_Message_could_not_go));
        return null;
    }

    // Store and return Case c
    public Case storeCase() {
        try {
                if(exsistingCase != null) {

                        if(c.Shipment_identification__c != null && c.Shipment_identification__c != '' && (exsistingCase.Shipment_identification__c == null || exsistingCase.Shipment_identification__c == ''))  { exsistingCase.Shipment_identification__c = c.Shipment_identification__c; }
                    if(c.Shipment_number__c != null && c.Shipment_number__c != '' && (exsistingCase.Shipment_number__c == null || exsistingCase.Shipment_number__c == ''))                                                                      { exsistingCase.Shipment_number__c = c.Shipment_number__c; }
                    if(c.Vekt_Min__c != null && exsistingCase.Vekt_Min__c == null)                                                                                                                                                                                                                                                      { exsistingCase.Vekt_Min__c = c.Vekt_Min__c; }
                                if(c.Vekt_Maks__c != null && exsistingCase.Vekt_Maks__c == null)                                                                                                                                                                                                                                                { exsistingCase.Vekt_Maks__c = c.Vekt_Maks__c; }
                                if(c.shipper_name__c != null && c.shipper_name__c != '' && (exsistingCase.shipper_name__c == null || exsistingCase.shipper_name__c == ''))                                                                                              { exsistingCase.shipper_name__c = c.shipper_name__c; }
                                if(c.shipper_address__c != null && c.shipper_address__c != '' && (exsistingCase.shipper_address__c == null || exsistingCase.shipper_address__c == '') )                                                                 { exsistingCase.shipper_address__c = c.shipper_address__c; }
                                if(c.shipper_postal_address__c != null && c.shipper_postal_address__c != '' && (exsistingCase.shipper_postal_address__c == null || exsistingCase.shipper_postal_address__c == '') )             { exsistingCase.shipper_postal_address__c = c.shipper_postal_address__c; }
                                if(c.shipper_zip_code__c != null && c.shipper_zip_code__c != '' && (exsistingCase.shipper_zip_code__c == null || exsistingCase.shipper_zip_code__c == '') )                                                             { exsistingCase.shipper_zip_code__c = c.shipper_zip_code__c; }
                                if(c.shipper_country__c != null && c.shipper_country__c != '' && (exsistingCase.shipper_country__c == null || exsistingCase.shipper_country__c == ''))                                                                  { exsistingCase.shipper_country__c = c.shipper_country__c; }
                                if(c.reciever_Name__c != null && c.reciever_Name__c != '' && (exsistingCase.reciever_Name__c == null || exsistingCase.reciever_Name__c == ''))                                                                                  { exsistingCase.reciever_Name__c = c.reciever_Name__c; }
                                if(c.reciever_Address__c != null && c.reciever_Address__c != '' && (exsistingCase.reciever_Address__c == null || exsistingCase.reciever_Address__c == '') )                                                             { exsistingCase.reciever_Address__c = c.reciever_Address__c; }
                                if(c.reciever_Postal_Address__c != null && c.reciever_Postal_Address__c != '' && (exsistingCase.reciever_Postal_Address__c == null || exsistingCase.reciever_Postal_Address__c == ''))  { exsistingCase.reciever_Postal_Address__c = c.reciever_Postal_Address__c; }
                                if(c.reciever_Zip_Code__c != null && c.reciever_Zip_Code__c != '' && (exsistingCase.reciever_Zip_Code__c == null || exsistingCase.reciever_Zip_Code__c == ''))                                                  { exsistingCase.reciever_Zip_Code__c = c.reciever_Zip_Code__c; }
                                if(c.reciever_Country__c != null && c.reciever_Country__c != '' && (exsistingCase.reciever_Country__c == null || exsistingCase.reciever_Country__c == ''))                                                              { exsistingCase.reciever_Country__c = c.reciever_Country__c; }
                        if(c.external_description__c != null && c.external_description__c != '' && (exsistingCase.external_description__c == null || exsistingCase.external_description__c == ''))                              { exsistingCase.external_description__c = c.external_description__c; }
                        if(c.content_description__c != null && c.content_description__c != '' && (exsistingCase.content_description__c == null || exsistingCase.content_description__c == ''))                                  { exsistingCase.content_description__c = c.content_description__c; }

                        upsert exsistingCase;
                        return exsistingCase;
                } else {
                        c.status = 'Under behandling';
                        if(c.Subject == null || c.Subject == '') { c.subject = 'Søk etter ubesørgelig'; }

                        if(record == 'Registrert') {
                                c.Type__c = 'Registered';
                                if(c.Shipment_identification__c == null || c.Shipment_identification__c == '') { c.Shipment_identification__c = '0'; }
                        } else {
                                c.Type__c = 'Unregistered';
                        }
                        upsert c;
                        return c;
                }
        } catch(Queryexception e) {
                //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Noe gikk galt under lagring av sak'));
                //CSPhase2, 16122016, Supriya ->Added label
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,  System.label.cs_error_in_saving_cases));
                
               
        }
        return null;
    }

    //Close the undeliverable shipment.
    //Set the status, undeliverable comment and delivered to address
    //Status and PageReference depends on wether the undeliverable shipment is connectet to case or not
    //
    // artf1821080: Need to check the comment length before setting it - otherwise we get an error in the database. 
    //              Also - Hardcoded the limit.  Is there a way to get this from DB?
    //
    public PageReference closeUndeliverable() {
        UndeliverableShipment__c u = getUndeliverableObject(undeliverableId);
        try {

                PageReference page;
                String id = ApexPages.currentPage().getParameters().get('id');

                u.Levert_til__c = shipTo;
                //if(u.Kommentar__c != null) { u.Kommentar__c = u.Kommentar__c + '\n' + comment; } else { u.Kommentar__c = comment; }
                                if(u.Kommentar__c != null) {
                        String newComment = u.Kommentar__c + '\n' + comment;
                        Integer result = newComment.length();
                        if(result > 250) {
                                // ERROR!  Comment is too long.
                                                // Should NEVER get here!                                               
                        } 
                        u.Kommentar__c = newComment;
                } 
                else { 
                        u.Kommentar__c = comment; 
                }
                
                if(id != null && id != '') {
                        Case caseToAttach = storeCase();
                        u.status__c = 'Tilknyttet sak'; //api name
                        u.Case__c = caseToAttach.id;
                page = new PageReference('/' + caseToAttach.id);
                } else {
                        u.status__c = 'Identifisert';//api name
                        page = new PageReference('/' + u.id);
                }
                upsert u;

            page.setRedirect(true);
            return page;
        } catch (system.Queryexception e) {
            //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Noe gikk galt når ubesørgelig ble knyttet til sak\n' + e.getMessage()));
            //CSPhase2, 16122016, Supriya ->Added label
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_Something_went_wrong_in_saving_undeliverable+'\n' + e.getMessage()));
        }
        return null;
    }

    //Test to see if the search contains any undeliverable shipments
    public boolean getHasUndeliverable() {
        if(undeliverable != null && undeliverable.size() > 0) {
            return true;
        }
        return false;
    }

    //Shecks the users profile. Only certain profiles should be able to se internal description on undeliverable objects
    public boolean hasCorrectProfile() {
        for(Profile p : [SELECT id FROM Profile WHERE name = 'System Administrator' OR name = 'KATS Kundekonsulent m ubesorgelig' OR name = 'KATS Ledelsesbruker med ubesørgelig']) {
                if(userinfo.getProfileId() == p.id) {
                        return true;
                }
        }
        return false;
    }

    /*  SEARCH FOR SHIPMENTS
    *   Step 1: Build the Search Query based on the parameters
    *   Step 2: Perform SOQL query based on the search parameters
    *   Step 3: Builds up the search results (list)
    *   Step 4: Sort the results
    */
    public PageReference searchUndeliverableShipment() 
    {
        try 
        {
            //Reset the results before searchin again
            if(results != null)
            { 
                results.clear(); 
            }

            /*
            *  Step 1
            */
            // All fields needed from the Undeliverable shipment objects
            String querySelect = 'id, name, status__c, submitted__c, Produkt__c, Shipment_identification__c, shipment_number__c, interiorDescription__c, outerDescription__c, CreatedDate, senderZipCode__c, senderPostalAddress__c, senderName__c, senderCountry__c, senderAddress__c, recieverZipCode__c, recieverPostalAddress__c, recieverName__c, recieverCountry__c, recieverAddress__c, weight__c, funnet__c, RecordType.Name';
            String queryWhere = ' WHERE';

            // 1. Status
            if(status != '' && status != null){
                if(status != 'Alle'){
                    queryWhere += ' status__c = \'' + status + '\'';
                }
            }

            // 2. Record Type
            if(record != null && record != '') 
            { 
                if(!(queryWhere.endsWith(' WHERE')))
                { 
                    queryWhere += ' AND '; 
                }
                queryWhere += ' recordTypeId = \'' +  KATSUtilities.getRecordType(record) + '\''; 
            }


            /*
            *   3. Ubesørgelignummer - Step 1.1
            *   If the field 'Ubesørgelignummer' is filled in, the search will only use this as a criteria,
            *   in addition to status and Undeliverable Record Type.
            */
            if(undeliverableNumber != null && undeliverableNumber != '')
            {
                if(!(queryWhere.endsWith('WHERE')))
                {
                    queryWhere += ' AND';
                }

                String numberQuery = 'SELECT ' 
                                        + querySelect 
                                        + ' FROM UndeliverableShipment__c '
                                        + queryWhere 
                                        + ' name LIKE \'%' 
                                        + undeliverableNumber 
                                        + '%\' LIMIT 200';
                
                List<UndeliverableShipment__c> numberResults;
                numberResults = Database.query(numberQuery);
                
                if(numberResults.size() == 0)
                {
                    KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'c' ));
                } 
                else 
                {
                    for(UndeliverableShipment__c un : numberResults)
                    {
                        results.add(new UndeliverableResults(un));
                    }
                }
                if(numberResults.size() == 200)
                {
                   // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Ditt søk på ubesørgelignummer returnerte mer enn 200 treff. Vennligst spesifiser ubesørgelignummer bedre dersom du ikke finner sendingen' ));
                     //CSPhase2, 19122016, Supriya ->Added label
                    
                    KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.cs_more_than_200_hits ));
                }
                return null;
            }
            
            // 4. Kollinummer
            if(c.Shipment_identification__c != null && c.Shipment_identification__c != '' && c.Shipment_identification__c != '0')       
            { 
                if(!(queryWhere.endsWith(' WHERE')))
                { 
                    queryWhere += ' AND '; 
                } 
                queryWhere += ' Shipment_identification__c LIKE \'%' + c.Shipment_identification__c + '%\''; 
            }

            // 5. Sendingsnummer
            if(c.Shipment_number__c != null && c.Shipment_number__c != '')    
            {
                if(!(queryWhere.endsWith(' WHERE')))
                { 
                    queryWhere += ' AND '; 
                } 
                queryWhere += ' Shipment_number__c LIKE \'%' + c.Shipment_number__c + '%\''; 
            }

            // 6. Clause for Minimum Weight (Vekt)
            if(c.Vekt_Min__c != null)                                         
            { 
                if(!(queryWhere.endsWith(' WHERE')))
                { 
                    queryWhere += ' AND '; 
                } 
                queryWhere += ' weight__c >= ' + c.Vekt_Min__c; 
            }

            // 6. Clause for Maximum Weight (Vekt)
            if(c.Vekt_Maks__c != null)
            {
                if(!(queryWhere.endsWith(' WHERE')))
                {
                    queryWhere += ' AND ';
                }
                queryWhere += ' weight__c <= ' + c.Vekt_Maks__c; 
            }

            // 7. From Date for Registrert field
            if(fromDate != null)
            {
                if(!(queryWhere.endsWith(' WHERE')))
                {
                    queryWhere += ' AND ';
                }
                queryWhere += ' submitted__c >= :fromDate';
            }
            
            // 8. To Date for Registrert field
            if(toDate != null)
            {
                if(!(queryWhere.endsWith(' WHERE')))
                {
                    queryWhere += ' AND ';
                }
                queryWhere += ' submitted__c <= :toDate';
            }

            // 9. Avsender Name
            if(c.shipper_name__c != null && c.shipper_name__c != '')
            { 
                if(!(queryWhere.endsWith(' WHERE')))
                { 
                    queryWhere += ' AND '; 
                }
                queryWhere += ' senderName__c LIKE \'%' + c.shipper_name__c + '%\'' ; 
            }

            // 10. Avsender Address
            if(c.shipper_address__c != null && c.shipper_address__c != '')
            { 
                if(!(queryWhere.endsWith(' WHERE')))
                { 
                    queryWhere += ' AND '; 
                }
                queryWhere += ' senderAddress__c LIKE \'%' + c.shipper_address__c + '%\'' ; 
            }

            // 11. Avsender poststed
            if(c.shipper_postal_address__c != null && c.shipper_postal_address__c != '')
            { 
                if(!(queryWhere.endsWith(' WHERE')))
                { 
                    queryWhere += ' AND '; 
                }
                queryWhere += ' senderPostalAddress__c LIKE \'%' + c.shipper_postal_address__c + '%\'' ; 
            }


            // 12. Avsender postnummer
            if(c.shipper_zip_code__c != null && c.shipper_zip_code__c != '')
            { 
                if(!(queryWhere.endsWith(' WHERE')))
                { 
                    queryWhere += ' AND '; 
                }
                queryWhere += ' senderZipCode__c LIKE \'%' + c.shipper_zip_code__c + '%\'' ; 
            }

            // 13. Avsender land (Country)
            if(c.shipper_country__c != null && c.shipper_country__c != '')
            { 
                if(!(queryWhere.endsWith(' WHERE')))
                { 
                    queryWhere += ' AND '; 
                }
                queryWhere += ' senderCountry__c LIKE \'%' + c.shipper_country__c + '%\'' ; 
            }

            // 14. Mottaker (Name)
            if(c.reciever_Name__c != null && c.reciever_Name__c != '')
            { 
                if(!(queryWhere.endsWith(' WHERE')))
                { 
                    queryWhere += ' AND '; 
                }
                queryWhere += ' recieverName__c LIKE \'%' + c.reciever_Name__c + '%\'' ; 
            }
              
            // 14. Mottaker adresse
            if(c.reciever_Address__c != null && c.reciever_Address__c != '')
            { 
                if(!(queryWhere.endsWith(' WHERE')))
                { 
                    queryWhere += ' AND '; 
                }
                queryWhere += ' recieverAddress__c LIKE \'%' + c.reciever_Address__c + '%\'' ; 
            }          
                        
            // 15. Mottaker poststed (Postal Address)
            if(c.reciever_Postal_Address__c != null && c.reciever_Postal_Address__c != '')
            { 
                if(!(queryWhere.endsWith(' WHERE')))
                { 
                    queryWhere += ' AND '; 
                }
                queryWhere += ' recieverPostalAddress__c LIKE \'%' + c.reciever_Postal_Address__c + '%\'' ; 
            }            
            
            // 16. Mottaker postnummer
            if(c.reciever_Zip_Code__c != null && c.reciever_Zip_Code__c != '')
            { 
                if(!(queryWhere.endsWith(' WHERE')))
                { 
                    queryWhere += ' AND '; 
                }
                queryWhere += ' recieverZipCode__c LIKE \'%' + c.reciever_Zip_Code__c + '%\'' ; 
            }  

            // 17. Mottaker land (Country)
            if(c.reciever_Country__c != null && c.reciever_Country__c != '')
            { 
                if(!(queryWhere.endsWith(' WHERE')))
                { 
                    queryWhere += ' AND '; 
                }
                queryWhere += ' recieverCountry__c LIKE \'%' + c.reciever_Country__c + '%\'' ; 
            }  


            List<UndeliverableShipment__c> searchResults;  

            // Building the Query statement
            String SoqlQuery = 'SELECT ' 
                                + querySelect 
                                + ' FROM UndeliverableShipment__c ';

            if(!queryWhere.endsWith('WHERE'))
            { 
                SoqlQuery += queryWhere; 
            }
            
            SoqlQuery += ' ORDER BY submitted__c DESC LIMIT 9998';
            system.debug('SOQL query ' + SoqlQuery);
            system.debug(status);

            searchResults = Database.query(SoqlQuery);

            if(searchResults.size() == 9998)
            {
                //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Søkeresultat returnert store datasett. Vennligst spesifisere søket bedre' ));
                 //CSPhase2, 19122016, Supriya ->Added label
                 
                 KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.cs_Large_data_set));
            }

            if(searchResults.size() == 0)
            {
                //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Ingen treff, forsøk å spesifisere søket bedre' ));
                 //CSPhase2, 19122016, Supriya ->Added label
                 KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.cs_No_results ));
            }
            
            /*
            *   STEP 3
            *   This step will check if we have any search terms entered in the fields: 'Ytre/gjenstand Beskrivelse' AND/OR 'Innholds Beskrivelse'
            *   If no search parameter is entered we pick up the Latest 200
            *   If Search parameters exist, we pick it up and add the one's in the list
            *   
            */

            if(c.external_description__c == null && c.content_description__c == null)
            {
                for(UndeliverableShipment__c un : searchResults)
                {
                    UndeliverableResults result = new UndeliverableResults(un);

                    // Checks if we have reached 200 options
                    if(results.size() == 200)
                    {
                        //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Søkeresultatene oversteg 200 treff, hvis du ikke finner den aktuelle sendingen forsøk å spesifisere søket bedre' ));
                        //CSPhase2, 19122016, Supriya ->Added label
                         KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.cs_more_than_200_hits ));
                        break;
                    }

                    results.add(result);
                }

            }
            else
            {
                for(UndeliverableShipment__c un : searchResults)
                {
                    UndeliverableResults result = new UndeliverableResults(un);

                    // This variable will be set True if we find a match
                    Boolean foundMatch = false;

                    if(result.innerDescription != null && c.content_description__c != null) 
                    {
                        String interiorDescription = result.innerDescription.toUpperCase();
                        String splitString = c.content_description__c.toUpperCase();
                        String[] caseContent = splitString.split(' ');
                        for(String str : caseContent) 
                        {
                            if(interiorDescription.contains(str))
                            { 
                                result.hitsInnerDescription--; 
                                foundMatch = true;
                            }
                        }
                    }

                    if(result.outerDescription != null && c.external_description__c != null) 
                    {
                        String outerDecriptionresult = result.outerDescription.toUpperCase();
                        String splitString = c.external_description__c.toUpperCase();
                        String[] caseExterior = splitString.split(' ');
                        for(String str : caseExterior) 
                        {
                            if(outerDecriptionresult.contains(str)) 
                            { 
                                result.hitsOuterDescription--; 
                                foundMatch = true;
                            }
                        }
                    }

                    // Checks if we have reached 200 options
                    if(results.size() == 200)
                    {
                         //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Søkeresultatene oversteg 200 treff, hvis du ikke finner den aktuelle sendingen forsøk å spesifisere søket bedre' ));
                        //CSPhase2, 19122016, Supriya ->Added label
                         KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.cs_more_than_200_hits ));
                       
                        break;
                    }

                    // We will add the record to the list only if we find a matching term
                    if(foundMatch)
                    {
                        results.add(result);
                    }
                }
            }
            

            /*
            *       STEP 4
            */
            // Checks if we found a matching record after the above process.
            // If not, return a comment suggesting to refine the search with more terms
            if(results.size() <= 0)
            {
               // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Ingen treff, forsøk å spesifisere søket bedre' ));
                 //CSPhase2, 19122016, Supriya ->Added label
                   KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.cs_No_Results));
            }
            else
            {
                QuickSort qs = new QuickSort();
                qs.sort(results);    
            }
        } 
        catch (system.SearchException e) 
        {
            system.debug('Something went wrong during the query for undeliverable shipments -' + e.getMessage());
           // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Noe gikk galt under søk etter ubesørgelig - ' + e.getMessage() ));
            
            //CSPhase2, 19122016, Supriya ->Added label
              KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.label.cs_Something_went_wrong+' - ' + e.getMessage() ));
            
        } 
        catch (system.QueryException qe) 
        {
            system.debug('Something went wrong during the query for undeliverable shipments -' + qe.getMessage());
           // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Noe gikk galt under søk etter ubesørgelig - ' + qe.getMessage() ));
             //CSPhase2, 19122016, Supriya ->Added label
             KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.label.cs_Something_went_wrong+' - ' + qe.getMessage() ));
        }
        return null;
    }

    /*
    *   Quicksort class for sorting search results based on hits in inner and outer description
    */
    public class QuickSort {
        List<UndeliverableResults> helper;
        integer x;

        public void sort(List<UndeliverableResults> results) {
                // Check for empty or null array
                if(results == null || results.size() == 0) {
                        return;
                }
                this.helper = results;
                x = results.size();
                quicksort(0, x - 1);
        }

        private void quicksort(integer low, integer high) {
                system.debug('QuickSort');
                integer i = low;
                integer j = high;

                // Get the pivot element from the middle of the list
                integer pivot = helper[low + (high-low)/2].hitsTotal;

                // Divide into two lists
                while(i <= j) {

                        // If the current value from the left list is smaller then the pivot
                                // element then get the next element from the left list
                        while(helper[i].hitsTotal < pivot) {
                                i++;
                        }

                        // If the current value from the right list is larger then the pivot
                                // element then get the next element from the right list
                        while(helper[j].hitsTotal > pivot) {
                                j--;
                        }

                        // If we have found a values in the left list which is larger then
                                // the pivot element and if we have found a value in the right list
                                // which is smaller then the pivot element then we exchange the
                                // values.
                                // As we are done we can increase i and j
                        if (i <= j) {
                                        exchange(i, j);
                                        i++;
                                        j--;
                                }
                }

                // Recursion
                        if (low < j)
                                quicksort(low, j);
                        if (i < high)
                                quicksort(i, high);
        }

        private void exchange(integer i, integer j) {
                        UndeliverableResults temp = helper[i];
                        helper[i] = helper[j];
                        helper[j] = temp;
                }
    }
    
    public Boolean getCurrentSearchStatus(){
        return (this.status == 'Alle');
    }

    /*
    *   Class holding the variables used for the undeliverable search result
    */
    public class UndeliverableResults {
        public UndeliverableShipment__c undeliverable;

        /*
        *       Integers used for sorting the results
        */
        public integer hitsRecipient { set; get{if(hitsRecipient != null){return hitsRecipient; } return 0;} }
        public integer hitsSender { set; get{if(hitsSender != null){return hitsSender; } return 0;} }
        public integer hitsInnerDescription { set; get{if(hitsInnerDescription != null){return hitsInnerDescription; } return 0;} }
        public integer hitsOuterDescription { set; get{if(hitsOuterDescription != null){return hitsOuterDescription; } return 0;} }
        public integer hitsTotal { get{ return hitsInnerDescription + hitsOuterDescription + hitsRecipient + hitsSender; } set; }

        public String name { get; set; }
        public String id { get; set; }
        public Date submitted { get; set; }
        public String ShipmentNumber { get; set; }
        public String ShipmentIdentification { get; set; }
        public String recieverName { get; set; }
                public String recieverAddress { get; set; }
                public String recieverPostalAddress { get; set; }
                public String recieverZipCode { get; set; }
                public String recieverCountry { get; set; }
        public String shipperName { get; set; }
        public String shipperAddress { get; set; }
                public String shipperPostalAddress { get; set; }
                public String shipperZipCode { get; set; }
                public String shipperCountry { get; set; }
        public String outerDescription { get; set; }
        public String innerDescription { get; set; }
        public String funnet { get; set; }
        public String status { get; set; }


        public UndeliverableResults(UndeliverableShipment__c undeliverable) {
            this.undeliverable = undeliverable;
            this.name = undeliverable.name;
            this.id = undeliverable.id;
            this.submitted = undeliverable.submitted__c;
            this.outerDescription = undeliverable.outerDescription__c;
            this.innerDescription = undeliverable.interiorDescription__c;
            this.funnet = undeliverable.Funnet__c;
            this.status = undeliverable.status__c;
                        this.ShipmentNumber = undeliverable.Shipment_number__c;
                this.ShipmentIdentification = undeliverable.Shipment_identification__c;
            this.recieverName = undeliverable.recieverName__c;
                        this.recieverAddress = undeliverable.recieverAddress__c;
                        this.recieverPostalAddress = undeliverable.recieverPostalAddress__c;
                        this.recieverZipCode = undeliverable.recieverZipCode__c;
                        this.recieverCountry = undeliverable.recieverCountry__c;
            this.shipperName = undeliverable.senderName__c;
                        this.shipperAddress = undeliverable.senderAddress__c;
                        this.shipperPostalAddress = undeliverable.senderPostalAddress__c;
                        this.shipperZipCode = undeliverable.senderZipCode__c;
                        this.shipperCountry = undeliverable.senderCountry__c;
        }
    }
}