/*
Created By:Supriya Goel
Date: 27 th oct 2016
set conversion fields to blank

*/

global class crm_setvaluesonpartyforconversion_Batch implements Database.batchable<sObject>,Database.Stateful{
    public string callback = '';        
    global crm_setvaluesonpartyforconversion_Batch (String callback){
        this.callback = callback;   
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
         crm_AccountRecordTypes__c rTparty= crm_AccountRecordTypes__c.getValues('Party level Customer');
         Id partyLevelRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTparty.crm_Record_Type_Label__c).getRecordTypeId();
         String tempid ='001w000001YDwoYAAT';
        String query = 'Select id, crm_conv_Count_Org_No_in_group__c , crm_cov_ListOrg_no_in_group__c, crm_Conv_Customer_Conversion_Group__c, crm_Conv_Total_Revenue__c, crm_conv_Customer_state__c,crm_Conv_Conversion_Process__c,crm_Conv_Order_Channel__c, crm_Conv_Converison_Heat__c,Planned_Conversion_date__c,crm_Conv_Start_Date__c, Agreement_Proposition_Ready__c,Conversion_Ready__c, Customer_Price_Ready__c,Conversion_Email_Sent__c, Customer_Converted__c, crm_customer_converted_date__c, crm_conv_Conversion_comment__c,currencyisocode  from Account where RecordTypeId = :partyLevelRecordTypeId and id !=:tempid '; 
        return Database.getQueryLocator(query);                      
    }

    global void execute(Database.BatchableContext BC, List<Account> acclist) {
    for (Account a:acclist )
    {
        a.crm_conv_Count_Org_No_in_group__c = 0;
        a.crm_cov_ListOrg_no_in_group__c= '' ;
        a.crm_Conv_Customer_Conversion_Group__c='';
        a.crm_Conv_Total_Revenue__c =0;
        a.crm_conv_Customer_state__c ='';
        a.crm_Conv_Conversion_Process__c ='';
        a.crm_Conv_Order_Channel__c='';
        a.crm_Conv_Converison_Heat__c ='';
        a.Planned_Conversion_date__c =null;
        a.crm_Conv_Start_Date__c = null;
        a.Agreement_Proposition_Ready__c = false;
        a.Conversion_Ready__c = false;
        a.Customer_Price_Ready__c = false; 
        a.Conversion_Email_Sent__c= null;
        a.Customer_Converted__c = '';
        a.crm_customer_converted_date__c=null;
        a.crm_conv_Conversion_comment__c= '';
    }
     update acclist;
    
    
    
    }
    
    
     global void finish(Database.BatchableContext BC) {
        String str = '';
        AsyncApexJob[] a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ApexClass.Name from AsyncApexJob where Id =:bc.getJobId() ];
        if(callback != '' && callback != null)
                  str += callback + '\n';
        
        if(a != null && a.size() > 0){
                    str += a[0].ApexClass.Name + ' ( '+ a[0].Id + ' ' + a[0].status + ')  processed ' + a[0].TotalJobItems + ' batches with '+ a[0].NumberOfErrors + ' failures.';
                }
                
                
                 //send mail 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List < string > toAddress = new List < string > ();
        environment_settings__c emailnotifications = environment_settings__c.getValues('BatchEmailNotification');
        List < String > valuesList1 = new List < String > ();
        if (emailnotifications != null && emailnotifications.value__c != null) 
        valuesList1 = emailnotifications.value__c.split(',');
     
       for (String emailuser:valuesList1 )
            toAddress.add(emailuser);  
       //below code will send an email to User about the status
        mail.setToAddresses(toAddress);
        mail.setSenderDisplayName('Posten');
        mail.setSubject('Set default values on Party customer for Conversion plan ');
        mail.setPlainTextBody(str);
        
        // Send the email for the developer reference
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });          
        
          
      } 

    }