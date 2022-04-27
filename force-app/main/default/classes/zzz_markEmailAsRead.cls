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
private class zzz_markEmailAsRead {

    static testMethod void myUnitTest() {
		
        test.startTest();
        Case c = new Case(subject='Test case', description = 'test', unread_action__c = true);
    	insert c;
      	
        c = [select id, unread_action__c from Case where id=:c.id];
        system.assertEquals(true, c.unread_action__c);
            	
		PageReference pageRef = Page.markEmailAsRead;
        Test.setCurrentPage(pageRef);
      	ApexPages.currentPage().getParameters().put('id', c.id);
		
		ApexPages.StandardController sc = new ApexPages.standardController(c);      
        markEmailAsReadController controller = new markEmailAsReadController(sc);
    
    	controller.loaddata();
    
    	c = [select id, unread_action__c from Case where id=:c.id];
        system.assertEquals(false, c.unread_action__c);
    	String caseid = controller.getExCaseId();

  		test.stopTest();
    }    
}