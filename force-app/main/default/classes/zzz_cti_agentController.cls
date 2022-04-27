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
private class zzz_cti_agentController {
    
    static cti_agentController controller;
    static Case c;
    
    static { 
        c = new Case(Assigned_to_CTI__c = true, Assigned_to_CTI_Agent__c = true);
        insert c;
        controller = new cti_agentController(new ApexPages.StandardController(c));
    }

    static testMethod void testPrepareCaseForAgent() {
        PageReference pf = controller.prepareCaseForAgent();
        c = [select Id, Assigned_to_CTI__c, Assigned_to_CTI_Agent__c, OwnerId, Status, case_new_Comment__c, unread_action__c from Case where Id = :c.Id limit 1];
        Id userId = UserInfo.getUserId();
        String url = pf.getUrl();
        c = [select Id, Assigned_to_CTI__c, Assigned_to_CTI_Agent__c, OwnerId, Status, case_new_Comment__c, unread_action__c from Case where Id = :c.Id limit 1];
        //System.assert(url.endsWith(c.Id), 'URL should end with Case.Id = ' + c.Id + ' but the URL is: ' + url);
        System.assert(c.OwnerId == userId, 'Owner should change to current user');
        // Dinesh , Commented lin no. 43 on Feb 23 2017
        //System.assert(c.Status == 'Processing');
        System.assert(c.Assigned_to_CTI__c == false, 'Assigned_to_CTI__c is not reset to false');
        System.assert(c.Assigned_to_CTI_Agent__c == false, 'Assigned_to_CTI__c is not reset to false');
        System.assertEquals(c.case_new_Comment__c, false);
        System.assertEquals(c.unread_action__c, false);
    }
    
    static testMethod void testUnreadActionToFalse() {
        c.case_new_Comment__c = true;
        c.unread_action__c = true;
        upsert c;
        
        PageReference pf = controller.prepareCaseForAgent();
        c = [select Id, Assigned_to_CTI__c, Assigned_to_CTI_Agent__c, OwnerId, Status, case_new_Comment__c, unread_action__c from Case where Id = :c.Id limit 1];
        Id userId = UserInfo.getUserId();
        String url = pf.getUrl();
        c = [select Id, Assigned_to_CTI__c, Assigned_to_CTI_Agent__c, OwnerId, Status, case_new_Comment__c, unread_action__c from Case where Id = :c.Id limit 1];
        
        System.assertEquals(c.case_new_Comment__c, false);
        System.assertEquals(c.unread_action__c, false);
    }
}