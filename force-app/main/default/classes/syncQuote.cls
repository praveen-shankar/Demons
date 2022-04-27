public class syncQuote {

    public static string opportunityIds = '';
    public static boolean quoteSync = false, quoteLineSync = false, quoteLineSyncDel = false;


    /* 
        Below Methods performs compare logics and also update , insert and Delete of Opportunity Line Item
    */
    @AuraEnabled
    public static syncquoteAndLineitem syncQuoteWithOpportunity(string quoted) {
        id oppid;
        syncquoteAndLineitem abc = new syncquoteAndLineitem();
        // Variables created below - Begins
        quote qut_Loc = new quote();
        list < quotelineitem > quoteLine_Loc = new list < quotelineitem > ();
        opportunity opp_loc = new opportunity();
        list < opportunityLineItem > oppLine_loc = new list < opportunityLineItem > ();
        // Variables created above - Ends
        if (!string.isBlank(quoted)) {
            qut_Loc = [select id, test_sync__c, OpportunityId from quote where id =: quoted limit 1];
            oppid = qut_Loc.OpportunityId;
            if (!string.isBlank(string.valueOf(qut_Loc.OpportunityId))) {
                opp_loc = [select id, test_sync_opp__c from opportunity where id =: qut_Loc.OpportunityId limit 1];
                system.debug('opp_loc.id----' + opp_loc.id );
                syncQuote.opportunityIds = opp_loc.Id;
            }
            boolean updte = false;
             syncQuoteOpportunity(qut_Loc, opp_loc);
            if (quoteSync) {
                quoteSync = false ;
                //opp_loc.test_sync_opp__c = 'abcdefgh' ;
                try {
                    system.debug('hello there---' + opp_loc );
                    update opp_loc;
                    syncQuote.quoteSync = true;
                } catch (exception e) {

                }
            }
            quoteLine_Loc = [select id, quote_opp_line_rel__c, Discount, Quantity, PricebookEntryId, Product2Id from quotelineitem where QuoteId =: qut_Loc.Id];
            oppLine_loc = [select id, crm_Discount__c, crm_Conversion_Factor__c, crm_Direction__c, crm_Free_Pickup__c, crm_lineItemsGroupId__c, OpportunityId, PricebookEntryId, Product2Id, opp_quote_line_rel__c, UnitPrice from opportunitylineitem where OpportunityId =: opp_loc.Id];
            /* 
              Below Method is called and Pass quote Line and Opportunity Line to Sync - Includes update , insert and Delete operations
             * */
            syncQuoteLineItemAndOpportunityLineItem(quoteLine_Loc, oppLine_loc, oppid);
        } else {
            // Error message in case no Quote Id found
        }
        abc.quote_sync = syncQuote.quoteSync;
        abc.quote_linesync = syncQuote.quoteLineSync;
        abc.oppLine_delete = syncQuote.quoteLineSyncDel;
        return abc;
    }
    /*
      Below Method is designed to SYNC Quote with Opportunity
    */
    public static boolean syncQuoteOpportunity(quote qq, opportunity opp) {
        //boolean updt = false;
        if (qq.test_sync__c != opp.test_sync_opp__c) {
            opp.test_sync_opp__c = qq.test_sync__c;
            //updt = true;
            quoteSync = true ;
        }
        return quoteSync;
    }
    /* 
      Below Method is designed to SYNC QuoteLine with OpportunityLine
     */
    public static void syncQuoteLineItemAndOpportunityLineItem(list < quotelineitem > ql, list < opportunitylineitem > ol, id opid) {
        map < string, opportunitylineitem > oppLine_map = new map < string, opportunitylineitem > ();
        map < string, quotelineitem > qtLine_map = new map < string, quotelineitem > ();
        set < string > oppLine_key = new set < string > ();
        set < string > qtLine_key = new set < string > ();
        list < opportunitylineitem > oppLineUpdate_upsrt = new list < opportunitylineitem > ();
        list < opportunitylineitem > oppLineUpdate_upd = new list < opportunitylineitem > ();
        list < opportunitylineitem > oppLineUpdate_ins = new list < opportunitylineitem > ();
        list < opportunitylineitem > oppLineUpdate_Del = new list < opportunitylineitem > ();

        for (opportunitylineitem ol_loc: ol) {
            oppLine_map.put(ol_loc.opp_quote_line_rel__c, ol_loc);
        }
        oppLine_key = oppLine_map.keyset();
        for (quotelineitem ql_loc: ql) {
            qtLine_map.put(ql_loc.quote_opp_line_rel__c, ql_loc);
            // Below logic will create a new opportunity Line Items in correspondence to Quote Line Items
            if (!oppLine_key.contains(ql_loc.quote_opp_line_rel__c)) {
                opportunitylineitem abc = new opportunitylineitem();
                //abc.crm_Actual_Service__c = null ;
                abc.crm_Discount__c = ql_loc.Discount;
                abc.crm_Conversion_Factor__c = 'Standard';
                abc.crm_Direction__c = 'Both';
                abc.crm_Free_Pickup__c = false;
                abc.crm_lineItemsGroupId__c = '';
                abc.OpportunityId = opid;
                abc.PricebookEntryId = ql_loc.PricebookEntryId;
                abc.Product2Id = ql_loc.Product2Id;
                abc.opp_quote_line_rel__c = ql_loc.quote_opp_line_rel__c;
                abc.UnitPrice = ql_loc.Quantity;
                oppLineUpdate_ins.add(abc);
                // Below logic will SYNC Quote Line Items With corresponding opportunity Line Items
            }
            if (oppLine_key.contains(ql_loc.quote_opp_line_rel__c)) {
                opportunitylineitem abc1 = new opportunitylineitem();
               // abc1.id = 
                abc1 = oppLine_map.get(ql_loc.quote_opp_line_rel__c);
                abc1.Discount = ql_loc.Discount;
                abc1.crm_Conversion_Factor__c = 'Standard';
                abc1.crm_Direction__c = 'Both';
                abc1.crm_Free_Pickup__c = false;
                abc1.UnitPrice = ql_loc.Quantity;
               // abc1.PricebookEntryId = ql_loc.PricebookEntryId;
                oppLineUpdate_upd.add(abc1);
            }
        }
        qtLine_key = qtLine_map.keyset();
        /*
          Below code to Delete Opportunity line items
         */
        for (opportunitylineitem oppl_loc: ol) {
            if (!qtLine_key.contains(oppl_loc.opp_quote_line_rel__c)) {
                oppLineUpdate_Del.add(oppl_loc);
            }
        }
        /* 
          Below code performs DML operations to Update , Insert and Delete 
        */
        // Begins  
        try {
            if (oppLineUpdate_upd.size() > 0 || oppLineUpdate_ins.size() > 0) {
                system.debug('hello there');
                //upsert oppLineUpdate_upsrt ;
                if (oppLineUpdate_upd.size() > 0) {
                    update oppLineUpdate_upd;
                }
                if (oppLineUpdate_ins.size() > 0) {
                    insert oppLineUpdate_ins;
                }


                syncQuote.quoteLineSync = true;
            }
            if (oppLineUpdate_Del.size() > 0) {
                system.debug('hello there');
                delete oppLineUpdate_Del;
                syncQuote.quoteLineSyncDel = true;
            }
        } catch (Exception e) {

        }
        //Ends
    }
    public class syncquoteAndLineitem {
        // @AuraEnabled
        @AuraEnabled
        public boolean quote_sync;
        @AuraEnabled
        public boolean quote_linesync;
        @AuraEnabled
        public boolean oppLine_delete;
    }
}