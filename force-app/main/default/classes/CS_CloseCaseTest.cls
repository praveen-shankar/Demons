@isTest
private class CS_CloseCaseTest {
   
    static testMethod void CS_CloseCasetestmethod() {
       
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
        
        Service_Product__c p1= new Service_Product__c();
        p1.Name='test1';
        insert p1;
        
        Code_Event__c c1= new Code_Event__c();
        c1.name= 'code1';
        insert c1;
        
        
        Case testCase1= new Case(Origin = 'OEBS',
                                OEBS_order_number__c = '123456',
                                OEBS_order_URL__c = 'www.test.com',
                                OEBS_order_line_id__c = '12345',
                                OEBS_top_article__c = 'Test Produkt',
                                OEBS_contract_name__c = 'Kontrakt',
                                OEBS_contract_number__c = '123456',
                                OEBS_producer__c = testAccount.id,
                                OEBS_Order_Status__c = '',
                                  Code_Event__c =c1.id,
                                  Service_Product__c=p1.id,
                                OEBS_order_release_reason__c = ''
        );
        insert testCase1;
        
        CS_CloseCase.loadCaseDetails(testCase.id);
        CS_CloseCase.loadCaseStatus(testCase.id);
        CS_CloseCase.SaveCase(testCase.id,'Avsluttet',null,5,System.today(),true,true,false,false,'subject','description','comment');
        

        
     }
 }