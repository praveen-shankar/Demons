({
	verify : function(component) {
		let opprec = component.get("v.opprecord");
        if(opprec.check && opprec.opp.StageName === 'Closed Won' && !opprec.opp.crm_Verified_by_Contract_Management__c && !opprec.opp.crm_Agreement_Interface_TransactionId__c
          && !opprec.opp.crm_Enriched_In_PriceEngine__c) {
            component.set("v.showhighlighter2",true);
            component.set("v.showhighlighter1",false);
        } else if(opprec.check && opprec.opp.StageName === 'Closed Won' && opprec.opp.crm_Verified_by_Contract_Management__c && 
            opprec.opp.crm_Enriched_In_PriceEngine__c && opprec.opp.crm_Agreement_Interface_TransactionId__c) {
            component.set("v.showhighlighter1",true);
            component.set("v.showhighlighter2",false);
        } else if(opprec.check && opprec.opp.StageName === 'Closed Won' && opprec.opp.crm_Verified_by_Contract_Management__c && 
            !opprec.opp.crm_Enriched_In_PriceEngine__c && opprec.opp.crm_Agreement_Interface_TransactionId__c) {
            component.set("v.showhighlighter1",false);
            component.set("v.showhighlighter2",false);
        } else {
            component.set("v.showhighlighter1",false);
            component.set("v.showhighlighter2",false);
        } 
	}
})