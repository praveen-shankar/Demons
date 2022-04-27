public with sharing class opportunityToQuotesCreate {
    public static quote quote_pass ;
    public static boolean qutcheck_stat ;
    public static boolean qut_stat ;
    public static boolean qutline_stat ;
    public static string opp_Id ;
    /*
      Below methods verify any related Quote exist or not .
      In case no Quote then create new Quote and Quote line item in correspondence
      In case a Quote Exist then Message display and says Quote exist
    */
    @AuraEnabled
    public static oppAndLineitem getOpprtunityCheck(string oppid) {
        boolean quoteAvailable = null;
        list < quote > qtlcheck = new list < quote > ();
        oppAndLineitem opptyQuote_stat = new oppAndLineitem();
        if (!string.isBlank(oppid)) {
            opportunityToQuotesCreate.opp_Id = oppid;
            qtlcheck = [select id from quote where OpportunityId =: oppid limit 1];
            if (qtlcheck.size() == 0 || qtlcheck == null) {
                opptyQuote_stat.qutcheck = true;
                createQuoteAndLineitem(oppid);
            } else {
                qutcheck_stat = false;
            }
        }
        
        opptyQuote_stat.qutcheck = qutcheck_stat;
        opptyQuote_stat.qut = qut_stat;
        opptyQuote_stat.qutline = qutline_stat;
        
        return opptyQuote_stat;
    }

    /*
    call Below method to create quote and quotelineitem from opportunity correspondence
   */
    @AuraEnabled
    public static void createQuoteAndLineitem(string oppid) {
        opportunity op = new opportunity();
        list < OpportunityLineItem > oppLI = new list < OpportunityLineItem > ();
        list < quote > qtlcheck = new list < quote > ();

        op = [select id, name from opportunity where id =: oppid];
        oppLI = [select id, PricebookEntryId, Product2Id, Quantity, UnitPrice, Discount ,ProductCode ,  
        crm_Product_Name__c , crm_Minimum_Price__c , crm_Free_Pickup__c	, crm_Passive_Return__c , crm_Min_Weight__c , 
        crm_Max_Weight__c ,crm_Local__c , crm_Conversion_Factor__c , crm_lineItemsGroupId__c,IsPayerReceiverorSender__c , ListPrice , 
                 crm_Terminals__c , crm_Direction__c
            from OpportunityLineItem where OpportunityId =: oppId
        ];
/*
  Create Quote record based on opportunity record passed to method
*/
        if (op != null) {
            quote_pass = createquoterec(op);
        }
/*
 Create Quote Line record based on opportunity record childs  - Opportunity Line items
*/
        if (oppLI.size() > 0) {
            createquoteLineItemrec(oppLI, quote_pass);
        }
    }
    /*
    Create quote record from opportunity
    */
    public static quote createquoterec(opportunity opp) {

        quote qt_new = new quote() ;
        //qt_new.OpportunityId = opp.id ;
        qt_new.OpportunityId = opp_Id ;
        qt_new.Name =  opp.Name + ' - Quote' ;
        qt_new.Quote_Version__c = 0 ;
        try {
            insert qt_new ;
            quote_pass = qt_new ;
            qut_stat = true ;
        } catch (exception e) {

        }
        return qt_new ;
    }

    /*
  Create Quote line item record from opportunity line item records 
   */
    public static void createquoteLineItemrec(list < OpportunityLineItem > oLI, quote q) {
        list < QuoteLineItem > qtlitem = new list < QuoteLineItem > ();
        for (OpportunityLineItem ol_loc: oLI) {
            QuoteLineItem loc_loc1 = new quoteLineItem() ;
            loc_loc1.QuoteId = q.Id ;
            loc_loc1.PricebookEntryId = ol_loc.PricebookEntryId ;
            loc_loc1.Product2Id = ol_loc.Product2Id ;
            loc_loc1.Quantity = ol_loc.Quantity ;
            loc_loc1.UnitPrice = ol_loc.UnitPrice ;
            loc_loc1.Discount = ol_loc.Discount ;
            loc_loc1.OpportunityLineItemId = ol_loc.id ;
            loc_loc1.crm_Free_PickUp__c = ol_loc.crm_Free_Pickup__c ;
            loc_loc1.Passive_Return__c = ol_loc.crm_Passive_Return__c ;
            loc_loc1.crm_Max_Weight__c = ol_loc.crm_Max_Weight__c ;
            loc_loc1.crm_Min_Weight__c = ol_loc.crm_Min_Weight__c ;
            loc_loc1.crm_Local__c = ol_loc.crm_Local__c ;
            loc_loc1.crm_Conversion_Factor__c = ol_loc.crm_Conversion_Factor__c ;
            loc_loc1.IsPayerReceiverorSender__c = ol_loc.IsPayerReceiverorSender__c ;
            loc_loc1.crm_Terminals__c = ol_loc.crm_Terminals__c ;
            loc_loc1.crm_Direction__c = ol_loc.crm_Direction__c ;
            loc_loc1.Group_Line_Item_Id__c =ol_loc.crm_lineItemsGroupId__c;
            //loc_loc1.CurrencyIsoCode = ol_loc.CurrencyIsoCode ;
            qtlitem.add(loc_loc1);

        }
        try {
            if (qtlitem.size() > 0) {
                insert qtlitem;
                qutline_stat = true;
            }
        } catch (exception ex) {

        }
    }

    // @AuraEnabled(cacheable=true)
    public class oppAndLineitem {
        // @AuraEnabled
        @AuraEnabled
        public boolean qutcheck;
        @AuraEnabled
        public boolean qut;
        // @AuraEnabled(cacheable=true)
        @AuraEnabled
        public boolean qutline;
    }
}