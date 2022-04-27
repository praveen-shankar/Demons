trigger opportunityLineTrigger_SF2 on OpportunityLineItem (before insert , before update , after insert , after update) {
    if(trigger.isinsert && trigger.isbefore ){
        for (OpportunityLineItem opp_line: trigger.new){
            if(String.isBlank(opp_line.opp_quote_line_rel__c)){
                opp_line.opp_quote_line_rel__c = Utility_Apex_SF2.generateUniqueString('QuoteOppLine') ;
            }
            
        }
    }
    

}