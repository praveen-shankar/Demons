@isTest
private class MassApprRejectController_test {
    
    private static Service_Product__c createTestProduct(){
        Service_Product__c p=new Service_Product__c(Name='MyTestProduct');
        insert p;
        return p;
    }
    private static Service_Product__c testProduct=createTestProduct();
    
    static testMethod void approvetest(){
        
        prepareArticleNumbers();
        System.debug('Maheep 11');
        Profile P = [Select id from Profile where name='System Administrator'];
        User approver = new User();
        approver.lastname='test';
        approver.Profileid=p.id;
        approver.Email = 'puser000@test.com';
        approver.Username = 'test2333@posten.test.com';
        approver.CompanyName = 'TEST';
        approver.Title = 'title';
        approver.Alias = 'alias';
        approver.TimeZoneSidKey = 'America/Los_Angeles';
        approver.EmailEncodingKey = 'UTF-8';
        approver.LanguageLocaleKey = 'en_US';
        approver.LocaleSidKey = 'en_US';
        approver.Max_payment_amount__c = 10;
        approver.Max_payment_amount_Logistikk__c = 10;
        
        insert approver;
        
        User u= new User();
        u.lastname='test1';
        u.profileid=p.id;
        u.Email = 'puser1000@test.com';
        u.Username = 'test3321@test.com';
        u.CompanyName = 'TEST';
        u.Title = 'title';
        u.Alias = 'alias';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        u.managerid=approver.id;
        u.Transaction_approver_Logistikk__c=approver.id;
        u.Transaction_approver__c=approver.id;
        
        u.Max_payment_amount__c = 10;
        u.Max_payment_amount_Logistikk__c = 10;
        insert u;
        
        Recordtype rt = [Select id from Recordtype where name =: 'Relation level Customer'];
        Account a = new Account(name='GP',recordtypeid=rt.id,ownerid=u.id); //00520000001C2TK
        Database.insert(a);
        Case c = new Case(subject='Test case', Service_Product__c=testProduct.id, accountid=a.id,amount_claimed__c=100.20);
        upsert c;
        System.debug('Maheep 22');
        //***************Test Data for Approval***************************//
        
        monetary_transaction__c t = new monetary_transaction__c(
            case__c=c.id, Bank_Account_Number__c='12345678903',type__c='Refusion',Form_of_Transaction__c='Kreditnota/Faktura');
        upsert t;
        System.debug('Maheep 33');
        Monetary_Transaction_Line_Item__c tltest = new Monetary_Transaction_Line_Item__c (
            is_motpost__c =true,Transaksjon__c = t.id, Type__c='Manuell Behandling', Line_Amount__c=700);
        upsert tltest;
        System.debug('Maheep 44');
        Monetary_Transaction_Line_Item__c tltest2 = new Monetary_Transaction_Line_Item__c (
            is_motpost__c =true,Transaksjon__c = t.id, Type__c='Regress', Line_Amount__c=100);
        upsert tltest2;
        System.debug('Maheep 55');
        test.startTest();
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setObjectId(t.id);
        req.setNextApproverIds(new List<Id>{u.id});
        req.setComments('Submitting request for approval automatically using Trigger');
        
        System.debug('Maheep 66');
        
        System.debug('Maheep 66.1:'+req);
        Approval.ProcessResult result ;
        System.runAs(u){
            result = Approval.process(req);
            List<Id> newWorkItemIds = result.getNewWorkitemIds();
            System.debug('Maheep 77');
            
            PageReference pageRef = Page.VF_MassApprReject;
            Test.setCurrentPage(pageRef);        
            pageRef.getParameters().put('items',newWorkItemIds.get(0));        
            //ApexPages.currentPage().getParameters().put('items', newWorkItemIds.get(0));         
            
            MassApprRejectController massAppr = new MassApprRejectController(); 
            massAppr.Comments = 'Test Approval';
            //System.assertNotEquals(null,massAppr.ApproveAllItems());
            massAppr.ApproveAllItems();
            //***************Test class for MassReassignApprovalRqst***************************//        
            list<ProcessInstanceWorkItem> piwList = [select id, actorid,processinstance.targetobjectid,CreatedDate ,processinstance.targetobject.name,
                                                     ProcessInstance.TargetObject.type,OriginalActorId 
                                                     from processinstanceworkitem 
                                                    ];
            pageRef = Page.MassReassignApprovalRqst;
            Test.setCurrentPage(pageRef);        
            pageRef.getParameters().put('items',piwList[0].processinstance.targetobjectid);
            MassReassignApprovalRqst reassignObj = new MassReassignApprovalRqst();
            reassignObj.Approver = a;
            System.assertNotEquals(null, reassignObj.ReassignAll());
            MassReassignApprovalRqst massReassignCancel= new MassReassignApprovalRqst();
            System.assertNotEquals(null,massReassignCancel.cancel());
            
            System.debug('maheep2');
            //***************Test class for ItemsToApproveController***************************//
            User testuser = [Select id from User where id =: a.OwnerId];
            System.debug('maheep3');
            
            ItemsToApproveController itemToAppr = new ItemsToApproveController();
            ItemsToApproveController.ApproveRejectnavigation();
            ItemsToApproveController.ReassingNavigation();
            itemToAppr.Select_All();
            itemToAppr.AssignAll();
            itemToAppr.ApproveRejectAll();
            
            
            System.debug('maheep4');
            //***************Test Data for Reject***************************//
            monetary_transaction__c t1 = new monetary_transaction__c(
                case__c=c.id, Bank_Account_Number__c='12345678903',type__c='Refusion',Form_of_Transaction__c='Kreditnota/Faktura');
            upsert t1;
            
            Monetary_Transaction_Line_Item__c tltest1 = new Monetary_Transaction_Line_Item__c (
                is_motpost__c =true,Transaksjon__c = t1.id, Type__c='Manuell Behandling', Line_Amount__c=700);
            upsert tltest1;
            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(t1.id);        
            Approval.ProcessResult result1 = Approval.process(req1);
            List<Id> newWorkItemIds1 = result1.getNewWorkitemIds();
            
            PageReference pageRef1 = Page.VF_MassApprReject;
            Test.setCurrentPage(pageRef1);        
            pageRef1.getParameters().put('items',newWorkItemIds1.get(0));        
            //ApexPages.currentPage().getParameters().put('items', newWorkItemIds1.get(0));         
            
            MassApprRejectController massReject= new MassApprRejectController(); 
            massReject.Comments = 'Test Reject';
            System.assertNotEquals(null,massReject.RejectAllItems());
            
            MassApprRejectController massCancel= new MassApprRejectController();
            System.assertNotEquals(null,massCancel.cancel());
        }//end of user
        test.stopTest();       
    }
    
    
    private static void prepareArticleNumbers() {
        
        list<Article_Number__c> an = new list<Article_Number__c>();
        
        an.add(new Article_Number__c(Name='TEST-AN123', Service_Product__c=testProduct.id, Transaction_Type__c='Refund'));
        
        list <Service_Product__c> products=new list<Service_Product__c>();
        for(integer i=0; i<200; i++) {
            Service_Product__c p=new Service_Product__c(Name='MyTestProduct'+i);   
            products.add(p);
        }
        insert products;
        
        for(integer i=0; i<200; i++) {
            
            an.add(new Article_Number__c(Name='TEST-AN123'+i, Service_Product__c=products.get(i).id,Transaction_Type__c='Refund'));
        }
        upsert an;
        
    }
    
}