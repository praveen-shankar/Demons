/*
Created By:Supriya Goel
Date: 26th oct 2017
Agreement should be created on the “Agreement Start Date” and when opp is closed won at that point the “parent agreement” should be set to Terminated. 

*/

global class crm_createAgreementBatch implements Database.batchable<sObject>,Database.Stateful{
    public string callback = '';    
   
    global crm_createAgreementBatch(String callback){
        this.callback = callback;   
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String Stage='Closed Won';
        String query='';
        String mainQuery = 'Select id,Name,Accountid,crm_reason_won__c ,Send_email_to_Bid_team__c ,crm_Verified_by_Contract_Management__c ,Ownerid,  Account.name, type,crm_Agreement_Start_Date__c ,crm_Private__c,stagename,crm_Close_Behaviour__c, crm_Agreement__c,crm_Opp_Service_Family__c,crm_Opp_Service_Group__c,CurrencyIsoCode,amount, crm_footer_image__c,crm_header_image__c,crm_Primary_Opportunity_Contact__c,crm_TemplateID__c,crm_Language_for_Offer__c,crm_Legal_Company_for_Offer__c from Opportunity  where crm_Do_not_create_Agreement__c = false and crm_Agreement_Start_Date__c <= TODAY  and Stagename= :Stage and  crm_Agreement__c=null and crm_reason_won__c !=null  order by crm_Agreement_Start_Date__c asc'; 
           
        return Database.getQueryLocator(mainQuery );                   
    }
    
    
    global void execute(Database.BatchableContext BC, List<Opportunity> oppList1) {
    
    
    List<Opportunity> oppList = new List<Opportunity>();
      Set<id> accntids = new Set<id>();
    environment_settings__c env = environment_settings__c.getValues('AgeementMasterInterfaceSwitch');
      
     for (Opportunity opp :oppList1){
    accntids.add(opp.accountid);
       crm_get_Service_Area__c oppServiceArea = crm_get_Service_Area__c.getValues(opp.crm_Opp_Service_Group__c); ///later on pass rev group
       if (oppServiceArea != null  &&  oppServiceArea.Is_New__c && env != null && env.value__c == 'true' && !opp.crm_Verified_by_Contract_Management__c && !opp.Send_email_to_Bid_team__c ) {   oppList.add(opp);
            }
            else if(oppServiceArea != null  &&  oppServiceArea.Is_New__c && env != null && env.value__c == 'true' && opp.crm_Verified_by_Contract_Management__c && opp.Send_email_to_Bid_team__c){ oppList.add(opp);
            }
            else if (oppServiceArea != null  &&  oppServiceArea.Is_New__c && env != null && env.value__c == 'true' && opp.crm_Verified_by_Contract_Management__c && !opp.Send_email_to_Bid_team__c){
            oppList.add(opp);
            }           
            else if (oppServiceArea != null  &&  !oppServiceArea.is_New__c)
                oppList.add(opp);
      } //end of for loop    
         
         Map < Id, String > accountStatusMap = new Map < Id, String > ();
 List < Account > accList = [SELECT Id, Customer_Converted__c FROM Account WHERE Id in: accntids];

  for (Account a: accList) {
   accountStatusMap.put(a.id, a.Customer_Converted__c);
  }
 List<New_Service_Structure__mdt> newserviceslist= [Select id, Service_Group__c,Service_Family__c,CounterPart_Service_Group__c, CounterPart_Service_Family__c from New_Service_Structure__mdt ];
             
    System.debug('@@ newserviceslist' + newserviceslist)      ;
     System.debug('@@ accountStatusMap' + accountStatusMap)      ;
     
      
        Set<id> oppSet = new Set<Id>();
        List<crm_agreement__c> agrList = new List<crm_agreement__c>(); 
        Map<Id,crm_agreement__c> oppAgrMap= new Map<Id,crm_agreement__c>();
        for(Opportunity opp :oppList){
             List<crm_agreement__c> agrobjlist = new List<crm_agreement__c>(); 
            if(opp.crm_Opp_Service_Group__c!='Post' && opp.crm_Opp_Service_Group__c != 'Dialog'){
                if(opp.crm_Opp_Service_Family__c!='Offshore Project'){ 
                    
                    crm_agreement__c agr = new crm_agreement__c();
                    //Datetime dt = new Datetime(opp.crm_Agreement_Start_Date__c);
                    String formattedDate =DateTime.newInstance(opp.crm_Agreement_Start_Date__c.year(),opp.crm_Agreement_Start_Date__c.month(),1).format('d-MM-YYYY');
                    //<<Service  Family name>> Agreement for <<Customer Name>> from <<Agreement Start Date>>  
                    agr.crm_Agreement_Name__c =opp.crm_Opp_Service_Family__c + ' Agreement for ' +   opp.Account.name + ' from ' + formattedDate  ;
                    agr.crm_Account__c= opp.Accountid;
                    agr.crm_Agreement_Service_Family__c= opp.crm_Opp_Service_Family__c;
                    agr.crm_Agreement_Service_Group__c = opp.crm_Opp_Service_Group__c;
                    agr.crm_Agreement_Start_Date__c=opp.crm_Agreement_Start_Date__c;
                    
                       System.debug('$$opp.accountid' +opp.accountid);           
          if (accountStatusMap.containskey(opp.accountid) && ( accountStatusMap.get(opp.accountid)== 'Converted' || accountStatusMap.get(opp.accountid)== 'InPreparation')){
           System.debug('##inside 1');
            if(opp.crm_Close_Behaviour__c =='Create' && opp.type!='Renegotiate'  && opp.type!='Upsell' )  {
            agr.crm_New_Revenue_Start_Date__c= date.newInstance(opp.crm_Agreement_Start_Date__c.year(),opp.crm_Agreement_Start_Date__c.month(),1);   
             
         }
         else if(opp.crm_Close_Behaviour__c=='Create' && opp.type=='Renegotiate' ) {
         for (New_Service_Structure__mdt newobj : newserviceslist ) {
             if(opp.crm_Opp_Service_Family__c  == newobj.Service_Family__c && opp.crm_Opp_Service_Group__c  == newobj.Service_Group__c ){
             System.debug('##inside 2');
                agrobjlist= [Select id,crm_Agreement_Start_Date__c, crm_New_Revenue_Start_Date__c ,crm_Agreement_Service_Family__c, crm_Agreement_Service_Group__c from  crm_agreement__c where crm_account__c = :opp.accountid and  crm_Agreement_Service_Group__c =:newobj.CounterPart_Service_Group__c  and crm_Agreement_Service_Family__c = :newobj.CounterPart_Service_Family__c and crm_status__c='Active' order by crm_Agreement_Start_Date__c desc limit 1 ];
                if(agrobjlist.size()>0 && agrobjlist!=null){
                IF(agrobjlist[0].crm_New_Revenue_Start_Date__c <= System.today() && agrobjlist[0].crm_New_Revenue_Start_Date__c >= System.today().addyears(-1)){
               agr.crm_New_Revenue_Start_Date__c = agrobjlist[0].crm_New_Revenue_Start_Date__c;
                }        else   agr.crm_New_Revenue_Start_Date__c= null;
                }
                else                 agr.crm_New_Revenue_Start_Date__c= null;       break;
             
           }
            }//end of for 
         
         }//end of renegotiate
      }//customer conversion 
           else  if (accountStatusMap.containskey(opp.accountid) && ( accountStatusMap.get(opp.accountid)!= 'Converted' && accountStatusMap.get(opp.accountid)== 'InPreparation')){
          if(opp.crm_Close_Behaviour__c!='Renegotiate' && opp.type=='Renegotiate'  ){   agr.crm_New_Revenue_Start_Date__c= null;
         } else 
               agr.crm_New_Revenue_Start_Date__c= date.newInstance(opp.crm_Agreement_Start_Date__c.year(),opp.crm_Agreement_Start_Date__c.month(),1);
           
      } else  if (accountStatusMap.containskey(opp.accountid) && ( accountStatusMap.get(opp.accountid)!= 'Converted' && accountStatusMap.get(opp.accountid)!= 'InPreparation')){
          if(opp.crm_Close_Behaviour__c!='Renegotiate' && opp.type=='Renegotiate'  ){     agr.crm_New_Revenue_Start_Date__c= null;
         } else 
               agr.crm_New_Revenue_Start_Date__c= date.newInstance(opp.crm_Agreement_Start_Date__c.year(),opp.crm_Agreement_Start_Date__c.month(),1);
           
      } 

                    agr.CurrencyIsoCode=opp.CurrencyIsoCode;
                    agr.crm_Annual_Contract_Value__c=opp.amount;
                    agr.crm_Agr_Footer__c=opp.crm_footer_image__c;
                    agr.crm_Agr_Header__c=opp.crm_header_image__c;
                    agr.crm_Agreement_Increased_Contract_Value__c = opp.amount;
                    agr.crm_Agreement_Primary_Contact__c= opp.crm_Primary_Opportunity_Contact__c;
                    agr.crm_Agreement_Template_ID__c=opp.crm_TemplateID__c;
                    agr.crm_Language_From_Opportunity__c=opp.crm_Language_for_Offer__c;
                    agr.crm_Opportunity_Id__c= opp.id;
                    //agr.crm_Posten_Legal_Company_for_Offer__c=opp.crm_Legal_Company_for_Offer__c;
                    agr.crm_Private__c =opp.crm_Private__c;
                    agr.crm_Status__c ='Active';
                    agr.ownerid=opp.Ownerid; 
                    agrList.add(agr);
                    oppAgrMap.put(opp.id,agr );
                    oppSet.add(opp.id);
                    
                }  //end of sf check
                
            }//end of sg check
            
             if(agrobjlist.size()>0 && agrobjlist!=null){
            for (crm_agreement__c agr : agrobjlist){
                agr.crm_Agreement_End_Date__c = opp.crm_Agreement_Start_Date__c.addDays(-1);   //new agreement satrt date -1
                   System.debug('^^^^' + agr);
                   agr.crm_status__c ='Terminated';       }       update  agrobjlist;
                 
             }
        }//end of for          
        try{
            if(agrList.size()>0)  
                insert agrList;
        }catch(Exception e) {  crm_Exception_handler.createExceptionRecords(e);  }
        
        Map<Id,Id> oppAgrIdMap= new Map<Id, Id>();
        Map<Id,Id> oppParentOppMap= new Map<Id, Id>();
        
        Map <Id,Decimal> oppAmount= new Map <Id,Decimal>();
        List<Opportunity> CBRenegotiateList = new List<Opportunity>(); 
        List<Opportunity> agrLinkedOpp= [Select id, amount,crm_agreement__c, type,stagename, Accountid,crm_Close_Behaviour__c,crm_Agreement_Start_Date__c , crm_Parent_Opp__c from Opportunity where id in :oppset]; //oppset -> all the opp  in the query
        
        //opp3=> ag3, op1 , ag2-> op1, op2 
        for (Opportunity opp: agrLinkedOpp){
        
            System.debug('%%%opp type ' +  opp );
              System.debug('%%%' +  opp.crm_agreement__c);
                System.debug('%%%' +  opp.crm_Parent_Opp__c);
            if(opp.crm_agreement__c !=null && opp.crm_Parent_Opp__c !=null){
            oppAgrIdMap.put(opp.id,opp.crm_agreement__c);  //map of latest opp and latest agreement created//opp2, ag2
            oppParentOppMap.put(opp.id, opp.crm_Parent_Opp__c); //latest and parent opp  opp2, opp1
            oppAmount.put(opp.crm_agreement__c ,opp.Amount);// agrement , opp.amount  ag2, 500
            }
            
            if (opp.type=='Upsell'){
                UpsellProcess(agrList,oppAgrIdMap,oppParentOppMap, oppAmount, oppList);
                
            }
            else if(opp.crm_Close_Behaviour__c!='Renegotiate' && opp.type=='Renegotiate'  ){ 
                CBRenegotiateList.add(opp);
                calculateCBRenegotiateNew(CBRenegotiateList);
            } 
            else if(opp.type=='Renegotiate'){
                RenegotiateProcess(agrList,oppAgrIdMap,oppParentOppMap, oppAmount);
            }
            else 
                openoppProcess(agrList,oppList);
           
            
        }  
    }//end of execute
    
   public void openoppProcess (List<crm_agreement__c> agrList, List<Opportunity> oppList){
    
    set<id> agrids= new Set<Id>();
    Set<id> acntids = new Set<Id>();
    set<String> sfSet= new Set<String>();
    String status ='Active';
    
    for (crm_agreement__c agr: agrlist){
        agrids.add(agr.id);
        sfSet.add(agr.crm_Agreement_Service_Family__c);
        acntids.add(agr.crm_Account__c);
        }
      
        List<crm_agreement__c> updateAgrlist=[Select id, crm_Agreement_End_Date__c, crm_Status__c from crm_agreement__c where crm_Agreement_Service_Family__c in :sfSet and crm_Account__c in :acntids and id not in :agrids];
         
         if (updateAgrlist.size()>0){   List<Opportunity> linkedOpplist=[Select id, crm_Agreement__c from Opportunity where crm_Opp_Service_Family__c in :sfSet and accountid in :acntids and crm_agreement__c not in :agrids and crm_agreement__r.crm_status__c = :status];
           if (linkedOpplist.size()>0){ for (Opportunity opp: linkedOpplist){      opp.crm_Agreement__c= agrList[0].id;    }
          
          update linkedOpplist;
          }
    
         for (crm_agreement__c agr: updateAgrlist){ agr.crm_Agreement_End_Date__c = agrlist[0].crm_Agreement_Start_Date__c.addDays(-1); agr.crm_Status__c = 'Terminated';}       update updateAgrlist;
          }
    
    }
    
    
    public void UpsellProcess(List<crm_agreement__c> agrList,Map<Id,Id> oppAgrIdMap, Map<Id,Id> oppparentoppmap, Map<Id, Decimal> oppAmount, List<Opportunity> oppList){
        
        system.debug('****oppagrIdMap'+oppAgrIdMap );
        system.debug('****oppparentoppmap'+oppparentoppmap);
        
        //get the agreement assocaited to parent opp
        Map<Id,Id> parentOppagrmap= new Map<Id,Id>();
        
        //get all the old opportunities
        List<Opportunity> Relatedopplist=[Select id, crm_Agreement__c from opportunity where id in :oppParentOppMap.values()];
        //opp1, agr2
        
        
        system.debug('****Relatedopplist'+Relatedopplist +oppParentOppMap.values()  );
        Map<id,List<Opportunity>> agrOppMap= new Map<id,List<Opportunity>> ();
        
        for (Opportunity opp: Relatedopplist ){      parentOppagrmap.put(opp.id, opp.crm_agreement__c);
            //opp1, ag1
        }
        
        
        Map<Id,Id> oldOppnewOppMap = new map<Id,Id>();
        
        for(Id newoppid: oppparentoppmap.keyset()){   oldOppnewOppMap.put(oppparentoppmap.get(newoppid),newoppid) ;
        }
        
        //parent oppid,  parent opp agreement 
        
        List<Opportunity> relatedOpplist1=[Select id, crm_Agreement__c, stagename, amount from opportunity where crm_Agreement__c  in :parentOppAgrMap.values()]; 
        //map<agrid, annualcntract value>
        
        system.debug('****Relatedopplist1'+relatedOpplist1  );
        Decimal contractValue=0;
        for (Opportunity opp: relatedOpplist1 ){
            
        
            
            if (agrOppMap.containsKey(opp.crm_Agreement__c)){            List<Opportunity> templist = new List<Opportunity>();  templist = agrOppMap.get(opp.crm_Agreement__c); templist.add(opp); agrOppMap.put(opp.crm_Agreement__c,templist );
                
            }
            else {     List<Opportunity> templist = new List<Opportunity>(); templist.add(opp); agrOppMap.put(opp.crm_Agreement__c,templist) ;
                
                
            } 
            //ag2=> opp1, opp2  //old agreement , all opplinked  to the old greement  
            
        }
        
        for(Opportunity opp :Opplist){
            if (oppParentOppMap.containskey(opp.id)){
                Id parentopp= oppParentOppMap.get(opp.id);  Id agrid=parentOppAgrMap.get(parentopp);  List<opportunity> Toupdate = agrOppMap.get(agrid);
                for (Opportunity opp1: Toupdate ){  opp1.crm_agreement__c= oppAgrIdMap.get(opp.id);    }         update Toupdate ;
            }
            
        }
        
        Map <Id,Decimal> oppAgrContractValue  = new Map <Id,Decimal>();
        Map <Id,Decimal> oppAgrIncreasedValue = new Map <Id,Decimal>();
        
        List<opportunity> OppFinalList= [Select id, crm_agreement__c , stagename, amount from  Opportunity where crm_agreement__c in :oppAgrIdMap.values()]  ;
        for (Opportunity opp: OppFinalList){
            
            if (opp.stagename=='Closed Won'){
                if (oppAgrContractValue.containskey(opp.crm_Agreement__c) ){
                    contractValue=oppAgrContractValue.get(opp.crm_Agreement__c); contractValue=contractValue+opp.amount; oppAgrContractValue.put(opp.crm_Agreement__c,contractValue );
                    
                    
                }else{
                    oppAgrContractValue.put(opp.crm_Agreement__c,opp.amount);
                    
                    
                }
            }//end of closedwon
        }//end of for  
        system.debug('****OppFinalList at the end'+OppFinalList);   
        
        Map<Id, crm_agreement__c> agrMap= new Map<id, crm_agreement__c>();
        
        for (crm_agreement__c agr : agrList){
        agrMap.put(agr.id,agr);
            
            if(oppAgrContractValue.containskey(agr.id))    agr.crm_Annual_Contract_Value__c=oppAgrContractValue.get(agr.id);
            
            if(oppAgrIncreasedValue.containskey(agr.id))   agr.crm_Agreement_Increased_Contract_Value__c =oppAgrIncreasedValue.get(agr.id);
            
        } 
        
        
        system.debug('****agrList at the end'+agrList);  
        
        update agrList; 
        
        
        List<crm_agreement__c> agrtoUpdate= [Select id, crm_status__c, crm_Agreement_End_Date__c, crm_New_Revenue_Start_Date__c  from crm_agreement__c where id in :parentOppagrmap.values()];
        
        
        for(crm_agreement__c agr:agrtoUpdate){
        List<Opportunity> templist = new List<Opportunity>();
           if(agrOppMap.containskey(agr.id)){     templist =agrOppMap.get(agr.id) ;//list of all old opp    opp2, opp1  (opp1, opp2)
               
               for(Opportunity opp:templist  ){
               if(oldOppnewOppMap.containskey(opp.id)) {
                   Id newOppId= oldOppnewOppMap.get(opp.id);  Id newAgr= oppAgrIdMap.get(newOppid); crm_agreement__c agrObj= agrMap.get(newAgr);
                                  
                  // agrObj.crm_Agreement_Start_Date__c =  date.newInstance(agrObj.crm_Agreement_Start_Date__c.year(),agrObj.crm_Agreement_Start_Date__c.month(),1);
                   agrObj.crm_New_Revenue_Start_Date__c = agr.crm_New_Revenue_Start_Date__c ;
                   agr.crm_Agreement_End_Date__c = agrObj.crm_Agreement_Start_Date__c.addDays(-1);   //new agreement satrt date -1
                   System.debug('^^^^' + agr);
                   agr.crm_status__c ='Terminated'; update agrObj;
                   System.debug('^^^^' + agrObj);
               
               }
               
               }
               //get the new opp opp2
               //get the new agr 
               //get the satrt date
            
        }
        }
        
        Update agrtoUpdate;
        
        
        
        
        
    }
    
    public void RenegotiateProcess(List<crm_agreement__c> agrList,Map<Id,Id> oppAgrIdMap, Map<Id,Id> oppparentoppmap,  Map<Id, Decimal> oppAmount){
        
        //oppagrIdMap    opp2, agr2
        
        system.debug('%%in Rene  %% agrList'+ agrList);  // ag2
        system.debug('%%in Rene  %% oppagrIdMap'+ oppagrIdMap);//opp2, ag2,
        system.debug('%%in Rene  %% oppparentoppmap'+ oppparentoppmap);//opp2, opp1
        system.debug('%%in Rene  %% oppAmount'+ oppAmount);//opp, 400
        
        Map<Id, crm_agreement__c> newAgrMap= new Map<Id, crm_agreement__c>();
        for (crm_agreement__c agr: agrList){
            newAgrMap.put(agr.id,agr);
        
        
        }
        
        Map<Id, Id> newAgrOppMap=  new Map<Id,Id>(); 
        Map<Id, Id> OldOppNewOppMap=  new Map<Id,Id>();        
        
        List<opportunity> OppFinalList= [Select id, crm_agreement__c , stagename,crm_Parent_Opp__c , amount from  Opportunity where crm_agreement__c in :oppAgrIdMap.values()]  ;
        for (Opportunity opp: OppFinalList){
            newAgrOppMap.put(opp.crm_agreement__c , opp.id);  OldOppNewOppMap.put(opp.crm_Parent_Opp__c , opp.id);
        }//ag2, opp2
        
        
        Map<Id, Id> oppAgrMap=  new Map<Id,Id>();
        Map<Id, Id> oldAgrOppMap=  new Map<Id,Id>();
        
        List<Opportunity> Opplist =[Select id , crm_agreement__c from opportunity where id in :oppparentoppmap.values()];
        System.debug('%% Opplist ' + Opplist );
        for (Opportunity opp: Opplist){
            oppAgrMap.put(opp.id,opp.crm_agreement__c);   oldAgrOppMap.put(opp.crm_agreement__c,opp.id);   //opp1,ag1   //upsell/72 
            
        }
        System.debug('%% oppAgrMap' + oppAgrMap );
        
        Map<Id,Decimal> ACVAgrMap = new Map<Id, Decimal>();
        List<crm_agreement__c> ACVAgrList=[Select id,crm_Annual_Contract_Value__c, crm_Agreement_Start_Date__c from crm_agreement__c where id in :oppAgrMap.values() ];
        System.debug('%% ACVAgrList' + ACVAgrList);
        for (crm_agreement__c agr: ACVAgrList){
            ACVAgrMap.put(agr.id, agr.crm_Annual_Contract_Value__c); //old agr ACV
            
        }
        
        System.debug('%% ACVAgrMap' + ACVAgrMap );
          System.debug('%% newAgrOppMap' + newAgrOppMap);
            System.debug('%% oppparentoppmap' + oppparentoppmap);
              System.debug('%% ACVAgrMap' + ACVAgrMap );
                System.debug('%% oppAgrMap' + oppAgrMap);
          System.debug('%% agrList' + agrList);
          
          
        for (crm_agreement__c agr :agrList){
            // if(oppagrIdMap.containskey(agr.id)){
            System.debug('### agrid'+ agr.id);
            if(newAgrOppMap.containskey(agr.id)){
            Id newoppid= newAgrOppMap.get(agr.id);
           
             System.debug('###newoppid'+ newoppid);
            Id oldparentid=oppparentoppmap.get(newoppid);   Id oldagrid=oppAgrMap.get(oldparentid);   Decimal amount= oppAmount.get(agr.id);
            agr.crm_Annual_Contract_Value__c  = amount;
            System.debug('^^^oldparentid' + oldparentid);
            System.debug('^^^oldagrid' + oldagrid);
            agr.crm_Agreement_Increased_Contract_Value__c   = amount- ACVAgrMap.get(oldagrid);
             } 
        }
        
        update agrlist;
        
        List<crm_agreement__c> TerminatedAgreements=[Select id, crm_status__c, crm_Agreement_End_Date__c, crm_New_Revenue_Start_Date__c   from crm_agreement__c where id in :oppAgrMap.values()];
        
        for (crm_agreement__c agr: TerminatedAgreements ){
          Id oldoppId= oldAgrOppMap.get(agr.id);   Id newOppId= oldOppnewOppMap.get(oldoppId);
          Id newAgr= oppAgrIdMap.get(newOppid); crm_agreement__c agrObj= newAgrMap.get(newAgr);  //
                   System.debug('^^^^' + agrObj);
            agr.crm_status__c ='Terminated';  agrObj.crm_New_Revenue_Start_Date__c = agr.crm_New_Revenue_Start_Date__c ;
            
            Date endDate =  date.newInstance(agrObj.crm_Agreement_Start_Date__c.year(),agrObj.crm_Agreement_Start_Date__c.month(),1);
            agr.crm_Agreement_End_Date__c = endDate.addDays(-1);   //new agreement satrt date -1  
            update agrobj;
        }
        
        update TerminatedAgreements;
    } 
    
    public void calculateCBRenegotiateNew(List<Opportunity> oppList){
        Map <Id,Decimal> oppAgrContractValue = new Map <Id,Decimal>();
        Map <Id,Decimal> oppAgrIncreasedValue= new Map <Id,Decimal>();
        
        
        Map <Id,Decimal> oppAmount= new Map <Id,Decimal>();
        
        
        Set<id> OppIds= new Set<Id>();
        Set<id> agrIds= new Set<Id>();
        Set<id> accountIds= new Set<Id>();
        Map<Id,Id> oppagrmap = new Map<Id, Id>();
        
        for (Opportunity opp:oppList){
            OppIds.add(opp.id); 
            accountIds.add(opp.Accountid);
            
            agrIds.add(opp.crm_agreement__c); 
            oppagrmap.put(opp.crm_agreement__c , opp.id);
            
            if(!oppAmount.containskey(opp.id))
                oppAmount.put(opp.id,opp.amount);
        }
        
        System.debug('###oppAgrIncreasedValue'+oppAgrIncreasedValue);
        
        System.debug('###oppAmount'+oppAmount);
        System.debug('###agrIds'+agrIds);
        
        Decimal contractValue=0;
        List<Opportunity> agrLinkedOpp= [Select id, amount,crm_agreement__c, stagename, crm_Agreement_Start_Date__c  from Opportunity where crm_agreement__c in :agrIds ] ;
        for (Opportunity opp: agrLinkedOpp){
            
            if(opp.stagename=='Closed Won')
                contractValue = contractValue+opp.Amount;
            
            oppAgrContractValue.put(opp.crm_agreement__c,contractValue );
            
        }
        System.debug('###oppAgrContractValue'+oppAgrContractValue);
        
        Set<Account> relationaccounts= new set<account>([Select id from  account where parentid in :accountIds]);
        
        List<Account> ParentaccountList =[Select id , parentid from Account where parentid in :accountIds];
        Map<Id,Id> relationpartyccountMap =new Map<Id,Id>();
        //relation id , party id
        
        for (account a: ParentaccountList ){
            relationpartyccountMap.put(a.id, a.parentid) ;
        }
        //partyid, rev list
        Map<Id, List<crm_Revenue_Line__c>> AccountRevenueMap = new Map<Id, List<crm_Revenue_Line__c>>();
        
        Map<Id, Map<String, Decimal>>  AccountSFRevenueMap = new   Map<Id, Map<String, Decimal>>();
        //accountid, list of SF , list of rev lines
        Map<Id, Decimal> AccountRevenueValueMap = new Map<Id, Decimal>();
        List<crm_Revenue_Line__c> revLines=[Select crm_Account__c ,crm_Amount__c , crm_Agreement__c,crm_Agreement__r.crm_Agreement_Start_Date__c ,crm_Transaction_Date__c, crm_Product_Service_Family__c, crm_Product_Service_Group__c   from crm_Revenue_Line__c where crm_Account__c in :relationaccounts and crm_Transaction_Date__c = LAST_N_DAYS:365]; 
        System.debug('@@revLines'+revLines);    
        Decimal totalrevamount=0;               
        for (crm_Revenue_Line__c rev: revLines)   {
            Id partyaccountid = relationpartyccountMap.get(rev.crm_Account__c); 
            if (AccountSFRevenueMap.containsKey(partyaccountid)    ){
                Map<String, Decimal> SFREvMap= AccountSFRevenueMap.get(partyaccountid);
                
                
                if(SFREvMap.containskey(rev.crm_Product_Service_Family__c)){
                    totalrevamount = SFREvMap.get(rev.crm_Product_Service_Family__c);
                    totalrevamount = totalrevamount + rev.crm_amount__c;
                    SFREvMap.put(rev.crm_Product_Service_Family__c, totalrevamount );
                    
                   // break;
                    
                }//end of contains SF
                else {
                    SFREvMap.put(rev.crm_Product_Service_Family__c, rev.crm_Amount__c); 
                    
                    
                }
                
                AccountSFRevenueMap.put(partyaccountid,SFREvMap) ;
                
            }//end of contains account
            else{
                
                
                Map<String, Decimal> SFREvMap= new Map<String, Decimal> ();
                SFREvMap.put(rev.crm_Product_Service_Family__c, rev.crm_Amount__c); 
                AccountSFRevenueMap.put(partyaccountid , SFREvMap);
                
            }
            
            
            
            
        }
        
        
        
        System.debug('@@AccountRevenueValueMap'+AccountRevenueValueMap);
        
        
        List <crm_agreement__c> UpdateAgrList= [Select id,crm_Parent_Agreement__c,crm_Agreement_Increased_Contract_Value__c,crm_New_Revenue_Start_Date__c,crm_Annual_Contract_Value__c,crm_Agreement_Start_Date__c, crm_Agreement_Service_Family__c from crm_agreement__c where id in :agrIds];
        
        
        
        for (crm_agreement__c agr: UpdateAgrList){
            
            if(oppagrmap.containskey(agr.id)){
                Id oppid=oppagrmap.get(agr.id);
                Id accountid= [Select accountid from Opportunity where id =:oppid].accountid;
                if(AccountSFRevenueMap.containskey(accountid)){
                    Map<String, Decimal> SFREvMap= AccountSFRevenueMap.get(accountid);  
                    if(SFREvMap.containskey(agr.crm_Agreement_Service_Family__c)){
                        Decimal revamount=SFREvMap.get(agr.crm_Agreement_Service_Family__c);
                        agr.crm_Agreement_Increased_Contract_Value__c= oppAmount.get(oppid)-revamount;
                        agr.crm_Annual_Contract_Value__c= oppAgrContractValue.get(agr.id);
                       // agr.crm_New_Revenue_Start_Date__c= null;
                        
                        }
                    
                }
                
            }
            
            
        } 
        
        if (UpdateAgrList.size()>0){
            try {
                update UpdateAgrList;
                
            }//end of try
            catch(Exception e) {crm_Exception_handler.createExceptionRecords(e) ;}
            
        }
        
        
    }//end of calculateCBRenegotiate
    
    
    global void finish(Database.BatchableContext BC) {
        
        
    } 
    
}