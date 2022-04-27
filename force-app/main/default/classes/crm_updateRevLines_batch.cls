/*
Created By: Supriya Goel
Object  : Update Unique id  in Rev lines which are craeted by data migration team
*/

global class crm_updateRevLines_batch implements Database.Batchable<SObject>{

    String queryString = '';
   
                    
    public crm_updateRevLines_batch (){
     
    Id DatamigrationUserid = [select id from User where name = 'Data Migration Team'].Id;
       
        queryString += 'Select crm_Account__r.crm_Customer_Number__c , crm_Product_ERP_ID__c ,crm_Transaction_Month_Text__c, crm_Transaction_Month_Number__c, crm_Transaction_Year_Text__c, crm_Rev_Line_Unique_Id__c , crm_Transaction_Date__c from crm_Revenue_Line__c ';
        queryString += ' WHERE createdbyId =  \''+DatamigrationUserid +'\'  order by crm_Account__c ';
        
        
    }

    global Database.QueryLocator start(Database.BatchableContext bcMain){   
        return Database.getQueryLocator(queryString);
    }
    
    global void execute(Database.BatchableContext bcMain, List<crm_Revenue_Line__c> revLines){
    
    for (crm_Revenue_Line__c rev: revLines){
    
       if (rev.crm_Transaction_Date__c!=null){
            rev.crm_Transaction_Month_Text__c= String.valueof(rev.crm_Transaction_Date__c.month());
            rev.crm_Transaction_Month_Number__c= Integer.valueof(rev.crm_Transaction_Date__c.month());
            rev.crm_Transaction_Year_Text__c= String.valueof(rev.crm_Transaction_Date__c.year());
            rev.crm_Rev_Line_Unique_Id__c=  rev.crm_Account__r.crm_Customer_Number__c + rev.crm_Product_ERP_ID__c + String.valueof(rev.crm_Transaction_Date__c.month()) + String.valueof(rev.crm_Transaction_Date__c.year())+'NAV-OEBS';
            
    }
    
    
    }
    
    try{
              
        Database.update (revLines, false);
        }catch(Exception e) {   crm_Exception_handler.createExceptionRecords(e);   }   

    }    
     global void finish(Database.BatchableContext bc){}

}