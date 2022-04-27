public with sharing class cloneQuoteAndQuoteLineItem {

    public static boolean abc1;
    public static boolean abc2;
    public static boolean abc3;
/*
     Method to call from LWC by passing quote id and create cloned version quote and Line Item records
*/ 
    @AuraEnabled
    public static quoteAndLineitem createQuoteAndLineItem(string quoted) {
        quote qt_var = new quote();
        list < quote > qt_var1 = new list < quote > ();
        quote qt_var_clone_Pass = new quote();
        list < QuoteLineItem > qtLi = new list < QuoteLineItem > ();

        quoteAndLineitem abc = new quoteAndLineitem();

        if (quoted != '' && quoted != null) {
            qt_var1 = [select id from quote where Quote__c =: quoted limit 1];
            if (qt_var1 != null && qt_var1.size() >= 0) {
                abc3 = true;
                abc.quote_cannotBeCloned = abc3;
            } else {
                abc3 = false;
                abc.quote_cannotBeCloned = abc3;
            }
            qt_var = [select id, Status, Name, Quote_Version__c, OpportunityId, Quote__c, Opportunity.name from quote where id =: quoted limit 1];
            if (qt_var != null) {
                qt_var_clone_Pass = createQuote(qt_var);
                abc.quote_cloned = abc1;
            }
            qtLi = [select id, QuoteId, PricebookEntryId, Product2Id, Quantity, UnitPrice, Discount , OpportunityLineItemId,
                    crm_Free_PickUp__c , Passive_Return__c , crm_Max_Weight__c , crm_Min_Weight__c , crm_Local__c ,
                    crm_Conversion_Factor__c , IsPayerReceiverorSender__c , crm_Terminals__c , crm_Direction__c
                from QuoteLineItem where QuoteId =: quoted
            ];
            if (qtLi.size() > 0 && qt_var != null) {
                createQuoteLineItem(qtLi, qt_var_clone_Pass);
                abc.quoteLine_cloned = abc2;
            }
        }
        // insert cloned Quote ends
        return abc;
    }
/*
    Create cloned Quote from current Quote
*/        
    public static quote createQuote(quote qt_var) {
        quote qt_cloned = new quote();
        list < QuoteLineItem > qtLi = new list < QuoteLineItem > ();
        // insert cloned Quote
        //qt_var.Status == 'Accepted'
        if (true) {
            decimal num = qt_var.Quote_Version__c + 1;
            qt_cloned.Name = 'Quote-' + qt_var.Opportunity.Name + ' V-' + string.valueof(num);
            qt_cloned.status = qt_var.Status;
            qt_cloned.OpportunityId = qt_var.OpportunityId;
            qt_cloned.Quote_Version__c = num;
            qt_cloned.Quote__c = qt_var.Id;
        }

        try {
            if (qt_cloned != null) {
                savepoint sp = Database.setSavepoint();
                insert qt_cloned;
                abc1 = true;
            }
        } catch (Exception e) {
            abc1 = false;
        }
        return qt_cloned;
    }
/*
    Create copy of QuoteLine item from existing Quote and attach or relate to new Quote
*/  
    public static string createQuoteLineItem(list < QuoteLineItem > abc, quote qq) {
        list < QuoteLineItem > qtLineItem = new list < QuoteLineItem > ();
        if (abc.size() > 0) {
            for (QuoteLineItem qli: abc) {

                QuoteLineItem qliLoc = new QuoteLineItem();

                qliLoc.QuoteId = qq.Id;
                qliLoc.PricebookEntryId = qli.PricebookEntryId;
                qliLoc.Product2Id = qli.Product2Id;
                qliLoc.Quantity = qli.Quantity;
                qliLoc.UnitPrice = qli.UnitPrice;
                qliLoc.Discount = qli.Discount;

                qliLoc.OpportunityLineItemId = qli.OpportunityLineItemId ;
                qliLoc.crm_Free_PickUp__c = qli.crm_Free_PickUp__c ;
                qliLoc.Passive_Return__c = qli.Passive_Return__c ;
                qliLoc.crm_Max_Weight__c = qli.crm_Max_Weight__c ;
                qliLoc.crm_Min_Weight__c = qli.crm_Min_Weight__c ;
                qliLoc.crm_Local__c = qli.crm_Local__c ;
                qliLoc.crm_Conversion_Factor__c = qli.crm_Conversion_Factor__c;
                qliLoc.IsPayerReceiverorSender__c = qli.IsPayerReceiverorSender__c ;
                qliLoc.crm_Terminals__c = qli.crm_Terminals__c ;
                qliLoc.crm_Direction__c = qli.crm_Direction__c ;
                
                qtLineItem.add(qliLoc);
            }
            try {
                if (qtLineItem.size() > 0) {
                    insert qtLineItem;
                    abc2 = true;
                }
            } catch (Exception e) {
                abc2 = false;
            }
        }
        return null;
    }
/*
   Wrapper class to save status of Quote Clone operations
*/
    public class quoteAndLineitem {
        @AuraEnabled
        public boolean quote_cloned;
        @AuraEnabled
        public boolean quote_cannotBeCloned;
        @AuraEnabled
        public boolean quoteLine_cloned;
    }

}