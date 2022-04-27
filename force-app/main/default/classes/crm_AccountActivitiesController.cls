/*
Created By: Supriya Goel
Object  :Account 
Date: Sprint 1
Controller class for vf page to show  all open activities on the account detail page
*/

public class crm_AccountActivitiesController {

    private ApexPages.StandardController controller {get; set;}
    public Account acnt{get;set;}
    public Set<Id> allAccounts;
    public List<OpenActivity>  actRList {get; set;}
    public boolean flag {get;set;}
    
    //**Contructor
    public crm_AccountActivitiesController(ApexPages.StandardController controller) {
        this.controller = controller;
        this.acnt = (Account)controller.getRecord();
        allAccounts= new Set<Id>();
        getallchildaccounts();
        String theme = UserInfo.getUiThemeDisplayed();
        if(theme != 'Theme3' )
            flag = true;
        else
            flag = false;
       
    }
    
    //function to get all the activities for all the child account and parent account
    public void getallchildaccounts(){ 
        if(acnt.id!=null)
        {        
            allAccounts.add(acnt.id);
            try {
                for (Account a: [Select Id from account where ParentId = :acnt.Id]) {
                     allAccounts.add(a.id);
                }
             }//end of try
            catch(Exception e) {crm_Exception_handler.createExceptionRecords(e) ;}
          
            //get list of activities       
            actRList = new List<OpenActivity>();
            try {
                for(Account acc : [Select (Select Id,What.Name,WhatId,IsTask,Owner.Name,ActivityDate,AccountId,Account.Name,Status, Priority, CreatedBy.Name,       Subject From OpenActivities order by CreatedDate DESC) from Account where Id in  :allAccounts]){
                        if(!(acc.OpenActivities.isEmpty())){ 
                              for(OpenActivity opnAct: acc.OpenActivities) { // If there are multiple Tasks and Events this loop will take care of that.
                                    actRList.add(opnAct);
                                }
    
                            }
                        } 
           
                }//end of try
            catch(Exception e) {crm_Exception_handler.createExceptionRecords(e) ;}
        }
    }
    
}