/*
Created by :Supriya Goel
Date: Sprint 3
create Addon Opportunity and create Renegotiate Opportunity

*/

global class crm_opportunityProcessOpp
{
    public crm_Agreement__c agreement{get;set;}
    
    public crm_opportunityProcessOpp(ApexPages.StandardController stdController){
        this.agreement= (crm_Agreement__c)stdController.getRecord();
    }
    
    
    public Pagereference createAddonOpportunity() 
    { 
        
        //remove the field NRSD as this should be inherited from the previouyus opportunity 
        crm_Agreement__c oldAgmt =[Select Id,crm_Status__c , crm_Language_From_Opportunity__c,crm_New_Revenue_Start_Date__c, crm_Agreement_Template_ID__c,agr_Legal_Company__c,crm_account__c,crm_account__r.Name,crm_Annual_Contract_Value__c,crm_Parent_Agreement__c,crm_Agreement_Increased_Contract_Value__c,crm_Agreement_Name__c,crm_Agreement_Service_Family__c,crm_Agreement_Service_Group__c,crm_Realized_Contract_Value__c, crm_Agreement_Start_Date__c,crm_Agreement_End_Date__c, crm_Posten_Legal_Company_for_Offer__c from crm_Agreement__c where id=:agreement.Id];
        
        Map < Id, String > accountStatusMap = new Map < Id, String > ();

  List < Account > accList = [SELECT Id, Customer_Converted__c FROM Account WHERE Id =:oldAgmt.crm_account__c limit 1];

  for (Account a: accList) {
   accountStatusMap.put(a.id, a.Customer_Converted__c);
  }

  crm_Opportunity_Record_Type__mdt[] recordTypes = [SELECT Id, DeveloperName, MasterLabel, crm_Id__c, crm_IsNew__c, Modified__c,Unchanged__c,Service_Group_Api_Name__c
   FROM crm_Opportunity_Record_Type__mdt
   WHERE Service_Group_Api_Name__c =:oldAgmt.crm_Agreement_Service_Group__c ORDER BY MasterLabel ASC
  ];

  Set < String > oppnew = new Set < String > ();
  Set < String > oppold = new Set < String > ();

  for (crm_Opportunity_Record_Type__mdt o: recordTypes) {
   if (o.crm_IsNew__c || o.Modified__c  ) { 
    oppnew.add(o.Service_Group_Api_Name__c);

   }
   if (!o.crm_IsNew__c && !o.Modified__c && !o.Unchanged__c ) {  
    oppold.add(o.Service_Group_Api_Name__c);
   }
  }

   if ((accountStatusMap.get(oldAgmt.crm_account__c) == 'Converted' || accountStatusMap.get(oldAgmt.crm_account__c) == 'InPreparation') && oppold.contains(oldAgmt.crm_Agreement_Service_Group__c)) {
  return new Pagereference('/apex/crm_cannotcreateonoldservices?acc='+oldAgmt.crm_account__c);
   }


   if ((accountStatusMap.get(oldAgmt.crm_account__c) == '' || accountStatusMap.get(oldAgmt.crm_account__c) == 'NotConverted') && oppnew.contains(oldAgmt.crm_Agreement_Service_Group__c)) {
   return new Pagereference('/apex/crm_cannotcreateonoldservices?acc='+oldAgmt.crm_account__c);
   }
   
        List<Opportunity> listopp= new List<opportunity>();
        if(oldAgmt.crm_Status__c == 'Active' ){  
            List<Opportunity> previousOpp =[Select name,CurrencyIsoCode,PriceBook2Id , Accountid,crm_Inherited_From__c, Account.name, crm_Opp_Service_Family__c,crm_TemplateID__c,crm_Opp_Service_Group__c,crm_Primary_Opportunity_Contact__c,Owner.crm_Signature_URL__c, recordtypeid, crm_Posten_Legal_Company_for_Offer__c from Opportunity  where crm_Agreement__c =:agreement.Id and  stageName = 'Closed Won' order by Createddate desc limit 1];
            if(previousOpp.size()>0){
                  System.debug('$$'+previousOpp[0].id  );  
                string OppObject ='Opportunity';
                String filters = '%' + previousOpp[0].crm_Opp_Service_Group__c + '%';
                Opportunity opp = New Opportunity();
                opp.accountId = previousOpp[0].Accountid;
                opp.Name= previousOpp[0].account.Name + '-'+ previousOpp[0].crm_Opp_Service_Family__c+ '-Upsell';
                opp.crm_Opp_Service_Group__c=previousOpp[0].crm_Opp_Service_Group__c;
                opp.crm_Opp_Service_Family__c= previousOpp[0].crm_Opp_Service_Family__c;
                opp.Stagename='New Opportunity';
                opp.type='Upsell';
                opp.crm_Close_Behaviour__c='Upsell';
                opp.CloseDate=Date.today()+14;
                opp.crm_Language_for_Offer__c= oldAgmt.crm_Language_From_Opportunity__c;
                opp.crm_Posten_Legal_Company_for_Offer__c = previousOpp[0].crm_Posten_Legal_Company_for_Offer__c;
                opp.RecordTypeId=previousOpp[0].RecordTypeId;
                opp.crm_TemplateID__c=previousOpp[0].crm_TemplateID__c;
                opp.crm_Posten_Legal_Company_for_Offer__c= previousOpp[0].crm_Posten_Legal_Company_for_Offer__c;
                opp.crm_Parent_Opp__c= previousOpp[0].id;
                opp.CurrencyIsoCode=previousOpp[0].CurrencyIsoCode;
                Opp.PriceBook2Id =previousOpp[0].PriceBook2Id; 
                System.debug('$$'+previousOpp[0].crm_Inherited_From__c  ); 
                
                if(previousOpp[0].crm_Inherited_From__c == null  ||  previousOpp[0].crm_Inherited_From__c =='')
                   opp.crm_Inherited_From__c = previousOpp[0].id;
                 else                   
                   opp.crm_Inherited_From__c = previousOpp[0].crm_Inherited_From__c + '|' + previousOpp[0].id;
                
                //try{
                listopp.add(opp);
                      Database.SaveResult[] InsertResultList=Database.Insert(listopp,false);
                      System.debug('InsertResultList' + InsertResultList);
                           for(Integer i = 0; i < InsertResultList.size(); i++)
                           {
                                if(InsertResultList[i].isSuccess()==false)
                                {
                                        return new Pagereference('/apex/crm_cannotcreateonoldservices?acc='+agreement.crm_account__c);
                                }
                                
                              }  
                   
                //} catch(Exception e) { crm_Exception_handler.createExceptionRecords(e);}    
                
                //copy primary contact to new opportunity  Supriya 14th march 2017
                
                if(previousOpp[0].crm_Primary_Opportunity_Contact__c!=null)
                {
                    OpportunityContactRole ocr = [select id, contactid, Opportunityid, role, isprimary from OpportunityContactRole where opportunityid =:previousOpp[0].id and isprimary = true];
                    
                    if(ocr!=null)
                    {
                        OpportunityContactRole  newContactRole = new OpportunityContactRole();
                        
                        newContactRole.ContactId=ocr.contactid;
                        newContactRole.OpportunityId=opp.id;
                        newContactRole.Role=ocr.role;
                        newContactRole.IsPrimary=true;
                        try{
                        insert newContactRole;
                        /****************************/
                        
                        opp.crm_Primary_Opportunity_Contact__c=ocr.contactid; 
                        update opp; 
                        } catch(Exception e) {                         
                        return new Pagereference('/apex/crm_No_Opp_for_Agr?agr='+agreement.Id); ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
                        }    
                        
                    }
                }   
                else{
                     List<AccountContactrelation> acrList= [Select id,Accountid,contactid, contact.crm_contact_type__c ,contact.crm_Activities_Count__c, contact.status__c from  AccountContactrelation where Accountid = :previousOpp[0].Accountid and contact.status__c='Aktiv' and contact.crm_contact_type__c ='Sales' order by contact.crm_Activities_Count__c desc ];
                     if(acrList.size()>0 && acrList != null){
                         Opportunity oppWithPrimaryCon = New Opportunity();
                         oppWithPrimaryCon.Id = opp.Id;
                         oppWithPrimaryCon.crm_Primary_Opportunity_Contact__c = acrList[0].contactId;
                         update oppWithPrimaryCon;
                      }
                
                }
                
                return new Pagereference('/'+opp.Id ); //+ '/e?retURL=%2F'+opp.Id
            }
            else{ return new Pagereference('/apex/crm_No_Opp_for_Agr?agr='+agreement.Id); }
        } 
        
        else{ return new Pagereference('/apex/crm_No_Agreement_Created?agr='+agreement.Id);    }
    }
    
       public Pagereference createRenegotiateOpportunity() { 
        
        //check for single  renegottaite opp and give error msg 
        List<Opportunity> listopp=new List<Opportunity> ();
        crm_Agreement__c oldAgmt =[Select id, crm_Status__c ,crm_Language_From_Opportunity__c,agr_Legal_Company__c,crm_New_Revenue_Start_Date__c, crm_Agreement_Template_ID__c,crm_account__c,crm_account__r.Name,crm_Annual_Contract_Value__c,crm_Parent_Agreement__c,crm_Agreement_End_Date__c,crm_Agreement_Increased_Contract_Value__c,crm_Agreement_Name__c,crm_Agreement_Service_Family__c,crm_Agreement_Service_Group__c,crm_Agreement_Start_Date__c,crm_Realized_Contract_Value__c, crm_Posten_Legal_Company_for_Offer__c from crm_Agreement__c where id=:agreement.Id];
         Map < Id, String > accountStatusMap = new Map < Id, String > ();

  List < Account > accList = [SELECT Id, Customer_Converted__c FROM Account WHERE Id =:oldAgmt.crm_account__c limit 1];

  for (Account a: accList) {
   accountStatusMap.put(a.id, a.Customer_Converted__c);
  }

  crm_Opportunity_Record_Type__mdt[] recordTypes = [SELECT Id, DeveloperName, MasterLabel, crm_Id__c, crm_IsNew__c, Modified__c,Unchanged__c,Service_Group_Api_Name__c
   FROM crm_Opportunity_Record_Type__mdt
   WHERE Service_Group_Api_Name__c =:oldAgmt.crm_Agreement_Service_Group__c ORDER BY MasterLabel ASC
  ];

  Set < String > oppnew = new Set < String > ();
  Set < String > oppold = new Set < String > ();

  for (crm_Opportunity_Record_Type__mdt o: recordTypes) {
   if (o.crm_IsNew__c || o.Modified__c) {
    oppnew.add(o.Service_Group_Api_Name__c);

   }
   if (!o.crm_IsNew__c && !o.Modified__c && !o.Unchanged__c ) {   
    oppold.add(o.Service_Group_Api_Name__c);
   }
  }

   if ((accountStatusMap.get(oldAgmt.crm_account__c) == 'Converted' || accountStatusMap.get(oldAgmt.crm_account__c) == 'InPreparation') && oppold.contains(oldAgmt.crm_Agreement_Service_Group__c)) {
  return new Pagereference('/apex/crm_cannotcreateonoldservices?acc='+oldAgmt.crm_account__c);
   }


   if ((accountStatusMap.get(oldAgmt.crm_account__c) == '' || accountStatusMap.get(oldAgmt.crm_account__c) == 'NotConverted') && oppnew.contains(oldAgmt.crm_Agreement_Service_Group__c)) {
   return new Pagereference('/apex/crm_cannotcreateonoldservices?acc='+oldAgmt.crm_account__c);
   }
        if(oldAgmt.crm_Status__c == 'Active' ){ 
            
            List<Opportunity> Checkrenego= [Select id from opportunity where accountid=: oldAgmt.crm_account__c and crm_Opp_Service_Family__c  =:oldAgmt.crm_Agreement_Service_Family__c and type ='Renegotiate' and crm_Close_Behaviour__c ='Renegotiate' and crm_agreement__c=null];
            if (Checkrenego.size()<1){
                //Opportunity previousOpp =[Select name from Opportunity  where crm_Agreement__c =:agreement.Id order by Createddate desc limit 1];
                List<Opportunity> previousOpp=[Select id, CurrencyIsoCode,PriceBook2Id ,amount,stageName,crm_Inherited_From__c, crm_Opp_Service_Group__c, crm_Opp_Service_Family__c ,Accountid,Account.name, type, recordtypeid, crm_Posten_Legal_Company_for_Offer__c,crm_Primary_Opportunity_Contact__c  from Opportunity  where crm_Agreement__c =:agreement.Id order by Createddate desc limit 1];
                
                if (previousOpp.size()>0){
                    if(previousOpp[0].stageName!= 'Closed Won'){//previousOpp[0].type =='Upsell'  && 
                        return new Pagereference('/apex/crm_Upsell_Opp_Not_closed?agr='+agreement.Id);
                    }
                    
                    string OppObject ='Opportunity';
                    String[] filters = new String[]{'%'+previousOpp[0].crm_Opp_Service_Group__c +'%'};
                        // string RecordTypeId = [Select Id From RecordType where sobjecttype = :OppObject and name like :filters limit 1].Id;
                      crm_get_Service_Area__c oppServiceArea = crm_get_Service_Area__c.getValues(previousOpp[0].crm_Opp_Service_Group__c); ///later on pass rev group
                              
                        
                    Opportunity opp = New Opportunity();
                    opp.accountId= previousOpp[0].Accountid;
                    opp.Name= previousOpp[0].Account.Name + '-'+ previousOpp[0].crm_Opp_Service_Family__c + '-Renegotiate';
                    opp.crm_Opp_Service_Group__c = previousOpp[0].crm_Opp_Service_Group__c;
                    opp.crm_Opp_Service_Family__c = previousOpp[0].crm_Opp_Service_Family__c ;
                    opp.Stagename='New Opportunity';
                    opp.type='Renegotiate'; 
                    opp.crm_Close_Behaviour__c='Renegotiate';
                    opp.CloseDate=Date.today()+14;
                    //opp.crm_Agreement__c = newAgmt.id;
                    // opp.crm_Agreement_Start_Date__c = System.today().addYears(1);     //set 1 year ahead from today 
                    opp.crm_Agreement_End_Date__c = null;
                    opp.RecordTypeId=previousOpp[0].RecordTypeId;
                    opp.crm_Language_for_Offer__c= oldAgmt.crm_Language_From_Opportunity__c;
                    //opp.crm_Legal_Company_for_Offer__c= oldAgmt.agr_Legal_Company__c;
                    opp.crm_Posten_Legal_Company_for_Offer__c= previousOpp[0].crm_Posten_Legal_Company_for_Offer__c; 
                    opp.crm_Parent_Opp__c= previousOpp[0].id; 
                    opp.CurrencyIsoCode=previousOpp[0].CurrencyIsoCode;
                    Opp.PriceBook2Id =previousOpp[0].PriceBook2Id; 
                    if(previousOpp[0].crm_Inherited_From__c == null  ||  previousOpp[0].crm_Inherited_From__c =='')
                   opp.crm_Inherited_From__c = previousOpp[0].id;
                 else                   
                   opp.crm_Inherited_From__c = previousOpp[0].crm_Inherited_From__c + '|' + previousOpp[0].id;
                    
                   listopp.add(opp);
                      Database.SaveResult[] InsertResultList=Database.Insert(listopp,false);
                           for(Integer i = 0; i < InsertResultList.size(); i++)
                           {
                                if(InsertResultList[i].isSuccess()==false)
                                {
                                        return new Pagereference('/apex/crm_cannotcreateonoldservices?agr='+agreement.Id);
                                }
                                
                              }  
                    
                    //copy primary contact to new opportunity  Supriya 14th march 2017
                    
                    if(previousOpp[0].crm_Primary_Opportunity_Contact__c!=null)
                    {
                        OpportunityContactRole ocr = [select id, contactid, Opportunityid, role, isprimary from OpportunityContactRole where opportunityid =:previousOpp[0].id and isprimary = true];
                        
                        if(ocr!=null)
                        {
                            OpportunityContactRole  newContactRole = new OpportunityContactRole();
                            
                            newContactRole.ContactId=ocr.contactid;
                            newContactRole.OpportunityId=opp.id;
                            newContactRole.Role=ocr.role;
                            newContactRole.IsPrimary=true;
                            
                            insert newContactRole;
                            opp.crm_Primary_Opportunity_Contact__c=ocr.contactid;
                            update opp;
                        }
                        
                    }
                    else{
                     List<AccountContactrelation> acrList= [Select id,Accountid,contactid, contact.crm_contact_type__c ,contact.crm_Activities_Count__c, contact.status__c from  AccountContactrelation where Accountid = :previousOpp[0].Accountid and contact.status__c='Aktiv' and contact.crm_contact_type__c ='Sales' order by contact.crm_Activities_Count__c desc ];
                     if(acrList.size()>0 && acrList != null){
                         Opportunity oppWithPrimaryCon = New Opportunity();
                         oppWithPrimaryCon.Id = opp.Id;
                         oppWithPrimaryCon.crm_Primary_Opportunity_Contact__c = acrList[0].contactId;
                         update oppWithPrimaryCon;
                      }
                
                }
                    
                    System.debug('^^'+ opp.crm_Inherited_From__c);
                    
                    Set<String> inheritedOppSet = new Set<String>();
                    
                    List<String> inheritedOpps =   opp.crm_Inherited_From__c.split('\\|');
                    System.debug('^^inheritedOpps  '+ inheritedOpps );
                      
                   // inheritedOppSet.addAll(inheritedOpps);  
                   
                       inheritedOppSet.add(inheritedOpps.get(inheritedOpps.size() - 1)); //get last element
                  
                   
                    System.debug('^^inheritedOppSet'+ inheritedOppSet);
                    //clone all the opportunity products
                    
                    
                    List<opportunitylineitem> oppLineItems = new List<opportunitylineitem> ();
                    if (inheritedOppSet.size()>0){ 
                        List<opportunitylineitem> ProductList=[Select Discount, Description, ListPrice, opportunityId, ProductCode, Quantity ,UnitPrice,Subtotal,crm_Agreed_Item_Price__c,crm_Discount__c, crm_Estimated_Volume__c, crm_Estimated_Weight__c,crm_Item_Type__c, crm_No_of_items_estimate__c, crm_weight_volume_conversion_factor__c ,crm_Zone_Estimates_specified__c,crm_lineItemsGroupId__c, PricebookEntryId, crm_Local__c, crm_Actual_Service__c, crm_Conversion_Factor__c, crm_Direction__c, crm_Minimum_Price__c, crm_Minimum_PricePercent__c, crm_Price_List_Business_Delivery__c, crm_Price_Unit__c,crm_Terminals__c,crm_Unit_Price__c, crm_Free_Pickup__c, crm_Max_Weight__c , crm_Min_Weight__c, crm_Passive_return__c  from opportunitylineitem where opportunityId in :inheritedOppSet order by crm_lineItemsGroupId__c,crm_Actual_Service__c  asc];
                        System.debug('^^'+ ProductList);
                        
                        //create a map of grouplineitemid , list of lineitems
                       
                        map<String, List<opportunitylineitem>> OpplineitemMap= new Map<String, List<OpportunityLineitem>>();
                       
                        for (opportunitylineitem opplineitem : ProductList) {
                         if(opplineitem.crm_lineItemsGroupId__c!= null){
                         if (OpplineitemMap.containskey(opplineitem.crm_lineItemsGroupId__c)){
                            List<opportunitylineitem> templist= new List<opportunitylineitem>();
                            templist=OpplineitemMap.get(opplineitem.crm_lineItemsGroupId__c);
                            templist.add(opplineitem);
                            OpplineitemMap.put(opplineitem.crm_lineItemsGroupId__c,templist);
                         }
                         else{
                            List<opportunitylineitem> templist= new List<opportunitylineitem>();
                            templist.add(opplineitem);
                            OpplineitemMap.put(opplineitem.crm_lineItemsGroupId__c,templist);
                             }
                                                
                            }
                        
                        }
                        
                        System.debug('^^ OpplineitemMap' +  OpplineitemMap);
                        if(OpplineitemMap.size()>0 ) // &&  oppServiceArea != null  &&  oppServiceArea.Is_New__c  )
                        {
                        for (String grpitemid: OpplineitemMap.keyset()){
                        if(OpplineitemMap.containskey(grpitemid)){
                         List<opportunitylineitem>templist=OpplineitemMap.get(grpitemid);
                         String newgroupId= grpitemid.substring(0, 15) + String.valueOf(Datetime.now().getTime()) + String.valueOf(Math.abs(Crypto.getRandomLong()));
                         for (opportunitylineitem lineitem: templist){
                        
                            Opportunitylineitem NewItem = lineitem.clone(false, true);
                            NewItem.opportunityId=opp.id;
                            NewItem.crm_lineItemsGroupId__c =newgroupId;
                            oppLineItems.add(NewItem); 
                            
                             System.debug('^^ NewItem' +  NewItem);  
                            }
                        }
                          }
                         
                        }  else if (oppServiceArea != null  &&  !oppServiceArea.Is_New__c && ProductList.size()>0 ){
                        
                         
                            for(opportunitylineitem Product:ProductList){
                                Opportunitylineitem NewItem = Product.clone(false, true);
                                NewItem.opportunityId=opp.id;
                               // NewItem.PricebookEntry.CurrencyIsoCode ='NOK';
                                oppLineItems.add(NewItem);   
                            
                        }  
                        
                        
                        
                        }  
                        
                        else
                        {
                            opp.amount=oldAgmt.crm_Annual_Contract_Value__c;
                            update opp;
                        }
                        
                        try{
                            if(oppLineItems.size()>0)
                                insert oppLineItems;
                        } catch(Exception e) { crm_Exception_handler.createExceptionRecords(e);   }   
                    } 
                    
                    
                    return new Pagereference('/'+opp.Id);// + '/e?retURL=%2F'+opp.Id
                    
                }
                else{   return new Pagereference('/apex/crm_No_Opp_for_Agr?agr='+agreement.Id);         } } 
            else {  return new Pagereference('/apex/crm_renegotiateopp_already?opp='+Checkrenego[0].Id);      }
            
        }//end of active chk
        else{ return new Pagereference('/apex/crm_No_Agreement_Created?agr='+agreement.Id);     }  
        
    } //end of fn
    
    

}