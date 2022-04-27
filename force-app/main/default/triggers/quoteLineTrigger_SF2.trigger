trigger quoteLineTrigger_SF2 on QuoteLineItem (before insert , before update , after insert , after update) {
    if(trigger.isinsert && trigger.isbefore ){
        for (QuoteLineItem quote_line: trigger.new){
            if(String.isBlank(quote_line.quote_opp_line_rel__c)){
                quote_line.quote_opp_line_rel__c = Utility_Apex_SF2.generateUniqueString('oppQuoteLine') ;
            }
            
        }
    }
}