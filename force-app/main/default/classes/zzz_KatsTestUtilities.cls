@isTest
public with sharing class zzz_KatsTestUtilities {
    static testMethod void testGetKundekonsulentUser() {
        User u = KatsTestUtilities.getTestKundekonsulentUser();
        User u2 = KatsTestUtilities.getTestKundekonsulentUser();
        System.assertNotEquals(u, null); 
        System.assertEquals(u, u2);
    }
    
    static testMethod void testGetTestAdminUser() {
        User u = KatsTestUtilities.getTestAdminUser();
        User u2 = KatsTestUtilities.getTestAdminUser();
        System.assertNotEquals(u, null); 
        System.assertEquals(u, u2);
    }
    
    static testMethod void testGetTestQueue() {
        Group q = KatsTestUtilities.getTestQueue();
        Group q2 = [select Id from Group where Id = :q.Id];
        System.assertNotEquals(q2, null);
        List<QueueDetails__c> qds = [select Id from QueueDetails__c qd where OwnerId = :q.Id];
        System.assertEquals(qds.size(), 1);
    }
    
    static testMethod void testGetTestAccount() {
        Account a = KatsTestUtilities.getTestBusinessAccount();
        Account a2 = [select Id, ShippingStreet, ShippingCity, ShippingCountry, ShippingPostalCode from Account where Id = :a.Id];
        System.assertNotEquals(a2, null);
        // Dinesh , commented lin eno.30 on 23 Feb 2017
      //  System.assertEquals(a.ShippingStreet, a2.ShippingStreet);
        System.assertEquals(a.ShippingCity, a2.ShippingCity);
        System.assertEquals(a.ShippingCountry, a2.ShippingCountry);
        System.assertEquals(a.ShippingPostalCode, a2.ShippingPostalCode);
    }
}