/*
Created By:Supriya Goel
Date: 31 may 2019 
set the opp owner, primary opportunity contact, amount 

*/

global class crm_SetdetailsonOpportunity_Batch implements Database.batchable < sObject > , Database.Stateful {

 
  


 global Database.QueryLocator start(Database.BatchableContext BC) {
 String query='Select id,Accountid, Owner_set_from_Counter_Part__c,crm_Opp_Service_Group__c, crm_Opp_Service_Family__c , crm_Primary_Opportunity_Contact__c, ownerid from Opportunity where  External_Id_from_P11__c!=null and Owner_set_from_Counter_Part__c = false'; //checkbox 
  //if(oppId!=null)
 // query='Select id,Accountid,Owner_set_from_Counter_Part__c, crm_Opp_Service_Group__c, crm_Opp_Service_Family__c , crm_Primary_Opportunity_Contact__c, ownerid from Opportunity where id =:oppId and  External_Id_from_P11__c!=null and Owner_set_from_Counter_Part__c = false'; //checkbox 
  return Database.getQueryLocator(query);
 }
 
 global void execute(Database.BatchableContext BC, List < Opportunity> opplist) {
 
 Map<id,Map<String,opportunity>> AccountOppMap = new Map<id,Map<String,opportunity>>();
 
 Map<String, New_Service_Structure__mdt> newServiceMap= new Map<String, New_Service_Structure__mdt> ();
  List<New_Service_Structure__mdt> newserviceslist= [Select id, Service_Group__c,Service_Family__c,CounterPart_Service_Group__c, CounterPart_Service_Family__c from New_Service_Structure__mdt];
  
  for (New_Service_Structure__mdt newobj:newserviceslist ){
   newServiceMap.put(newobj.Service_Family__c, newobj );
  }
  
    for (Opportunity opp : opplist){
     
  
     if(AccountOppMap.containskey(opp.accountid)){
     
            Map<String,Opportunity > segmentUserMap=  AccountOppMap.get (opp.accountid);    
            Map<String,Opportunity > tempMap  = AccountOppMap.get(opp.accountid);
                tempMap.put(opp.crm_Opp_Service_Family__c, opp);
                AccountOppMap.put(opp.accountid, tempMap);
          
            
        }
        else {  //if not customer peresent 
                
            Map<String,Opportunity > tempMap  = new Map<String,Opportunity >();
            tempMap.put(opp.crm_Opp_Service_Family__c, opp);
            AccountOppMap.put(opp.accountid, tempMap);
                
        }
         
     
       }//end of for 
       List<crm_agreement__c> agrList= [Select id,crm_Agreement_Start_Date__c, crm_Account__c, crm_Agreement_Primary_Contact__c, crm_New_Revenue_Start_Date__c ,crm_Agreement_Service_Family__c, crm_Agreement_Service_Group__c, ownerid from  crm_agreement__c where crm_account__c in :AccountOppMap.keyset() and crm_status__c='Active' ];
       Map<Id, List<crm_agreement__c>>  AccntagrMap= new Map<Id, List<crm_agreement__c>>();
       for (crm_agreement__c agr: agrList)  {
         if (AccntagrMap.containsKey(agr.crm_Account__c)){
                List<crm_agreement__c> templist = new List<crm_agreement__c>();
                templist = AccntagrMap.get(agr.crm_Account__c);   templist.add(agr);    AccntagrMap.put(agr.crm_Account__c,templist );
                
            }
            else {
                List<crm_agreement__c> templist = new List<crm_agreement__c>();    templist.add(agr);    AccntagrMap.put(agr.crm_Account__c,templist) ;
                
                
            } 
       
       
       
       }//end of agr for 
       
       System.debug('##AccntagrMap '+ AccntagrMap);
       
        List<Opportunity> oppList1= [Select id,crm_Opp_Service_Family__c, crm_Opp_Service_Group__c,crm_Primary_Opportunity_Contact__c, ownerid, Accountid from  Opportunity where Accountid in :AccountOppMap.keyset() order by createddate desc ];
       Map<id, List<opportunity>>  AcntoppMap= new Map<id, List<Opportunity>>();
       for (opportunity opp: oppList1)  {
         if (AcntoppMap.containsKey(opp.accountid)){
                List<opportunity> templist = new List<opportunity>();
                templist = AcntoppMap.get(opp.accountid); 
                templist.add(opp); 
                AcntoppMap.put(opp.accountid,templist );
                
            }
            else {
                List<opportunity> templist = new List<opportunity>();
                templist.add(opp);
                AcntoppMap.put(opp.accountid,templist) ;
                
                
            } 
       
       
       
       }//end of opp for 
       
       
           List<crm_Segment__c> segList= [Select id,crm_Service_Group__c, crm_Sales_Responsible__c, crm_Sales_Responsible__r.name,crm_Account__c from  crm_Segment__c where crm_account__c = :AccountOppMap.keyset() order by createddate desc ];
       Map<Id, List<crm_Segment__c>>  AcntSegMap= new Map<Id, List<crm_Segment__c>>();
       for (crm_Segment__c seg: segList)  {
         if (AcntSegMap.containsKey(seg.crm_Account__c)){
                List<crm_Segment__c> templist = new List<crm_Segment__c>(); templist = AcntSegMap.get(seg.crm_Account__c);   templist.add(seg);    AcntSegMap.put(seg.crm_Account__c,templist );
                
            }
            else {
                List<crm_Segment__c> templist = new List<crm_Segment__c>();  templist.add(seg); AcntSegMap.put(seg.crm_Account__c,templist) ;
                
                
            } 
       
       
       
       }//end of seg for 
       
       List<AccountContactrelation> conList= [Select id,Accountid ,contactid, contact.crm_contact_type__c ,contact.crm_Activities_Count__c, contact.status__c from  AccountContactrelation where Accountid = :AccountOppMap.keyset() and contact.status__c='Aktiv' and contact.crm_contact_type__c ='Sales' order by contact.crm_Activities_Count__c desc ];
       Map<Id, id> ContactActcount= new Map<Id, id>();
      
       for (AccountContactrelation con: conList)  {
       if(!ContactActcount.containskey(con.accountid))
            ContactActcount.put(con.accountid, con.contactid);
            
       }//end of con for 
       
         String Datamigrationteamid='';
       environment_settings__c env3 = environment_settings__c.getValues('DataMigrationTeamId');  
      if(env3 != null && env3.value__c !=''){   
         List<User> DataMigrationTeamList= [Select id from user where username= :env3.value__c limit 1];
             if (DataMigrationTeamList.size()>0) {            Datamigrationteamid = DataMigrationTeamList[0].id;      }
      }   
    

       
  for (Opportunity opp : opplist){
     Boolean isOwner = false;
     Boolean isContact= false;
   
       New_Service_Structure__mdt newobj =   newServiceMap.get(opp.crm_Opp_Service_Family__c);
       
       System.debug('## newobj '+ newobj );
       system.debug('##opp' + opp);
       
     if(opp.crm_Opp_Service_Group__c ==newObj.Service_Group__c && opp.crm_Opp_Service_Family__c ==newObj.Service_Family__c){
     if(AccntagrMap.containskey(opp.accountid)){List<crm_agreement__c> agrlist1= AccntagrMap.get(opp.accountid);
       for (crm_agreement__c agr: agrList1){
       System.debug('## agr '+ agr );
       if(agr.crm_Agreement_Service_Family__c == newObj.CounterPart_Service_Family__c && agr.crm_Agreement_Service_Group__c==newObj.CounterPart_Service_Group__c){
        opp.ownerid = agr.ownerid;      isOwner=true;
        if(agr.crm_Agreement_Primary_Contact__c!=null){   opp.crm_Primary_Opportunity_Contact__c= agr.crm_Agreement_Primary_Contact__c;   isContact= true;  opp.Owner_set_from_Counter_Part__c= true;
        }
        
       }
       
       }
       
     }
     if(AcntoppMap.containskey(opp.Accountid) && (!isContact || !isOwner)){
     List<Opportunity> oppList2 = AcntoppMap.get(opp.Accountid);
     for (Opportunity opp1: opplist2){
     if(opp1.crm_Opp_Service_Family__c == newObj.CounterPart_Service_Family__c && opp1.crm_Opp_Service_Group__c==newObj.CounterPart_Service_Group__c){
        opp.ownerid = opp1.ownerid;
         isOwner=true;
        if(opp1.crm_Primary_Opportunity_Contact__c!=null){
            opp.crm_Primary_Opportunity_Contact__c= opp1.crm_Primary_Opportunity_Contact__c;   
             isContact= true;
             opp.Owner_set_from_Counter_Part__c= true;
            }
             
      
       }
     }
     
     }
     if(AcntSegMap.containskey(opp.AccountId)  && !isOwner){
     List<crm_Segment__c> seglist1= AcntSegMap.get(opp.Accountid);
     for (crm_Segment__c seg: seglist1){
     if(seg.crm_Service_Group__c ==newObj.CounterPart_Service_Group__c){
        if(!seg.crm_Sales_Responsible__r.name.contains('Kanal') && seg.crm_Sales_Responsible__c !=null  )      opp.ownerid = seg.crm_Sales_Responsible__c;
         else {        opp.ownerid=Datamigrationteamid ;    
         
         } 
            
       }
     }
     }
     
     if(ContactActcount.containskey(opp.accountid) && !isContact){
         if (ContactActcount.containskey(opp.accountid))          opp.crm_Primary_Opportunity_Contact__c = ContactActcount.get(opp.accountid);
         
     
     }
     opp.Owner_set_from_Counter_Part__c= true;
    }//end of counter service part check
     
     
     } //end of opp loop
         
            
    update opplist;     
  
   
   
   
   
   }//end of fn
  
 
 


global void finish(Database.BatchableContext BC) {
 
  

 }
 }