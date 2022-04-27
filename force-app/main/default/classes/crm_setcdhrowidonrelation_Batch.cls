/*
Created By:Supriya Goel
Date: 13th may 2019
set the cdh row id as  relation-rowid

*/

global class crm_setcdhrowidonrelation_Batch implements Database.batchable<sObject>,Database.Stateful{
    public string callback = '';   
    global Integer Faliurecount=0;     
    global crm_setcdhrowidonrelation_Batch (String callback){
        this.callback = callback;   
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
         crm_AccountRecordTypes__c rTrelation= crm_AccountRecordTypes__c.getValues('Relation level Customer');
         Id relationLevelRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTrelation.crm_Record_Type_Label__c).getRecordTypeId();
       String tempid= '0017E000013nSfi';
        String query = 'Select id, crm_CDH_RowId__c, orga__c, crm_customer_number__c  from Account where RecordTypeId = :relationLevelRecordTypeId and crm_CDH_RowId__c!=null'; 
        return Database.getQueryLocator(query);                      
    }
    
      global void execute(Database.BatchableContext BC, List<Account> acclist) {
      for (Account a: acclist){
          a.crm_CDH_RowId__c  = 'relation-' + a.crm_CDH_RowId__c ; 
      }
      //update accounta nd handle exceptions
       String FailedOrgNumber;
       String FailedCustomerNumber;
         List<crm_Exception__c> errorlogs=new List<crm_Exception__c>();
      
        Database.SaveResult[] UpdateResultList=Database.update(acclist,false);

                for(Integer i = 0; i < UpdateResultList.size(); i++)
                 {
                            if(UpdateResultList[i].isSuccess()==false)
                            {
                                 Faliurecount++;
                                 FailedOrgNumber=acclist[i].orga__c;
                                 FailedCustomerNumber=acclist[i].crm_customer_number__c;
                                 for(Database.Error err : UpdateResultList[i].getErrors()) {
                                 crm_Exception__c ex=new crm_Exception__c();
                                 if(err.getMessage().length()>255)
                                 {
                                 err.getMessage().abbreviate(252);
                                 }
                                 ex.crm_Message__c=err.getMessage();
                                 ex.crm_Dml_Field_Names__c=String.valueof(err.getFields());
                                 ex.crm_Stack_Trace__c='crm_setcdhrowidonrelation_Batch  FailedOrgNumber:'+FailedOrgNumber+' FailedCustomerNumber:'+FailedCustomerNumber+' Account Id'+acclist[i].id;
                                 errorlogs.add(ex);
                                 }

                            }
                }
      
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
        String[] toAddresses = new String[] {'postenbringsalesforce.no@capgemini.com'}; 
        String[] ccAddresses = new String[] {'supriya.goel@capgemini.com'};
        
        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);
        mail.setReplyTo('postenbringsalesforce.no@capgemini.com');
        mail.setSenderDisplayName('Posten');
        mail.setSubject('Set CDH rowid on relation account ');
        mail.setPlainTextBody(str);
        
        // Send the email for the developer reference
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });          
        
          
      } 

    }