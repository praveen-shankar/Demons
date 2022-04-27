/*
Created By: Supriya Goel
Object  :Opportunity
Date: 28 march 2016
*/

trigger crm_OpportunityTrigger on Opportunity(after update, before update, before insert, after insert, before delete) {
/*
      ** Author  :- Praveen Shankar from TCS
      ** Date    :- November 2021
      ** Project :- Posten SF2.0
 */
    //Begins - SF2.0
   set<id> skipRecType_SF2 = new set<id>() ;
   for(New_Business_Type_Opp__mdt loc_NewBusiness : [select Id__c from New_Business_Type_Opp__mdt where Available__c = true]){
        skipRecType_SF2.add(loc_NewBusiness.id__c) ;
         }
    //Ends - SF2.0
    
 if (test.isRunningTest()) {
  crm_OpptyTriggerSetting__c objOppCustomSetting = new crm_OpptyTriggerSetting__c();
  objOppCustomSetting.crm_Oppty_Trigger_Status__c = true;
  objOppCustomSetting.Name = 'Oppty';
  insert objOppCustomSetting;

  environment_settings__c objCustomSetting = new environment_settings__c();
  objCustomSetting.value__c = '1';
  objCustomSetting.Name = 'Lead_Conversion_code';
  insert objCustomSetting;
 }
 crm_OpptyTriggerSetting__c OpptyTriggerSetting = crm_OpptyTriggerSetting__c.getValues('Oppty');
 Boolean IsTriggerON = OpptyTriggerSetting.crm_Oppty_Trigger_Status__c;
 
  
 if (IsTriggerON) {
  //create EDI tasks for admin  when opp is closed won
  //set the private field on agreement from the most recent closed won opportunity private field
  if (Trigger.isUpdate && Trigger.isAfter) {
   List < Opportunity > closedWonsetAgrFieldsList = new List < Opportunity > ();
   Set < Id > Acntset = new Set < Id > ();
   Set < Id > oppSet = new Set < Id > ();
            List<Opportunity> oppListForPricingTool = New List<Opportunity>();
   for (Opportunity opp: Trigger.new) {
    Opportunity oldOpp = Trigger.oldMap.get(opp.Id);
       //conditions added to Skip --> && !skipRecType_SF2.contains(opp.RecordTypeId)
    if (oldOpp.StageName != opp.StageName && opp.StageName == 'Closed Won' && !skipRecType_SF2.contains(opp.RecordTypeId) ) {
     oppSet.add(opp.id);
     closedWonsetAgrFieldsList.add(opp);
    }
   }
   crm_opportunityTriggerHelper.createEDITasks(oppSet); //create edi tasks
   crm_opportunityTriggerHelper.setAgreementfields(closedWonsetAgrFieldsList); //set the private for agreement

   List < Opportunity > closedWonOppList = new List < Opportunity > ();
   List < Opportunity > opptenderlist = new List < Opportunity > ();
   map < id, Opportunity > oldMap = new map < id, Opportunity > ();
   List < Id > Accntids = new List < Id > ();

   for (Opportunity opp: Trigger.new) {
    Opportunity oldOpp = Trigger.oldMap.get(opp.id);
   //conditions added to Skip --> && !skipRecType_SF2.contains(opp.RecordTypeId)
    if (opp.stageName == 'Closed Won' && oldOpp.stageName != opp.stageName && opp.crm_Close_Behaviour__c != 'Create'
       && !skipRecType_SF2.contains(opp.RecordTypeId)) {
     closedWonOppList.add(opp);
     Accntids.add(opp.accountid);
    }

    if ( (opp.crm_tender__c != null || oldOpp.crm_tender__c != null || (oldOpp.amount != opp.amount && 
        opp.crm_tender__c != null))  && !skipRecType_SF2.contains(opp.RecordTypeId) ) {
     opptenderlist.add(opp);
     oldMap.put(opp.id, oldOpp);

    }
   //conditions added to Skip --> && !skipRecType_SF2.contains(opp.RecordTypeId)
    if (((oldOpp.stageName != opp.stageName && opp.crm_tender__c != null) || 
        (oldOpp.stageName != opp.stageName && oldOpp.crm_tender__c != null) || 
        (oldOpp.stageName != opp.stageName && opp.crm_tender__c != oldOpp.crm_tender__c)) 
        && !skipRecType_SF2.contains(opp.RecordTypeId)
       ) {
     opptenderlist.add(opp);
     oldMap.put(opp.id, oldOpp);
    }

    /**************************************/
    //&& !skipRecType_SF2.contains(opp.RecordTypeId)
    if ((opp.stageName == 'Closed Won' 
        && oldOpp.crm_Verified_by_Contract_Management__c != opp.crm_Verified_by_Contract_Management__c 
        && opp.crm_Verified_by_Contract_Management__c == true && opp.New_Service_Group__c == true) 
        && !skipRecType_SF2.contains(opp.RecordTypeId)
       ) {
     Acntset.add(opp.Accountid);
    }
   //  OpportunityLineItemHelper.setoptiononaccount(Acntset);    
       if(opp.Send_to_Pricing_Tool__c && !skipRecType_SF2.contains(opp.RecordTypeId)){
     oppListForPricingTool.add(opp);
    }

   }

   // if(Acntset.size()>0) 
   //  OpportunityLineItemHelper.setoptiononaccount(Acntset);
   if (opptenderlist.size() > 0)
    crm_opportunityTriggerHelper.TenderCalculations(opptenderlist, oldMap, false);
      
      if(oppListForPricingTool.size() > 0  && crm_opportunityTriggerHelper.firstCall){
        crm_opportunityTriggerHelper.firstCall = false;
          //skipRecType_SF2 ;
          list<opportunity> triigerNewV = new list<opportunity>() ;
          for(opportunity opp_loc : Trigger.New){
              if(!skipRecType_SF2.contains(opp_loc.recordtypeid)){
                  triigerNewV.add(opp_loc) ;
              }
          }
        //crm_opportunityTriggerHelper.sendToPricingTool(Trigger.New,Trigger.oldMap,'update');
          crm_opportunityTriggerHelper.sendToPricingTool(triigerNewV,Trigger.oldMap,'update');
   }

  }

  //set the opp type before opp is inserted
  //Add price book according to service Family when opp is inserted

  if (Trigger.isInsert && Trigger.isBefore) {
   environment_settings__c env = environment_settings__c.getValues('OppValidationConvertedCustomer');
   if (env != null && env.value__c == 'true') {
                 list<opportunity> triigerNewV = new list<opportunity>() ;
      
          for(opportunity opp_loc : Trigger.New){
              
           
              
              if(!skipRecType_SF2.contains(opp_loc.id)){
                  triigerNewV.add(opp_loc) ;
              }
          }
    
    //crm_opportunityTriggerHelper.checkselectedcustomer(Trigger.new);
    crm_opportunityTriggerHelper.checkselectedcustomer(triigerNewV);
   }

   List < Opportunity > Oppstocheckfordates = new List < Opportunity > ();
   List < Opportunity > oppList = new List < Opportunity > ();
     list<opportunity> NewListSF = new list<opportunity>() ;
   for (Opportunity opp: Trigger.new) {
       if(skipRecType_SF2.contains(opp.RecordTypeId)){
                  
                  NewListSF.add(opp);
                  System.debug('NewListSF 8305499228'+NewListSF);
              }
    //addingd the check for the Sales CR to check the dates
    //&& !skipRecType_SF2.contains(opp.RecordTypeId)
    if (opp.crm_Agreement_Start_Date__c != null && !skipRecType_SF2.contains(opp.RecordTypeId)) { //(opp.crm_Close_Behaviour__c == 'Renegotiate' || opp.crm_Close_Behaviour__c == 'Upsell') &&
      Oppstocheckfordates.add(opp);
    }
    //&& !skipRecType_SF2.contains(opp.RecordTypeId)
    if (opp.crm_Verified_by_Contract_Management__c == true && !skipRecType_SF2.contains(opp.RecordTypeId))
     opp.crm_Verified_by_Contract_Management__c = false;
    //&& !skipRecType_SF2.contains(opp.RecordTypeId)
    if (opp.crm_Enriched_In_PriceEngine__c == true && !skipRecType_SF2.contains(opp.RecordTypeId))
     opp.crm_Enriched_In_PriceEngine__c = false;
    // && !skipRecType_SF2.contains(opp.RecordTypeId)
    if (opp.Type != 'Renegotiate' && opp.type != 'Upsell' && !skipRecType_SF2.contains(opp.RecordTypeId)) {
     oppList.add(opp);
    }
       
   }
      if(NewListSF.size()>0){
        crm_opportunityTriggerHelper.addPricebook(NewListSF);
       }
      
   if (Oppstocheckfordates.size()>0){
    crm_opportunityTriggerHelper.checksamedatesonopp(Oppstocheckfordates);
    
    }
      if(!system.isBatch())
      {
          if (oppList.size() > 0) 
          {
              crm_opportunityTriggerHelper.setOppType(oppList, true); //1=> check all conditions
          }
      }
          list<opportunity> triigerNewV = new list<opportunity>() ;
          for(opportunity opp_loc : Trigger.New){
          System.debug('skipRecType_SF2'+ skipRecType_SF2);
          System.debug('!skipRecType_SF2.contains(opp_loc.id)'+ !skipRecType_SF2.contains(opp_loc.id));
              if(!skipRecType_SF2.contains(opp_loc.recordtypeid)){ 
                  triigerNewV.add(opp_loc) ;
                  System.debug('triigerNewV 8305499228 lineno.175 '+triigerNewV);
              }
          }
   //crm_opportunityTriggerHelper.addPricebook(Trigger.new);
   //crm_opportunityTriggerHelper.setnewservicegroup(Trigger.new);
  // crm_opportunityTriggerHelper.checkoppinsameSF(Trigger.new); //Tempararly commented for SF2.0
 
      if(triigerNewV.size() > 0){
    crm_opportunityTriggerHelper.addPricebook(triigerNewV);
    crm_opportunityTriggerHelper.setnewservicegroup(triigerNewV);
    crm_opportunityTriggerHelper.checkoppinsameSF(triigerNewV); 
                               }
  } //end of before

  if (Trigger.isInsert && Trigger.isAfter) {
   List < Opportunity > opplist = new List < Opportunity > ();
   List < Opportunity > primaryopplist = new List < Opportunity > ();
   List < Opportunity > oppListForPricingTool = New List < Opportunity >();
   for (Opportunity opp: Trigger.new) {

    //link pricebook
    //&& !skipRecType_SF2.contains(opp.RecordTypeId)
    if (opp.crm_tender__c != null && !skipRecType_SF2.contains(opp.RecordTypeId)) {
     opplist.add(opp);
    }
    //&& !skipRecType_SF2.contains(opp.RecordTypeId)
    if (opp.crm_Primary_Opportunity_Contact__c != null && !skipRecType_SF2.contains(opp.RecordTypeId)) {
     primaryopplist.add(opp);
    }
    // && !skipRecType_SF2.contains(opp.RecordTypeId)  
    if(opp.Send_to_Pricing_Tool__c && !skipRecType_SF2.contains(opp.RecordTypeId)){
     oppListForPricingTool.add(opp);
    }

   }

   if (opplist.size() > 0)
    crm_opportunityTriggerHelper.TenderCalculations(opplist, Trigger.oldMap, false);

   //Change in Contact CR  , primary contact selected here should be added as a  primary opportunity contact role
   if (primaryopplist.size() > 0)
    crm_opportunityTriggerHelper.CreatePrimaryOppRole(primaryopplist);
      
   if(oppListForPricingTool.size() > 0  && crm_opportunityTriggerHelper.firstCall){
     crm_opportunityTriggerHelper.firstCall = false;
     crm_opportunityTriggerHelper.sendToPricingTool(oppListForPricingTool,Trigger.oldMap,'Create');
   }
   

  }

  if (Trigger.isDelete && Trigger.IsBefore) {
   List < Opportunity > opplist = new List < Opportunity > ();
   List<Opportunity> oppListForPricingTool = New List<Opportunity>();
   List < Opportunity > oppListToDelete = New List < Opportunity >();
   for (Opportunity opp: Trigger.old) {
    //link pricebook
    //&& !skipRecType_SF2.contains(opp.RecordTypeId)
    if (opp.crm_tender__c != null && !skipRecType_SF2.contains(opp.RecordTypeId)) {
     opplist.add(opp);
    }
    //&& !skipRecType_SF2.contains(opp.RecordTypeId)
    if(opp.Send_to_Pricing_Tool__c && !skipRecType_SF2.contains(opp.RecordTypeId)){
       oppListForPricingTool.add(opp);
    }
   }
      
   if (opplist.size() > 0)
    crm_opportunityTriggerHelper.TenderCalculations(opplist, Trigger.oldMap, Trigger.IsDelete);
      
   if(oppListForPricingTool.size()>0 && crm_opportunityTriggerHelper.firstCall){
      crm_opportunityTriggerHelper.firstCall = false;
      crm_opportunityTriggerHelper.sendToPricingTool(oppListForPricingTool,Trigger.oldMap,'delete');
   }


  }
  //update the pricebook if service family updated 
  //associate primary contact to check if stage is changed to offer sent orclosed won and set the primary contact field on opportunity
  //run opp type

  if (Trigger.isUpdate && Trigger.isBefore) {
   List < Opportunity > linkpricebook = new List < Opportunity > ();
   List < Opportunity > associateprimarycontact = new List < Opportunity > ();
   List < Opportunity > oppAgrStartDateChangelist = new List < Opportunity > ();
   List < Opportunity > oppAgrEndDateChangelist = new List < Opportunity > ();
   List < Opportunity > Openopplist = new List < Opportunity > ();
   List < Opportunity > closedLostOppList = new List < Opportunity > ();
   List < Opportunity > Closedwonopplist = new List < Opportunity > ();
   List < Opportunity > setAgrblankList = new List < Opportunity > ();
   List < Opportunity > ConvertedFromLead = new List < Opportunity > ();
   List < Opportunity > Oppstocheckfordates= new List < Opportunity > ();

   for (Opportunity opp: Trigger.new) {
    Opportunity oldOpp = Trigger.oldMap.get(opp.id);
    
    //addingd the check for the Sales CR to check the dates
    //&& !skipRecType_SF2.contains(opp.RecordTypeId)
    if ((opp.crm_Agreement_Start_Date__c != null && oldOpp.crm_Agreement_Start_Date__c !=opp.crm_Agreement_Start_Date__c) 
       && !skipRecType_SF2.contains(opp.RecordTypeId)) {
      Oppstocheckfordates.add(opp);
    
    }

    //link pricebook
    //&& !skipRecType_SF2.contains(opp.RecordTypeId)
    if (opp.crm_Opp_Service_Family__c != oldOpp.crm_Opp_Service_Family__c && !skipRecType_SF2.contains(opp.RecordTypeId)) {
     linkpricebook.add(opp);
    }else if(skipRecType_SF2.contains(opp.RecordTypeId)){
     linkpricebook.add(opp);
     System.debug('linkpricebook 8305499228 '+linkpricebook);
    }

    //associate primary contact
    if (!System.isbatch() || !Test.isRunningTest()) {
     associateprimarycontact.add(opp);
    }

    //SET THE DATE TO TODAY WHEN THE OPP IS IFFER SENT STAGE 
    //&& !skipRecType_SF2.contains(opp.RecordTypeId)   
    if (opp.StageName == 'Offer sent' && opp.Stagename != oldOpp.Stagename && !skipRecType_SF2.contains(opp.RecordTypeId)) {
     opp.crm_Offer_Sent__c = System.today();

    }

    //stage not closed won and  amount, close date or agreement start date changes , run opp type again
    //stage not closed won and  amount, close date or agreement start date changes , run opp type again
    //&& !skipRecType_SF2.contains(opp.RecordTypeId)
    if (opp.StageName != 'Closed Won' && (Opp.crm_Close_Behaviour__c != 'Upsell' 
        && opp.crm_Close_Behaviour__c != 'Renegotiate') && ((opp.Amount != oldOpp.Amount) 
        || (opp.crm_Agreement_Start_Date__c != null && opp.crm_Agreement_Start_Date__c != oldOpp.crm_Agreement_Start_Date__c) 
        || (opp.CloseDate != oldOpp.CloseDate))
       && !skipRecType_SF2.contains(opp.RecordTypeId)) { //&& opp.StageName != 'New Opportunity'
     Openopplist.add(opp); //opp type run 
    }

    //Removed as user is updating the agrm date in above scenarios

    /* if (Opp.crm_Close_Behaviour__c!='Upsell' && opp.crm_Close_Behaviour__c!='Renegotiate'  && opp.crm_Agreement_Start_Date__c!= oldOpp.crm_Agreement_Start_Date__c){
         System.debug('%%%'+ opp);
         System.debug('%%%'+ oldopp);
         Openopplist.add(opp) ;//opp type run 
     }*/


    //this will work instead
    //&& !skipRecType_SF2.contains(opp.RecordTypeId)
    if (opp.crm_Agreement_Start_Date__c != oldOpp.crm_Agreement_Start_Date__c && !skipRecType_SF2.contains(opp.RecordTypeId) ) {
     Openopplist.add(opp); //opp type run 
     // oppAgrStartDateChangelist.add(opp);//change the start date in opp
    }
    //&& !skipRecType_SF2.contains(opp.RecordTypeId)
    if (opp.crm_Agreement_end_Date__c != oldOpp.crm_Agreement_End_Date__c && !skipRecType_SF2.contains(opp.RecordTypeId)) {

     oppAgrEndDateChangelist.add(opp); //update the opportunity end dates
    }
    //&& !skipRecType_SF2.contains(opp.RecordTypeId)
    if (opp.StageName == 'Closed Won' && opp.Stagename != oldOpp.Stagename && !skipRecType_SF2.contains(opp.RecordTypeId)) {
     Closedwonopplist.add(opp); //perform closed won calculations
    }
    //&& !skipRecType_SF2.contains(opp.RecordTypeId)
    if (opp.stageName == 'Closed Lost' && oldOpp.stageName != opp.stageName && !skipRecType_SF2.contains(opp.RecordTypeId)) {
     closedLostOppList.add(opp); //closed lost flow 
    }

    /*Service family can be updated if product=0 ie amount=0 */
     //&& !skipRecType_SF2.contains(opp.RecordTypeId)
    if ((opp.StageName != 'Closed Won') && (opp.crm_Opp_Service_Family__c != oldOpp.crm_Opp_Service_Family__c) 
        && (opp.Amount == 0 || opp.amount == null) && !skipRecType_SF2.contains(opp.RecordTypeId) ) {

     setAgrblankList.add(opp);
     Openopplist.add(opp); //opp type run 
    }
    //&& !skipRecType_SF2.contains(opp.RecordTypeId)
    if ((opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost') && oldOpp.stageName != opp.stageName
       && !skipRecType_SF2.contains(opp.RecordTypeId) ) {
     opp.CloseDate = System.today();
    }

    Integer flag = 1;

    environment_settings__c leadconversionsetting = environment_settings__c.getInstance('Lead_Conversion_code');
    flag = Integer.valueof(leadconversionsetting.value__c);
    if (flag == 1) {

     //lead conversion issue fix
     //seller changing the record type
     string oldOpprecordtypename = Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(oldopp.recordtypeid).getname();
     string newOpprecordtypename = Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(opp.recordtypeid).getname();

     System.debug('###' + oldOpprecordtypename + newOpprecordtypename);
        //&& !skipRecType_SF2.contains(opp.RecordTypeId)
     if (oldOpprecordtypename == 'Converted From Lead' && oldOpprecordtypename != newOpprecordtypename 
        && !skipRecType_SF2.contains(opp.RecordTypeId)) {
      ConvertedFromLead.add(opp);
     }
    }

   } //end of for 
   
    if (Oppstocheckfordates.size()>0){
    crm_opportunityTriggerHelper.checksamedatesonopp(Oppstocheckfordates);
    
    }

   if (oppAgrStartDateChangelist.size() > 0) {
    crm_opportunityTriggerHelper.setAgrDate(oppAgrStartDateChangelist);

   }

   if (oppAgrEndDateChangelist.size() > 0) {
    crm_opportunityTriggerHelper.setAgrDate(oppAgrEndDateChangelist);
   }

      if(!system.isBatch())
      {
          if (Openopplist.size() > 0) 
          {
              crm_opportunityTriggerHelper.setOppType(Openopplist, false); //donot check
          }
          if (Closedwonopplist.size() > 0) 
          {
              crm_opportunityTriggerHelper.setOppType(Closedwonopplist, false);
              // crm_opportunityTriggerHelper.PerformClosedWonCalculations(Closedwonopplist) ;
          }
      }

   if (closedLostOppList.size() > 0) {
    crm_opportunityTriggerHelper.PerformClosedLostCalculations(closedLostOppList, Trigger.oldMap);
   }

   if (linkpricebook.size() > 0) {
    crm_opportunityTriggerHelper.addPricebook(linkpricebook);
   }

   if (associateprimarycontact.size() > 0) {
    crm_opportunityTriggerHelper.associateprimarycontact(associateprimarycontact, Trigger.oldMap);
   }

   if (setAgrblankList.size() > 0) {
    crm_opportunityTriggerHelper.setAgrblank(setAgrblankList);
   }

   if (ConvertedFromLead.size() > 0) {
    crm_opportunityTriggerHelper.SetPartyAccountOnConvertedFromLead(ConvertedFromLead);
   }
      
  

   //Added by Supriya Master agreement change                
   //if opp is updated after closed won and was earlier verified by contract management and status was callout finished
   environment_settings__c env = environment_settings__c.getValues('AgeementMasterInterfaceSwitch');
   if (env != null && env.value__c == 'true') {
          list<opportunity> triigerNewV = new list<opportunity>() ;
          for(opportunity opp_loc : Trigger.New){
              if(!skipRecType_SF2.contains(opp_loc.id)){
                  triigerNewV.add(opp_loc) ;
                   System.debug('triigerNewV 8305499228 lineno.432 '+triigerNewV);
              }
          }
       if(triigerNewV.size() > 0){
    //crm_opportunityTriggerHelper.setCalloutstatus(Trigger.new, Trigger.oldMap);
    //crm_opportunityTriggerHelper.checkverifiedcontractmngnt(Trigger.new, Trigger.oldMap);
    //crm_opportunityTriggerHelper.checklocallyenrichedvalue(Trigger.new, Trigger.oldMap);

    crm_opportunityTriggerHelper.setCalloutstatus(triigerNewV, Trigger.oldMap);
    crm_opportunityTriggerHelper.checkverifiedcontractmngnt(triigerNewV, Trigger.oldMap);
    //crm_opportunityTriggerHelper.checklocallyenrichedvalue(triigerNewV, Trigger.oldMap);
       }


   }


  } //Trigger.isUpdate && Trigger.isBefore

 }
}