/* Created By: Supriya Goel
Date: 11th nov 2018
Test class: Test class crm_addproducttopricebook_Batch , crm_addproducttopricebookHelper 
*/


@isTest

public class crm_addproducttopricebook_BatchTest{
    
    @testSetup static void setup() {
    
      //create product
        Product2 prdobj = crm_TestDataFactory.createProduct();
        prdobj.crm_ERP_Product_ID__c ='123' ;
        prdobj.crm_global_Service_Area__c='Logistics';
        prdobj.crm_global_Service_Group__c ='Business Delivery';
        prdobj.crm_global_Service_Family__c ='Business Delivery';
        prdobj.IsActive = true;
        prdobj.crm_New_Service__c = true;
        insert prdobj;
        
        }
        
         static testMethod void createpricebookentry(){
         Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
         Pricebook2 Pricebook = new Pricebook2(
           name=' Business Delivery',
            IsActive = true
        );
         insert Pricebook;
      
          List<Product2> prdlist= [Select id from  Product2 where crm_ERP_Product_ID__c ='123'];
          crm_addproducttopricebook_Batch acb = new crm_addproducttopricebook_Batch(''); 
            
            System.Test.startTest();
            Database.executeBatch(acb);    
            System.Test.stopTest(); 
         }
         
      }