@isTest
private class zzz_ActionController {

    static testMethod void test_goDo_NULL() {
        ActionController ac = new ActionController();
        PageReference pr = null;
        pr = ac.goDo();
        
        system.assert(pr == null);
    }
     
    static testMethod void test_goDo_CREATE_SIMPLE_INQUERY() {
        
        User testUser = KatsTestUtilities.getTestKundekonsulentUser();
        Group g = KatsTestUtilities.getTestQueue();
        QueueDetails__c qd = KatsTestUtilities.getQueueDetails().get(0);
        Account a = KatsTestUtilities.getTestBusinessAccount();
        Contact con = KatsTestUtilities.getTestContact();
        CDS_Service__c cdsService= KatsTestUtilities.getCDSService();
                
        String anumber = con.MobilePhone;
        String cdsServiceName = cdsService.CDS_Service_Group_Name__c;
        ApexPages.currentPage().getParameters().put('action', ActionController.CREATE_SIMPLE_INQUERY);
        ApexPages.currentPage().getParameters().put('phone', anumber);
        ApexPages.currentPage().getParameters().put('cdsServiceGroupName', cdsServiceName);

        ActionController ac = new ActionController();
        PageReference pr = null;
        pr = ac.goDo();
        system.assert(pr != null);
        
        String caseId = pr.getUrl().substring(1); // get id of newly created case from url returned by ac.goDo()
        Case c = [SELECT id, SuppliedPhone, hidden_queue_id__c, accountId, recordTypeId, Division__c, CDS_Service__r.CDS_Service_Group_Name__c, CDS_Service__r.QueueDetails__r.OwnerId FROM Case WHERE Id = :caseId];
        
        system.assertEquals(c.SuppliedPhone, anumber);
        system.assertEquals(c.CDS_Service__r.CDS_Service_Group_Name__c , cdsServiceName);
        // Dinesh , Commented line no. 38 on 23 Feb 2017
       // system.assertEquals(c.AccountId , a.Id);
        system.assertEquals(c.hidden_queue_id__c ,  c.CDS_Service__r.QueueDetails__r.OwnerId);
        system.assertEquals(c.hidden_queue_id__c ,  qd.OwnerId);
        
        
        
    }
    static testMethod void test_SearchCustomer(){
        ApexPages.currentPage().getParameters().put('action', ActionController.SEARCH_CUSTOMER);
        ActionController ac = new ActionController();
        PageReference pr = null;
        pr = ac.goDo();
        system.assert(pr != null);
        
        Case c=new Case();
        insert c;
        ApexPages.currentPage().getParameters().put('caseId', c.id);
        ApexPages.currentPage().getParameters().put('searchType', 'customersearch_private');
        ApexPages.currentPage().getParameters().put('phone', '222222');
        ApexPages.currentPage().getParameters().put('startSearch', 'true');
        pr = ac.goDo();
        system.assert(pr != null);
        
        ApexPages.currentPage().getParameters().put('searchType', 'business');
        pr = ac.goDo();
        system.assert(pr != null);
    }
}