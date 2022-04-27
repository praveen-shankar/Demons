@isTest
private class CS_ReleaseOrderTest {
   
    static testMethod void OEBS_ReleaseOrderPageController_1() {
       
       Account testAccount = new Account(Name = 'Test OEBS Account',
                                    crm_customer_number__c = '12345678');
        
        upsert testAccount;
       
    
   
        Case testCase = new Case(Origin = 'OEBS',
                                OEBS_order_number__c = '123456',
                                OEBS_order_URL__c = 'www.test.com',
                                OEBS_order_line_id__c = '12345',
                                OEBS_top_article__c = 'Test Produkt',
                                OEBS_contract_name__c = 'Kontrakt',
                                OEBS_contract_number__c = '123456',
                                OEBS_producer__c = testAccount.id,
                                OEBS_Order_Status__c = '',
                                OEBS_order_release_reason__c = ''
        );
        insert testCase;
        
        Case testCase1 = new Case(Origin = 'OEBS',
                                OEBS_order_number__c = '123456',
                                OEBS_order_URL__c = 'www.test.com',
                                OEBS_order_line_id__c = '12345',
                                OEBS_top_article__c = 'Test Produkt',
                                OEBS_contract_name__c = 'Kontrakt',
                                OEBS_contract_number__c = '123456',
                                OEBS_producer__c = testAccount.id,
                                OEBS_Order_Status__c = '',
                                OEBS_order_release_reason__c = ''
        );
        insert testCase1;
        
        CaseComment c1= new CaseComment();
        c1.CommentBody ='test1';
        c1.parentid= testCase.id;
        insert c1;
        
        
        CaseComment c2= new CaseComment();
        c2.CommentBody ='test2';
        c2.parentid= testCase.id;
        insert c2;
        
              
      
        CS_ReleaseOrder.loadCaseDetails(testCase.id);
        CS_ReleaseOrder.loadCaseComments(testCase.id);
        CS_ReleaseOrder.releaseorderFn(testCase.id, 'test reason');
        
        }
        
        }