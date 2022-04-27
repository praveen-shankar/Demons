/*
Created By: Supriya Goel
Object:Revenue Batch
Batch on the revenue line object which will match the correct segmnent on relation or party account
This will execute only once for the given year
*/

global class crm_revenueSegmentYear_batch implements Database.Batchable<SObject>{

        public String queryString = '';
        public integer year;
                    
        public crm_revenueSegmentYear_batch(integer year1){
          year  =  year1;
          queryString = 'SELECT crm_Account__c, crm_Revenue_Responsible__c, crm_Product_Service_Group__c, crm_Responsible_Seller__c, crm_Transaction_Date__c from crm_Revenue_Line__c where crm_Transaction_Year__c = :year  order by createddate desc';
          System.debug('@@@'+ queryString);   
        }
          
        global Database.QueryLocator start(Database.BatchableContext bcMain){   
            return Database.getQueryLocator(queryString);
        }
        
          global void execute(Database.BatchableContext bcMain, List<crm_Revenue_Line__c> revLinesList){
          
            Set<Id> relationAcntIds = new Set<Id>();
            Set<Id> partyAcntIds = new Set<Id>();
        
            //get all account id for the rev lines //all will be relation accounts
            for (crm_Revenue_Line__c rev: revLinesList ){
                relationAcntIds.add(rev.crm_Account__c);      
        
           }
          
          //get all parentids also 
          
           List<Account> partyAcntList =[Select id,parentid from Account where id in  :relationAcntIds];
           Map<Id, id> parentAcntMap= new Map<Id, Id>();
           for (Account acnt:partyAcntList  ){
               partyAcntIds.add(acnt.parentid );
               parentAcntMap.put(acnt.id, acnt.parentid);
            }
          
          
               //map of account, segment list// get all segments from relation level
                Map<Id, list<crm_Segment__c>>  AccountSegmentMap = new  Map<Id, List<crm_Segment__c>>(); 
              
                List<crm_Segment__c> SegmentList= [Select id, crm_Sales_Responsible__c,crm_Sales_Responsible__r.firstname , crm_Sales_Responsible__r.lastname ,crm_Service_Group__c,crm_Sales_Team__c, crm_Account__c  from  crm_Segment__c where  crm_Account__c in :relationAcntIds];    
             
                for (crm_Segment__c seg: SegmentList ){
                                     
                    if (AccountSegmentMap.containsKey(seg.crm_Account__c)){
                        List<crm_Segment__c> templist = new List<crm_Segment__c>();
                        templist = AccountSegmentMap.get(seg.crm_Account__c);
                        templist.add(seg);
                        AccountSegmentMap.put(seg.crm_Account__c,templist ) ;
                    }
                    else {
                        List<crm_Segment__c> templist = new List<crm_Segment__c>();
                        templist.add(seg);
                        AccountSegmentMap.put(seg.crm_Account__c,templist ) ;
                    } 
                }
                
                List<crm_Revenue_Line__c> Revlist = new List<crm_Revenue_Line__c >();
                List<crm_Revenue_Line__c> remainingRevlist = new List<crm_Revenue_Line__c >();
                 for (crm_Revenue_Line__c rev: revLinesList ){
                  if(AccountSegmentMap.containskey(rev.crm_Account__c)){
                      List<crm_segment__c> seglist= AccountSegmentMap.get(rev.crm_Account__c);
                       Integer counter =0;
                        for (crm_Segment__c seg: seglist){
                        if(seg.crm_Service_Group__c== rev.crm_Product_Service_Group__c && seg.crm_Sales_Responsible__c!=null){
                            //if(seg.crm_Sales_Responsible__c!=null) {
                            rev.crm_Responsible_Seller__c=seg.crm_Sales_Responsible__c;
                            
                            String reponsible_seller= '';
                            if(seg.crm_Sales_Responsible__r.firstname!=null )
                                reponsible_seller= seg.crm_Sales_Responsible__r.firstname + ' ';
                            
                             if(seg.crm_Sales_Responsible__r.lastname !=null )
                                reponsible_seller += seg.crm_Sales_Responsible__r.lastname + ' ';    
                                
                                rev.crm_Revenue_Responsible__c=reponsible_seller ;
                               
                        }  //end of if for servive group...
                        else
                      {
                         
                        
                       System.debug('##not matching SG'+ rev.id);
                        //  Revlist.add(rev);
                        counter = counter +1; // 
                         System.debug('##counter'+ counter);
                      
                      }
                    }//end of for
                    
                    if (counter==seglist.size()){
                     System.debug('##counter'+ counter+ seglist.size());
                        Revlist.add(rev);
                    
                    }
                  }//end of account
                  
                  else
                  {
                  System.debug('##not matching account'+ rev.id);
                      Revlist.add(rev);
                  
                  }
               }//end od rev line loop
               
              try{
              
               Database.update (revLinesList , false);
            System.debug('@@revLinesList'+revLinesList );
           }catch(Exception e) {   crm_Exception_handler.createExceptionRecords(e);   }
               
               
                //map of account, segment list// get all segments from relation level
                Map<Id, list<crm_Segment__c>>  PartyAccountSegmentMap = new  Map<Id, List<crm_Segment__c>>(); 
              
               SegmentList= [Select id, crm_Sales_Responsible__c,crm_Sales_Responsible__r.firstname , crm_Sales_Responsible__r.lastname ,crm_Service_Group__c,crm_Sales_Team__c, crm_Account__c  from  crm_Segment__c where  crm_Account__c in :partyAcntIds];    
             
                for (crm_Segment__c seg: SegmentList ){
                                     
                    if (PartyAccountSegmentMap.containsKey(seg.crm_Account__c)){
                        List<crm_Segment__c> templist = new List<crm_Segment__c>();
                        templist = PartyAccountSegmentMap.get(seg.crm_Account__c);
                        templist.add(seg);
                        PartyAccountSegmentMap.put(seg.crm_Account__c,templist ) ;
                    }
                    else {
                        List<crm_Segment__c> templist = new List<crm_Segment__c>();
                        templist.add(seg);
                        PartyAccountSegmentMap.put(seg.crm_Account__c,templist ) ;
                    } 
                }
                
              
                 for (crm_Revenue_Line__c rev: Revlist ){
                  Id partyacntid= parentAcntMap.get(rev.crm_Account__c);
                  if(PartyAccountSegmentMap.containskey(partyacntid)){
                      List<crm_segment__c> seglist= PartyAccountSegmentMap.get(partyacntid);
                         Integer counter =0;
                        for (crm_Segment__c seg: seglist){
                        if(seg.crm_Service_Group__c== rev.crm_Product_Service_Group__c && seg.crm_Sales_Responsible__c!=null){
                            rev.crm_Responsible_Seller__c=seg.crm_Sales_Responsible__c;
                            
                            String reponsible_seller= '';
                            if(seg.crm_Sales_Responsible__r.firstname!=null )
                                reponsible_seller= seg.crm_Sales_Responsible__r.firstname + ' ';
                            
                             if(seg.crm_Sales_Responsible__r.lastname !=null )
                                reponsible_seller += seg.crm_Sales_Responsible__r.lastname + ' ';    
                                
                                rev.crm_Revenue_Responsible__c=reponsible_seller ;
                              //  break;
                        }  //end of if for servive group...
                      
                        
                         else
                       {
                        counter = counter +1; // 
                       }   
                    
                    }
                    
                    if (counter==seglist.size()){
                         remainingRevlist.add(rev);
                           System.debug('added to list');     
                    
                    }
                      
                      }//end of account check
                      
                      
                   
                else
                {
                
                remainingRevlist.add(rev);
                
                 }  
                 
               }//end od rev line loop
               
               
           
           
        for (crm_Revenue_Line__c rev: remainingRevlist){
            rev.crm_Responsible_Seller__c=null;
            rev.crm_Revenue_Responsible__c='';
          
            }
            
          
            
           try{
              
               Database.update (remainingRevlist, false);
            System.debug('@@revLinesList'+remainingRevlist);
           }catch(Exception e) {   crm_Exception_handler.createExceptionRecords(e);   }  
           
            try{
              
               Database.update (Revlist , false);
            System.debug('@@revLinesList'+Revlist );
           }catch(Exception e) {   crm_Exception_handler.createExceptionRecords(e);   }  
          
          }//end of execute
          
          global void finish(Database.BatchableContext bc){
         
    
    
       
          
          }
          
          }