@isTest
public class CS_MonetaryTransactionLineNPBOEBSTest {

   
    @testSetup static void setup() {
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
                                OEBS_order_release_reason__c = '',
                                 transporter__c='Alvew'
        );
        insert testCase;
        
      
       /* Monetary_Transaction__c trans1= new Monetary_Transaction__c();
        trans1.RecordTypeId=recordtypeid;
        trans1.case__c=testCase.id;
        trans1.Form_of_Transaction__c='Utbetaling';
        trans1.no_of_parcels__c=1;
        insert trans1;*/
    }
    
       static testMethod void loadLineItems(){
           Case testcase1 = [Select id,Origin,transporter__c from case where Origin='OEBS'];
             String recordtypeid = [Select id, name from recordtype where developername ='Transaction_NPB_OEBS'].id;
           String recordtypeid1 = [Select id, name from recordtype where developername ='Transaction_Regress_NPB_OEBS'].id;
          
            Monetary_Transaction__c trans1= new Monetary_Transaction__c();
        trans1.RecordTypeId=recordtypeid;
        trans1.case__c=testcase1.id;
        trans1.Form_of_Transaction__c='Utbetaling';
        trans1.no_of_parcels__c=1;
           trans1.Bank_Account_Number__c='97600106345';
           //ans1.Transaction_Action__c='SOW_ALL_PRODUCTS';
        insert trans1;
           
          Monetary_Transaction__c trans2= new Monetary_Transaction__c();
        trans2.RecordTypeId=recordtypeid;
        trans2.case__c=testcase1.id;
        trans2.Form_of_Transaction__c='Settlement by insurance company third party';
        trans2.no_of_parcels__c=1;
           trans2.Bank_Account_Number__c='97600106345';
           //ans1.Transaction_Action__c='SOW_ALL_PRODUCTS';
        insert trans2;
           
             Monetary_Transaction__c trans3= new Monetary_Transaction__c();
        trans3.RecordTypeId=recordtypeid1;
        trans3.case__c=testcase1.id;
        trans3.Form_of_Transaction__c='Faktura';
        trans3.no_of_parcels__c=1;
           trans3.Bank_Account_Number__c='97600106345';
           //ans1.Transaction_Action__c='SOW_ALL_PRODUCTS';
        insert trans3;
           
           
           Monetary_Transaction_Line_Item__c line1 = new Monetary_Transaction_Line_Item__c();
           line1.Transaksjon__c=trans1.id;
           line1.Line_Amount__c=500;
           line1.Type__c='Manuell Behandling';
           line1.Description__c='AUTO';
           line1.Invoice_number__c='123456';
           insert line1;
           String myJSON = JSON.serialize(line1);
           
              MonetarylineWrapper wrapper= new MonetarylineWrapper();

        MonetarylineWrapper obj = new MonetarylineWrapper();
       // obj.month='3';
        //obj.year='2018';
        obj.transactionId= line1.Transaksjon__c;
           obj.description=line1.Description__c;
           obj.invoiceNumber=line1.Invoice_number__c;
           obj.forwarder=testcase1.transporter__c;
              //.transactions.transporter__c;
       obj.lineAmountvalue=String.valueOf(line1.Line_Amount__c);
       
      
        String JSONString = JSON.serialize(obj);
           
   
   
           CS_MonetaryTransactionLineNPBOEBS.loadLineItems(trans1.Id);
           CS_MonetaryTransactionLineNPBOEBS.loadtransaction(trans1.Id);
             CS_MonetaryTransactionLineNPBOEBS.loadcase(trans1.Id);
             CS_MonetaryTransactionLineNPBOEBS.getAllowedArticles(trans1.Id);
            CS_MonetaryTransactionLineNPBOEBS.getOperatingUnit(trans1.Id);
            CS_MonetaryTransactionLineNPBOEBS.savetransactionline(JSONString);
            CS_MonetaryTransactionLineNPBOEBS.getRegressType();
            CS_MonetaryTransactionLineNPBOEBS.getAllowedArticles(trans2.Id);
           CS_MonetaryTransactionLineNPBOEBS.getAllowedArticles(trans3.Id);
         
           
           
       }
       
         static testMethod void searchcustomerTest(){
         
          crm_TestDataFactory.CreateCustomSetting();
       //create party level account
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt;
       
       //create relation level account
       Account relationLevelacnt= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt.parentId=partyLevelacnt.id;
       insert  relationLevelacnt;
       
       CS_RegressCustomer.searchDB('Account', 'Name','Name',5,'Name', 'test');
       
       
         
         
         }
    
    

}