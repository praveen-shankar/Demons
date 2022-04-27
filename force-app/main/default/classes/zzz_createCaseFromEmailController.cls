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
private class zzz_createCaseFromEmailController {

    static testMethod void myUnitTest() {
        
        test.startTest();
        Case c = new Case(subject='Test case', description = 'test');
        insert c;
        c = [select id, unread_action__c from Case where id=:c.id];
        
        EmailMessage e = new EmailMessage(Subject='nytt', textBody='email', parentid=c.id);
        insert e;
        PageReference pageRef = Page.createCaseFromLastEmail;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', c.id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(c);      
        createCaseFromEmailController controller = new createCaseFromEmailController(sc);
    
        controller.loaddata();
        String caseid = controller.getExCaseId();
        String newcaseid = controller.getNewCaseId();
                
        test.stopTest();

    }
}