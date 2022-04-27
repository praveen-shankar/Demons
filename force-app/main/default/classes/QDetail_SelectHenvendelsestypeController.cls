public class QDetail_SelectHenvendelsestypeController
{
    public QueueDetails__c qd {get; set;}

    // Private Variables
    private String recordtypename {get; set;}   // This variable will hold the Record Type name

    // public Hendelsestype__c hendvalue {get;set;}
    public String eventId {get;set;}
    public String productFamily {get;set;}
    public String productId {get;set;}
    public String reason1Id {get;set;}
    public String reason2Id {get;set;}

    // Maps to hold Values of the fields
    private Map<String,String> eventCode_Map {get; set;}
    private Map<String,String> prodFamily_Map {get; set;}
    private Map<String,String> prod_Map {get; set;}
    private Map<String,String> reason1_Map {get; set;}
    private Map<String,String> reason2_Map {get; set;}

    // This boolean variable is to control the visibility of Detail section and Edit Section
    public Boolean viewCatSec {get; set;}               
   
    public QDetail_SelectHenvendelsestypeController(ApexPages.StandardController stc)
    {
        //Setting the default view to Closed Edit section and no Record type changes
        viewCatSec = true;
        recordtypename = '';

        if(!Test.isRunningTest())
        {
                /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
            stc.addFields(new List<String>{ 'Product__c',
                                            'Product__r.Produktfamilie__c',
                                            'Service_Product__c',
                                            'Service_Product__r.Produktfamilie__c',
                                            'Code_Reason1__c',
                                            'Code_Reason2__c',
                                            'Code_Event__c',
                                            'Def_Rec_Type__c'
                                          });
        }

        qd = (QueueDetails__c)stc.getRecord();

        if(qd.Code_Event__c != null)
        {
            this.eventId = qd.Code_Event__c;
        }

        if(qd.Service_Product__r.Produktfamilie__c != null) /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        {
            this.productFamily = qd.Service_Product__r.Produktfamilie__c;
        }

        if(qd.Service_Product__c != null)
        {
            this.productId = qd.Service_Product__c;
        }

        if(qd.Code_Reason1__c != null)
        {
            this.reason1Id = qd.Code_Reason1__c;
        }


        if(qd.Code_Reason2__c != null)
        {
            this.reason2Id = qd.Code_Reason2__c;
        }

        // Checking for default Record Type
        if(qd.Def_Rec_Type__c != null)
        {
            this.recordtypename = qd.Def_Rec_Type__c;
        }


        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,System.Label.cs_QDetailsMessage1));
    }


    //EDIT EVENT, PRODUCT AND REASONS SECTION VISIBILITY TOGGLE
    //This function will show/hide the detail section and open the edit section for the user to edit.
    public void toggleCategorySec()
    {
        if(viewCatSec == true)
        {
            viewCatSec = false;
        }
        else
        {
            viewCatSec = true;
        }
         
    }




    // Henvendelsestype object - CODE EVENT LIST
    // A SOQL search directly on the Code_event object is done to find possible values for the picklist
    public list<SelectOption> getEventOpts()
    {
        list<SelectOption> options = new list<SelectOption>();
        eventCode_Map = new Map<String, String>();
        list<Code_Event__c> eventList = new list<Code_Event__c>();    


        options.add(new SelectOption(System.Label.cs_NA,System.Label.cs_SelectEnqTyp));

        // If a Default Record Type is selected, The Code_Event list must be limited
        if(recordtypename != '')
        {
            eventList = [SELECT Id, Name, isActive__c 
                                           FROM Code_Event__c 
                                          WHERE isActive__c = true 
                                            AND CaseTypeMultiselect__c INCLUDES (:recordtypename)
                                       ORDER BY Name asc];
    

        }
        // If no Default is Selected, All the Code_Event values must be provided in the List
        else
        {
            eventList = [SELECT Id, Name, isActive__c 
                                           FROM Code_Event__c 
                                          WHERE isActive__c = true 
                                       ORDER BY Name asc];    
        }
        
    
        for(Code_Event__c e : eventList)
        {
            options.add(new SelectOption(e.Id,e.Name));
            eventCode_Map.put(e.Id,e.Name);
        }
                
        return options;
    }

    // PRODUCT FAMILY LIST
    // Product Family is picked up from all the Products in Scope
    // If there is a link between the Code Event and a Product Family directly (instead of a Product), its also picked up
    public list<SelectOption> getProductFamiliesOpts()
    {
        list<SelectOption> options = new list<SelectOption>();
        prodFamily_Map = new Map<String,String>();  
        
        //Check if the Code Event is selected
        if(eventId == null || eventId == System.Label.cs_NA)
        {
            options.add(new SelectOption(System.Label.cs_NA,System.Label.cs_NoChoiceAvailable));
            productFamily = System.Label.cs_NA;
        } 
        else 
        {
                /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
            list<Code_Event_Prod__c> eventProductList = [SELECT Product__c, Product__r.Name, Product__r.Produktfamilie__c, Product__r.Produktfamilie__r.Name ,
                                                                                                                Service_Product__c, Service_Product__r.Name, Service_Product__r.Produktfamilie__c, Service_Product__r.Produktfamilie__r.Name 
                                          FROM Code_Event_Prod__c 
                                         WHERE IsActive__c = true 
                                           AND Code_event__c =: eventId 
                                      ORDER BY Service_Product__r.Produktfamilie__r.Name asc];
            
            if(eventProductList.size() > 0)
            {
                options.add(new SelectOption(System.Label.cs_NA,System.Label.cs_SelectProduct));
            
                if(productFamily == System.Label.cs_NO_PRODUKT)
                {
                    productFamily = System.Label.cs_NA;
                }

                
                for(Code_Event_Prod__c ep: eventProductList)
                {
                    if(ep.Service_Product__r.Produktfamilie__c != null) /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
                    {
                        if(!prodFamily_Map.containsKey(ep.Service_Product__r.Produktfamilie__c))
                        {
                                /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
                            options.add(new SelectOption(ep.Service_Product__r.Produktfamilie__c,ep.Service_Product__r.Produktfamilie__r.Name));
                            prodFamily_Map.put(ep.Service_Product__r.Produktfamilie__c,ep.Product__r.Produktfamilie__r.Name);
                        }
                    }
                    else if((!prodFamily_Map.containsKey(ep.Service_Product__c)) && (ep.Service_Product__c != null))
                    {
                        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
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
                options.add(new SelectOption(System.Label.cs_NO_PRODUKT_FAM,System.Label.cs_None_available));
                productFamily = System.Label.cs_NO_PRODUKT_FAM;
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
        
        if(productFamily == null || productFamily == System.Label.cs_NA)
        {
            options.add(new SelectOption(System.Label.cs_NA,System.Label.cs_No_choice_available));
            productId = System.Label.cs_NA;
        } 
        else 
        {
                /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
            list<Code_Event_Prod__c> eventProductList = [SELECT Code_event__c, 
                                                                Product__c, 
                                                                Product__r.Name, 
                                                                Service_Product__c,
                                                                Service_Product__r.Name,
                                                                Id, 
                                                                IsActive__c 
                                                           FROM Code_Event_Prod__c 
                                                          WHERE IsActive__c = true 
                                                            AND Code_event__c = :eventId 
                                                            AND Service_Product__r.Produktfamilie__c =:productFamily 
                                                       ORDER BY Service_Product__r.Name asc];
            System.debug('=========productFamily'+productFamily);
            System.debug('=========eventId'+eventId);
            
            if(eventProductList.size() > 0)
            {
                options.add(new SelectOption(System.Label.cs_NA,'--'+System.Label.cs_Select_Product+'--'));
                                    
                if(productId == System.Label.cs_NO_PRODUKT)
                {
                    productId = System.Label.cs_NA;
                }

                //If there is only one Product - system will automatically select it
                if(eventProductList.size() == 1)
                {
                    productId = eventProductList.get(0).Service_Product__c; /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
                }
                
                for(Code_Event_Prod__c ep: eventProductList)
                {
                    if((!prod_Map.containsKey(ep.Service_Product__c)) && (ep.Service_Product__c != null))
                    {
                        options.add(new SelectOption(ep.Service_Product__c,ep.Service_Product__r.Name)); /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
                        prod_Map.put(ep.Service_Product__c,ep.Service_Product__r.Name);
                    }
                }
            }
            else
            {
                options.add(new SelectOption(System.Label.cs_NO_PRODUKT,System.Label.cs_None_available));
                productId = System.Label.cs_NO_PRODUKT;
            }
            
        }
        
        return options;
    }


    // REASON 1
    // A SOQL search on the CodeProdReason__c (junction object between product and reason1) is done which finds all 
    // relations between the chosen product and reason1 where isActive is true.
    public list<SelectOption> getReason1Opts()
    {
        list<SelectOption> options = new list<SelectOption>();
        reason1_Map = new Map<String,String>();

        if(productId == null || productId == System.Label.cs_NA)
        {
            options.add(new SelectOption(System.Label.cs_NA,System.Label.cs_NoChoiceAvailable));
            reason1Id = System.Label.cs_NA;
        } 
        else
        {
            list<CodeProdReason__c> prodReason1List = new list<CodeProdReason__c>();
            
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
        
            //Product view in options box
            if(prodReason1List.size()>0)
            {
                options.add(new SelectOption(System.Label.cs_NA,'--'+System.Label.cs_Select_reason_1+'--'));
                if(reason1Id == System.Label.cs_NO_REASON_1)
                { 
                    reason1Id = System.Label.cs_NA; 
                }

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
                options.add(new SelectOption(System.Label.cs_NO_REASON_1,System.Label.cs_NoProblem));
                reason1Id = System.Label.cs_NO_REASON_1;
            }
        }
        
        return options;
    }





    // REASON 2
    // A SOQL search on the Code_Reason_12__c (junction object between reason1 and reason2 ) is done which finds all 
    // relations between the chosen reason1 and reason2 where isActive is true.
    public list<SelectOption> getReason2Opts()
    {
        list<SelectOption> options = new list<SelectOption>();
        reason2_Map = new Map<String,String>();

        if(reason1Id == null || reason1Id == System.Label.cs_NA)
        {
            options.add(new SelectOption(System.Label.cs_NA,System.Label.cs_NoChoiceAvailable));
            reason2Id = System.Label.cs_NA;
        } 
        else if(reason1Id == System.Label.cs_NO_REASON_1)
        {
            options.add(new SelectOption(System.Label.cs_NO_REASON2,System.Label.cs_NoProblem));
            reason2Id = System.Label.cs_NO_REASON2;
        } 
        else 
        {
            list<Code_Reason_12__c> reason12List = [SELECT Code_reason1__c, 
                                                           Code_Reason2__c, 
                                                           Code_Reason2__r.Name, 
                                                           Id, 
                                                           IsActive__c 
                                                      FROM Code_Reason_12__c 
                                                     WHERE IsActive__c = true 
                                                       AND Code_reason1__c = :reason1Id
                                                       AND Service_Product__c = :productId   /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
                                                  order by Code_Reason2__r.Name asc];
                                                  
            //Product view in options box
            if(reason12List.size() > 0)
            {
                options.add(new SelectOption(System.Label.cs_NA,'--'+System.Label.cs_Select_reason_2+'--'));
                if(reason2Id ==System.Label.cs_NO_REASON2)reason2Id = System.Label.cs_NA;

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
                        reason2_Map.put(r12.Code_reason2__c,r12.Code_reason2__r.Name);     
                    }
                }
            } 
            else 
            {
                options.add(new SelectOption(System.Label.cs_NO_REASON2,System.Label.cs_NoProblem));
                reason2Id =System.Label.cs_NO_REASON2;
            }
        }
        
        return options;
    }

    public void saveDefaults()
    {
        try
        {
            if(eventId != System.Label.cs_NA)
            {
                qd.Code_Event__c = eventId;
            }
            else
            {
                qd.Code_Event__c = null;
            }
            
            if(productId != System.Label.cs_NA && productId != System.Label.cs_NO_PRODUKT)
            {
                qd.Service_Product__c = productId;/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
            }
            else
            {
                qd.Service_Product__c = null; 
            }

            if(reason1Id != System.Label.cs_NA && reason1Id != System.Label.cs_NO_REASON_1)
            {
                qd.Code_Reason1__c = reason1Id;
            }
            else
            {
                qd.Code_Reason1__c = null;  
            }

            if(reason2Id != System.Label.cs_NA && reason2Id != System.Label.cs_NO_REASON2)
            {
                qd.Code_Reason2__c = reason2Id;
            }
            else
            {
                qd.Code_Reason2__c = null;  
            }

            Database.update(qd);
            viewCatSec = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,System.Label.cs_QDetailsMessage2));
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.cs_QDetailsMessage3 + e.getMessage()));
        }
    }

}