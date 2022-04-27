// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
public with sharing class Lightuser_CreateCaseController 
{
    @testVisible
    private static String eventName;
    private Case c;
    private ApexPages.StandardController stdController;
    private String recordtypeName='';
    public PostalUnit__c pu { get; set; }
    public PostalUnit__c pu_to_blame { get; set; }
    public Account acct {get; set; }
        
    public Map<String,String> mapPicklist;
    
    public String customerNumber { get; set; }
    public String customerName { get; set; }
    
    // Variable to hold Record type Ids
    public String deviationId {get; set;}
    public String gjenliggId {get; set;}
   
    // Variable for new Code Changes
    public String eventId {get;set;}
    public String productFamily {get;set;}
    public String productId {get;set;}
    public String reason1Id {get;set;}
    public String reason2Id {get;set;}
    
    //Strings to hold error messages
    public String noEventMsg {get;set;}
    public String noProductMsg {get;set;}
    public String noReason1Msg {get;set;}
    public String noReason2Msg {get;set;}
    public String noOldOrderNum {get;set;}
    public String noNewOrderNum {get;set;}
    
    //Maps to hold Values of the fields
    private Map<String,String> eventCode_Map {get; set;}
    private Map<String,String> prodFamily_Map {get; set;}
    private Map<String,String> prod_Map {get; set;}
    private Map<String,String> reason1_Map {get; set;}
    
    //Field to hold the values for new and old order numbers. 
    //These values (fields) will be made visible on the page layout only when Henvendelsestype is: 'Avvik som skal krediteres'
    public String old_Order_Number {get; set;}
    public String new_Order_Number {get; set;}  
     public Boolean Isactivelightuser {get;set;}
    
    public Lightuser_CreateCaseController(ApexPages.StandardController stdController) 
    {
        this.stdController = stdController;
         Isactivelightuser =true;
       environment_settings__c env = environment_settings__c.getValues('Isactivelightuser');
        if (env != null && env.value__c == 'false')  {
              Isactivelightuser =false;  
        
        }
        c = (Case)stdController.getRecord();
                pu = new PostalUnit__c();
        
        pu_to_blame = new PostalUnit__c();
        eventName = '';
        
        gjenliggId = KATSutilities.getRecordType('Gjenligg');
        deviationId = KatsUtilities.getRecordType('deviation_case');

        old_Order_Number = '';
        new_Order_Number = '';
                        
        String record = ApexPages.currentPage().getParameters().get('record');
        String unit = ApexPages.currentPage().getParameters().get('unit');
        String user = ApexPages.currentPage().getParameters().get('user');
        String prod = ApexPages.currentPage().getParameters().get('prod');
        String kat = ApexPages.currentPage().getParameters().get('kat');

        if(!String.isEmpty(unit) && !unit.equalsIgnoreCase('null') ) 
        {
            pu.Name = unit;
        }
        
        if(!String.isEmpty(record) && !record.equalsIgnoreCase('null')) 
        {
            c.RecordTypeId = record;
        } 
        else 
        {
            c.RecordTypeId = deviationId;
        }
        
        if(!String.isEmpty(user) && !user.equalsIgnoreCase('null') ) 
        {
            c.Created_by_Name__c = user;
        }
        
        if(!String.isEmpty(kat) && !kat.equalsIgnoreCase('null'))
        {
            eventId = kat;
            List<Code_Event__c> ceList = new List<Code_Event__c>();
            ceList = [SELECT Name FROM Code_Event__c WHERE Id = :kat LIMIT 1];

            if(ceList.size() == 1)
            {
                c.Category__c = ceList[0].Name;
            }
        }
        if(!String.isEmpty(prod) && !prod.equalsIgnoreCase('null'))
        {
            productId = prod;
            /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
            Code_Event_Prod__c[] pf = [SELECT Product__r.Produktfamilie__c,
                                                                          Service_Product__r.Produktfamilie__c //ADDED FOR SALES  
                                         FROM Code_Event_Prod__c 
                                        WHERE Service_Product__c = :prod   // WHERE Product__c  = :prod    COMMENTED FOR SALES                                   
                                          AND Code_event__c = :eventId
                                          AND isActive__c = true
                                        LIMIT 1];
            /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
            //if((pf.size() > 0)&&(pf.get(0).Product__r.Produktfamilie__c != null))   // COMMENTED FOR SALES 
            if((pf.size() > 0)&&(pf.get(0).Service_Product__r.Produktfamilie__c != null))
            {
                    // productFamily = pf.get(0).Product__r.Produktfamilie__c;  // COMMENTED FOR SALES
                     productFamily = pf.get(0).Service_Product__r.Produktfamilie__c;
            }
            else
            {
                productFamily = prod;
            }
        }
        
        System.debug('============c.RecordTypeId'+c.RecordTypeId);
        
        recordtypeName = KATSutilities.getRecordTypeNameDeveloper(c.RecordTypeId);

        if(recordtypeName.equalsIgnoreCase('deviation_case'))
        {
          //c.Subject = 'Avvik';
          //CSphase2 supriya 26122016
          c.Subject= System.Label.cs_Deviation;
        }
        else if(recordtypeName.equalsIgnoreCase('Gjenligg'))
        {
          c.Subject = 'Gjenligg';
           //CSphase2 supriya 26122016
            c.Subject = system.label.cs_undelivered_mail;
        }
    }
    
    
    
    
    
    
    /* Explanation of the different statuses set on the picklists (eventId,productId,reason1Id,reason2Id):
    * 
    * null         - default value on loading the page, if no value for the field exists on the current case record
    * 'NA'         - Options are available for the selectOption picklist, but the user has not yet picked any value. 
    *                A validation error will occur when saving if any of the id's are set to NA.
    * 'NO_PRODUKT' - There are no available product picklist values for the current choice of event. 
    *                When the record is saved, c.product will be set to null.
    * 'NO_REASON1' - There are no available reason1 picklist values for the current choices of event/Serviceproduct .
    *                When the record is saved, c.Code_Reason1__c will be set to null.
    * 'NO_REASON2' - There are no available reason2 picklist values for the current choices of event/product/reason1.
    *                When the record is saved, c.Code_Reason1__c will be set to null.
    */
    
    // Hendelsestype object
    // A SOQL search directly on the Code_event object is done to find possible values for the picklist
    public list<SelectOption> getEventOpts()
    {
    
        list<SelectOption> options = new list<SelectOption>();
        eventCode_Map = new Map<String, String>();
        System.debug('============recordTypeName'+recordTypeName);
        if(cs_CaseRecordTypeToEnquiryTypMap__c.getInstance(recordTypeName).cs_Code_Event_Api__c != null){ 
        options.add(new SelectOption('NA','--'+System.Label.cs_Select_Inquiry_Type+'--'));
        
        list<Code_Event__c> eventList = [SELECT Id, 
                                                Name, 
                                                isActive__c 
                                           FROM Code_Event__c 
                                          WHERE isActive__c = true 
                                            AND CaseTypeMultiselect__c INCLUDES (:cs_CaseRecordTypeToEnquiryTypMap__c.getInstance(recordtypeName).cs_Code_Event_Api__c)  
                                       order by Name asc];
                                       
                                       /*

list<Code_Event__c> eventList = [SELECT Id, 
                                                Name, 
                                                isActive__c 
                                           FROM Code_Event__c 
                                          WHERE isActive__c = true 
                                            AND CaseTypeMultiselect__c INCLUDES (:recordtypeName)  
                                       order by Name asc];
                                       */
                                       
                                       

        for(Code_Event__c e : eventList)
        {
            options.add(new SelectOption(e.Id,e.Name));
            eventCode_Map.put(e.Id,e.Name);
        }
        }        
        return options;
        
    }
    
    
    // Set Case Category
    // This function will set the value in Category__c field when the user selects the Henvendelsystype
    public void setCaseCategory()
    {
        if(eventCode_Map.containsKey(eventId))
        {
            c.Category__c = eventCode_Map.get(eventId);
        }       
    } 
  
    
    // PRODUCT FAMILY LIST
    // Product Family is picked up from all the Products in Scope
    // If there is a link between the Code Event and a Product Family directly (instead of a Product), its also picked up
    public list<SelectOption> getProductFamiliesOpts()
    {
        list<SelectOption> options = new list<SelectOption>();
        prodFamily_Map = new Map<String,String>();
        
        if(eventId == null || eventId == 'NA')
        {
            //options.add(new SelectOption('NA','--Ingen valg tilgjengelige--'));
            //Csphase2 Supriya 26122016
            options.add(new SelectOption('NA', System.Label.cs_No_choice_available));
            productFamily = 'NA';
        } 
        else 
        {
                /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
            list<Code_Event_Prod__c> ProductFamList = [Select c.Product__r.Produktfamilie__c, 
                                                              c.Id,
                                                              Product__c, 
                                                              Product__r.Name, 
                                                              c.Product__r.Produktfamilie__r.Name ,
                                                              c.Service_Product__r.Produktfamilie__c,  // Added for Sales                                                           
                                                              Service_Product__c,     // Added for Sales
                                                              Service_Product__r.Name,    // Added for Sales
                                                              c.Service_Product__r.Produktfamilie__r.Name   // Added for Sales
                                                         From Code_Event_Prod__c c 
                                                        Where c.IsActive__c = true 
                                                          AND c.Code_event__c = :eventId 
                                                        order by c.Service_Product__r.Produktfamilie__r.Name asc];   // Added for Sales
                                                        //order by c.Product__r.Produktfamilie__r.Name asc];
            
            if(ProductFamList.size() > 0)
            {
                //options.add(new SelectOption('NA','--Velg Produkt--'));
                options.add(new SelectOption('NA','--'+System.label.cs_Select_Product+'--'));
                if(productFamily == 'NO_PRODUKT'){productFamily = 'NA';}

                for(Code_Event_Prod__c ep: ProductFamList)
                {
                        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
                    //if(ep.Product__r.Produktfamilie__c != null)  COMMENTED FOR SALES
                    if(ep.Service_Product__r.Produktfamilie__c != null)
                    {
                        // if(!prodFamily_Map.containsKey(ep.Product__r.Produktfamilie__c))
                        if(!prodFamily_Map.containsKey(ep.Service_Product__r.Produktfamilie__c))
                        
                        {
                            //options.add(new SelectOption(ep.Product__r.Produktfamilie__c,ep.Product__r.Produktfamilie__r.Name));
                            //prodFamily_Map.put(ep.Product__r.Produktfamilie__c,ep.Product__r.Produktfamilie__r.Name);
                            options.add(new SelectOption(ep.Service_Product__r.Produktfamilie__c,ep.Service_Product__r.Produktfamilie__r.Name));
                            prodFamily_Map.put(ep.Service_Product__r.Produktfamilie__c,ep.Service_Product__r.Produktfamilie__r.Name);
                        }
                    }
                    //else if((!prodFamily_Map.containsKey(ep.Product__c)) && (ep.Product__c != null))
                    else if((!prodFamily_Map.containsKey(ep.Service_Product__c)) && (ep.Service_Product__c != null))
                    {
                        //options.add(new SelectOption(ep.Product__c,ep.Product__r.Name));
                        //prodFamily_Map.put(ep.Product__c,ep.Product__r.Name);
                        options.add(new SelectOption(ep.Service_Product__c,ep.Service_Product__r.Name));
                        prodFamily_Map.put(ep.Service_Product__c,ep.Service_Product__r.Name);
                    }
                }

                //If there is only one Product Family - system will automatically select it
                if(options.size() == 2)
                {
                    productFamily = options.get(1).getValue();
                }
            } 
            else 
            {
                //options.add(new SelectOption('NO_PRODUKT_FAM','Ingen produkt'));
                //csphase2 supriya 26122016
                options.add(new SelectOption('NO_PRODUKT_FAM',System.label.cs_No_Product));
                productFamily = 'NO_PRODUKT_FAM';
            }
        }
        return options;
    }
    
    
    // PRODUCT LIST
    // A SOQL search on the Code_Event_Prod (junction object between event and product) is done which finds all 
    // relations between the chosen event and product where isActive is true
    public list<SelectOption> getProductOpts()
    {
        list<SelectOption> options = new list<SelectOption>();
        prod_Map = new Map<String,String>();
        
        if(productFamily == null || productFamily == 'NA')
        {
            //options.add(new SelectOption('NA','--Ingen valg tilgjengelige--'));
              //csphase2 supriya 26122016
              options.add(new SelectOption('NA','--'+ System.Label.cs_No_choice_available+'--'));
            productId = 'NA';
        }
        else 
        {
                /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
            list<Code_Event_Prod__c> eventProductList = [SELECT Code_event__c, 
                                                                Product__c, 
                                                                Product__r.Name, 
                                                                Service_Product__c,  //Added for Sales
                                                                Service_Product__r.Name,   //Added for Sales
                                                                Id, 
                                                                IsActive__c 
                                                           FROM Code_Event_Prod__c 
                                                          WHERE IsActive__c = true 
                                                            AND Code_event__c = :eventId 
                                                            AND Service_Product__r.Produktfamilie__c =:productFamily  //Added for Sales
                                                       order by Service_Product__r.Name asc];  //Added for Sales
                                            
            if(eventProductList.size() > 0)
            {
                //options.add(new SelectOption('NA','--Velg Produkt--'));
                //Csphase2 Supriya26122016
                options.add(new SelectOption('NA',System.label.cs_SelectProduct));
                        
                if(productId == 'NO_PRODUKT')
                {
                    productId = 'NA';
                }
                
                //If there is only one Product - system will automatically select it
                if(eventProductList.size() == 1)
                {
                    productId = eventProductList.get(0).Service_Product__c;
                }

                for(Code_Event_Prod__c ep: eventProductList)
                {
                    if((!prod_Map.containsKey(ep.Service_Product__c)) && (ep.Service_Product__c != null))
                    {
                      options.add(new SelectOption(ep.Service_Product__c,ep.Service_Product__r.Name));
                      prod_Map.put(ep.Service_Product__c,ep.Service_Product__r.Name);
                    }
                }
            }
            else
            {
                //options.add(new SelectOption('NO_PRODUKT','Ingen tilgjengelige'));
                 //Csphase2 Supriya26122016
                options.add(new SelectOption('NO_PRODUKT',System.Label.cs_None_available));
                productId = 'NO_PRODUKT';
            }
        }
        return options;
    }



    //Reason 1 object
    // A SOQL search on the CodeProdReason__c (junction object between product and reason1) is done which finds all 
    // relations between the chosen product and reason1 where isActive is true.
    public list<SelectOption> getReason1Opts()
    {
        list<SelectOption> options = new list<SelectOption>();
        reason1_Map = new Map<String,String>();
        
        if(productFamily == null || productFamily == 'NA')
        {
          //options.add(new SelectOption('NA','--Ingen valg tilgjengelige--'));
           //Csphase2 Supriya26122016
          options.add(new SelectOption('NA','--'+ System.Label.cs_No_choice_available+'--'));
          reason1Id = 'NA';
        } 
        else
        {
            list<CodeProdReason__c> prodReason1List = new list<CodeProdReason__c>();
          
            if(productId == null || productId == 'NA' || productId == 'NO_PRODUKT')
            {
                prod_Map.put(productFamily,prodFamily_Map.get(productFamily));
            /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
                prodReason1List = [SELECT Product__c, 
                                                                        Service_Product__c,
                                                        Code_reason1__c, 
                                                        Code_reason1__r.Name, 
                                                        Id, 
                                                        IsActive__c 
                                                                FROM CodeProdReason__c 
                                                                WHERE IsActive__c = true
                                                        AND Service_Product__c IN :prod_Map.keySet()
                                                        AND Henvendelsestype__c = :eventId
                                                                ORDER BY Code_reason1__r.Name asc];

            }
            else
            {
                /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
                prodReason1List = [SELECT Product__c, 
                                                Service_Product__c,
                               Code_reason1__c, 
                               Code_reason1__r.Name, 
                               Id, 
                               IsActive__c 
                           FROM CodeProdReason__c 
                          WHERE IsActive__c = true
                            AND Service_Product__c = :productId 
                            AND Henvendelsestype__c = :eventId
                           ORDER BY Code_reason1__r.Name asc];
            }
        
            //Product view in options box
            if(prodReason1List.size() > 0)
            {
                //options.add(new SelectOption('NA','--Velg årsak 1--'));
                //csphase2 supriya 26122016
                options.add(new SelectOption('NA','--'+System.label.cs_Select_reason_1+'--'));
                
                if(reason1Id == 'NO_REASON1'){ reason1Id = 'NA'; }

                //if there is only one option for Arsak1, system will automatically select that
                if(prodReason1List.size() == 1)
                {
                    reason1Id = prodReason1List.get(0).Code_reason1__c;
                }

                for(CodeProdReason__c pr: prodReason1List)
                {
                    if(pr.Code_reason1__c != null)
                    {
                        if(!reason1_Map.containsKey(pr.Code_reason1__c))
                        {
                            options.add(new SelectOption(pr.Code_reason1__c,pr.Code_reason1__r.Name));
                            reason1_Map.put(pr.Code_reason1__c,pr.Code_reason1__r.Name);    
                        }
                    }
                }
            } 
            else 
            {
                //options.add(new SelectOption('NO_REASON1','Ingen årsak'));
                //csphase2 Supriya 26122016
                options.add(new SelectOption('NO_REASON1',System.Label.cs_No_reason1));
                
                reason1Id = 'NO_REASON1';
            }
        }
    
    return options;
    }



    //Reason 2 object
    // A SOQL search on the Code_Reason_12__c (junction object between reason1 and reason2 ) is done which finds all 
    // relations between the chosen reason1 and reason2 where isActive is true.
    public list<SelectOption> getReason2Opts()
    {
        list<SelectOption> options = new list<SelectOption>();
        if(reason1Id == null || reason1Id == 'NA')
        {
            //options.add(new SelectOption('NA','--Ingen valg tilgjengelige--'));
            //Csphase2 Supriya26122016
            options.add(new SelectOption('NA','--'+ System.Label.cs_No_choice_available+'--'));
            reason2Id = 'NA';
        } 
        else if(reason1Id == 'NO_REASON1')
        {
            //options.add(new SelectOption('NO_REASON2','Ingen årsak'));
            //csphase2 Supriya 26122016
            options.add(new SelectOption('NO_REASON2',System.Label.cs_No_reason1));
            reason2Id = 'NO_REASON2';
        } 
        else 
        {
                /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
            list<Code_Reason_12__c> reason12List = [SELECT Code_reason1__c, 
                                                           Code_Reason2__c, 
                                                           Code_Reason2__r.Name, 
                                                           Id, 
                                                           IsActive__c ,
                                                           Service_Product__c
                                                      FROM Code_Reason_12__c 
                                                     WHERE IsActive__c = true
                                                       AND Service_Product__c = :productId
                                                       AND Code_reason1__c = :reason1Id 
                                                  order by Code_Reason2__r.Name asc];
                                                  
            //Reason 2 view in options box
            if(reason12List.size() > 0)
            {
                //options.add(new SelectOption('NA','--Velg årsak 2--'));
                //csphase2 Supriya 26122016
                 options.add(new SelectOption('NA','--'+System.label.cs_Select_reason_2+'--'));
                if(reason2Id =='NO_REASON2')reason2Id = 'NA';


                //if there is only one option for Arsak2, system will automatically select that
                if(reason12List.size() == 1)
                {
                    reason2Id = reason12List.get(0).Code_Reason2__c;
                }
                
                for(Code_Reason_12__c r12: reason12List)
                {
                    if(r12.Code_reason2__c != null)
                    {
                        options.add(new SelectOption(r12.Code_Reason2__c,r12.Code_Reason2__r.Name));    
                    }
                }
            } 
            else 
            {
              // options.add(new SelectOption('NO_REASON2','Ingen årsak'));
             //csphase2 Supriya 26122016
            options.add(new SelectOption('NO_REASON2',System.Label.cs_No_reason1));
             
                reason2Id ='NO_REASON2';
            }
        }
        
        return options;
    }

    
    public PageReference saveCase() 
    {
        // Reset messages every time the save-button is clicked
        noEventMsg = null;
        noProductMsg = null;
        noReason1Msg = null;
        noReason2Msg = null;
        noOldOrderNum = null;
        noNewOrderNum = null;
        
        //Checking Event Id Selection
        if(eventId == null || eventId == 'NA')
        {
            noEventMsg = System.Label.cs_EnquiryError;
            return null;
        } 
        else
        {
            c.Code_Event__c = eventId;
            c.Category__c = eventCode_Map.get(eventId);         //Setting up the old Category field
            eventName = c.Category__c;
        }
        
         
        //Checking Product Selection
        if(productFamily == null || productFamily == 'NA' || productFamily == 'NO_PRODUKT_FAM')
        {
            //noProductMsg = 'Error: Vennligst velg produkt familie';
            //CsPhase2 Supriya 26122016 
            noProductMsg = System.Label.cs_Select_service_family;
            return null;
        }
        else
        {
            if(productId == null || productId == 'NA' || productId == 'NO_PRODUKT')
            {
               // noProductMsg = 'Error: Vennligst velg produkt';
                 //CsPhase2 Supriya 26122016 
                 noProductMsg = System.Label.cs_select_product_error;
                return null;
            }
            else
            {
                c.Service_Product__c = productId;
                
                if(prod_Map.containsKey(productId))
                    c.Produkt__c = prod_Map.get(productId);             //Setting up the old Product Field
            }
        }
        
        
        //Checking selection in Reason 1
        if((reason1Id == null || reason1Id == 'NA') && (!eventName.toLowerCase().contains('ingen gjenligg')))
        {
            //noReason1Msg = 'Error: Vennligst velg årsak';
            //CsPhase2 Supriya 26122016 
            noReason1Msg = System.Label.cs_Select_reason_error;
            return null;
        } 
        else
        {
            if(reason1Id == 'NA' || reason1Id == 'NO_REASON1')
            {
                c.Code_Reason1__c = null;
                c.reason__c = '';
            }
            else
            {
                c.Code_Reason1__c = reason1Id;

                if(reason1_Map.containsKey(reason1Id))
                    c.reason__c = reason1_Map.get(reason1Id);   
            }
        }
        
        
        //Checking selection in Reason 2 - This field is not mandatory
        if(reason2Id == null || reason2Id == 'NA' || reason2Id == 'NO_REASON2')
        {
            c.Code_Reason2__c = null;
        }
        else
        {
            c.Code_Reason2__c = reason2Id;
        }
        
        
        
        //Validating fields
        if(isValidFields() == false) 
        {
             return null;
        }
        
        //Set basic values
        if(pu.name != null || String.isNotBlank(pu.name))
        {
            c.Created_by_Unit__c = setPostalUnit(pu);
        }
        if(pu_to_blame.name != null || String.isNotBlank(pu_to_blame.name))
        {
            c.unit_to_blame__c = setPostalUnit(pu_to_blame);
        }
        
        c.AccountId = setAccount();
        c.Origin = 'Lightuser';
        
        // Add additional description for Henvendelsestype: Avvik som skal krediteres
        // Gammelt Ordernummer: 'old_Order_Number'
        // Nytt Ordernummer: 'new_Order_Number'
        // The above text must be added before the description entered by the user
        if(c.Category__c.equalsIgnoreCase('avvik som skal krediteres'))
        {
            c.Description = System.Label.cs_OldOrderNumber + old_Order_Number + '\n'
                        + System.Label.cs_NewOrderNumber + new_Order_Number + '\n\n' + c.Description;
        }

        //Close criteria for Gjenligg
        if(c.RecordTypeId == gjenliggId && !(prod_Map.get(productId).toLowerCase().contains('postreklame uadressert') && (c.deviation_shipments_nmb__c >= 250 || c.deviation_nmb_households__c >= 250))) 
        {
            c.Status = 'Avsluttet';
            insert c;
        } 
        else if((c.RecordTypeId == deviationId) && c.Category__c.equalsIgnoreCase('avvik avdekket av bring express'))
        {
            c.Status = 'Avsluttet';//api name
            //Csphase2 Supriya 26122016
            //c.Status = 'Closed';
            Database.insert(c);
        }
        else 
        {
            Database.DMLOptions dml = new Database.DMLOptions();    
            dml.assignmentRuleHeader.useDefaultRule = true;
            database.insert(c, dml);
        }
        

        String partyNumber = ApexPages.currentPage().getParameters().get('partyId');
        
        if(partyNumber == null){
            return new PageReference('/Lightuser_CaseDetailView?id=' + c.id);
        }else{
            return new PageReference('/Lightuser_CaseDetailView?id=' + c.id + '&partyid=' + partyNumber);
        }
    }
    
    
    
    
    
    //This function will validate all the fields based on the record types under various scenarios
    public Boolean isValidFields() 
    {
        Boolean validFields = true;
        
        //Check if the name of the user is updated
        if((c.Created_by_Name__c == null)||(c.Created_by_Name__c.trim() == ''))
        {
            //c.Created_by_Name__c.addError('Skriv inn ditt navn');
             //Csphase2 Supriya 26122016
              c.Created_by_Name__c.addError(System.Label.cs_Enter_your_name);
           
            validFields = false;
        }
        
        //Check if the Postal Unit selected is Valid
        if(!isPostalUnitValid(pu)) {
           // pu.Name.addError('Ugyldig enhetsnummer/navn');
            //Csphase2 Supriya 26122016
             pu.Name.addError(System.Label.cs_Invalid_device_number_name);
            validFields = false;
        }
        
        //Check if the Postal Unit selected in the field "Sak relatert til enhet" is Valid    
        if(String.isNotBlank(pu_to_blame.Name) && !isPostalUnitValid(pu_to_blame)) {
            //pu_to_blame.Name.addError('Ugyldig enhetsnummer/navn');
             //Csphase2 Supriya 26122016
             pu_to_blame.Name.addError(System.Label.cs_Invalid_device_number_name);
            validFields = false;
        }
        
        if(c.RecordTypeId == KatsUtilities.getRecordType('deviation_case') && c.deviation_time_of_incident__c == null) {
            //c.deviation_time_of_incident__c.addError('Legg inn dato for når avviket oppstod');
             //Csphase2 Supriya 26122016
            c.deviation_time_of_incident__c.addError(System.Label.cs_enter_date_when_error_occured);    
            validFields = false;
        }
        
        //Checks if the Record type is Gjenligg and the Category is not 'Ingen gjenligg' or 'feil eller mangler i postadressen' then the Tiltak field must be updated
        if((c.RecordTypeId == gjenliggId) && (!eventName.toLowerCase().contains('ingen gjenligg')) && (!eventName.toLowerCase().contains('feil eller mangler i postadressen')) && String.isBlank(c.measures__c)) 
        {
        
           //c.measures__c.addError('Legg inn tiltak');
           //csphase2 Supriya 26122016
           c.measures__c.addError(System.Label.cs_Submit_measures);
           
            validFields = false;
        }

        //Checks if the Record Type is Gjenligg and the word 'Distribution' exists in Henvendelsestype or 'Omdelt etter frist'
        if((c.RecordTypeId == gjenliggId) && String.isBlank(c.deviation_route__c) && !KatsUtilities.IsEmpty(eventName) && (eventName.toLowerCase().contains('distribusjon') || eventName.toLowerCase().contains('omdelt etter frist')) )
        {
            //c.deviation_route__c.addError('Rute mangler');
             //csphase2 Supriya 26122016
            c.deviation_route__c.addError(System.Label.cs_Route_missing);
            validFields = false;
        }

        //Checks if the Henvendelsestype is set as 'Avvik som skal krediteres' and 
        //if the two fields 'Ordrenummer med feil*' and 'Riktig ordrenummer*' are updated (mandatory)
        //Both the field should be Numeric
        if(eventName.toLowerCase().contains('avvik som skal krediteres') && ((old_Order_Number == '') || (!old_Order_Number.isNumericSpace())))
        {
            noOldOrderNum = Label.Lightuser_Empty_Field;
            validFields = false;
        }
        if(eventName.toLowerCase().contains('avvik som skal krediteres') && ((new_Order_Number == '') || (!new_Order_Number.isNumericSpace())))
        {
            noNewOrderNum = Label.Lightuser_Empty_Field;
            validFields = false;
        }

        //Checks if Category contains the word 'Distribusjon' - the following fields must be updated
        if((c.RecordTypeId == gjenliggId) && !KatsUtilities.IsEmpty(eventName) && eventName.toLowerCase().contains('distribusjon')) 
        {
        
            if(String.isBlank(c.deviation_postal_nmb_from__c)) 
            {
               // c.deviation_postal_nmb_from__c.addError('Postnummer mangler');
                //csphase2 Supriya 26122016
               c.deviation_postal_nmb_from__c.addError(System.Label.cs_Zipcode_missing);
               
                validFields = false;
            }
            else if(c.deviation_postal_nmb_from__c.trim().length() != 4)
            {
               //c.deviation_postal_nmb_from__c.addError('Postnummer må ha 4 tegn');
                 //csphase2 Supriya 26122016
                c.deviation_postal_nmb_from__c.addError(System.Label.cs_Zipcode_4_chars);
                
                validFields = false;
            }
            else if(!c.deviation_postal_nmb_from__c.trim().isNumeric())
            {
            
                //c.deviation_postal_nmb_from__c.addError('Legg inn kun nummer verdier');
                 //csphase2 Supriya 26122016
                c.deviation_postal_nmb_from__c.addError(System.Label.cs_Submit_only_number_values);
                
                
                validFields = false;
            }
            if(String.isBlank(c.deviation_postal_nmb_to__c)) 
            {
                //c.deviation_postal_nmb_to__c.addError('Postnummer mangler');
                  //csphase2 Supriya 26122016
               c.deviation_postal_nmb_from__c.addError(System.Label.cs_Zipcode_missing);
                validFields = false;
            }
            else if(c.deviation_postal_nmb_to__c.trim().length() != 4)
            {
                //c.deviation_postal_nmb_to__c.addError('Postnummer må ha 4 tegn');
                 //csphase2 Supriya 26122016
                c.deviation_postal_nmb_from__c.addError(System.Label.cs_Zipcode_4_chars);
                validFields = false;
            }
            else if(!c.deviation_postal_nmb_to__c.trim().isNumeric())
            {
                //c.deviation_postal_nmb_to__c.addError('Legg inn kun nummer verdier');
                 //csphase2 Supriya 26122016
                c.deviation_postal_nmb_from__c.addError(System.Label.cs_Submit_only_number_values);
                
                validFields = false;
            }
            if(c.deviation_nmb_households__c == null) 
            {
               // c.deviation_nmb_households__c.addError('Antall mangler');
               //Csphase2 Supriya 27122016
               c.deviation_nmb_households__c.addError(System.Label.cs_Missing_number);
                validFields = false;
            }
            if(String.isBlank(c.deviation_affected_address__c) && !eventName.toLowerCase().contains('gjenligg')) 
            {
                //c.deviation_affected_address__c.addError('Adresse mangler');
                //Csphase2 Supriya 27122016
                c.deviation_affected_address__c.addError(System.label.cs_Missing_address);
                validFields = false;
            } 
        }
       
        //Checks if Category contains the word 'Terminal' - the following fields must be updated
        if((c.RecordTypeId == gjenliggId) && !KatsUtilities.IsEmpty(eventName) && eventName.toLowerCase().contains('ruteklargjøring')) 
        { 
            if(String.isBlank(c.Letter_priority__c)) 
            {
                //c.Letter_priority__c.addError('Strøm mangler');
                //Csphase2 Supriya 27122016
                c.Letter_priority__c.addError(System.label.cs_power_missing);
                validFields = false;
            }

            if(String.isBlank(c.deviation_depature_spread__c)) 
            {
                //c.deviation_depature_spread__c.addError('Avgang/Spredning mangler');
                 //Csphase2 Supriya 27122016
                 c.deviation_depature_spread__c.addError(System.label.cs_Departure_Spread_missing);
                validFields = false;
            }

            if(c.deviation_shipments_nmb__c == null) 
            {
                //c.deviation_shipments_nmb__c.addError('Antall – sendinger mangler');
                 //Csphase2 Supriya 27122016
                c.deviation_shipments_nmb__c.addError(System.Label.cs_Number_broadcasts_missing);
                   
                validFields = false;
            }
        }
       
        if(String.isBlank(c.Description) && !KatsUtilities.IsEmpty(eventName) && (!eventName.toLowerCase().contains('ingen gjenligg')))
        {
            c.Description.addError('Saksbeskrivelse mangler');
             //Csphase2 Supriya 27122016
              c.Description.addError(System.Label.cs_Case_description_missing);
             
            validFields = false;
        }
        
       
        return validFields;
    }
    
    
    
    
    
    public boolean isPostalUnitValid(PostalUnit__c pu) 
    {
        String unitName;
        if(String.isBlank(pu.name))
            return false;
        else
            unitName = pu.Name.trim();
        
        Integer i = [SELECT COUNT() FROM PostalUnit__c where Name = :unitName];
        
        if(i == 1) 
        {
            return true;
        } 
        else 
        {
            return false;
        }
    }
    
    
    public Id setPostalUnit(PostalUnit__c pu) 
    {
        Id unitId;
        try 
        {
            if(String.isNotBlank(pu.Name)) 
            {
                String unitName = pu.Name.trim();
                unitId = [SELECT id FROM PostalUnit__c WHERE Name = :unitName LIMIT 1].id;
            }  
            if(unitId==null)
            {            
                //c.Description = 'Forsøkte å registrere ' + pu.Name + ' på Reg. av enhet i Lightbrukeren\n' + c.Description;
                 //Csphase2 Supriya 27122016
                 c.Description = System.Label.cs_Attempted_to_register + pu.Name +  System.Label.cs_reg_unity_light_user+ '\n' + c.Description;
            }
        } 
        catch(QueryException e) 
        {
           // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Noe gikk galt under lagring av enhet'));
              KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_something_went_wrong_while_saving_device));
          
             //Csphase2 Supriya 27122016
           // c.Description = 'Forsøkte å registrere ' + pu.Name + ' på Reg. av enhet i Lightbrukeren, men noe gikk galt\n' + c.Description;
            
          c.Description = System.Label.cs_Attempted_to_register + pu.Name +  System.Label.cs_reg_unity_light_user+ System.Label.cs_Somethingwent_wrong_during_the_update + '\n' + c.Description;
            return null;
        }
        return unitId;
    }
    
    public Id setAccount() 
    {
        Id accountId;
        try 
        {  
            if(String.isNotBlank(customerNumber)) 
            {
                accountId = [SELECT Id FROM Account WHERE crm_customer_number__c= :customerNumber LIMIT 1].Id;
            }
        } 
        catch(QueryException e) 
        {
            if(c.AccountId == null) 
            {
                if(customerNumber != null && customerNumber != '') 
                {
                    //c.Description = 'Kunde med følgende kundenummer ble ikke funnet i KATS da saken ble registrert av Lightbruker ' + customerNumber + '\n' + c.Description;
                     //Csphase2 Supriya 27122016
                      c.Description = System.Label.cs_customer_not_found + customerNumber + '\n' + c.Description;
                }
            }
        }
        return accountId;
    }
}