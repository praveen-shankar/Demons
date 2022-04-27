/*
Created By:Supriya Goel
Date: 8th feb  2018
add the prodtcs to pricebook

*/

global class crm_addproducttopricebook_Batch implements Database.batchable<sObject>
{    
    
    public string productid = '01tw0000004izqU';        
    global crm_addproducttopricebook_Batch (String productid){
        this.productid= productid;   
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
      String query = 'Select id, name, crm_global_Service_Family__c  from Product2 where  crm_New_Service__c= true and isActive= true order by lastmodifieddate desc'; 
        return database.getquerylocator(query);       
       
    }
    
      global void execute(Database.BatchableContext BC, List<Product2> productList) {
      
      crm_addproducttopricebookHelper.addPricebookentries(productList);
  
   
   }
   
   
   global void finish(Database.BatchableContext BC) {}
   
      
      }