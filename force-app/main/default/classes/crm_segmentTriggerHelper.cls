/*
Created By: Supriya Goel
Object  :segment
Date: 12 july 
If responsible seller on the segment changers then the revenue responsible seller to be updated for that month
*/

public class crm_segmentTriggerHelper {

    public static void updateResponsibleSelleronRev(List<crm_Segment__c> newSegList){
    Set<Id> relationAcntids = new Set<Id>();
    Map<Id,List<crm_Segment__c>> AccountSegmentMap= new Map<Id,List<crm_Segment__c>>();
    
    for(crm_Segment__c seg: newSegList) {
       relationAcntids.add(seg.crm_Account__c);
                            
        if (AccountSegmentMap.containsKey(seg.crm_Account__c)){
            List<crm_Segment__c> templist = new List<crm_Segment__c>();
            templist = AccountSegmentMap.get(seg.crm_Account__c);
            templist.add(seg);
            AccountSegmentMap.put(seg.crm_Account__c,templist ) ;
        }
        else {
            List<crm_Segment__c> templist = new List<crm_Segment__c>();
            templist.add(seg);
            AccountSegmentMap.put(seg.crm_Account__c,templist) ;
        } 
            
    }
    Integer currentMonth = Date.Today().Month();
    Integer currentYear  = Date.Today().Year();
    
    List<crm_Revenue_Line__c> RevenueList = [Select crm_Account__c ,crm_Responsible_Seller__c,crm_Transaction_Month__c, crm_Transaction_Year__c, crm_Product_Service_Group__c from crm_Revenue_Line__c  where crm_Account__c in :RelationacntIds and crm_Transaction_Month__c =:currentMonth and crm_Transaction_Year__c  =:currentYear]; 
    for (crm_Revenue_Line__c rev :RevenueList){
        List<crm_Segment__c> segmentListtocheck =  AccountSegmentMap.get(rev.crm_Account__c);
        for (crm_Segment__c seg: segmentListtocheck ){
            if (seg.crm_Service_Group__c == rev.crm_Product_Service_Group__c){
                rev.crm_Responsible_Seller__c = seg.crm_Sales_Responsible__c;
                break;
            
            }//end of if
        
        }//end of seg for
    
    
    }//end of rev line for
   try{
           update RevenueList ;
            
      }catch(Exception e) { crm_Exception_handler.createExceptionRecords(e);}          

    } 
    public static void MapDivisionRecordonUpdate(List<crm_Segment__c> newSegList){
             
        Set<Id> accountSet =  new Set<Id>();
        Set<Id> UserSet=  new Set<Id>();
            
        Map<Id,crm_Segment__c> SegmentMap= new Map<Id,crm_Segment__c>();
        Map<Id,User> userMap= new Map<Id,User>();
        Map<Id,Account> accountMap= new Map<Id,Account>();
        
        for (crm_segment__c seg: newSegList){
            accountSet.add(seg.crm_account__c);
            UserSet.add(seg.crm_Sales_Responsible__c);
        } 
        //sales responsible user map
        List<User> salesResponsibleList= [Select firstname, lastname, email,phone from User where  id in:UserSet];
        for (User u : salesResponsibleList ){
            userMap.put(u.id, u);
        
        }
        
        List<Account> AccountList= [Select name from account where  id in:accountSet];
        for (Account a : AccountList){
            accountMap.put(a.id, a);
        
        }
        
        for (crm_segment__c seg: newSegList){
            //check if divsion record already exists for the segment
            if(seg.crm_Division_Id__c!=null){
                SegmentMap.put(seg.crm_Division_Id__c, seg);      
            }
          
              
      }      
        List<Division__c> UpdatedDivList=[select account__c, Sales_Person_First_Name__c,Sales_Person_Last_Name__c, Sales_Person_Email__c, Sales_Person_Phone_Number__c,SegmentName__c, SubSegmentName__c, Name from division__c where id in :SegmentMap.keyset()];
        for (Division__c div: UpdatedDivList){
              crm_segment__c seg = SegmentMap.get(div.id);
              if(seg.crm_Sales_Responsible__c !=null && userMap.containskey(seg.crm_Sales_Responsible__c)){
                  User u =userMap.get(seg.crm_Sales_Responsible__c);
                  div.Sales_Person_First_Name__c = u.firstname;
                  div.Sales_Person_Last_Name__c = u.lastname;
                  div.Sales_Person_Email__c = u.email;
                  div.Sales_Person_Phone_Number__c = u.phone;
                }
              div.SegmentName__c = seg.crm_Service_Group__c ;
              div.Name= accountMap.get(seg.crm_account__c).name + '-' +  seg.crm_Service_Group__c ;
              div.SubSegmentName__c = seg.crm_Sales_Internal_Segment__c; 
             }    
        
    
   try{
       
        if (UpdatedDivList.size()>0){
            update UpdatedDivList;
                   
        }
        
            }catch(Exception e) {  crm_Exception_handler.createExceptionRecords(e); }  
    
    }
    
    public static void MapDivisionRecordonInsert(List<crm_Segment__c> newSegList){ 
        List<Division__c> InsertDivlist = new List<Division__c>();      
        Set<Id> UserSet=  new Set<Id>();
        Set<Id> accountSet=  new Set<Id>();
        
        Map<Id,User> userMap= new Map<Id,User>();
        Map<Id,Account> accountMap= new Map<Id,Account>();
        
        for (crm_segment__c seg: newSegList){
            UserSet.add(seg.crm_Sales_Responsible__c);
            accountSet.add(seg.crm_account__c);
        } 
        //sales responsible user map
        List<User> salesResponsibleList= [Select firstname, lastname, email,phone from User where  id in:UserSet];
        for (User u : salesResponsibleList ){
            userMap.put(u.id, u);
        
        }
        
        List<Account> AccountList= [Select name from account where  id in:accountSet];
        for (Account a : AccountList){
            accountMap.put(a.id, a);
        
        }
        
        for (crm_segment__c seg: newSegList){
           
              Division__c div= new Division__c();
              div.account__c = seg.crm_account__c ;
              if(seg.crm_Sales_Responsible__c !=null && userMap.containskey(seg.crm_Sales_Responsible__c)){
                  User u =userMap.get(seg.crm_Sales_Responsible__c);
                  div.Sales_Person_First_Name__c = u.firstname;
                  div.Sales_Person_Last_Name__c = u.lastname;
                  div.Sales_Person_Email__c = u.email;
                  div.Sales_Person_Phone_Number__c = u.phone;
              }
              
              div.SegmentName__c = seg.crm_Service_Group__c ;
              div.Name= accountMap.get(seg.crm_account__c).name + '-' +  seg.crm_Service_Group__c ;
              div.SubSegmentName__c = seg.crm_Sales_Internal_Segment__c; 
              InsertDivlist.add(div) ;
           
            }
      
       try{
        if (InsertDivlist.size()>0){
            insert InsertDivlist;
                   
        }
        
       }catch(Exception e) { crm_Exception_handler.createExceptionRecords(e); }  
         
       for (integer i =0; i < newSegList.size() ;i++){
              newSegList[i].crm_Division_Id__c = InsertDivlist[i].id;         
       }
   }
     
   
    
 }