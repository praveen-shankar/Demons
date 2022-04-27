public with sharing class MultilevelDependentPicklist {
    //Private variables to store data for dependancy calculations
    private Case c;
    private ApexPages.StandardController stdController;
    private String recordTypeName;
    public String recordTypeNameD;
    public String recordTypeName2;
    public Map < String, String > mapPicklist;
    public Boolean Notlightuser {
        get;
        set;
    }
    public Boolean FlaglightuserOnload {
        get;
        set;
    }

    //This boolean variable is to control the visibility of Detail section and Edit Section
    //And for checking if the last change was a record type change
    public Boolean viewCatSec {
        get;
        set;
    }
    public Boolean recTypeChanged {
        get;
        set;
    }
    public Boolean viewButton {
        get;
        set;
    }
    public Boolean updBeforeClosing {
        get;
        set;
    }
    public Boolean caseClosed {
        get;
        set;
    }
    public Boolean missingReferences {
        get;
        set;
    }
    public boolean productFamilyCheck {
        get;
        set;
    }

    //String to hold Arsak 2 Value
    public String arsak2 {
        get;
        set;
    }

    //public Hendelsestype__c hendvalue {get;set;}
    public String eventId {
        get;
        set;
    }
    public String productFamily {
        get;
        set;
    }
    public String productId {
        get;
        set;
    }
    public String reason1Id {
        get;
        set;
    }
    public String reason2Id {
        get;
        set;
    }

    //Public Error message holder Strings
    public String noEventMsg {
        get;
        set;
    }
    public String noProductMsg {
        get;
        set;
    }
    public String noReason1Msg {
        get;
        set;
    }
    public String noReason2Msg {
        get;
        set;
    }
    public String fieldCheck {
        get;
        set;
    }
    public String prductFamilyCheckMsg {
        get;
        set;
    }

    //For Fields to view
    public Case viewCase {
        get;
        set;
    }

    //Maps to hold Values of the fields
    private Map < String, String > eventCode_Map {
        get;
        set;
    }
    private Map < String, String > prodFamily_Map {
        get;
        set;
    }
    private Map < String, String > prod_Map {
        get;
        set;
    }
    private Map < String, String > reason1_Map {
        get;
        set;
    }
    private Map < String, String > reason2_Map {
        get;
        set;
    }

    //String to hold error message while updating
    public String stopMessage {
        get;
        set;
    }

    //Controller    
    public MultilevelDependentPicklist(ApexPages.StandardController stdController) {
        //Setting the default view to Closed Edit section and no Record type changes
        viewCatSec = true;
        recTypeChanged = false;
        viewButton = true;
        updBeforeClosing = false;
        caseClosed = false;
        missingReferences = false;
        productFamilyCheck = false;

        arsak2 = '';
        fieldCheck = '';

        //Creating closed status lists
        List < String > clStatus = new List < String > ();
        clStatus.add('Avsluttet');
        clStatus.add('Avsluttet - dublett');
        clStatus.add('Avsluttet - avbestilt');
        clStatus.add('Avsluttet - feilregistrering');
        clStatus.add('Avsluttet - henvendelse');
        clStatus.add('SPAM');

        /* Csphase2 27122016 Supriya*/

        /* clStatus.add('Closed');
         clStatus.add('Closed - doublet');
         clStatus.add('Closed - Cancelled');
         clStatus.add('Closed - misregistration');
         clStatus.add('Closed - inquiry');
         clStatus.add('SPAM');*/




        //Adding fields with which we are going to work
        if (!Test.isRunningTest()) {
            // The method addFields() can not be executed in a testclass 
            stdController.addFields(new List < String > {
                'Code_Event__c',
                'Code_Event__r.Name',
                'Status',
                'RecordType.Name',
                'RecordType.DeveloperName',
                'Product.Produktfamilie__c',
                'Service_Product__r.Produktfamilie__c',
                'ProductId',
                'Service_Product__c',
                'Code_Reason1__c',
                'Code_Reason2__c',
                'Code_Reason2__r.Name',
                'Shipment_identification__c',
                'get_Queue_Defaults__c',
                'hidden_queue_id__c',
                'Invoice_no__c',
                'change_address_ref_no__c',
                'CaseNumber',
                'Produkt__c',
                'Category__c',
                'reason__c',
                'Product.Produktfamilie__r.Name',
                'Service_Product__r.Produktfamilie__r.Name',
                'Party_number__c',
                'Created_by_User_profile__c'
            });
        }


        //Added as part pf Communities
        ID lightprofile = [Select id from Profile where name = 'CS community'].id;
        ID userprofile = UserInfo.getprofileid();

        if (lightprofile == userprofile) {
            Notlightuser = false;

        } else
            Notlightuser = true;


        this.stdController = stdController;
        this.c = (Case) stdController.getRecord();
        this.viewCase = (Case) stdController.getRecord();

        this.eventId = c.Code_Event__c;

        if (viewCase.Code_Reason1__c != null) {
            FlaglightuserOnload = false;
        } else
            FlaglightuserOnload = true;


        if (viewCase.Code_Reason2__c != null) {
            arsak2 = viewCase.Code_Reason2__r.Name;
        }

        for (String status: clStatus) {
            if (c.Status.equals(status)) {
                //Commented as part of C-05421 
                //viewButton = false;
            }
        }

        //This is done to check, in case we have a direct linkage to a Product Family rather than a Product
        if (c.Service_Product__r.Produktfamilie__c == null) {
            this.productFamily = c.Service_Product__c;
        } else {
            this.productFamily = c.Service_Product__r.Produktfamilie__c;
        }

        this.productId = c.Service_Product__c;
        this.reason1Id = c.Code_Reason1__c;
        this.reason2Id = c.Code_Reason2__c;

        this.recordTypeName = c.RecordType.Name;
        this.recordTypeName2 = c.RecordType.Name;
        this.recordTypeNameD = c.RecordType.DeveloperName;

        System.debug('=========c.RecordType.Name1' + c.RecordType.Name);
        System.debug('=========c.RecordType.DevloperName1' + recordTypeNameD);

        Schema.DescribeFieldResult fieldResult = Code_Event__c.CaseTypeMultiselect__c.getDescribe();
        System.debug('==========' + fieldResult);
        List < Schema.PicklistEntry > plv = fieldResult.getPicklistValues();
        mapPicklist = new Map < String, String > ();
        for (Schema.PicklistEntry f: plv) {
            mapPicklist.put(f.getLabel(), f.getValue());
            System.debug('Field Label ' + f.getLabel());
            System.debug('Field Value ' + f.getValue());
        }
        System.debug('==========' + mapPicklist);

        //This is to check if the last update was a Record Type change        
        try {
            CaseHistory cH = [SELECT Field FROM CaseHistory WHERE CaseId =: c.Id ORDER BY CreatedDate DESC LIMIT 1];
            if (cH.Field == 'RecordType') {
                recTypeChanged = true;
            }

        } catch (System.QueryException e) {
            // Case has no history
            recTypeChanged = false;
        }

        //if(recordTypeName.toLowerCase().equals('klage') && c.Party_number__c != null && c.Service_Product__c != null)
        //csphase2 Supriya 27122016
        /*    if(recordTypeNameD.equalsIgnoreCase('Complaint') && c.Party_number__c != null && c.Service_Product__c != null)
            

            {   
                if(c.Service_Product__r.Produktfamilie__c != null)
                {
                    String product_family_name =c.Service_Product__r.Produktfamilie__r.Name;

                    if(!(product_family_name.equalsIgnoreCase('flere produkter logistikk') || product_family_name.equalsIgnoreCase('ukjent produkt logistikk')))
                    {
                        if(!c.Party_number__c.startsWithIgnoreCase('bl'))
                        {
                        //product family name cannot be translated as per posten
                        //Cspahse2 supriya 27122016
                        
                            if(product_family_name.equalsIgnoreCase('Gods Nasjonalt') || product_family_name.equalsIgnoreCase('Gods Internasjonalt')) 
                            {
                                 
                                 productFamilyCheck = true;


                            }
                        }
                        
                        else if (c.Party_number__c.startsWithIgnoreCase('bl'))
                        {
                            if(!(product_family_name.equalsIgnoreCase('gods nasjonalt') || product_family_name.equalsIgnoreCase('gods internasjonalt'))) 
                            {
                                 
                                  productFamilyCheck = true;
                                 
                            }
                        }
                    }
                }
            }*/

    }


    //EDIT EVENT, PRODUCT AND REASONS SECTION VISIBILITY TOGGLE
    //This function will show/hide the detail section and open the edit section for the user to edit.
    public void toggleCategorySec() {
        //Reseting the messages before section toggles
        noEventMsg = null;
        noProductMsg = null;
        noReason1Msg = null;
        noReason2Msg = null;

        if (viewCatSec == true) {
            viewCatSec = false;
        } else {
            viewCatSec = true;
        }

    }


    /* Explanation of the different statuses set on the picklists (eventId,productId,reason1Id,reason2Id):
     * 
     * null         - default value on loading the page, if no value for the field exists on the current case record
     * 'NA'         - Options are available for the selectOption picklist, but the user has not yet picked any value. 
     *                A validation error will occur when saving if any of the id's are set to NA.
     * 'NO_PRODUKT' - There are no available product picklist values for the current choice of event. 
     *                When the record is saved, c.product will be set to null.
     * 'NO_REASON1' - There are no available reason1 picklist values for the current choices of event/product.
     *                When the record is saved, c.Code_Reason1__c will be set to null.
     * 'NO_REASON2' - There are no available reason2 picklist values for the current choices of event/product/reason1.
     *                When the record is saved, c.Code_Reason1__c will be set to null.
     */


    // Henvendelsestype object - CODE EVENT LIST
    // A SOQL search directly on the Code_event object is done to find possible values for the picklist
    public list < SelectOption > getEventOpts() {
        list < SelectOption > options = new list < SelectOption > ();
        if (cs_CaseRecordTypeToEnquiryTypMap__c.getInstance(recordTypeNameD).cs_Code_Event_Api__c != null) {

            eventCode_Map = new Map < String, String > ();

            //options.add(new SelectOption('NA','--Velg Henvendelsestype--'));
            //Csphase2 Supriya 27122016
            options.add(new SelectOption('NA', '--' + System.Label.cs_Select_Inquiry_Type + '--'));

            // Only events for this recordtype should be listed
            // Get recordtypename of current case
            System.debug('===========recordTypeName2' + recordTypeName2);
            list < Code_Event__c > eventList = [SELECT Id, Name, isActive__c
                FROM Code_Event__c
                WHERE isActive__c = true
                AND CaseTypeMultiselect__c INCLUDES(: cs_CaseRecordTypeToEnquiryTypMap__c.getInstance(recordTypeNameD).cs_Code_Event_Api__c)
                order by Name asc
            ];

            for (Code_Event__c e: eventList) {
                options.add(new SelectOption(e.Id, e.Name));
                eventCode_Map.put(e.Id, e.Name);
            }

        }
        return options;
    }

    // PRODUCT FAMILY LIST
    // Product Family is picked up from all the Products in Scope
    // If there is a link between the Code Event and a Product Family directly (instead of a Product), its also picked up
    public list < SelectOption > getProductFamiliesOpts() {
        list < SelectOption > options = new list < SelectOption > ();
        prodFamily_Map = new Map < String, String > ();

        //Check if the Code Event is selected
        if (eventId == null || eventId == 'NA') {
            //  options.add(new SelectOption('NA','--Ingen valg tilgjengelige--'));
            //Csphase2 Supriya 2722016
            options.add(new SelectOption('NA', '--' + System.label.cs_No_choice_available + '--'));

            productFamily = 'NA';
        } else {

            //As per Business we are removing the product filter
            list < Code_Event_Prod__c > eventProductList = [SELECT Service_Product__c, Service_Product__r.Name, Service_Product__r.Produktfamilie__c, Service_Product__r.Produktfamilie__r.Name
                FROM Code_Event_Prod__c
                WHERE IsActive__c = true
                AND Code_event__c =: eventId
                ORDER BY Service_Product__r.Produktfamilie__r.Name asc
            ];
            /*                        
                     list<Code_Event_Prod__c> eventProductList = [SELECT Service_Product__c, Service_Product__r.Name, Service_Product__r.Produktfamilie__c, Service_Product__r.Produktfamilie__r.Name 
                                                   FROM Code_Event_Prod__c 
                                                  WHERE IsActive__c = true 
                                                    
                                               ORDER BY Service_Product__r.Produktfamilie__r.Name asc];                          
                     */
            if (eventProductList.size() > 0) {
                //options.add(new SelectOption('NA','--Velg Produkt--'));
                //Csphase2 supriya 27122016
                options.add(new SelectOption('NA', '--' + System.label.cs_Select_Product + '--'));



                if (productFamily == 'NO_PRODUKT') {
                    productFamily = 'NA';
                }


                for (Code_Event_Prod__c ep: eventProductList) {
                    if (ep.Service_Product__r.Produktfamilie__c != null) {
                        if (!prodFamily_Map.containsKey(ep.Service_Product__r.Produktfamilie__c)) {
                            options.add(new SelectOption(ep.Service_Product__r.Produktfamilie__c, ep.Service_Product__r.Produktfamilie__r.Name));
                            prodFamily_Map.put(ep.Service_Product__r.Produktfamilie__c, ep.Service_Product__r.Produktfamilie__r.Name);
                        }
                    } else if ((!prodFamily_Map.containsKey(ep.Service_Product__c)) && (ep.Service_Product__c != null)) {
                        options.add(new SelectOption(ep.Service_Product__c, ep.Service_Product__r.Name));
                        prodFamily_Map.put(ep.Service_Product__c, ep.Service_Product__r.Name);
                    }
                }


                //If there is only one Product Family - system will automatically select it
                if (options.size() == 2) {
                    productFamily = options.get(1).getValue();
                }
            } else {
                //options.add(new SelectOption('NO_PRODUKT_FAM','Ingen tilgjengelige'));
                //Csphase2 Supriya 27122016
                options.add(new SelectOption('NO_PRODUKT_FAM', System.label.cs_Not_available));
                productFamily = 'NO_PRODUKT_FAM';
            }
        }

        return options;
    }



    // PRODUCT LIST
    // A SOQL search on the Code_Event_Prod (junction object between event and product) is done which finds all 
    // relations between the chosen event and product where isActive is true
    public list < SelectOption > getProductOpts() {
        list < SelectOption > options = new list < SelectOption > ();
        prod_Map = new Map < String, String > ();

        if (productFamily == null || productFamily == 'NA') {

            //  options.add(new SelectOption('NA','--Ingen valg tilgjengelige--'));
            //Csphase2 Supriya 2722016
            options.add(new SelectOption('NA', '--' + System.label.cs_No_choice_available + '--'));
            productId = 'NA';
        } else {
            list < Code_Event_Prod__c > eventProductList = [SELECT Code_event__c,
                Service_Product__c,
                Service_Product__r.Name,
                Product__c,
                Product__r.Name,
                Id,
                IsActive__c
                FROM Code_Event_Prod__c
                WHERE IsActive__c = true
                AND Code_event__c =: eventId
                AND Service_Product__r.Produktfamilie__c =: productFamily
                ORDER BY Service_Product__r.Name asc
            ];

            if (eventProductList.size() > 0) {
                //options.add(new SelectOption('NA','--Velg Produkt--'));
                //Csphase2 supriya 27122016
                options.add(new SelectOption('NA', System.label.cs_SelectProduct));

                if (productId == 'NO_PRODUKT') {
                    productId = 'NA';
                }

                //If there is only one Product - system will automatically select it
                if (eventProductList.size() == 1) {
                    productId = eventProductList.get(0).Service_Product__c;
                }

                for (Code_Event_Prod__c ep: eventProductList) {
                    if ((!prod_Map.containsKey(ep.Service_Product__c)) && (ep.Service_Product__c != null)) {
                        options.add(new SelectOption(ep.Service_Product__c, ep.Service_Product__r.Name));
                        prod_Map.put(ep.Service_Product__c, ep.Service_Product__r.Name);
                    }
                }
            } else {
                // options.add(new SelectOption('NO_PRODUKT','Ingen tilgjengelige'));
                //Csphase2 Supriya 27122016
                options.add(new SelectOption('NO_PRODUKT_FAM', System.label.cs_Not_available));
                productId = 'NO_PRODUKT';
            }

        }

        return options;
    }


    // REASON 1
    // A SOQL search on the CodeProdReason__c (junction object between product and reason1) is done which finds all 
    // relations between the chosen product and reason1 where isActive is true.
    public list < SelectOption > getReason1Opts() {
        list < SelectOption > options = new list < SelectOption > ();
        reason1_Map = new Map < String, String > ();

        if (productFamily == null || productFamily == 'NA') {
            // options.add(new SelectOption('NA','--Ingen valg tilgjengelige--'));
            //Csphase2 Supriya 2722016
            options.add(new SelectOption('NA', '--' + System.label.cs_No_choice_available + '--'));
            reason1Id = 'NA';
        } else {
            list < CodeProdReason__c > prodReason1List = new list < CodeProdReason__c > ();

            if (productId == null || productId == 'NA' || productId == 'NO_PRODUKT') {
                prod_Map.put(productFamily, prodFamily_Map.get(productFamily));

                prodReason1List = [SELECT Service_Product__c,
                    Product__c,
                    Code_reason1__c,
                    Code_reason1__r.Name,
                    Id,
                    IsActive__c
                    FROM CodeProdReason__c
                    WHERE IsActive__c = true
                    AND Service_Product__c IN: prod_Map.keySet()
                    AND Henvendelsestype__c =: eventId
                    ORDER BY Code_reason1__r.Name asc
                ];

            } else {
                prodReason1List = [SELECT Product__c,
                    Service_Product__c,
                    Code_reason1__c,
                    Code_reason1__r.Name,
                    Id,
                    IsActive__c
                    FROM CodeProdReason__c
                    WHERE IsActive__c = true
                    AND Service_Product__c =: productId
                    AND Henvendelsestype__c =: eventId
                    ORDER BY Code_reason1__r.Name asc
                ];
            }

            //Product view in options box
            if (prodReason1List.size() > 0) {
                //options.add(new SelectOption('NA','--Velg årsak 1--'));
                //Csphase2 Supriya 27122016
                options.add(new SelectOption('NA', '--' + System.Label.cs_Select_reason_1 + '--'));

                if (reason1Id == 'NO_REASON1') {
                    reason1Id = 'NA';
                }

                //if there is only one option for Arsak1, system will automatically select that
                if (prodReason1List.size() == 1) {
                    reason1Id = prodReason1List.get(0).Code_reason1__c;
                }

                for (CodeProdReason__c pr: prodReason1List) {
                    if (pr.Code_reason1__c != null) {
                        if (!reason1_Map.containsKey(pr.Code_reason1__c)) {
                            options.add(new SelectOption(pr.Code_reason1__c, pr.Code_reason1__r.Name));
                            reason1_Map.put(pr.Code_reason1__c, pr.Code_reason1__r.Name);
                        }
                    }

                }
            } else {
                //options.add(new SelectOption('NO_REASON1','Ingen årsak'));
                //Csphase2 Supriya 27122016
                options.add(new SelectOption('NO_REASON1', System.label.cs_NoProblem));
                reason1Id = 'NO_REASON1';
            }
        }

        return options;
    }





    // REASON 2
    // A SOQL search on the Code_Reason_12__c (junction object between reason1 and reason2 ) is done which finds all 
    // relations between the chosen reason1 and reason2 where isActive is true.
    public list < SelectOption > getReason2Opts() {
        list < SelectOption > options = new list < SelectOption > ();
        reason2_Map = new Map < String, String > ();

        if (reason1Id == null || reason1Id == 'NA') {
            //options.add(new SelectOption('NA','--Ingen valg tilgjengelige--'));
            //Csphase2 Supriya 2722016
            options.add(new SelectOption('NA', '--' + System.label.cs_No_choice_available + '--'));
            reason2Id = 'NA';
        } else if (reason1Id == 'NO_REASON1') {
            //options.add(new SelectOption('NO_REASON2','Ingen årsak'));
            //Csphase2 Supriya 27122016
            options.add(new SelectOption('NO_REASON2', System.label.cs_NoProblem));
            reason2Id = 'NO_REASON2';
        } else {
            list < Code_Reason_12__c > reason12List = [SELECT Code_reason1__c,
                Code_Reason2__c,
                Code_Reason2__r.Name,
                Service_Product__c,
                Id,
                IsActive__c
                FROM Code_Reason_12__c
                WHERE IsActive__c = true
                AND Code_reason1__c =: reason1Id
                AND Service_Product__c =: productId
                order by Code_Reason2__r.Name asc
            ];

            //Product view in options box
            if (reason12List.size() > 0) {


                //options.add(new SelectOption('NA','--Velg årsak 2--'));
                //csphase 2 supriya 27122016
                options.add(new SelectOption('NA', '--' + System.Label.cs_Select_reason_2 + '--'));


                if (reason2Id == 'NO_REASON2') reason2Id = 'NA';

                //if there is only one option for Arsak2, system will automatically select that
                if (reason12List.size() == 1) {
                    reason2Id = reason12List.get(0).Code_Reason2__c;
                }

                for (Code_Reason_12__c r12: reason12List) {
                    if (r12.Code_reason2__c != null) {
                        options.add(new SelectOption(r12.Code_Reason2__c, r12.Code_Reason2__r.Name));
                        reason2_Map.put(r12.Code_reason2__c, r12.Code_reason2__r.Name);
                    }
                }
            } else {
                options.add(new SelectOption('NO_REASON2', System.label.cs_NoProblem));
                reason2Id = 'NO_REASON2';
            }
        }

        return options;
    }

    private Boolean ValidateSetValue() {
        //reset messages every time the save-button is clicked
        noEventMsg = null;
        noProductMsg = null;
        noReason1Msg = null;
        noReason2Msg = null;


        //if(prodFamily_Map.containsKey(productFamily) && recordTypeName.toLowerCase().equals('klage') && c.Party_number__c != null)
        /*    if(prodFamily_Map.containsKey(productFamily) && recordTypeNameD.equalsIgnoreCase('Complaint') && c.Party_number__c != null)
            {
                String product_family_name = prodFamily_Map.get(productFamily);

                if(!(product_family_name.equalsIgnoreCase('flere produkter logistikk') || product_family_name.equalsIgnoreCase('ukjent produkt logistikk')))
                {
                    if(!c.Party_number__c.startsWithIgnoreCase('bl'))
                    {
                        if(product_family_name.equalsIgnoreCase('Gods Nasjonalt') || product_family_name.equalsIgnoreCase('Gods Internasjonalt')) 
                        {
                             noProductMsg = System.Label.cs_actor_no_cannot_used;
                             return false;


                        }
                    }
                    
                    else if (c.Party_number__c.startsWithIgnoreCase('bl'))
                    {
                        if(!(product_family_name.equalsIgnoreCase('gods nasjonalt') || product_family_name.equalsIgnoreCase('gods internasjonalt'))) 
                        {
                             noProductMsg = System.Label.cs_actor_no_cannot_used;
                             return false;
                        }
                    }
                }
            }
            
            */

        //Checking Event Id Selection
        if (eventId == null || eventId == 'NA') {
            noEventMsg = System.label.cs_Enquiryselect;
            return false;
        } else {
            c.Code_Event__c = eventId;
            c.Category__c = eventCode_Map.get(eventId); //Setting up the old Category field

            if (c.Category__c.toLowerCase().contains('invoice')) {
                c.view_Backend_Invoices__c = true;
            } else {
                c.view_Backend_Invoices__c = false;
            }
        }


        //Checking Product Selection
        if (productFamily == null || productFamily == 'NA' || productFamily == 'NO_PRODUKT_FAM') {
            noProductMsg = System.label.cs_select_family;
            return false;
        } else {
            if (productId == null || productId == 'NA' || productId == 'NO_PRODUKT') {
                noProductMsg = System.Label.cs_Please_select_product;
                return false;
            } else {
                c.Service_Product__c = productId;
                c.Produkt__c = prod_Map.get(productId); //Setting up the old Product Field
            }
        }

        /* Validation for Account's Party_number__c starting with 'BL':
         If Party_number__c  starts with 'BL' and product family equal to 'Gods Nasjonalt' or 'Gods Internasjonalt'
         If Party_number__c  does not starts with 'BL' then product family should not be equal to 'Gods Nasjonalt' or 'Gods Internasjonalt'
         Exception to this rule are product family 'Flere produkter Logistikk' and 'Ukjent produkt Logistikk'
         */




        //Checking selection in Reason 1
        if (reason1Id == null || reason1Id == 'NA') {
            noReason1Msg = System.Label.cs_NO_REASON_1;
            return false;
        } else {
            //If there are no Reason 1 available the value is set to null
            if (reason1Id == 'NA' || reason1Id == 'NO_REASON1') {
                c.Code_Reason1__c = null;
                c.reason__c = '';
            } else {
                c.Code_Reason1__c = reason1Id;
                c.reason__c = reason1_Map.get(reason1Id);
            }
        }


        //Checking selection in Reason 2 - This field is not mandatory
        if (reason2Id == null || reason2Id == 'NA' || reason2Id == 'NO_REASON2') {
            c.Code_Reason2__c = null;
            arsak2 = '';
        } else {
            c.Code_Reason2__c = reason2Id;
            arsak2 = reason2_Map.get(reason2Id);
        }

        return true;
    }



    public pagereference Save() {
        if (this.ValidateSetValue() != true) {
            return null;
        } else {
            try {

                upsert c;
                FlaglightuserOnload = false;


                // if(recordTypeName.toLowerCase().equals('klage'))
                if (recordTypeNameD.equalsIgnoreCase('Complaint')) {
                    checkReferences();
                }
                viewCatSec = true;
                recTypeChanged = false;
                updBeforeClosing = false;
                productFamilyCheck = false;

                System.debug('%%%%before lead');
                convertcasetolead();

            } catch (exception e) {
                stopMessage = e.getmessage();
                updBeforeClosing = true;
            }

        }

        return null;
    }

    public pagereference SaveAndClose() {
        if (this.ValidateSetValue() == false) {
            return null;
        } else {
            // c.Status = 'Closed';
            c.Status = 'Avsluttet';



            try {
                FlaglightuserOnload = false;
                database.update(c);


                //if(recordTypeName.toLowerCase().equals('klage'))
                if (recordTypeNameD.equalsIgnoreCase('Complaint')) {
                    checkReferences();
                }
                viewCatSec = true;
                recTypeChanged = false;
                updBeforeClosing = false;
                viewButton = false;
                productFamilyCheck = false;
                caseClosed = true;

                convertcasetolead();


            } catch (exception e) {
                stopMessage = e.getmessage();
                updBeforeClosing = true;
            }

        }

        return null;
    }

    public Boolean checkReferences() {
        List < Service_Product__c > prod = new List < Service_Product__c > ();
        prod = [SELECT Id,
            check_fakturanummer__c,
            check_kollinummer__c,
            check_adresseendring__c
            FROM Service_Product__c
            WHERE Id =: productId
            LIMIT 1
        ];

        String msg = '';
        if (prod.get(0).check_kollinummer__c == true) {
            if (c.Shipment_identification__c == null || c.Shipment_identification__c == '') {
                msg = msg + ((msg == '') ? ' Kollinummer' : ' og Kollinummer');
            }
        }
        if (prod.get(0).check_adresseendring__c == true) {
            if (c.change_address_ref_no__c == null || c.change_address_ref_no__c == '') {
                msg = msg + ((msg == '') ? ' Ref.adr.endring' : ' og Ref.adr.endring');
            }
        }
        if (prod.get(0).check_fakturanummer__c == true) {
            if (c.Invoice_no__c == null || c.Invoice_no__c == '') {
                msg = msg + ((msg == '') ? ' Fakturanummer' : ' og Fakturanummer');
            }
        }

        if (msg != '') {
            fieldCheck = 'Husk å oppdatere' + msg + ' i saken.';
            missingReferences = true;
        }

        return true;
    }


    // This is a temporary function created to support the issue with Bulk upload from OEBS
    public PageReference setDefaultsForHenvendelsestype() {
        if (c.get_Queue_Defaults__c == true) {
            List < QueueDetails__c > qdList = new List < QueueDetails__c > ();
            qdList = [SELECT id,
                OwnerId,
                entitlement__c,
                Default_Division_In_Queue__c,
                Business_Hours__c,
                Code_Event__c,
                Product__c,
                Service_Product__c,
                Code_Reason1__c,
                Code_Reason2__c,
                Code_Event__r.Name,
                Product__r.Name,
                Service_Product__r.Name,
                Service_Product__r.Produktfamilie__c,
                Product__r.Produktfamilie__c,
                Code_Reason1__r.Name,
                Code_Reason2__r.Name,
                is_inactive_queue__c,
                queueEmailAddress__c,
                fetch_from_cti__c,
                queue_owner__c,
                queue_owner__r.email,
                Queue_id_route_to__c
                FROM QueueDetails__c
                WHERE ownerid =: c.hidden_queue_id__c
            ];

            if (qdList.size() > 0) {
                CaseController.setHenvendelsestypeDefaults(c, qdList[0]);

                this.eventId = c.Code_Event__c;
                this.productFamily = qdList[0].Service_Product__r.Produktfamilie__c;
                this.productId = c.Service_Product__c;
                this.reason1Id = c.Code_Reason1__c;
                this.reason2Id = c.Code_Reason2__c;

                if (!String.isBlank(qdList[0].Queue_id_route_to__c)) {
                    c.hidden_queue_id__c = qdList[0].Queue_id_route_to__c;
                }
            }

            try {
                c.get_Queue_Defaults__c = false;
                Database.update(c);
            } catch (exception e) {
                ExceptionController.handleException(false, true, e, 'Occured in MultiLevelDependentPicklist --> tempCodeEventForAvvik', '');
            }

        } else if (c.Code_Event__c == null && !KATSutilities.isEmpty(c.Category__c)) {
            List < Code_Event__c > ceForAvvik = new List < Code_Event__c > ();
            ceForAvvik = [SELECT Id, Name FROM Code_Event__c WHERE Name =: c.Category__c.trim() LIMIT 1];

            if (ceForAvvik.size() > 0) {
                c.Code_Event__c = ceForAvvik.get(0).Id;
                this.eventId = ceForAvvik.get(0).Id;

                Database.update(c);
            }
        } else if (c.Code_Event__c != null && !KATSutilities.isEmpty(c.Category__c) && !c.Code_Event__r.Name.equalsIgnoreCase(c.Category__c)) {
            c.Category__c = c.Code_Event__r.Name;

            try {
                Database.update(c);
            } catch (exception e) {
                ExceptionController.handleException(false, true, e, 'Occured in MultiLevelDependentPicklist --> tempCodeEventForAvvik --> Last Else If Condition', '');
            }
        }

        return null;
    }

    private void convertcasetolead() {
        Boolean leadcreated = false;

        String Role = '';
        Set < String > roleSet = new Set < String > ();
        List < String > roleList = new List < String > ();


        environment_settings__c restrictedRoleSetting = environment_settings__c.getValues('RestrictedRoleLeadConversion');

        if (restrictedRoleSetting != null) {
            role = restrictedRoleSetting.value__c;
        }

        if (role != '') {
            roleList = role.split(';');
        }

        roleSet.addAll(roleList);

        /* for(segment_responsible_not_assign_lead__c rs:segment_responsible_not_assign_lead__c.getall().values())
          {
               AliasName.add(rs.alias__c); 
           }*/


        Case Caseobj = [Select id, Code_Reason1__c, Code_Event__c, Code_Event__r.name, Service_Product__c, Service_Product__r.Name, Category__c, account.parentid, accountid, AccountEmail__c, AccountPhone__c, account.name, account.crm_bus_addr_City__c, account.crm_bus_addr_Country__c, account.crm_bus_addr_Street__c, account.crm_bus_addr_Zip_Code__c, subject, contactid, contact.firstname, contact.lastname, contact.phone, contact.email, casenumber, Account.Recordtypeid, LM_current_postal_address__c, LM_current_country__c, LM_current_zip_code__c, description, CRMStatus__c, cs_lead_Id__c, cs_Case_Converted__c,PostNumber__c from Case where id =: c.id];

        Code_Reason1__c reason1Obj = [Select name from Code_Reason1__c where id =: Caseobj.Code_Reason1__c];
        //Service_Product__c productObj =[Select name from Service_Product__c where id =:Caseobj.Service_Product__c];
        if (reason1Obj.name == 'Leads til salg' && Caseobj.Category__c == 'Behovsavdekking') {

            Lead leadobj = new Lead();
            Integer count = [Select count() from lead where cs_case_number__c =: c.caseNumber];


            if (count == 0) {
                //lead not converted yet 

                // if(Caseobj.contactid!=null) {
                if (Caseobj.contact.firstname != null)
                    leadobj.firstname = Caseobj.contact.firstname;


                if (Caseobj.contact.lastname != null)
                    leadobj.lastname = Caseobj.contact.lastname;
                else
                    leadobj.lastname = Caseobj.casenumber;

                if (Caseobj.AccountEmail__c != null)
                    leadobj.email = Caseobj.AccountEmail__c;
                else
                    leadobj.email = Caseobj.contact.email;


                if (Caseobj.AccountPhone__c != null) {
                    leadobj.phone = Caseobj.AccountPhone__c;
                    leadobj.mobilephone = Caseobj.AccountPhone__c;

                } else {
                    leadobj.phone = Caseobj.contact.phone;
                    leadobj.mobilephone = Caseobj.contact.phone;
                }

                // }


                /*  if(Caseobj.AccountEmail__c!=null && Caseobj.AccountEmail__c!='')
                        leadobj.email=Caseobj.AccountEmail__c;
                        
                   if(Caseobj.AccountPhone__c!=null)
                    leadobj.phone=Caseobj.AccountPhone__c;  */



                if (Caseobj.account.name != null)
                    leadobj.company = Caseobj.Account.name;

                else if (Caseobj.subject != null)
                    leadobj.company = Caseobj.subject;

                else
                    leadobj.company = Caseobj.casenumber;



                leadobj.status = 'New';
                leadobj.leadSource = 'Customer Service';
                /* List<User> Admin =[Select id from User where alias='aadmi' limit 1];
                 
                 if (Admin!=null)
                 {
                 leadobj.ownerid = Admin[0].id;
                 }*/

                /* Poupluate user detals on lead obkjects*/

                List < Profile > PROFILE = [SELECT Id, Name FROM Profile WHERE Id =: userinfo.getProfileId() LIMIT 1];
                String ProfileName = PROFILE[0].Name;

                String rolename = '';
                List < UserRole > Roles = [SELECT Id, Name FROM UserRole WHERE Id =: userinfo.getUserRoleId() LIMIT 1];
                if (Roles.size() > 0)
                    rolename = Roles[0].Name;

                leadobj.cs_lead_createdby__c = UserInfo.getName();
                if (rolename != '')
                    leadobj.cs_Lead_Conversion_User_details__c = ProfileName + ' - ' + rolename;
                else
                    leadobj.cs_Lead_Conversion_User_details__c = ProfileName;

                String orgno = '';
                if (Caseobj.Accountid != null) {
                    if (Caseobj.Account.Recordtypeid == KATSutilities.getRecordType('business_account')) {

                        orgno = [Select Orga__c from Account where id =: Caseobj.Accountid limit 1].orga__c;

                    }

                }


                if (orgno != null)
                    leadobj.crm_organization_number__c = orgno;


                /* if(Caseobj.LM_current_postal_address__c!=null)  
                    leadobj.city=Caseobj.LM_current_postal_address__c;    
    
    
                    
                  if(Caseobj.LM_current_country__c!=null)
                    leadobj.country=Caseobj.LM_current_country__c;  
                    
                  if(Caseobj.LM_current_zip_code__c!=null)
                    leadobj.PostalCode=Caseobj.LM_current_zip_code__c;   
                 */
                //     map address

                if (caseobj.account.crm_bus_addr_City__c != null)
                    leadobj.city = caseobj.account.crm_bus_addr_City__c;

                if (caseobj.account.crm_bus_addr_Country__c != null)
                    leadobj.country = caseobj.account.crm_bus_addr_Country__c;

                if (caseobj.account.crm_bus_addr_Street__c != null)
                    leadobj.Street = caseobj.account.crm_bus_addr_Street__c;
      
//Changes in zip code field start
                if (caseobj.account.crm_bus_addr_Zip_Code__c == null)
                {
                    if (caseobj.PostNumber__c!= null)
                    leadobj.PostalCode = caseobj.PostNumber__c;
                }else{
                leadobj.PostalCode = caseobj.account.crm_bus_addr_Zip_Code__c;    
                    }        
//Changes in zip code field ends    
              //    if (caseobj.account.crm_bus_addr_Zip_Code__c != null)
                //    leadobj.PostalCode = caseobj.account.crm_bus_addr_Zip_Code__c;

                leadobj.crm_Customer_Requirement__c = '';
                String Customer_Requirement = '';

                if (Caseobj.Service_Product__c != null) {
                    system.debug('@@ I am here');
                    Customer_Requirement = 'Product: ' + Caseobj.Service_Product__r.Name;
                }

                leadobj.crm_Customer_Requirement__c = Customer_Requirement;
                leadobj.description = '';
                String description = '';


                if (Caseobj.description != null && Caseobj.description != '')
                    description = ' Desc:' + Caseobj.description;

                if (Caseobj.subject != null && Caseobj.subject != '')
                    description += '\n Subject: ' + Caseobj.subject;


                if (Caseobj.casenumber != null && Caseobj.casenumber != '')
                    description += '\n Case Number: ' + Caseobj.casenumber;

                if (Caseobj.CRMStatus__c != null && Caseobj.CRMStatus__c != '')
                    description += '\n KS-status: ' + Caseobj.CRMStatus__c;

                //if(caseobj.recordtype.Developername!=null)
                // leadobj.description+= ' Case Record type: ' + caseobj.recordtype.Developername; 

                leadobj.description = description;

                leadobj.cs_case_Detail__c = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + Caseobj.Id;
                leadobj.cs_Case_Number__c = Caseobj.casenumber;

                //owner asignment
                Boolean SetResponsible = true;
                Service_Product__c serviceProduct = [Select id, Eier__c from Service_Product__c where id =: Caseobj.Service_Product__c];
                system.debug('@@@serviceProduct' + serviceProduct);
                if (serviceProduct.Eier__c.startsWithIgnoreCase('POST')) {
                    //check the responsible seller for the relation level segment

                    count = [Select count() from crm_Segment__c where crm_Account__c =: Caseobj.Accountid and crm_Service_Group__c = 'Post'];
                    if (count > 0) {
                        crm_segment__c segObj = [Select crm_Account__c, crm_Sales_Responsible__c, crm_Sales_Responsible__r.Userrole.name from crm_Segment__c where crm_Account__c =: Caseobj.Accountid and crm_Service_Group__c = 'Post'];
                        system.debug('@@@segObj relation' + segObj + roleSet + segObj.crm_Sales_Responsible__r.UserRole.name);
                        if (segObj != null && segObj.crm_Sales_Responsible__c != null) {

                            if (RoleSet != null && roleSet.contains(segObj.crm_Sales_Responsible__r.Userrole.name)) {
                                SetResponsible = false;

                            } else

                                leadobj.Ownerid = segObj.crm_Sales_Responsible__c;

                        }

                    } else //fetch parent segment 

                    {
                        System.debug('$$$' + Caseobj.Account.parentid + '$$$' + Caseobj.Accountid);
                        count = [Select count() from crm_Segment__c where crm_Account__c =: Caseobj.Account.parentid and crm_Service_Group__c = 'Post'];
                        if (count > 0) {
                            crm_segment__c segObj = [Select crm_Account__c, crm_Sales_Responsible__c, crm_Sales_Responsible__r.Userrole.name from crm_Segment__c where crm_Account__c =: Caseobj.Account.parentid and crm_Service_Group__c = 'Post'];
                            system.debug('@@@segObj' + segObj + roleSet + segObj.crm_Sales_Responsible__r.Userrole.name);
                            if (segObj != null && segObj.crm_Sales_Responsible__c != null) {
                                if (RoleSet != null && roleSet.contains(segObj.crm_Sales_Responsible__r.Userrole.name)) {
                                    SetResponsible = false;

                                } else

                                    leadobj.Ownerid = segObj.crm_Sales_Responsible__c;


                            } else {
                                SetResponsible = false;
                                //  Group gp =[select Id , name from Group where Name = 'post' and Type = 'Queue'];
                                // leadobj.Ownerid= gp.id;

                            }

                        } //end of count 
                        else {
                            SetResponsible = false;

                        }


                    }

                    if (!SetResponsible) {
                        Group gp = [select Id, name from Group where Name = 'post'
                            and Type = 'Queue'
                        ];
                        leadobj.Ownerid = gp.id;
                    }

                } else if (serviceProduct.Eier__c.startsWithIgnoreCase('LOGISTIKK')) {
                    Group gp = [select Id, name, developername from Group where developerName = 'crm_Logistics_Norway'
                        and Type = 'Queue'
                    ]; //changed where clause to compare with developername with 'API name' instead of 'label' for incident E2-IM018463049

                    leadobj.Ownerid = gp.id;

                }



                system.debug('@@@tempobj.ownerid' + leadobj.ownerid);

                system.debug('@@@leadobj' + leadobj);

                try {

                    insert leadobj;
                    leadcreated = true;


                } catch (Exception e) {
                    crm_Exception_handler.createExceptionRecords(e);
                }

                system.debug('@@@leadcreated' + leadcreated + leadobj);
                if (leadcreated) {
                    Lead tempobj = [Select id from lead where id =: leadobj.id];
                    Caseobj.cs_lead_Id__c = tempobj.id;
                    Caseobj.cs_Case_Converted__c = 'Case converted to lead';



                    try {
                        update Caseobj;
                        //update tempobj;

                    } catch (Exception e) {
                        crm_Exception_handler.createExceptionRecords(e);
                    }
                }

            }
        } //end of condition match            

    } //end of function 
} //end of classs