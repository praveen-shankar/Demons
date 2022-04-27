@isTest
private class CS_StartHandlingTest {
   
    static testMethod void updateCaseDetailsTest() {
       
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
        
        CS_StartHandling.updateCaseDetails(testCase.id);
        
        
        
        CS_StartHandling.starthandlingFn(testCase.id);
        
        }
        
      }