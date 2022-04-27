@isTest
Public class CreateMonetaryTransactionControllerTest{



public static Service_Product__c createTestProduct(){
      Service_Product__c p=new Service_Product__c(Name='MyTestProduct');
      insert p;
      return p;
    }
    
    
public static Service_Product__c testProduct=createTestProduct();    
        
        static testMethod void Test1() {
        list<monetary_transaction__c> tlist = new list<monetary_transaction__c> ();
        Case c = new Case(subject='Test case', Service_Product__c=testProduct.id);
                upsert c;
        id rtid = [select id,developerName from RecordType where SObjectTYpe= 'Monetary_Transaction__c' and developerName ='Transaction_NPB_OEBS' limit 1].id;
        
        monetary_transaction__c t = new monetary_transaction__c(case__c=c.id, Bank_Account_Number__c='12345678903',RecordTypeId = rtid );
        
        tlist.add(t);
        upsert tlist;       

       Test.startTest();
           Test.setCurrentPage(Page.CreateMonetaryTransaction);
           ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(tlist);
           ApexPages.currentPage().getParameters().put('id', c.id);
           CreateMonetaryTransactionController pCon = new CreateMonetaryTransactionController(stdSetController );       
           pCon.ContinueToCase();
       Test.stopTest();
         

}

}