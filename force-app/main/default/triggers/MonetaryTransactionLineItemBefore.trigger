trigger MonetaryTransactionLineItemBefore on Monetary_Transaction_Line_Item__c (before insert, before update) {
public static final String NAV = 'NAV';
if(KATSutilities.shouldTriggerRun()){ 
    map<string, map<string, map<string,string>>> articleNumbersMap; 
    
    //Load related transactions into list
    list<Id> relatedTransactions = new list<Id>();
    for(Monetary_Transaction_Line_Item__c t:trigger.new){ 
         relatedTransactions.add(t.Transaksjon__c);
    }
    
    list<Monetary_Transaction__c> translist = new list<Monetary_Transaction__c>([select id, name, case__c,ERP_target_system__c , Service_Product__c from Monetary_Transaction__c where id in :relatedTransactions]);
    
    map<Id, Monetary_Transaction__c> transmap = new map<Id, Monetary_Transaction__c>();
    for(Monetary_Transaction__c mo : translist){
        transmap.put(mo.id, mo);
    }
    //Load related cases into map
    list<Id> relatedCaseIds = new list<Id>();
    for(Monetary_Transaction__c tr:translist){ 
            if(tr.case__c != null) {
                 relatedCaseIds.add(tr.case__c);
            }
    }
    
    map<ID,case> relatedCases = new map<ID,case>([select id, Value_added_services__c,Service_Product__c   from case where id in :relatedCaseIds]);
    //list<Case> casesToUpsert = new list<Case>();
    
    //trigger loop
    for(Monetary_Transaction_Line_Item__c newT : trigger.new) {
        
        system.debug('MTLI: Calculate and update the transaction_number__c');
        
        
        
        Monetary_Transaction_Line_Item__c oldT = (trigger.oldMap != null) ? trigger.oldMap.get(newT.Id) : null;

if(articleNumbersMap == null) {
                articleNumbersMap = MonetaryTransactionsController.getArticleNumbersMap();
            }
System.debug('============articleNumbersMap '+articleNumbersMap );
        if(trigger.isBefore && newT.Transaksjon__c != null && (transmap.get(newT.Transaksjon__c).ERP_target_system__c == 'NPB_OEBS') && transmap.get(newT.Transaksjon__c).case__c != null && relatedCases.get(transmap.get(newT.Transaksjon__c).case__c).Service_Product__c != null){
             
             
             System.debug('==========transmap'+transmap.get(newT.Transaksjon__c));
             System.debug('=====newT.Type__c'+transmap.get(newT.Transaksjon__c).Service_Product__c);
             System.debug('======='+articleNumbersMap.get(KATSutilities.toUpperCase(transmap.get(newT.Transaksjon__c).Service_Product__c)).size());
             map<string, string> VASmap = articleNumbersMap.get(KATSutilities.toUpperCase(transmap.get(newT.Transaksjon__c).Service_Product__c)).get(KATSutilities.toUpperCase(newT.Type__c));
                //system.debug('MTLI: Vasmap created:'+ VASmap.size());
                
             
             
             if(VASmap!=null && VASmap.size()>0)
             {
                newT.Article_Number__c = VASmap.get(null); 
             }
             
             /*else {
             newT.addError('NO article number found for this product and payment type');
             }*/
             
                     
        }
        
        else if(trigger.isBefore && !(newT.Transaksjon__r.ERP_target_system__c == NAV)) {
        System.debug('============'+newT.Transaksjon__r.ERP_target_system__c);
            if(articleNumbersMap == null) {
                articleNumbersMap = MonetaryTransactionsController.getArticleNumbersMap();
            }

            try {
                map<string, string> VASmap = articleNumbersMap.get(KATSutilities.toUpperCase(transmap.get(newT.Transaksjon__c).Service_Product__c)).get(KATSutilities.toUpperCase(newT.Type__c));
                system.debug('MTLI: Vasmap created:'+ VASmap.size());
                
                newT.Article_Number__c = VASmap.get(null); //Setting fall back VAS/VØT value
                system.debug('MTLI: Article = null');
                
                if(relatedCases.get(transmap.get(newT.Transaksjon__c).Case__c) == null || KATSutilities.toUpperCase(relatedCases.get(transmap.get(newT.Transaksjon__c).Case__c).Value_added_services__c) == null) {
                    system.debug('MTLI: Case has no VAS/VØT values defined');
                }
                else {
                    system.debug('MTLI: Case has VAS/VØT values. checking articleNumbersMap for matches');
                    for(String singleVatValue : KATSutilities.toUpperCase(relatedCases.get(transmap.get(newT.Transaksjon__c).Case__c).Value_added_services__c).split(';')) {
                        if(VASmap.containsKey(singleVatValue)) {
                            newT.Article_Number__c = VASmap.get(singleVatValue); 
                            continue;
                        }
                    }
                }
                                
                system.debug('MTLI: Succesfully added article_number: ' + newT.Article_Number__c);
            }
            catch(Exception e) {
                system.debug('MTLI: Not able to add article_number to transaction line item: ' + newT);
                system.debug(e.getStackTraceString());
                newT.Article_Number__c = null;
            }
            
        }
        
    }
}
}