/*
Created By:Supriya Goel
Date: 9th july 2018
update segment record,  forecast , sales goal , revenue data
*/

global class crm_updateresponsibleseller_Batch implements Database.batchable<sObject>
{    
      public Set<string> reqId= new Set<String>();
      
    //added
    global crm_updateresponsibleseller_Batch (){}
  global crm_updateresponsibleseller_Batch (Set<String> reqId){
        this.reqId= reqId;   
       
    }
 
global Database.QueryLocator start(Database.BatchableContext BC){
    Set<String> status= new Set<String>{'Approved','Processing incomplete'};

   String query  ='Select id,  Customer__c ,Customer__r.Name, Customer__r.orga__c, Start_Date__c , Status__c   , Service_Group__c , Current_Sales_Responsible__c, Current_Sales_Responsible__r.email,Current_Sales_Responsible__r.Name, Proposed_Sales_Responsible__r.email, Proposed_Sales_Responsible__c,Proposed_Sales_Responsible__r.Name, Proposed_Sales_Responsible__r.lastname, Proposed_Sales_Responsible__r.firstname, RevUpdatedFlag__c ,SegmentupdatedFlag__c,ForecastUpdatedFlag__c from Segment_Change_Request__c where Status__c in :status and Start_Date__c <= TODAY';

       if (reqId.size()>0)
               query += ' and id in :reqId';
          
       return database.getquerylocator(query);
    }    
   
    
    global void execute(Database.BatchableContext BC, List<Segment_Change_Request__c> reqList) {
    
     System.debug('@@reqList'+ reqList);
     
     Set<String> reqIds = new Set<String>();
     Set<String> accountIds = new Set<String>();
      Set<String> orgIds = new Set<String>();
     Set<String> servicegrp = new Set<String>();
     

     
     List<crm_Exception__c> errorlogs=new List<crm_Exception__c>();
     
     Map<Id,Map<String, Segment_Change_Request__c >> accountSegmentMap=  new  Map<Id,Map<String, Segment_Change_Request__c >>();
     
     
    for (Segment_Change_Request__c req: reqList) {
        accountIds.add(req.Customer__c);
        servicegrp.add(req.Service_Group__c);
        orgIds.add(req.Customer__r.orga__c);
       
        if (accountSegmentMap.containskey (req.Customer__c)){
            
            Map<String,Segment_Change_Request__c > segmentUserMap=  accountSegmentMap.get (req.Customer__c);    
            Map<String,Segment_Change_Request__c > tempMap  = accountSegmentMap.get(req.Customer__c);
                tempMap.put(req.Service_Group__c, req);
                accountSegmentMap.put(req.Customer__c, tempMap);
          
            
        }
        else {  //if not customer peresent 
                
            Map<String,Segment_Change_Request__c > tempMap  = new Map<String,Segment_Change_Request__c >();
            tempMap.put(req.Service_Group__c, req);
            accountSegmentMap.put(req.Customer__c, tempMap);
                
        }
         
     }
     
      System.debug('@@accountIds'+ accountIds);
       System.debug('@@servicegrp'+ servicegrp);
      
     
     List<crm_segment__c> segList= new  List<crm_segment__c>();
     segList= [Select id, crm_account__c , crm_Service_Group__c  , crm_Sales_Responsible__c from crm_segment__c  where crm_account__c in  :accountIds  and    crm_Service_Group__c in :servicegrp];
     
     Map<id, Segment_Change_Request__c> segRequestMap= new Map<Id,Segment_Change_Request__c>();
     
     OrgWideEmailAddress owa = [Select id, DisplayName, Address from OrgWideEmailAddress limit 1];
     EmailTemplate etlosing = [SELECT Id FROM EmailTemplate WHERE DeveloperName ='Segment_request_seller_losing_customer_template' ];
     EmailTemplate etgetting = [SELECT Id FROM EmailTemplate WHERE DeveloperName ='Segment_request_seller_getting_customer_template' ];
     
     
     List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>(); 
           
     
      for (crm_segment__c  seg:segList ){
          if (accountSegmentMap.containskey(seg.crm_account__c)){
              Map<String,Segment_Change_Request__c > tempMap  = accountSegmentMap.get(seg.crm_account__c);
              if(tempMap.containskey(seg.crm_Service_Group__c)){
                   Segment_Change_Request__c reqObj= tempMap.get(seg.crm_Service_Group__c);  
                   seg.crm_Sales_Responsible__c= reqObj.Proposed_Sales_Responsible__c ;
                   segRequestMap.put(seg.id,reqObj);
              }
              
          }
          

      }
      
       
      
        try
            {   
                       
                //for inserting child records of new party level account 
                if(segList.size()>0)
                {              
                       //Insert all new party accounts
                       Database.SaveResult[] UpdateResultList=Database.update(segList,false);
                           for(Integer i = 0; i < UpdateResultList.size(); i++)
                           {
                                String segId = segList[i].id;
                                 Segment_Change_Request__c reqObj = new Segment_Change_Request__c ();
                                if(segRequestMap.containskey(segId))
                                    reqObj = segRequestMap.get(segId);
                                if(UpdateResultList[i].isSuccess()==false)
                                {   
                                    for(Database.Error err : UpdateResultList[i].getErrors()) {
                                     crm_Exception__c ex=new crm_Exception__c();
                                     if(err.getMessage().length()>255)
                                     {
                                     err.getMessage().abbreviate(252);
                                     }
                                     ex.crm_Message__c=err.getMessage();
                                     ex.crm_Dml_Field_Names__c=String.valueof(err.getFields());
                                     ex.crm_Stack_Trace__c='Segments not updated with Id  :'+segId ;
                                     errorlogs.add(ex);
                                     }
    
                                }
                                else{
                                
                                reqObj.SegmentupdatedFlag__c = true;
                                String subject= 'Responsible seller changed for '+ reqObj.Customer__r.Name;
                                
                                List<string> toAddress = new List<string>();
                                
                                toAddress.add(reqObj.Current_Sales_Responsible__r.email);
                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                    mail.setTemplateId(etlosing.Id);
                                    mail.setToAddresses(toAddress);
                                    mail.setSubject(subject);
                                   // mail.setTargetObjectId(primaryContact);
                                    mail.setWhatId(reqObj.Customer__C);
                                    mail.setSaveAsActivity(false);
                                    mail.setUseSignature(false);
                                        
                                   String body='';
                                  String losingbody='';
    
                                   String losingheader = 'Hello ' + reqObj.Current_Sales_Responsible__r.Name + '<br><br>';
                                    body = ' The responsible seller has been changed for '+ reqObj.Customer__r.Name +'<br><br>';
                                     body += 'Details of the change of Responsible seller:<br> Customer : '+ reqObj.Customer__r.Name +'<br> ';
                                     body+='Service Group: '+ reqObj.Service_Group__c + '<br> Start date: '+ reqObj.Start_Date__c +' <br>'; 
                                     body +=' Current Sales Responsible: '+ reqObj.Current_Sales_Responsible__r.Name + '<br>';
                                     body +='New Sales Responsible: '+ reqObj.Proposed_Sales_Responsible__r.Name;
                                        
                                     
                                        String bodyfooter = '<br><br>Thanks,<br> Salesforce<br>Posten & Bring support';
                                        losingbody = losingheader  + body + bodyfooter ;
                                        mail.setHtmlBody(losingbody);
                                        allmsg.add(mail);
                                        
                                         List<string> toAddress1 = new List<string>();
                                 toAddress1.add(reqObj.Proposed_Sales_Responsible__r.email);
                                Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                                    mail1.setTemplateId(etgetting.Id);
                                    mail1.setToAddresses(toAddress1);
                                    mail1.setSubject(subject);
                                   // mail.setTargetObjectId(primaryContact);
                                    mail1.setWhatId(reqObj.Customer__C);
                                    mail1.setSaveAsActivity(false);
                                    mail1.setUseSignature(false);
                                        
                                   
                                  String gettingbody='';
    
                                   String gettingheader = 'Hello ' + reqObj.Proposed_Sales_Responsible__r.Name + '<br><br>';
                                   
                                  
                                        gettingbody= gettingheader + body + bodyfooter ;
                                        mail1.setHtmlBody(gettingbody);
                                        allmsg.add(mail1);
                                }
                            }
                   }                   
                   else{
                    for (Segment_Change_Request__c req: reqList) {
                        req.SegmentupdatedFlag__c = true;
                    
                    }
                }
                   }catch(Exception e){ crm_Exception_handler.createExceptionRecords(e); }
                   
        try {
    Messaging.sendEmail(allmsg,false);
   
} catch (Exception e) {
    System.debug(e.getMessage());
}   

    
                   
      Map<id,Id> relationpartymap= new Map<Id,ID>();
     Set<id> relationids= new Set<Id>();              
     List<Account> relationaccounts= [Select id, parentid from account where parentid in : accountIds];
     for (Account a :  relationaccounts){
             relationids.add(a.id);
             relationpartymap.put(a.id,a.parentid);
     }
      Map<id, Segment_Change_Request__c> revRequestMap= new Map<Id,Segment_Change_Request__c>();
      System.debug('@@relationpartymap'+relationpartymap);
      System.debug('@@accountSegmentMap'+accountSegmentMap);
      List<crm_Revenue_Line__c> revList= new List<crm_Revenue_Line__c>();
      revList= [Select id,crm_Account__c, crm_Transaction_Date__c, crm_Product_Service_Group__c, crm_Responsible_Seller__c, crm_Revenue_Responsible__c From  crm_Revenue_Line__c where crm_account__c in  :relationpartymap.keyset()  and crm_Product_Service_Group__c in :servicegrp];
      System.debug('@@'+ revList);
      for  (crm_Revenue_Line__c rev:revList ){
          if(relationpartymap.containskey(rev.crm_account__c)){
              Id partyid= relationpartymap.get(rev.crm_account__c);
             
          if (accountSegmentMap.containskey(partyid)){
             Map<String,Segment_Change_Request__c> tempMap  = accountSegmentMap.get(partyid);
            
             if(tempMap.containskey(rev.crm_Product_Service_Group__c )){
                  Segment_Change_Request__c reqObj= tempMap.get(rev.crm_Product_Service_Group__c );
                   revRequestMap.put(rev.id,reqObj);
                   if(rev.crm_Transaction_Date__c >= reqObj.Start_Date__c )  { //Transaction Date equal or greater than Start Month/Start Year
                
                   rev.crm_Responsible_Seller__c =  reqObj.Proposed_Sales_Responsible__c ;
                   String name= '';
                   if(reqObj.Proposed_Sales_Responsible__r.firstname!='' || reqObj.Proposed_Sales_Responsible__r.firstname !=null)
                            name= reqObj.Proposed_Sales_Responsible__r.firstname + ' ';
                        else
                        name= reqObj.Proposed_Sales_Responsible__r.lastname;    
                   rev.crm_Revenue_Responsible__c = name;
                  
                  }
               }                    
              }
            }  
          }
          System.debug('####@@ revList'+revList.size()); 
          try
            { //for inserting child records of new party level account 
                if(revList.size()>0 )
                {              
                       //Insert all new party accounts
                       Database.SaveResult[] UpdateResultList=Database.update(revList,false);
                           for(Integer i = 0; i < UpdateResultList.size(); i++)
                           {
                               String RevId = revList[i].id;
                                Segment_Change_Request__c reqObj = new Segment_Change_Request__c ();
                               if(revRequestMap.containskey(RevId))
                                   reqObj = revRequestMap.get(RevId);
                                
                                if(UpdateResultList[i].isSuccess()==false)
                                {
                                    for(Database.Error err : UpdateResultList[i].getErrors()) {
                                     crm_Exception__c ex=new crm_Exception__c();
                                     if(err.getMessage().length()>255)
                                     {
                                     err.getMessage().abbreviate(252);
                                     }
                                     ex.crm_Message__c=err.getMessage();  ex.crm_Dml_Field_Names__c=String.valueof(err.getFields());   ex.crm_Stack_Trace__c='Revenue lines not updated or Id  :'+RevId ;
                                     errorlogs.add(ex);
                                     }
                                }
                                else{
                                    reqObj.RevUpdatedFlag__c = true;
                                }
                            }                      
                   }
                   else
                   {
                   System.debug('####@@'+reqList); 
                   for (Segment_Change_Request__c req: reqList) {
                        req.RevUpdatedFlag__c = true;
                    
                    }

                   }
                   }catch(Exception e){ crm_Exception_handler.createExceptionRecords(e); }
       
       System.debug('11@@'+reqList);
     system.debug('relation :'+ relationaccounts );
     List<crm_Forecast__c> forecastList= new  List<crm_Forecast__c> ();
     forecastList=  [Select id, crm_Customer__c, crm_Date__c,crm_Product__c , crm_Product__r.crm_global_Service_Group__c, Target_Responsible__c from crm_Forecast__c  where crm_Customer__r.orga__c in :orgIds and  crm_Product__r.crm_global_Service_Group__c in :servicegrp and Target_Category__c = 'Forecast' ];
     //changed above query to this
     //forecastList=  [Select id, crm_Customer__c, crm_Date__c,crm_Product__c , crm_Product__r.crm_global_Service_Group__c, Target_Responsible__c from crm_Forecast__c  where crm_Customer__c in :relationaccounts and  crm_Product__r.crm_global_Service_Group__c in :servicegrp];
      System.debug('@@' + forecastList );
      
       Map<id, Segment_Change_Request__c> forecastRequestMap= new Map<Id,Segment_Change_Request__c>();
     for (crm_Forecast__c ForecastObj :forecastList ){
      if (accountSegmentMap.containskey(ForecastObj.crm_Customer__c)){
              Map<String,Segment_Change_Request__c> tempMap  = accountSegmentMap.get(ForecastObj.crm_Customer__c);
                 System.debug('@@' + tempMap + tempMap + ForecastObj.crm_Product__r.crm_global_Service_Group__c);
              if(tempMap.containskey(ForecastObj.crm_Product__r.crm_global_Service_Group__c)){
                
                  Segment_Change_Request__c reqObj= tempMap.get(ForecastObj.crm_Product__r.crm_global_Service_Group__c );
                   if(ForecastObj.crm_Date__c>= reqObj.Start_Date__c )  { //Transaction Date equal or greater than Start Month/Start Year
                        ForecastObj.Target_Responsible__c =  reqObj.Proposed_Sales_Responsible__c ;
                        forecastRequestMap.put(ForecastObj.id,reqObj);
                        
                        }
                    }
                        
                 }       
        
         //new code inside for loop
         system.debug('Forecast: ' + ForecastObj );
          system.debug('accountSegmentMap: ' + accountSegmentMap);
         if(relationpartymap.containskey(forecastObj.crm_Customer__c)){
         Id partyid= relationpartymap.get(forecastObj.crm_Customer__c);
         system.debug('PartyId : '+ partyid);
          if (accountSegmentMap.containskey(partyid)){
            Map<String,Segment_Change_Request__c> tempMap  = accountSegmentMap.get(partyid);
            system.debug('tempMap  : '+ tempMap  );
             if(tempMap.containskey(forecastObj.crm_Product__r.crm_global_Service_Group__c )){
                  Segment_Change_Request__c reqObj= tempMap.get(forecastObj.crm_Product__r.crm_global_Service_Group__c );
                  forecastRequestMap.put(ForecastObj.id,reqObj);
                  if(forecastObj.crm_Date__c>= reqObj.Start_Date__c )  { //Transaction Date equal or greater than Start Month/Start Year
                        ForecastObj.Target_Responsible__c =  reqObj.Proposed_Sales_Responsible__c ;
                        
                        
                        }
             }
          }
     }
     
     }
     system.debug('Forecast change: ' + forecastRequestMap);
     system.debug('forecastList: ' + forecastList);
     
      if (forecastList.size()>0 ){
        Database.SaveResult[] UpdateResultList=Database.update(forecastList,false);
        for (Segment_Change_Request__c req: reqList) {
                        req.ForecastUpdatedFlag__c = true;
           }
        }
      else {
       for (Segment_Change_Request__c req: reqList) {
                        req.ForecastUpdatedFlag__c = true;
                   }
      }
        
                       
                //for inserting child records of new party level account 
              /*  if(forecastList.size()>0)
                {              
                       //Insert all new party accounts
                       Database.SaveResult[] UpdateResultList=Database.update(forecastList,false);
                          for(Integer i = 0; i < UpdateResultList.size(); i++)
                           {
                                String forecastId = forecastList[i].id;
                                 Segment_Change_Request__c reqObj = new Segment_Change_Request__c ();
                                if(forecastRequestMap.containskey(forecastId))
                                     reqObj = forecastRequestMap.get(forecastId);
                                
                                if(UpdateResultList[i].isSuccess()==false)
                                {
                                    for(Database.Error err : UpdateResultList[i].getErrors()) {
                                     crm_Exception__c ex=new crm_Exception__c();
                                     if(err.getMessage().length()>255)
                                     {
                                     err.getMessage().abbreviate(252);
                                     }
                                     ex.crm_Message__c=err.getMessage(); ex.crm_Dml_Field_Names__c=String.valueof(err.getFields());   ex.crm_Stack_Trace__c='forecast not updated or Id  :'+forecastId ;
                                     errorlogs.add(ex);
                                     }
    
                                }
                                
                                else{
                                    
                                    reqObj.ForecastUpdatedFlag__c = true;
                                }
                            }
                            
                   }
                   
                   else
                   {
                    for (Segment_Change_Request__c req: reqList) {
                        req.ForecastUpdatedFlag__c = true;
                    
                    }*/

                   
                   System.debug('666@@'+reqList);
                   
                   update   reqList;        
                   
                   for (Segment_Change_Request__c req: reqList) {
                    if(req.RevUpdatedFlag__c  && req.ForecastUpdatedFlag__c && req.SegmentupdatedFlag__c)  
                        req.Status__c= 'Completed'; 
                 
                    else
                         req.Status__c= 'Processing incomplete';
                 }
                   
                 if (forecastList==null &&  revList== null && segList==null ) {
                 for (Segment_Change_Request__c req: reqList) {
                     req.SegmentupdatedFlag__c=true;      req.RevUpdatedFlag__c = true;     req.ForecastUpdatedFlag__c = true;     req.Status__c= 'Completed';
                     
                 
                    }
                 
                 
                 }
      
         update   reqList;        
        //added
        insert errorlogs;
    }
    
    global void finish(Database.BatchableContext BC) {
    
      OrgWideEmailAddress owa = [Select id, DisplayName, Address from OrgWideEmailAddress limit 1];
           List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>(); 
        
               Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
               List<string> toAddress = new List<string>();           
               mail.setToAddresses(new String[]{UserInfo.getUserEmail()});
               //mail.setTargetObjectId(opps.crm_Primary_Opportunity_Contact__c);
               mail.setSaveAsActivity(false);
               mail.setUseSignature(false);
               mail.setSubject('Batch is executed successfully');
               String reason ='';
              
               string body ='Hello ' + UserInfo.getName() +',';
               body = body + '<br/> <br/> The batch job to change responsible seller is executed successfully';
              
               body = body + '<br/> <br/> Thanks, <br/> Salesforce Support';
               mail.setHtmlBody(body);

               allmsg.add(mail);           
               try {
                   Messaging.sendEmail(allmsg,false);
               }catch (Exception e) {
                   System.debug(e.getMessage());
              }
                
    }


}