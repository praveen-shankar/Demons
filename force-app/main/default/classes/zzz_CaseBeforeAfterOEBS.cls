/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class zzz_CaseBeforeAfterOEBS {

    static testMethod void myUnitTest() {
		List <Case> newCaseList = new List<Case>();
		List <Case> newnewCaseList = new List<Case>();
		
		Case newCase = null;
		
		for(Integer i=0;i<200;i++){
    		if(i<50){
    			newCase = new Case(Origin='OEBS',OEBS_order_line_id__c=''+i, OEBS_order_number__c='50' );
    			newCaseList.add(newCase);
    		}
    		if(i>49 && i<100){
    			newCase = new Case(Origin='OEBS',OEBS_order_line_id__c=''+i, OEBS_order_number__c='100' );
    			newCaseList.add(newCase);
    		}
    		if(i>99 && i<150){
    			newCase = new Case(Origin='OEBS',OEBS_order_line_id__c=''+i, OEBS_order_number__c='150' );
    			newCaseList.add(newCase);
    		}
    		if(i>149 && i<200){
    			newCase = new Case(Origin='OEBS',OEBS_order_line_id__c=''+i, OEBS_order_number__c='200' );
    			newCaseList.add(newCase);
    		}
    	}
    	
    	if(newCaseList.size() > 0){
 	   		insert newCaseList;
    	}
    	
    	for(Integer j=0;j<100;j++){
    		if(j<50){
    			newCase = new Case(Origin='OEBS',OEBS_order_line_id__c=''+j, OEBS_order_number__c='50', Description='uppdaterat fail' );
    			newnewCaseList.add(newCase);
    		}
    		if(j>49 && j<100){
    			newCase = new Case(Origin='OEBS',OEBS_order_line_id__c=''+j, OEBS_order_number__c='100', Description='uppdaterat fail');
    			newnewCaseList.add(newCase);
    		}
    	}
    	if(newnewCaseList.size() > 0){
 	   		insert newnewCaseList;
    	}
    }
}