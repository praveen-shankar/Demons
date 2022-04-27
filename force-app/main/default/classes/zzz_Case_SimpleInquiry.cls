@isTest
private class zzz_Case_SimpleInquiry {

    @isTest
    static void testCreateSimpleInquiry() 
    {
        User testUser = KatsTestUtilities.getTestKundekonsulentUser();
        Group g = KatsTestUtilities.getTestQueue();
        QueueDetails__c qd = KatsTestUtilities.getQueueDetails().get(0);
        Account a = KatsTestUtilities.getTestBusinessAccount();
        Contact con = KatsTestUtilities.getTestContact();
        CDS_Service__c cdsService= KatsTestUtilities.getCDSService();

        String anumber = con.MobilePhone;       
        String cdsServiceName = cdsService.CDS_Service_Group_Name__c;
        
        Case c1 = Case_SimpleInquiry.createSimpleInquiry(anumber, cdsServiceName);
        //System.assertNotEquals(c1, null, 'Case should be created');

        Case c1Stored = [select Id, AccountId, ContactId, Code_Event__c, Type__c, Division__c, hidden_queue_id__c, CDS_Service__r.QueueDetails__r.OwnerId, CDS_Service__r.CDS_Service_Group_Name__c from Case where Id = :c1.Id];

        /*
        System.assertNotEquals(c1Stored, null, 'Case should be stored');
        System.assertEquals(c1Stored.AccountId , a.Id);
        System.assertEquals(c1Stored.ContactId , con.Id);
        System.assertEquals(c1Stored.hidden_queue_id__c , g.Id);
        System.assertEquals(c1Stored.hidden_queue_id__c ,  qd.OwnerId);
        System.assertEquals(c1Stored.hidden_queue_id__c ,  c1Stored.CDS_Service__r.QueueDetails__r.OwnerId);
        System.assertEquals(c1Stored.Code_Event__c ,cdsService.Code_Event__c);
        System.assertEquals(c1Stored.Division__c ,cdsService.Case_default_division__c);
        System.assertEquals(c1Stored.Type__c ,cdsService.Case_default_type__c);
        System.assertEquals(c1Stored.CDS_Service__r.CDS_Service_Group_Name__c , cdsServiceName);    
        */
    }
    
    @isTest
    static void testCreateSimpleInquiryNoAnumber() {
        User testUser = KatsTestUtilities.getTestKundekonsulentUser();
        Group g = KatsTestUtilities.getTestQueue();
        QueueDetails__c qd = KatsTestUtilities.getQueueDetails()[0];
        Account a = KatsTestUtilities.getTestBusinessAccount();
        Contact con = KatsTestUtilities.getTestContact();
        CDS_Service__c cdsService= KatsTestUtilities.getCDSService();

        String anumber = null;      
        String cdsServiceName = cdsService.CDS_Service_Group_Name__c;
        
        Case c2 = Case_SimpleInquiry.createSimpleInquiry(anumber, cdsServiceName);
        //System.assertNotEquals(c2, null, 'Case should be created');
        
        Case c2Stored = [select Id, AccountId, Code_Event__c, Type__c, Division__c, hidden_queue_id__c, CDS_Service__r.QueueDetails__r.OwnerId, CDS_Service__r.CDS_Service_Group_Name__c from Case where Id = :c2.Id];
        /*
        System.assertNotEquals(c2Stored, null, 'Case should be stored, no account will be set');
        System.assertEquals(c2Stored.AccountId , null);
        System.assertEquals(c2Stored.hidden_queue_id__c , g.Id);
        System.assertEquals(c2Stored.hidden_queue_id__c ,  qd.OwnerId);
        System.assertEquals(c2Stored.hidden_queue_id__c ,  c2Stored.CDS_Service__r.QueueDetails__r.OwnerId);
        System.assertEquals(c2Stored.Code_Event__c ,cdsService.Code_Event__c);
        System.assertEquals(c2Stored.Division__c ,cdsService.Case_default_division__c);
        System.assertEquals(c2Stored.Type__c ,cdsService.Case_default_type__c);
        System.assertEquals(c2Stored.CDS_Service__r.CDS_Service_Group_Name__c , cdsServiceName);
        */
    }
    
    @isTest
    static void testCreateSimpleInquiryInvalidService() {
        User testUser = KatsTestUtilities.getTestKundekonsulentUser();
        Group g = KatsTestUtilities.getTestQueue();
        QueueDetails__c qd = KatsTestUtilities.getQueueDetails()[0];
        Account a = KatsTestUtilities.getTestBusinessAccount();
        Contact con = KatsTestUtilities.getTestContact();
        CDS_Service__c cdsService= KatsTestUtilities.getCDSService();

        String anumber = con.MobilePhone;       
        String cdsServiceName = 'Invalid Service Name';
        
        Case c3 = Case_SimpleInquiry.createSimpleInquiry(anumber, cdsServiceName);
        System.assertNotEquals(c3, null, 'Case should be created');
    
        Case c3Stored = [select Id, AccountId, Code_Event__c, Type__c, Division__c, hidden_queue_id__c, CDS_Service__c from Case where Id = :c3.Id];
        System.assertNotEquals(c3Stored, null, 'Case should be stored, no queue or service params are set');
        // Dinesh , commented line no. 83 on 23 Feb 2017
       // System.assertEquals(c3Stored.AccountId , a.Id);
        System.assertEquals(c3Stored.hidden_queue_id__c , null);
        System.assertEquals(c3Stored.Code_Event__c ,null);
        System.assertEquals(c3Stored.Division__c ,null);
        System.assertEquals(c3Stored.Type__c ,null);
        System.assertEquals(c3Stored.CDS_Service__c , null);        
    }
}