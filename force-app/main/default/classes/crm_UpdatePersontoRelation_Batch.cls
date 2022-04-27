/*
Created By:Supriya Goel
Date: 10 may 2018
if there are revenue lines on Person customer , convert it into Relation account and mark the field wasPersonaccount=true
*/

global class crm_UpdatePersontoRelation_Batch implements Database.batchable<sObject>
{    
Id privateRecordtypeid  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Privat').getRecordTypeId();
 Id relationRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Relation level Customer').getRecordTypeId();

  public string callback = '';
  public crm_UpdatePersontoRelation_Batch(String callback){
  this.callback = callback;
  
  }
 
global Database.QueryLocator start(Database.BatchableContext BC){
 string tempid ='0010E00000KMqKY';
 
  //select all Private accounts
       String query = 'Select id, WasPersonAccount__c from Account where recordtypeid =  :privateRecordtypeid order by lastmodifieddate desc'; 
       return database.getquerylocator(query);
    }    
    
    global void execute(Database.BatchableContext BC, List<Account> AccountList) {
    
    Set<Id> acntIds = new Set<Id>();
    Set<Id> personacntIds = new Set<Id>();
    for (Account a: AccountList){
        acntIds.add(a.id); 
    }
    //get all revenue lines for these accounts
    
    List<crm_revenue_line__c> revList =[Select id, crm_account__c from crm_revenue_line__c where crm_account__c in :acntIds ];
    if (revList.size()>0 ){
        for(crm_revenue_line__c  rev :revList){
            personacntIds.add(rev.crm_account__c ) ;
                
           }
      }
      List<Account> personAcntList= [Select id, recordtypeid from Account where id in :personacntIds];
      if (personAcntList.size()>0) {
          for (Account a:personAcntList ) {
              a.recordtypeid= relationRecordTypeId ;
              
          }
          
          update personAcntList;
      }
      
      if (personAcntList.size()>0) {
          for (Account a:personAcntList ) {
            a.WasPersonAccount__c  = true;  
          }
          
          update personAcntList;
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
        
    }


}