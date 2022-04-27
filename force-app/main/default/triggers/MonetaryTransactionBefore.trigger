trigger MonetaryTransactionBefore on monetary_transaction__c (before insert, before update, after insert, after update) { 
    map<string, map<string, map<string,string>>> articleNumbersMap; 
    list<ID> transactionsToSubmitForPayment = new list<ID>();
    list<ID> transactionsIdList = new list<ID>();
    List<Monetary_transaction_line_item__c> transLineToUpdate = new List<Monetary_transaction_line_item__c>(); // Liste med alle trans-linjer som skal oppdateres 
    
    //Load related cases into map, add all transaction id's to list
    list<Id> relatedCaseIds = new list<Id>();
    for(Monetary_Transaction__c t:trigger.new) { 
        if(t.case__c != null) { 
            relatedCaseIds.add(t.case__c);
        } 
        transactionsIdList.add(t.id);
   }
    
    // Get all cases related to the transactions
    map<ID,case> relatedCases = new map<ID,case>([select id, Value_added_services__c  from case where id in :relatedCaseIds]);
    
    // Get all transaction lines related to the transactions. Put into map where the autonumber part of the Name is the map key (i.e. for Name = 'TL-12345' the key is '12345')
    List<Monetary_transaction_line_item__c> allTransactionLines = [Select Name, Type__c, id, voucher_number__c, is_motpost__c from Monetary_transaction_line_item__c where Transaksjon__c in :transactionsIdList];
    
    map<String,Monetary_transaction_line_item__c> transLineMap = null;
    if(allTransactionLines.size() > 0){
        transLineMap = new map<String, Monetary_transaction_line_item__c>();
        for(Monetary_transaction_line_item__c tl : allTransactionLines){
            transLineMap.put(tl.Name.substring(3), tl);
        }
    }
    
    list<CaseComment> caseCommentsToInsert = new list<CaseComment>();
    
    //trigger loop
    for(monetary_transaction__c newT : trigger.new) {
        system.debug('Translating eConnect statuses');
        if(newT.Status__c == MonetaryTransactionsController.ECONNECT_PENDING_STATUS && newT.ERP_target_system__c == MonetaryTransactionsController.OEBS) {
            newT.Status__c = MonetaryTransactionsController.SUCCESS_STATUS_OEBS;
        }
        else if(newT.Status__c == MonetaryTransactionsController.ECONNECT_DONE_STATUS && newT.ERP_target_system__c == MonetaryTransactionsController.OEBS) {
            newT.Status__c = MonetaryTransactionsController.DONE_STATUS;
        }
        else if(newT.Status__c == MonetaryTransactionsController.ECONNECT_PENDING_STATUS && newT.ERP_target_system__c == MonetaryTransactionsController.NAV) {
            newT.Status__c = MonetaryTransactionsController.SUCCESS_STATUS_NAV;
        }
        else if(newT.Status__c == MonetaryTransactionsController.ECONNECT_DONE_STATUS && newT.ERP_target_system__c == MonetaryTransactionsController.NAV) {
            newT.Status__c = MonetaryTransactionsController.DONE_STATUS;
        }
        //added for NPB OEBS
        else if(newT.Status__c == MonetaryTransactionsController.ECONNECT_PENDING_STATUS && newT.ERP_target_system__c == MonetaryTransactionsController.NPB_OEBS) {
            newT.Status__c = MonetaryTransactionsController.SUCCESS_STATUS_NPB_OEBS;
        }
        else if(newT.Status__c == MonetaryTransactionsController.ECONNECT_DONE_STATUS && newT.ERP_target_system__c == MonetaryTransactionsController.NPB_OEBS) {
            newT.Status__c = MonetaryTransactionsController.DONE_STATUS;
        }
        else if(newT.Status__c == MonetaryTransactionsController.ECONNECT_ERROR_STATUS_ERR01 && newT.ERP_target_system__c == MonetaryTransactionsController.NAV) {
            newT.Status__c = MonetaryTransactionsController.ERR01;
        }
        else if(newT.Status__c == MonetaryTransactionsController.ECONNECT_ERROR_STATUS_ERR02 && newT.ERP_target_system__c == MonetaryTransactionsController.NAV) {
            newT.Status__c = MonetaryTransactionsController.ERR02;
        }
                
        
        Monetary_transaction__c oldT = (trigger.oldMap != null) ? trigger.oldMap.get(newT.Id) : null;
        
        
        
        
        if(trigger.isAfter) {
            
            //checking if the case needs a reminder set
            if(newT.Trans_reminder_on_case__c == true && newT.Trans_reminder_on_case__c != oldT.Trans_reminder_on_case__c){
                caseCommentsToInsert.add(new CaseComment(
                                                        ParentId = newT.case__c,
                                                        CommentBody = 'Transaksjonen '+ newT.Name +' er ikke godkjent. Kontakt Godkjenner.'
                                                        )
                );
            }
            
            system.debug('Selecting transaction for submission to OEBS for: oldT:' + oldT + ' newT: ' + newT);
            //TODO: CHECK IF ITS MANUAL OR AUTOMATIC
            if((newT.Transaction_Action__c == 'AUTO' || newT.Transaction_Action__c == 'MOTPOST') && (oldT==null || oldT.status__c != MonetaryTransactionsController.READY_STATUS) && newT.status__c == MonetaryTransactionsController.READY_STATUS) {
                system.debug('This transaction should be submitted to OEBS:' + newT);
                transactionsToSubmitForPayment.add(newT.id);
            }
        }
        
        /*
        *  START METHOD FOR PERSISTING voucher_number__c ON TRANSACTION LINE ITEMS
        *  This code will only run when the value of OEBS_transaction_number__c is changed, and contains a ";" (semicolon)
        */
        Boolean createCaseCommentMotpost = false;
        // Criteria for entering trigger method: Value of OEBS_transaction_number__c is changed and contains a semi colon
        if (transLineMap != null && oldT != null && oldT.OEBS_transaction_number__c != newT.OEBS_transaction_number__c && newT.OEBS_transaction_number__c != null && newT.OEBS_transaction_number__c != '' && newT.OEBS_transaction_number__c.contains(';')){
            system.debug('Entry criteria ok. Recieved reference is ' + newT.OEBS_transaction_number__c);
            Map<String, String> transRefMap = new Map<String, String>();
            List<String> numbers = newT.OEBS_transaction_number__c.split(';');
            if(oldT.OEBS_transaction_number__c == null || oldT.OEBS_transaction_number__c == ''){ // Do not overwrite existing reference numbers. This value will be empty unless it is a motpost
                newT.OEBS_transaction_number__c = numbers[0]; // First element in table is transaction reference number
                if(newT.OEBS_transaction_number__c.startsWith('a07')){newT.OEBS_transaction_number__c = 'Se bilagsnummer på transaksjonslinjer';} // NAV will return the t.id as reference, f.ex. a07g0000002JNLx. If number from nav starts with a07, use the reference on transaction lines. 
            } else { // If OEBS_transaction_number__c is updated when not empty, the original value  
                newT.OEBS_transaction_number__c = oldT.OEBS_transaction_number__c; // + ',' + numbers[0]; // Alternative if both old and new value should be kept
            }
                        
            numbers.remove(0); // Remove first element in table
            
            for(String s : numbers ) { // Iterate remaining elements, on the form (TransLinjeId1,TranslinjeRef1)
                List<String> tempString = s.split(',');
                system.debug('New transactionLine reference ' + s);
                if(tempString.size() == 2 && tempString[0].length() > 4){ // If tempString[0] less than 5 chars, the reference is invalid
                    transRefMap.put(tempString[0],tempString[1] ); // Create new line in map: TransLinjeIdxxx,TranslinjeRefxxx  
                }
            }
                        
            String hiddenbilagsnummer ='';
            if(transRefMap.size() > 0){
                try{
                    String creditNoteVoucherNumber;
                    for(String tl_id : transRefMap.keySet()){
                        Monetary_transaction_line_item__c tl = transLineMap.get(tl_id);
                        if(tl != null){
                            tl.voucher_number__c = transRefMap.get(tl_id); //get(tl_id) returns the trans line reference
                            if(tl.voucher_number__c != null){                           
                                hiddenbilagsnummer += tl.voucher_number__c + ', ';
                                transLineToUpdate.add(tl);
                                if(tl.is_motpost__c){
                                    createCaseCommentMotpost = true;
                                }
                                if(tl.Type__c == MonetaryTransactionsController.KREDITTNOTA && tl.voucher_number__c != null){
                                    creditNoteVoucherNumber = tl.voucher_number__c;
                                }
                            }
                        }
                    }
                    // For trans lines of type kredittnota, only one of the trans lines recieves a voucher_number__c. Need to copy this number to remaining trans lines of type kredittnota.
                    if(creditNoteVoucherNumber != null){
                        for(Monetary_transaction_line_item__c mtl : transLineMap.values()){
                            if(mtl.Type__c == MonetaryTransactionsController.KREDITTNOTA && mtl.voucher_number__c == null){
                                mtl.voucher_number__c = creditNoteVoucherNumber;
                                transLineToUpdate.add(mtl);
                            }
                        }
                    }

                } catch(Exception e) {
                    system.debug('eConnect Exception: ' + e.getMessage());
                    system.debug('MonetaryTransactionBefore: Invalid Id reference recieved from Navision');
                }
            }
            if(hiddenbilagsnummer.length() > 2){
                hiddenbilagsnummer = hiddenbilagsnummer.substring(0,hiddenbilagsnummer.length()-2);
                newT.Hidden_bilagsnummer__c = hiddenbilagsnummer;
            }
        }
        if(createCaseCommentMotpost){
            caseCommentsToInsert.add(new CaseComment(
                ParentId = newT.case__c,
                CommentBody = 'Det er opprettet og godkjent en motpost på transaksjonen '+ newT.Name +'. Husk å sende en epost til kunden tilknyttet denne transaksjonen/motposten om at en motpost mot tidligere utsendt kreditnota/regress har blitt opprettet.'
                )
            );
        }
        /*
        *  END METHOD FOR PERSISTING voucher_number__c ON TRANSACTION LINE ITEMS
        */
    }
    
    
    Set<Id> CaseSet= new set<Id>();
    
    if(trigger.isbefore && trigger.isUpdate)
    {
   for(monetary_transaction__c newT : trigger.new)
    {
       monetary_transaction__c oldT = trigger.oldmap.get(newT.id);
            System.debug('@@@ i am here0' + newT.Transaction_approved_date__c);
            if((newT.Transaction_approved_date__c!=null) && (oldT.Transaction_approved_date__c!=newT.Transaction_approved_date__c) &&(newT.Form_of_Transaction__c=='Settlement by insurance company third party') && newT.Sum_of_lines_ex_mva__c!=null)  //check picklist value
            {
                            
                CaseSet.add(newT.case__c);
                
            }
            
          
            }
        
        
        //fetch cases
        
        List<case> CaseList= [Select id, Regress_sending__c, cs_transaction_amount_Settlement__c   from case where id in :caseset  ];
        
        for (Case c: Caselist){
            c.Regress_sending__c= c.cs_transaction_amount_Settlement__c ;
        }
        
        if(Caselist.size()>0){
        try{
            system.debug('Updating Caselist: ' + Caselist);
            Database.update(Caselist);
        } catch(Exception e) {
            system.debug('eConnect Exception: ' + e.getMessage());
        }  
        
     }
     }
    
    if(transLineToUpdate.size() > 0){
        try{
            system.debug('Updating trans lines: ' + transLineToUpdate);
            upsert(transLineToUpdate);
        } catch(Exception e) {
            system.debug('eConnect Exception: ' + e.getMessage());
        }       
    }
    
    
    system.debug('Sending list of transactions for submission to OEBS @future. List: ' + transactionsToSubmitForPayment);
    if(transactionsToSubmitForPayment.size() > 0) {
        MonetaryTransactionsController.sendPaymentForTransactions(transactionsToSubmitForPayment);
    }
    //inserting the case comments to the case to notify the case owner
    if(caseCommentsToInsert.size() > 0){
        insert caseCommentsToInsert;
    }  
}