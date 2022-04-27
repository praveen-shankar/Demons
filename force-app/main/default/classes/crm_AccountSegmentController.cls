/*
Created By: Supriya Goel
Object  :Account 
Date: 22 feb 2017 
Controller class for vf page to show  all segments on relation level from the party 
*/

public class crm_AccountSegmentController {
    
    private ApexPages.StandardController controller {get; set;}
    public Account acnt{get;set;}
    public List<crm_segment__c>  segList{get; set;}
    public boolean flag {get;set;}
    
    
    //**Contructor
    public crm_AccountSegmentController (ApexPages.StandardController controller) {
        this.controller = controller;
        this.acnt = (Account)controller.getRecord();
        acnt=[select id, parentid,CustomerTeam__c from Account where id=:acnt.id];
        segList = new List<crm_segment__c>();
        segList = [Select id,name, crm_Account__c, crm_Business_Area__c, crm_Sales_Responsible__r.name , crm_Sales_Responsible__c, crm_Customer_Service_Responsible__r.name,crm_Customer_Service_Responsible__c, crm_Sales_Internal_Segment__c, crm_Sales_Team__c, crm_Segment_Start_Date__c, crm_Service_Group__c, crm_Customer_Service_Category__c, crm_Customer_Service_Level__c from crm_Segment__c where crm_Account__c =:acnt.parentid ];
        String theme = UserInfo.getUiThemeDisplayed();
        if(theme != 'Theme3' )
            flag = true;
        else
            flag = false;
        
        IF (!(String.isBlank(acnt.CustomerTeam__c))){
            FOR (crm_Segment__c seg: segList){
                IF (seg.crm_Service_Group__c == 'Post')
                    seg.crm_Customer_Service_Level__c = acnt.CustomerTeam__c;            
            }
        }
    }
    
    
}