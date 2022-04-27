/*
Created By: Supriya Goel
Object  :Opportunity
Date: 28 march 2016
Helper class for Opp Trigger

*/
public class crm_opportunityTriggerHelper {
    Public static Boolean firstCall = true;
    
    public static void createEDITasks(set < Id > oppIds) {
        
        String Role = System.Label.crm_EDI_Admin;
        list < OpportunityTeamMember > OpportunityTeamMemberIds = [select id, TeamMemberRole, UserId, OpportunityId from OpportunityTeamMember where TeamMemberRole =: Role and OpportunityId in: oppIds];
        List < Task > Tasks = new List < Task > ();
        if (OpportunityTeamMemberIds.size() > 0) {
            for (OpportunityTeamMember member: OpportunityTeamMemberIds) {
                task t = new Task();
                t.whatID = member.OpportunityId;
                t.Subject = 'EDI Setup required';
                t.Priority = 'Normal';
                t.Status = 'Not Started';
                t.ActivityDate = date.today() + 3;
                t.OwnerId = member.UserId;
                Tasks.add(t);
            }
        }
        try {
            if (Tasks.size() > 0) {
                insert Tasks;
            }
        } catch (Exception e) {
            crm_Exception_handler.createExceptionRecords(e);
        }
    }
    
    public static void addPricebook(List < Opportunity > newOppList) {
    
    System.debug('Entered addPricebook method 8305499228');
        list < Pricebook2 > lstPricebook = [select Name from Pricebook2 where isActive = true];
        
        Id rectypeId =  crm_PostenUtilClass.recordTypeId('Opportunity', 'SF_II_RT_A');
        List<Opportunity> newModelOpptyList= new List<Opportunity>();
        
        map < String, ID > mapPricebook = new map < String, id > ();
        if (lstPricebook != null && lstPricebook.size() > 0) {
            for (Pricebook2 objprice: lstPricebook) {
                mapPricebook.put(objprice.Name, objprice.id);
            }
        }
        
        try {
            for (Opportunity opp: newOppList) {
                if (Opp.crm_Opp_Service_Family__c != null) {
                    if (mapPricebook != null && mapPricebook.get(Opp.crm_Opp_Service_Family__c) != null)
                        Opp.PriceBook2Id = mapPricebook.get(Opp.crm_Opp_Service_Family__c);
                }else if (opp.RecordTypeId == rectypeId){
                    newModelOpptyList.add(opp);
                }
            }
            if(newModelOpptyList.size()>0){
                Pricebook2 pb = [select id from Pricebook2 where Name =: System.Label.Combined_PriceBook_Name];
                for (Opportunity opp: newModelOpptyList) {
                    Opp.PriceBook2Id = pb.Id;
                    System.debug('Opp.PriceBook2Id = pb.Id'+Opp+'pb.Id'+pb.Id);
                }
            }
        } catch (Exception e) {
            crm_Exception_handler.createExceptionRecords(e);
        }
    }
    
    //associate primary contact with opportunity
    public static void associateprimarycontact(List < Opportunity > newOppList, Map < id, Opportunity > oldOppMap) {
        
        set < id > OppIds = new Set < Id > ();
        Map < Id, Id > oppContactMap = new Map < Id, Id > ();
        for (Opportunity opp: newOppList) {
            Opportunity oldOpp = oldOppMap.get(opp.id);
            OppIds.add(opp.id);
            if (opp.crm_Primary_Opportunity_Contact__c != null && opp.crm_Primary_Opportunity_Contact__c != oldOpp.crm_Primary_Opportunity_Contact__c)
                oppContactMap.put(opp.id, opp.crm_Primary_Opportunity_Contact__c);
            
        }
        
        List < OpportunityContactRole > UpdatedOCRlist = new List < OpportunityContactRole > ();
        Map < Id, List < OpportunityContactRole >> Opp_OCR = new Map < Id, List < OpportunityContactRole >> ();
        List < OpportunityContactRole > opproleList = [select id, contactid, Opportunityid, role, isprimary, opportunity.Accountid, Contact.Accountid, contact.Account.Parentid from OpportunityContactRole where opportunityid in: OppIds];
        if (opproleList.size() > 0) {
            for (OpportunityContactRole ocr: opproleList) {
                
                List < OpportunityContactRole > tmp_ocr = new List < OpportunityContactRole > ();
                if (Opp_OCR.containskey(ocr.opportunityid)) {
                    tmp_ocr = Opp_OCR.get(ocr.opportunityid);
                    tmp_ocr.add(ocr);
                    Opp_OCR.put(ocr.opportunityid, tmp_ocr);
                    System.debug('inside if');
                } else {
                    tmp_ocr.add(ocr);
                    Opp_OCR.put(ocr.opportunityid, tmp_ocr);
                    System.debug('insielse');
                }
                
            }
        } else {
            for (String oppid: oppContactMap.keyset()) {
                OpportunityContactRole temp = new OpportunityContactRole();
                temp.opportunityid = oppid;
                temp.contactid = oppContactMap.get(oppid);
                temp.isprimary = true;
                temp.role = 'Decision Maker';
                UpdatedOCRlist.add(temp);
                
            }
            
        }
        
        System.debug('@@@@Opp_OCR' + Opp_OCR);
        Integer counter = 0;
        for (String oppid: Opp_OCR.keyset()) {
            List < OpportunityContactRole > templist = Opp_OCR.get(oppid);
            Id PrimaryContactid = null;
            if (oppContactMap.containskey(oppid)) {
                PrimaryContactid = oppContactMap.get(oppid);
                
                for (OpportunityContactRole ocr: templist) {
                    System.debug('###' + ocr.contactid + '111 ' + PrimaryContactid);
                    
                    if (ocr.contactid != PrimaryContactid) { //add one ocr line 
                        counter = counter + 1;
                        ocr.isprimary = false;
                    }
                    
                    if (ocr.contactid == PrimaryContactid) {
                        ocr.isprimary = true;
                    }
                    
                    if (counter == templist.size()) {
                        OpportunityContactRole temp = new OpportunityContactRole();
                        temp.opportunityid = oppid;
                        temp.contactid = PrimaryContactid;
                        temp.isprimary = true;
                        temp.role = 'Decision Maker';
                        UpdatedOCRlist.add(temp);
                    }
                    
                }
                
                update templist;
            }
        }
        
        System.debug('###UpdatedOCRlist' + UpdatedOCRlist);
        insert UpdatedOCRlist;
        
        Map < id, boolean > PrimarycontactMap = new Map < id, boolean > ();
        
        Map < Id, List < OpportunityContactRole >> Opp_OCRfinal = new Map < Id, List < OpportunityContactRole >> ();
        for (OpportunityContactRole ocrprimary: [select id, contactid, Opportunityid, role, isprimary, opportunity.Accountid, Contact.Accountid, contact.Account.Parentid from OpportunityContactRole where opportunityid in: OppIds and isprimary = true]) {
            
            List < OpportunityContactRole > tmp_ocr = new List < OpportunityContactRole > ();
            tmp_ocr = Opp_OCRfinal.get(ocrprimary.opportunityid);
            if (tmp_ocr == null) {
                Opp_OCRfinal.put(ocrprimary.opportunityid, new List < OpportunityContactRole > {
                    ocrprimary
                        });
            } else {
                tmp_ocr.add(ocrprimary);
                Opp_OCRfinal.put(ocrprimary.opportunityid, tmp_ocr);
            }
            
            
        }
        
        System.debug('###Opp_OCRfinal' + Opp_OCRfinal);
        
        for (Opportunity opps: newOppList) {
            List < OpportunityContactRole > this_OCR = new List < OpportunityContactRole > ();
            this_OCR = Opp_OCRfinal.get(opps.id);
            
            if (this_OCR == null) {
                opps.crm_Primary_Opportunity_Contact__c = null;
                PrimarycontactMap.put(opps.id, false);
            } else {
                
                for (OpportunityContactRole r: this_OCR) {
                    if (r.isprimary) {
                        opps.crm_Primary_Opportunity_Contact__c = r.contactid;
                        PrimarycontactMap.put(opps.id, true);
                    }
                }
            }
        }
        
        for (Opportunity opp: newOppList) {
            Opportunity oldopp = oldOppMap.get(opp.id);
            
            if (oldopp.stagename != opp.stagename && (opp.stagename == 'Offer Sent' || opp.stagename == 'Closed Won')) {
                boolean chkPrimarycontact = PrimarycontactMap.get(opp.id);
                if (!chkPrimarycontact) opp.adderror('Please select Primary Contacts on Contact Roles Related List.');
                
            }
        }
        
    }
    
    
    /*  public static void checkAgreementforClosedwonopp(List<Opportunity> newOppList){   
Set<Id> oppIds= new Set<Id>();
Set<Id> acntIds= new Set<Id>();
Map<Id, Id> oppccntids = new Map<Id, Id>();
for(Opportunity opp : newOppList)       {
if(opp.type!='Upsell'  && opp.type!='Renegotiate' ){
acntIds.add(opp.AccountId);
if (!oppccntids.containsKey(opp.Id)){
oppccntids.put(opp.Id,opp.AccountId);
}
}
}  

String Status='Active';
Map<Id,List<crm_agreement__c>> agrMap= new Map<Id,List<crm_agreement__c>>();
List<crm_agreement__c> agrlist= [Select id, crm_Account__c,crm_Agreement_Service_Group__c,crm_Agreement_Service_Family__c from crm_agreement__c where crm_Status__c = :Status and  crm_Account__c in :acntIds];
if(agrlist.size()>0) {
for( crm_agreement__c agr: agrlist){

if (agrMap.containsKey(agr.crm_Account__c)){
List<crm_agreement__c> templist = new List<crm_agreement__c>();
templist = agrMap.get(agr.crm_Account__c);
templist.add(agr);
agrMap.put(agr.crm_Account__c,templist) ;
}
else {
List<crm_agreement__c> templist = new List<crm_agreement__c>();
templist.add(agr);
agrMap.put(agr.crm_Account__c,templist ) ;
} 

}
}//end of if

for(Opportunity opp : newOppList){
Id acntId= oppccntids.get(opp.id);
if(agrMap.containsKey(acntId)){ //chkl theblist of opp
list<crm_agreement__c> agrtocheckList =  agrMap.get(acntId);
for(crm_agreement__c agrtocheck: agrtocheckList ){
Boolean Service_Family = false;

if(opp.crm_Opp_Service_Family__c == agrtocheck.crm_Agreement_Service_Family__c ){
Service_Family = true;

}
//Service_Group && 
if(Service_Family ){
opp.addError(System.Label.crm_Agr_error_same_service_family);

}
}
}
}

}  */
    
    /* if opp= upsell or renogitaite then the agr.NRSD = oldest opp agr satrt date 
if opp cross group cross family = same as cross group family 
if opp= renogiate as there were rev lines =  null*/
    
    public static void setOppType(List < Opportunity > newOppList, Boolean updateinsertflag) {
        String agrTerminatedStatus = 'Terminated';
        
        Set < Id > agrIds = new set < Id > ();
        Set < Id > acntIds = new set < Id > ();
        Map < Id, Date > OppDate = new Map < Id, Date > ();
        Set < Id > convertedacntIds = new set < Id > ();
        crm_agreement__c agrtocheck = new crm_agreement__c();
        Map < Id, String > accountStatusMap = new Map < Id, String > ();
        
        
        for (Opportunity opp: newOppList) {
            
            agrIds.add(opp.crm_agreement__c);
            acntIds.add(opp.AccountId);
            if (opp.crm_Agreement_Start_Date__c != null) {
                Date newagrstartDate = date.newInstance(opp.crm_Agreement_Start_Date__c.year(), opp.crm_Agreement_Start_Date__c.month(), 1);
                OppDate.put(opp.AccountId, newagrstartDate);
            } //change for the CR-05742
            else
                OppDate.put(opp.AccountId, opp.CloseDate);
            
        }
        
        List < Account > accList = [SELECT Id, Customer_Converted__c FROM Account WHERE Id in: acntIds];
        
        for (Account a: accList) {
            accountStatusMap.put(a.id, a.Customer_Converted__c);
        }
        
        /*  Agreement  master  CR converted opportunity till transition period Supriya Goel*/
        
        List < Account > convertedAntList = [Select id, Customer_Converted__c, crm_customer_converted_date__c, crm_Transition_Period_In_Months__c from Account where Customer_Converted__c = 'Converted'
                                             and id in: acntIds
                                            ];
        for (Account acnt: convertedAntList) {
            Integer transitionPeriod = 2;
            System.debug(acnt.crm_Transition_Period_In_Months__c + '==== ' + acnt.crm_customer_converted_date__c);
            if (acnt.crm_customer_converted_date__c != null) {
                if (acnt.crm_Transition_Period_In_Months__c != null)
                    transitionPeriod = Integer.valueof(acnt.crm_Transition_Period_In_Months__c);
                Date actualconvertedDate = acnt.crm_customer_converted_date__c.addMonths(transitionPeriod);
                if (actualconvertedDate >= System.today())
                    convertedacntIds.add(acnt.id);
            }
        }
        System.debug('@@ActiveAgrList' + OppDate);
        
        List < crm_agreement__c > ActiveAgrList = [Select id, name, crm_Agreement_Name__c, crm_Account__c, crm_Agreement_Service_Family__c, crm_Agreement_Service_Group__c, crm_Agreement_Start_Date__c, crm_Agreement_End_Date__c, crm_status__c from crm_agreement__c where crm_status__c !=: agrTerminatedStatus and crm_Account__c in: AcntIds]; //and id not in  :agrIds 
        //List<crm_agreement__c> DraftAgrList=[Select id ,crm_Account__c, crm_Agreement_Service_Family__c , crm_Agreement_Service_Group__c , crm_Agreement_Start_Date__c from crm_agreement__c where crm_status__c= :agrDraftStatus and crm_Account__c in :AcntIds ];
        //    map account id, list of agr
        System.debug('@@ActiveAgrList' + ActiveAgrList);
        
        /**********new changes for opp creation Supriya Goel 23rd March 2018 ***************/
        /*  List<Opportunity> openOppList=[Select  id, AccountId,crm_Opp_Service_Family__c, crm_Agreement_Start_Date__c, stagename from Opportunity  where Accountid in :AcntIds ];
Map<id,Set<String>> accountOppSFMap=  new Map<id,Set<String>>();
for (Opportunity opp : openOppList){
//if((opp.stagename!= 'Closed Lost' && opp.Stagename !='Closed Won'  && opp.crm_Agreement_Start_Date__c ==null ) ||(opp.Stagename =='Closed Won' && opp.crm_Agreement_Start_Date__c!= null && opp.crm_Agreement_Start_Date__c >System.today() )) {
//new condition 

if((opp.stagename!= 'Closed Lost' && opp.Stagename !='Closed Won'  ) ||( opp.Stagename =='Closed Won' && opp.crm_Agreement_Start_Date__c!= null && opp.crm_Agreement_Start_Date__c >= System.today() )) {

if(accountOppSFMap.containsKey(opp.AccountId)){
Set<String> tempSet= new Set<String>();
tempSet= accountOppSFMap.get(opp.AccountId);
tempset.add(opp.crm_Opp_Service_Family__c);
accountOppSFMap.put(opp.AccountId,tempset);
}
else{
Set<String> tempSet= new Set<String>();
tempset.add(opp.crm_Opp_Service_Family__c);
accountOppSFMap.put(opp.AccountId,tempset);
}


}

}*/
        
        /*********************************************/
        Map < Id, List < crm_agreement__c >> AcntagrMap = new Map < Id, List < crm_agreement__c >> ();
        for (crm_agreement__c agr: ActiveAgrList) {
            if (AcntagrMap.containskey(agr.crm_Account__c)) {
                List < crm_agreement__c > temp = new list < crm_agreement__c > ();
                temp = AcntagrMap.get(agr.crm_Account__c);
                temp.add(agr);
                AcntagrMap.put(agr.crm_Account__c, temp);
                
            } else {
                List < crm_agreement__c > temp = new list < crm_agreement__c > ();
                temp.add(agr);
                AcntagrMap.put(agr.crm_Account__c, temp);
                
            }
        } //end of acntagr map
        
        Set < Account > relationaccounts = new set < account > ([Select id from account where parentid in: acntIds]);
        
        List < Account > ParentaccountList = [Select id, parentid from Account where parentid in: acntIds];
        Map < Id, Id > relationpartyccountMap = new Map < Id, Id > ();
        //relation id , party id
        
        for (account a: ParentaccountList) {
            relationpartyccountMap.put(a.id, a.parentid);
        }
        //partyid, rev list
        Map < Id, List < crm_Revenue_Line__c >> AccountRevenueMap = new Map < Id, List < crm_Revenue_Line__c >> ();
        List < crm_Revenue_Line__c > revLines = [Select crm_Account__c, crm_Amount__c, crm_Agreement__c, crm_Agreement__r.crm_Agreement_Start_Date__c, crm_Transaction_Date__c, crm_Product_Service_Family__c, crm_Product_Service_Group__c from crm_Revenue_Line__c where crm_Account__c in: relationaccounts];
        System.debug('@@revLines' + revLines);
        for (crm_Revenue_Line__c rev: revLines) {
            Id partyaccountid = relationpartyccountMap.get(rev.crm_Account__c);
            Date oppdatetochk = OppDate.get(partyaccountid);
            System.debug('@@oppdatetochk' + oppdatetochk); //  21.11.2016   2016-11-21 00:00:00   
            
            System.debug('@@oppdatetochk.addYears(-1) ' + oppdatetochk.addYears(-1));
            if (rev.crm_Transaction_Date__c >= oppdatetochk.addYears(-1) && rev.crm_Transaction_Date__c < oppdatetochk) {
                system.debug('@@ in if');
                if (AccountRevenueMap.containsKey(partyaccountid)) {
                    List < crm_Revenue_Line__c > templist = new List < crm_Revenue_Line__c > ();
                    templist = AccountRevenueMap.get(relationpartyccountMap.get(rev.crm_Account__c));
                    templist.add(rev);
                    AccountRevenueMap.put(partyaccountid, templist);
                } else {
                    List < crm_Revenue_Line__c > templist = new List < crm_Revenue_Line__c > ();
                    templist.add(rev);
                    AccountRevenueMap.put(partyaccountid, templist);
                }
                
            } //end of chk revenue date
            
        }
        
        List < Opportunity > oppNRDSlist = new List < Opportunity > ();
        List < Opportunity > oppNRDSlist2 = new List < Opportunity > ();
        
        System.debug('@@AcntagrMap' + AcntagrMap);
        for (Opportunity opp: newOppList) {
            System.debug('@@opp before upsell check' + opp);
            
            
            if (opp.crm_Close_Behaviour__c != 'Renegotiate' && opp.crm_Close_Behaviour__c != 'Upsell') {
                if (AcntagrMap.size() == 0) {
                    // opp.Type='New';
                    System.debug('@@after agr check' + opp);
                    opp.crm_Close_Behaviour__c = 'Create';
                }
            }
            /*else {
oppNRDSlist2.add(opp);

}*/
            System.debug('@@ opp.type ' + opp.type);
            if (opp.crm_Close_Behaviour__c != 'Upsell' && opp.crm_Close_Behaviour__c != 'Renegotiate') { // && 
                /*   Set<String> oppSFSet = new Set<String>();
System.debug('###accountOppSFMap' + accountOppSFMap);
//new changes  for opp creation Supriya Goel 23rd March 2018
if(accountOppSFMap.containskey(opp.Accountid) ){
oppSFSet= accountOppSFMap.get(opp.AccountId);   
}
System.debug('###oppSFSet ' + oppSFSet);

if(oppSFSet.contains(opp.crm_Opp_Service_Family__c)  && updateinsertflag ) {//&& !flag

String errordetails= 'There is already a open opportunity for Service family- ' + opp.crm_Opp_Service_Family__c ;   
opp.addError(errordetails, false );
break;

}*/
                
                if (AcntagrMap.containskey(opp.accountId)) { //acnt has active agr
                    List < crm_agreement__c > agrtocheckList = new list < crm_agreement__c > ();
                    agrtocheckList = AcntagrMap.get(opp.accountId);
                    Map < String, crm_agreement__c > ServicefamilyMap = new Map < String, crm_agreement__c > ();
                    Map < String, crm_agreement__c > ServicefamilyMapDraft = new Map < String, crm_agreement__c > ();
                    
                    Map < String, crm_agreement__c > ServicegroupMap = new Map < String, crm_agreement__c > ();
                    
                    for (crm_agreement__c agr: agrtocheckList) {
                        System.debug('###agr' + agr);
                        if ((!ServicefamilyMapDraft.containskey(agr.crm_Agreement_Service_Family__c)) && agr.crm_status__c == 'Draft') ServicefamilyMapDraft.put(agr.crm_Agreement_Service_Family__c, agr);
                        
                        if ((!ServicefamilyMap.containskey(agr.crm_Agreement_Service_Family__c)) && agr.crm_status__c == 'Active') ServicefamilyMap.put(agr.crm_Agreement_Service_Family__c, agr);
                        
                        
                        if ((!ServicegroupMap.containskey(agr.crm_Agreement_Service_group__c)) && agr.crm_status__c == 'Active') ServicegroupMap.put(agr.crm_Agreement_Service_group__c, agr);
                    }
                    
                    System.debug('###ServicefamilyMap' + ServicefamilyMap);
                    for (crm_agreement__c agr: agrtocheckList) {
                        
                        if (ServicefamilyMap.containskey(opp.crm_Opp_Service_Family__c) || ServicefamilyMapDraft.containskey(opp.crm_Opp_Service_Family__c)) {
                            
                            if (opp.crm_Close_Behaviour__c != 'Renegotiate') { //if CB != Renegotiate
                                if (ServicefamilyMapDraft.containskey(opp.crm_Opp_Service_Family__c)) { //check same SF draft agrm
                                    agrtocheck = ServicefamilyMapDraft.get(opp.crm_Opp_Service_Family__c);
                                    
                                    String AgmDetails = '<br/>Please refer this agreement ' + agrtocheck.name;
                                    
                                    opp.addError(System.Label.agreement_in_draft + AgmDetails, false);
                                    break;
                                    
                                } //end of check same SF draft agrm
                                System.debug('###ServicefamilyMap' + ServicefamilyMap + opp.crm_Opp_Service_Family__c);
                                if (ServicefamilyMap.containskey(opp.crm_Opp_Service_Family__c)  &&  ServicegroupMap.containskey(opp.crm_Opp_Service_Group__c)) { //check same SF active agrm && opp.stagename != 'Closed Won'
                                    System.debug('###ServicefamilyMap' + ServicefamilyMap + opp.crm_Opp_Service_Family__c);
                                    agrtocheck = ServicefamilyMap.get(opp.crm_Opp_Service_Family__c);
                                    String AgmDetails = '<br/>Please refer this agreement ' + agrtocheck.name;
                                    
                                    opp.addError(System.Label.crm_Opp_error_same_service_family + AgmDetails, false);
                                    break;
                                }
                                
                                if (ServicefamilyMap.containskey(opp.crm_Opp_Service_Family__c) && opp.stagename == 'Closed Won') { //check same SF active agrm
                                    agrtocheck = ServicefamilyMap.get(opp.crm_Opp_Service_Family__c);
                                    
                                }
                                
                            } //end of CB != Renegotiate
                            else {
                                opp.crm_Close_Behaviour__c = 'Create';
                            }
                            
                        } //end of service family check    
                        else {
                            opp.crm_Close_Behaviour__c = 'Create';
                            
                        }
                    } //end of agrm check     
                    
                } //end of agreement 
                
                
                
            } //end of upsell and renogiattire  
            System.debug('@@AccountRevenueMap' + AccountRevenueMap);
            //US:23786 - Renamed Offshore Project to Project Logistics
            if (opp.crm_Close_Behaviour__c == 'Create' && opp.crm_Opp_Service_Family__c != 'Project Logistics') {
                crm_get_Service_Area__c oppServiceArea = crm_get_Service_Area__c.getValues(opp.crm_Opp_Service_Group__c);
                /* if (convertedacntIds.contains(opp.Accountid) && opp.crm_Close_Behaviour__c != 'Upsell' && opp.crm_Close_Behaviour__c != 'Renegotiate' && oppServiceArea != null && oppServiceArea.is_New__c) {
opp.crm_Close_Behaviour__c = 'Create';
opp.type = 'Converted';
break;
System.debug('in converted' + opp.type);
} */ //if CB is set , caklculate the opp type  
                if (AccountRevenueMap.containskey(opp.accountId)) { //acnt has revenue line
                    if (opp.amount == null)
                        opp.amount = 0;
                    Decimal Totalrevenue = 0;
                    Decimal OppAmountCalculated = 0;
                    Boolean Service_Group = false, Service_Family = false, Service_area = false;
                    crm_Revenue_Line__c revforRenegotiate = new crm_Revenue_Line__c();
                    
                    List < crm_Revenue_Line__c > revtocheckList = new list < crm_Revenue_Line__c > ();
                    revtocheckList = AccountRevenueMap.get(opp.accountId);
                    System.debug('@@revtocheckList' + revtocheckList);
                    /*==========  New code for opp  type ===================*/
                    String counterSF = '';
                    String counterSG = '';
                    crm_get_Service_Area__c counterSAsetting;
                    String counterSA;
                    List < New_Service_Structure__mdt > newserviceslist = [Select id, Service_Group__c, Service_Family__c, CounterPart_Service_Group__c, CounterPart_Service_Family__c from New_Service_Structure__mdt where Service_Group__c =: opp.crm_Opp_Service_Group__c and Service_Family__c =: opp.crm_Opp_Service_Family__c limit 1];
                    System.debug('@@newserviceslist' + newserviceslist);
                    if (newserviceslist.size() != 0) {
                        counterSF = newserviceslist[0].CounterPart_Service_Family__c;
                        counterSG = newserviceslist[0].CounterPart_Service_Group__c;
                        counterSAsetting = crm_get_Service_Area__c.getValues(counterSG);
                        if (counterSAsetting != null) {
                            counterSA = counterSAsetting.crm_Service_Area__c;
                        }
                    }
                    
                    /***********************/
                    for (crm_Revenue_Line__c rev: revtocheckList) {
                        
                        
                        System.debug('@@rev  for renegotiate ' + opp.crm_Opp_Service_Family__c + rev);
                        if (opp.crm_Opp_Service_Family__c == rev.crm_Product_Service_Family__c || counterSF == rev.crm_Product_Service_Family__c) {
                            Totalrevenue = Totalrevenue + rev.crm_Amount__c; //check if the total rev for a service family
                            revforRenegotiate = rev;
                            
                        } //END OF CHKL SERVICE FAMILT
                        
                    } //end of for  
                    
                    OppAmountCalculated = Opp.Amount * (Integer.valueof(System.label.crm_Revenue_line_percent) * 0.01);
                    System.debug('@@@Totalrevenue  ' + Totalrevenue);
                    System.debug('@@@OppAmountCalculated   ' + OppAmountCalculated);
                    if (Totalrevenue > OppAmountCalculated) {
                        
                        System.debug('@@rev inside renego');
                        if (opp.crm_Close_Behaviour__c == 'Renegotiate' || opp.crm_Close_Behaviour__c == 'Create') {
                            opp.Type = 'Renegotiate';
                            oppNRDSlist2.add(opp);
                            break;
                            
                        }
                        
                    } //end of if total rev check  for same SF     
                    
                    //Revenue in S.F. less than  5% Opp Amount? -  chk same SG
                    Totalrevenue = 0;
                    for (crm_Revenue_Line__c rev: revtocheckList) {
                        System.debug('@@rev  for cross family ' + opp.crm_Opp_Service_Family__c + rev);
                        if (opp.crm_Opp_Service_Group__c == rev.crm_Product_Service_Group__c || counterSG == rev.crm_Product_Service_Group__c) {
                            Totalrevenue = Totalrevenue + rev.crm_Amount__c; //check if the total rev for a service group
                        } //end of if
                    } //end of for 
                    
                    OppAmountCalculated = Opp.Amount * (Integer.valueof(System.label.crm_Revenue_line_percent) * 0.01);
                    
                    if (Totalrevenue > OppAmountCalculated) {
                        opp.Type = 'Cross Family';
                        oppNRDSlist.add(opp);
                        break;
                        
                    }
                    
                    //end of same service group revenue
                    
                    //srtart of same service area
                    
                    Totalrevenue = 0;
                    String oppServiceAreaStr;
                    String revServiceAreaStr;
                    
                    
                    
                    if (oppServiceArea != null) {
                        oppServiceAreaStr = oppServiceArea.crm_Service_Area__c;
                    }
                    
                    
                    
                    
                    
                    for (crm_Revenue_Line__c rev: revtocheckList) {
                        System.debug('@@rev  for cross group ' + opp.crm_Opp_Service_Family__c + rev);
                        crm_get_Service_Area__c revServiceArea = crm_get_Service_Area__c.getValues(rev.crm_Product_Service_Group__c); ///later on pass rev group
                        //check if CS not null else assign default values  
                        
                        if (revServiceArea != null) {
                            revServiceAreaStr = revServiceArea.crm_Service_Area__c;
                        }
                        
                        System.debug('revServiceAreaStr' + revServiceAreaStr);
                        System.debug('oppServiceAreaStr' + oppServiceAreaStr);
                        System.debug('counterSA' + counterSA);
                        
                        if (oppServiceAreaStr == revServiceAreaStr || counterSA == revServiceAreaStr) {
                            Totalrevenue = Totalrevenue + rev.crm_Amount__c; //check if the total rev for a service group
                        } //end of if
                    } //end of for 
                    
                    OppAmountCalculated = Opp.Amount * (Integer.valueof(System.label.crm_Revenue_line_percent) * 0.01);
                    System.debug('OppAmountCalculated' + OppAmountCalculated);
                    System.debug('Totalrevenue' + Totalrevenue);
                    
                    if (Totalrevenue > OppAmountCalculated) {
                        opp.Type = 'Cross Group';
                        System.debug('@@@Totalrevenue    ' + Totalrevenue + '%%%' + OppAmountCalculated + 'cross group');
                        
                        System.debug('&&&&agrtocheck cross group ' + agrtocheck);
                        oppNRDSlist.add(opp);
                        break;
                        //set type = cross family
                    }
                    
                    //end of same service area
                    
                } //end of rev check
                opp.Type = 'New';
                oppNRDSlist.add(opp);
                
                break;
                
                
            } //end of if CB is set
            
        } //end of opp loop  
        
        system.debug('^^^^oppNRDSlist' + oppNRDSlist);
        
        if (oppNRDSlist.size() > 0) {
            setNRSD(oppNRDSlist);
        }
        /* if (oppNRDSlist2.size() > 0) {
setNRSDforRenopp(oppNRDSlist2);
}*/
        
    } //end of opp type  
    
    public static void setNRSD(List < Opportunity > newOppList) {
        Map < Id, date > agrmap = new Map < Id, date > ();
        
        for (Opportunity opp: newOppList) {
            if (opp.crm_agreement__c != null) {
                agrmap.put(opp.crm_agreement__c, opp.crm_Agreement_Start_Date__c);
                
                
            }
        } //end of for opp
        
        List < crm_agreement__c > agrlist = [Select id, crm_New_Revenue_Start_Date__c, crm_Agreement_Start_Date__c from crm_agreement__c where id in: agrmap.keyset()];
        for (crm_agreement__c agr: agrlist) {
            date nrsd = null;
            if (agrmap.get(agr.id) != null) nrsd = date.newInstance(agrmap.get(agr.id).year(), agrmap.get(agr.id).month(), 1);
            if (nrsd != null) {
                agr.crm_New_Revenue_Start_Date__c = nrsd;
                // agr.crm_Agreement_Start_Date__c = nrsd;
            }
        }
        update agrlist;
        
    }
    
    /*public static void setNRSDforRenopp(List < opportunity > newoppList) {
Set < Id > agrids = new Set < Id > ();
for (Opportunity opp: newOppList) {
if (opp.crm_agreement__c != null) {
agrids.add(opp.crm_agreement__c);
}
}
List < crm_agreement__c > agrlist = [Select id, crm_New_Revenue_Start_Date__c, crm_Agreement_Start_Date__c from crm_agreement__c where id in: agrids];
for (crm_agreement__c agr: agrlist) {
agr.crm_New_Revenue_Start_Date__c = null;

}



}

public static void setNRSDforopp(List < Opportunity > newOppList) {
Map < Id, date > agrmap = new Map < Id, date > ();
for (Opportunity opp: newOppList) {
if (opp.crm_agreement__c != null) {
agrmap.put(opp.crm_agreement__c, opp.crm_Agreement_Start_Date__c);

}
}
List < crm_agreement__c > agrlist = [Select id, crm_New_Revenue_Start_Date__c, crm_Agreement_Start_Date__c from crm_agreement__c where id in: agrmap.keyset()];
for (crm_agreement__c agr: agrlist) {
date nrsd = null;
if (agrmap.get(agr.id) != null)
nrsd = date.newInstance(agrmap.get(agr.id).year(), agrmap.get(agr.id).month(), 1);
if (nrsd != null) {
if (agr.crm_New_Revenue_Start_Date__c == null)
agr.crm_New_Revenue_Start_Date__c = nrsd;
agr.crm_Agreement_Start_Date__c = nrsd;
}
}
update agrlist;

}*/
    
    public static void PerformClosedLostCalculations(List < Opportunity > oppList, Map < Id, Opportunity > oldMap) {
        Map < Id, Decimal > oppAmount = new Map < Id, Decimal > ();
        Map < Id, String > oppCBMap = new Map < Id, String > ();
        Set < id > OppIds = new Set < Id > ();
        Set < id > renegotiateOppIds = new Set < Id > ();
        Set < id > agrIds = new Set < Id > ();
        
        for (Opportunity opp: oppList) {
            if (opp.type == 'Renegotiate') { //&&  opp.crm_Close_Behaviour__c == 'Renegotiate'  remoed this condition as discussed 
                renegotiateOppIds.add(opp.id);
            } else {
                OppIds.add(opp.id);
                oppCBMap.put(opp.crm_agreement__c, opp.crm_close_behaviour__c);
                if (oldMap.get(opp.id).stagename == 'Closed Won')
                    oppAmount.put(opp.crm_agreement__c, oldMap.get(opp.id).Amount);
            }
        }
        if (oppIds.size() > 0) {
            List < Opportunity > oppagrList = [Select crm_agreement__c from Opportunity where id in: OppIds order by createddate asc];
            Map < id, Integer > oppCount = new Map < id, integer > ();
            
            for (Opportunity opp: oppagrList) {
                agrIds.add(opp.crm_agreement__c);
                
            }
            
            List < crm_agreement__c > UpdateAgrList = [Select id, crm_Agreement_Increased_Contract_Value__c, crm_Annual_Contract_Value__c from crm_agreement__c where id in: oppAmount.keyset()];
            System.debug('@@in lost' + oppamount);
            for (crm_agreement__c agr: UpdateAgrList) {
                
                if (oppCBMap.containskey(agr.id)) {
                    String oppCB = oppCBMap.get(agr.id);
                    if (oppamount.containskey(agr.id)) {
                        agr.crm_Annual_Contract_Value__c = agr.crm_Annual_Contract_Value__c - oppamount.get(agr.id);
                    }
                    agr.crm_Agreement_Increased_Contract_Value__c = 0;
                }
            } //end of for  
            
            
            if (UpdateAgrList.size() > 0) {
                Database.update(UpdateAgrList);
                
            }
            
            Set < id > AgrtoDeleteSet = new Set < id > ();
            Set < id > AgrSet = new Set < id > ();
            
            for (Opportunity opp: oppList) 
            {
                if(opp.crm_agreement__c != null)
                {
                    AgrtoDeleteSet.add(opp.crm_agreement__c);
                    opp.crm_agreement__c = null;
                    opp.crm_Agreement_Start_Date__c = null;
                }
                
            }
            
            if (!AgrtoDeleteSet.isEmpty())
            {
                for (AggregateResult agg: [SELECT crm_agreement__c agr, count(id) count1 FROM Opportunity WHERE crm_agreement__c in: AgrtoDeleteSet group by crm_agreement__c])
                {
                    if ((Decimal) agg.get('count1') == 1) AgrSet.add((Id) agg.get('agr'));
                    
                }
                
                System.debug('@@AgrSet' + AgrSet);
                
                List < crm_agreement__c > agrlist = [Select id from crm_agreement__c where id in: AgrSet];
                if (agrlist.size() > 0) {
                    Database.delete(agrlist);
                }
            }
            
        } //end of oppids
        if (renegotiateOppIds.size() > 0) {
            Set < Id > accountIds = new Set < Id > ();
            List < Opportunity > opplistren = [Select id, crm_agreement__c, crm_Opp_Service_Family__c, accountid, closedate from Opportunity where id in: renegotiateOppIds];
            
            for (Opportunity opp: opplistren) {
                accountIds.add(opp.accountid);
                
            }
            String status = 'Terminated';
            
            List < crm_agreement__c > agrlist = [Select id, crm_Status__c, crm_Account__c, crm_Agreement_End_Date__c, crm_Agreement_Service_Family__c from crm_agreement__c where crm_account__c in: accountIds and crm_Status__c !=: status];
            
            Map < Id, List < crm_agreement__c >> AcntagrMap = new Map < Id, List < crm_agreement__c >> ();
            
            for (crm_agreement__c agr: agrlist) {
                if (AcntagrMap.containskey(agr.crm_Account__c)) {
                    List < crm_agreement__c > temp = new list < crm_agreement__c > ();
                    temp = AcntagrMap.get(agr.crm_Account__c);
                    temp.add(agr);
                    AcntagrMap.put(agr.crm_Account__c, temp);
                    
                } else {
                    List < crm_agreement__c > temp = new list < crm_agreement__c > ();
                    temp.add(agr);
                    AcntagrMap.put(agr.crm_Account__c, temp);
                    
                }
            } //end of acntagr map
            List < crm_agreement__c > updatedagrlist = new List < crm_agreement__c > ();
            
            for (Opportunity opp: opplistren) {
                if (AcntagrMap.containskey(opp.Accountid)) {
                    List < crm_agreement__c > templist = AcntagrMap.get(opp.Accountid);
                    if (templist.size() > 0) {
                        for (crm_agreement__c agr: templist) {
                            if (agr.crm_Agreement_Service_Family__c == opp.crm_Opp_Service_Family__c) {
                                agr.crm_Agreement_End_Date__c = opp.closedate;
                                agr.crm_Status__c = 'Terminated';
                                updatedagrlist.add(agr);
                            }
                        }
                    }
                    
                }
            }
            if (updatedagrlist.size() > 0)
                Database.update(updatedagrlist, false);
            
            
            
        } //check renogiate if
    }
    
    public static void setAgrDate(List < Opportunity > oppList) {
        
        Map < Id, date > oppAgrMapStartDate = new Map < Id, date > ();
        Map < Id, date > oppAgrMapEndDate = new Map < Id, date > ();
        Set < id > OppIds = new Set < Id > ();
        Set < id > agrIds = new Set < Id > ();
        
        for (Opportunity opp: oppList) {
            OppIds.add(opp.id);
            oppAgrMapStartDate.put(opp.crm_agreement__c, opp.crm_Agreement_Start_Date__c);
            oppAgrMapEndDate.put(opp.crm_agreement__c, opp.crm_Agreement_End_Date__c);
        }
        System.debug('@@oppAgrMapDate setdate' + oppAgrMapStartDate + oppAgrMapEndDate);
        
        List < Opportunity > oppagrList = [Select crm_agreement__c from Opportunity where id in: OppIds];
        
        for (Opportunity opp: oppagrList) {
            agrIds.add(opp.crm_agreement__c);
        }
        
        List < crm_agreement__c > UpdateAgrList = [Select id, crm_Agreement_Start_Date__c from crm_agreement__c where id in: agrIds];
        
        for (crm_agreement__c agr: UpdateAgrList) {
            agr.crm_Agreement_Start_Date__c = oppAgrMapStartDate.get(agr.id);
            agr.crm_Agreement_End_Date__c = oppAgrMapEndDate.get(agr.id);
        }
        
        System.debug('@@UpdateAgrListin setdate' + UpdateAgrList);
        if (UpdateAgrList.size() > 0) {
            try {
                Database.update(UpdateAgrList, false);
            } //end of try
            catch (Exception e) {
                crm_Exception_handler.createExceptionRecords(e);
            }
        }
    } //end of setAgrDate
    
    
    public static void setAgrblank(List < Opportunity > oppList) {
        for (Opportunity opp: oppList) {
            if (opp.crm_Close_Behaviour__c != 'Update') {
                opp.crm_agreement__c = null;
                opp.crm_Agreement_Start_Date__c = null;
                opp.crm_Agreement_End_Date__c = null;
            }
            System.debug('&&in set method' + opp);
        }
        
        
    }
    
    public static void setAgreementfields(List < Opportunity > oppList) {
        Map < Id, Boolean > agrMap = new Map < Id, Boolean > ();
        for (Opportunity opp: oppList) {
            agrMap.put(opp.crm_agreement__c, opp.crm_private__c);
        }
        
        List < crm_Agreement__c > agrList = [Select id, crm_private__c from crm_agreement__c where id in: agrMap.keyset()];
        for (crm_agreement__c agr: agrList) {
            agr.crm_private__c = agrMap.get(agr.id);
        }
        if (agrList.size() > 0) {
            try {
                Database.update(agrList, false);
                
            } //end of try
            catch (Exception e) {
                crm_Exception_handler.createExceptionRecords(e);
            }
        }
    }
    
    
    //update tender checkbox to true
    /*  public static void setTenderCheckboxonNew(List<Opportunity> oppList){
Set<id> tenderSet = new Set<Id>();
for (Opportunity opp:oppList ){
if(opp.crm_tender__c!=null){

tenderSet.add(opp.crm_tender__c);   
}
}

List<crm_Tender__c> tenderList= [Select id, crm_Check_Tender__c from crm_tender__c where id in :tenderSet];
for (crm_tender__c  tender: tenderList){
tender.crm_Check_Tender__c =   true;
}
if (tenderList.size()>0){
try {
Database.update (tenderList, false);

}//end of try

catch(Exception e) {crm_Exception_handler.createExceptionRecords(e) ;}
}

}


public static void setTenderCheckbox (List<Opportunity> oppList, Map<Id,Opportunity> oldMap){

Set<id> tenderSet = new Set<Id>();
for (Opportunity opp:oppList ){
if(oldMap.get(opp.id).crm_tender__c!= opp.crm_tender__c){

tenderSet.add(oldMap.get(opp.id).crm_tender__c);
tenderSet.add(opp.crm_tender__c);   
}
}

List<crm_Tender__c> tenderList= [Select id, crm_Check_Tender__c from crm_tender__c where id in :tenderSet];
for (crm_tender__c  tender: tenderList){
tender.crm_Check_Tender__c =   true;
}
if (tenderList.size()>0){
try {
Database.update (tenderList, false);

}//end of try

catch(Exception e) {crm_Exception_handler.createExceptionRecords(e) ;}
}


}
*/
    
    public static void TenderCalculations(List < Opportunity > oppList, Map < Id, Opportunity > oldMap, Boolean isDelete) {
        Set < Id > tenderids = new Set < Id > ();
        id OppId = null;
        for (Opportunity opp: oppList) {
            System.debug('^^^ in con 1' + oldMap);
            //opp insert
            if (oldMap == null && opp.crm_tender__c != null) {
                System.debug('^^^ in con 0 ');
                tenderids.add(opp.crm_tender__c);
                //tendercondition1(tenderids);
            }
            
            //condition1  from null to tender1 
            else if (oldMap.size() != 0 && oldMap.get(opp.id).crm_tender__c == null && opp.crm_tender__c != null) {
                System.debug('^^^ in con 1');
                tenderids.add(opp.crm_tender__c);
                //tendercondition1(tenderids);
            }
            
            
            //condition1  tender1 to tender2  
            else if (oldMap.size() != 0 && (oldMap.get(opp.id).crm_tender__c != opp.crm_tender__c && oldMap.get(opp.id).crm_tender__c != null && opp.crm_tender__c != null || oldMap.get(opp.id).amount != opp.amount || oldMap.get(opp.id).stagename != opp.stagename)) {
                System.debug('^^^ in con 2');
                tenderids.add(oldMap.get(opp.id).crm_tender__c);
                tenderids.add(opp.crm_tender__c);
                //tendercondition1(tenderids);
            }
            
            
            //condition3 temnder2 to null
            else if (oldMap.size() != 0 && oldMap.get(opp.id).crm_tender__c != null && (opp.crm_tender__c == null || isDelete)) {
                
                tenderids.add(oldMap.get(opp.id).crm_tender__c);
                OppId = opp.id;
                System.debug('^^^ tenderids in 3' + tenderids + opp.id);
                //tendercondition1(tenderids);
            }
            
        }
        if (tenderids.size() > 0)
            tendercondition1(tenderids, isDelete, OppId);
    }
    
    
    public static void tendercondition1(Set < id > tenderids, Boolean isdelete, Id deletedopp) {
        Map < id, List < Opportunity >> TenderOppMap = new Map < id, List < Opportunity >> ();
        
        //get all the system currency
        Map < String, decimal > currencyMap = new Map < String, decimal > ();
        
        List < CurrencyType > currencyList = [SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive = TRUE];
        for (CurrencyType ctype: currencyList) {
            currencyMap.put(ctype.ISOCode, ctype.ConversionRate);
        }
        
        
        Map < id, Id > agreementTenderMap = new Map < id, Id > ();
        
        System.debug('MS tenderids:' + tenderids);
        List < crm_tender__c > tenderList = [Select id, currencyisocode, crm_Accepted_value__c, crm_Total_Value__c, crm_Open_Value__c from crm_Tender__c where id in: tenderids]; //where condiion issing
        List < Opportunity > Opplist = [Select id, CurrencyIsoCode, crm_Tender__c, crm_agreement__c, amount, stagename from Opportunity where crm_Tender__c in: tenderids];
        System.debug('MS tenderList:' + tenderList);
        System.debug('MS Opplist:' + Opplist);
        
        Set < Id > agridsBlank = new Set < Id > ();
        List < crm_agreement__c > agrlisttoBlank = new List < crm_agreement__c > ();
        System.debug('###Opplist ' + Opplist);
        System.debug('###tenderList  ' + tenderList);
        
        if (Opplist.size() > 0) {
            
            for (Opportunity opp: Opplist) {
                
                
                if (TenderOppMap.containsKey(opp.crm_Tender__c)) {
                    List < Opportunity > templist = new List < Opportunity > ();
                    templist = TenderOppMap.get(opp.crm_Tender__c);
                    templist.add(opp);
                    TenderOppMap.put(opp.crm_Tender__c, templist);
                } else {
                    List < Opportunity > templist = new List < Opportunity > ();
                    templist.add(opp);
                    TenderOppMap.put(opp.crm_Tender__c, templist);
                }
                
                System.debug('###TenderOppMap' + TenderOppMap);
                
                if (opp.crm_Tender__c != null && opp.crm_agreement__c != null) {
                    agreementTenderMap.put(opp.crm_Agreement__c, opp.crm_tender__c);
                } //end of null check
                
            }
            
            
            
        } //end of size check 
        System.debug('###TenderOppMap' + TenderOppMap);
        System.debug('###agreementTenderMap' + agreementTenderMap);
        
        agrlisttoBlank = [Select id, crm_Tender__c from crm_agreement__c where crm_Tender__c in: tenderids];
        
        for (crm_agreement__c agr: agrlisttoBlank) {
            if (agr.crm_tender__c != null) agr.crm_tender__c = null;
            
        }
        
        update agrlisttoBlank;
        
        
        
        List < crm_Tender__c > newtenderlist = new List < crm_Tender__c > ();
        for (crm_tender__c tender: tenderList) {
            Decimal totalvalue = 0.0;
            Decimal acceptedvalue = 0.0;
            Decimal openvalue = 0.0;
            if (TenderOppMap.containskey(tender.id)) {
                List < Opportunity > templist = TenderOppMap.get(tender.id);
                for (Opportunity opp: templist) {
                    if (opp.amount != null) {
                        if (!isdelete) {
                            
                            if (opp.stagename == 'Closed Won') {
                                // acceptedvalue+= opp.amount;
                                acceptedvalue += (opp.amount / currencyMap.get(opp.CurrencyISOCode));
                            }
                            if (opp.stagename != 'Closed Won' && opp.stagename != 'Closed Lost')
                                openvalue += (opp.amount / currencyMap.get(opp.CurrencyISOCode));
                            
                            if (opp.amount != null)
                                totalvalue += (opp.amount / currencyMap.get(opp.CurrencyISOCode));
                            
                        } else {
                            if (opp.id == deletedopp) {
                                if (opp.stagename == 'Closed Won')
                                    acceptedvalue = 0;
                                
                                if (opp.stagename != 'Closed Won' && opp.stagename != 'Closed Lost')
                                    openvalue = 0;
                                totalvalue = 0;
                                
                            } //end of deleted opp
                            else {
                                if (opp.stagename == 'Closed Won')
                                    acceptedvalue += (opp.amount / currencyMap.get(opp.CurrencyISOCode));
                                
                                if (opp.stagename != 'Closed Won' && opp.stagename != 'Closed Lost')
                                    openvalue += (opp.amount / currencyMap.get(opp.CurrencyISOCode));
                                
                                if (opp.amount != null)
                                    totalvalue += (opp.amount / currencyMap.get(opp.CurrencyISOCode));
                            }
                            
                        } //end of isdeleted 
                        
                        
                    } //amount !=null 
                } //for
                
            } //if
            tender.crm_Accepted_value__c = acceptedvalue * currencyMap.get(tender.CurrencyISOCode);
            tender.crm_Total_Value__c = totalvalue * currencyMap.get(tender.CurrencyISOCode);
            tender.crm_Open_Value__c = openvalue * currencyMap.get(tender.CurrencyISOCode);
            
            //  newtenderlist.add(tenderobj);
            
        } //for 
        
        List < crm_agreement__c > agrList = new List < crm_agreement__c > ();
        
        if (agreementTenderMap.keyset().size() > 0) {
            for (Id agrid: agreementTenderMap.keyset()) {
                crm_agreement__c agr = new crm_agreement__c();
                agr.id = agrid;
                agr.crm_tender__c = agreementTenderMap.get(agrid);
                agrList.add(agr);
                
            }
        }
        Database.update(tenderList);
        Database.update(agrList);
    }
    
    
    public static void CreatePrimaryOppRole(List < Opportunity > oppList) {
        
        List < OpportunityContactRole > ocrList = new List < OpportunityContactRole > ();
        for (Opportunity opp: oppList) {
            OpportunityContactRole ocr = new OpportunityContactRole();
            ocr.Opportunityid = opp.id;
            ocr.contactid = opp.crm_Primary_Opportunity_Contact__c;
            ocr.isprimary = true;
            ocr.role = 'Decision Maker';
            ocrList.add(ocr);
            
        }
        
        if (ocrList.size() > 0)
            insert ocrList;
    }
    
    
    
    public static void checkverifiedcontractmngnt(List < Opportunity > oppList, Map < Id, Opportunity > oldMap) {
        
        Id BidteamGroupId = [Select id, name, type from Group where developername = 'crm_Contract_Bid_Management_Team'].id;
        if (BidteamGroupId != null) {
            List < GroupMember > members = [Select Id, UserOrGroupId, GroupId, Group.type From GroupMember Where GroupId =: BidteamGroupId];
            Set < Id > GroupmemberSet = new Set < Id > ();
            for (GroupMember member: members) {
                GroupmemberSet.add(member.UserOrGroupId);
            }
            Id SystemAdminProfileid = [Select id from Profile where name = 'System Administrator'
                                       OR name = 'Systemadministrator'
                                       limit 1
                                      ].id;
            
            for (Opportunity opp: oppList) {
                Opportunity oldOpp = oldMap.get(opp.id);
                if (opp.crm_Verified_by_Contract_Management__c != oldOpp.crm_Verified_by_Contract_Management__c) {
                    if (!GroupmemberSet.contains(UserInfo.getUserId()) && Userinfo.getProfileId() != SystemAdminProfileid) {
                        System.debug('##in  verification');
                        opp.addError(System.Label.Verified_by_bid_team_checkbox);
                        break;
                    }
                }
            }
            
        } //if group is created
    }
    
    public static void checkselectedcustomer(List < Opportunity > oppList) {
        
        //List<cls_recordType> returnValue = new List<cls_recordType>();
        Schema.DescribeSObjectResult oppinfo = Opportunity.SObjectType.getDescribe();
        
        
        Set < String > rtIds = new Set < String > ();
        
        for (Schema.RecordTypeInfo rt: oppinfo.getRecordTypeInfos()) {
            
            rtIds.add(rt.getRecordTypeId());
        }
        Set < id > accids = new Set < Id > ();
        Set < id > opprecordtypeids = new Set < Id > ();
        Map < Id, String > accountStatusMap = new Map < Id, String > ();
        
        for (Opportunity opp: opplist) {
            accids.add(opp.accountId);
            opprecordtypeids.add(opp.recordtypeid);
            
        }
        
        Map < id, String > recordTypeMap = new Map < id, String > ();
        List < RecordType > rtypes = [SELECT Id, DeveloperName FROM RecordType where sObjectType = 'Opportunity'
                                      and id in: opprecordtypeids
                                     ];
        for (RecordType rt: rtypes)
            recordTypeMap.put(rt.id, rt.DeveloperName);
        
        
        List < Account > accList = [SELECT Id, Customer_Converted__c FROM Account WHERE Id in: accids];
        
        for (Account a: accList) {
            accountStatusMap.put(a.id, a.Customer_Converted__c);
        }
        
        crm_Opportunity_Record_Type__mdt[] recordTypes = [SELECT Id, DeveloperName, MasterLabel, crm_Id__c, crm_IsNew__c, Modified__c, Unchanged__c, Unavailable__c
                                                          FROM crm_Opportunity_Record_Type__mdt
                                                          WHERE crm_Id__c IN: rtIds ORDER BY MasterLabel ASC
                                                         ];
        
        Set < String > oppnew = new Set < String > ();
        Set < String > oppold = new Set < String > ();
        
        for (crm_Opportunity_Record_Type__mdt o: recordTypes) {
            //  if (o.crm_IsNew__c || o.Modified__c) {
            if (o.crm_IsNew__c || o.Unchanged__c || o.Modified__c) {
                oppnew.add(o.DeveloperName);
                
            }
            // if (!o.crm_IsNew__c && !o.Modified__c) {
            if (o.Unavailable__c) { //|| o.Modified__c
                oppold.add(o.DeveloperName);
            }
        }
        
        system.debug('## new' + oppnew);
        system.debug('## old' + oppold);
        
        
        for (Opportunity opp: oppList) {
            String rdevname = recordTypeMap.get(opp.recordtypeid);
            System.debug('##' + accountStatusMap.get(opp.accountId));
            System.debug('##' + rdevname);
            if ((accountStatusMap.get(opp.accountId) == 'Converted' || accountStatusMap.get(opp.accountId) == 'InPreparation') && oppold.contains(rdevname)) {
                opp.addError(System.Label.Customer_Converted_error);
                break;
            }
            
            
            if ((accountStatusMap.get(opp.accountId) == '' || accountStatusMap.get(opp.accountId) == 'NotConverted') && oppnew.contains(rdevname)) {
                opp.addError(System.Label.Customer_Converted_error_new);
                break;
            }
        }
    }
    
    
    
    /*public static void checklocallyenrichedvalue(List < Opportunity > oppList, Map < Id, Opportunity > oldMap) {

Id BidteamGroupId = [Select id, name, type from Group where developername = 'crm_Contract_Bid_Management_Team'].id;
if (BidteamGroupId != null) {
List < GroupMember > members = [Select Id, UserOrGroupId, GroupId, Group.type From GroupMember Where GroupId =: BidteamGroupId];
Set < Id > GroupmemberSet = new Set < Id > ();
for (GroupMember member: members) {
GroupmemberSet.add(member.UserOrGroupId);
}
Id SystemAdminProfileid = [Select id from Profile where name = 'System Administrator'
OR name = 'Systemadministrator'
limit 1
].id;

for (Opportunity opp: oppList) {
Opportunity oldOpp = oldMap.get(opp.id);
if (opp.crm_Enriched_In_PriceEngine__c != oldOpp.crm_Enriched_In_PriceEngine__c) {
if (!GroupmemberSet.contains(UserInfo.getUserId()) && Userinfo.getProfileId() != SystemAdminProfileid) {
System.debug('##in  verification');
opp.addError(System.Label.Price_engine_locally_enriched_error);
break;
}
}
}

} //if group is created
}*/
    
    
    public static void setCalloutstatus(List < Opportunity > oppList, Map < Id, Opportunity > oldMap) {
        //Condition1 => if opportunitiy is verified by contract manement , set callout-status to Pending and sent to Price engine , status changes to caalout  finished
        //condition 2= >If any changes done to opportunity, verified by contact manement set to false,  callout status = '' , then again after bid team verifies follow step1
        
        List < String > oppIdsTosend = new List < String > ();
        List < String > shellOppToSend = new List < String > ();
        set < id > oppIdsset = new set < id > ();
        
        for (Opportunity opp: oppList) {
            
            oppIdsset.add(opp.id);
        }
        
        for (Opportunity opp: oppList) {
            
            Opportunity oldOpp = oldMap.get(opp.id);  
            
            List < OpportunityLineItem > oppLineItemsAS = [Select OpportunityId,crm_Discount__c,Product2.crm_Service_Type__c From OpportunityLineItem Where OpportunityId in :oppIdsset And Product2.crm_Service_Type__c = 'Actual Service'];
            System.debug('oppLineItemsAS---------------' + oppLineItemsAS );
            Map<Id, boolean>  oppMaptosend= new Map<Id, boolean>();
            
            List < Opportunity> opplist1 = [Select id,Copy_Existing_Agreement_in_PE__c  From Opportunity Where id in :oppIdsset ];
            //Map < id, Boolean > OppEnrichMap = new Map < id, Boolean > ();
            //Map < id, Boolean > OppCopyExistingAgreementInPE = new Map < id, Boolean > ();
            
            /*for (Opportunity copyExistingAgStatus: opplist1) {
//OppEnrichMap.put(enrichstatus.id, enrichstatus.crm_Enriched_In_PriceEngine__c);
OppCopyExistingAgreementInPE.put(copyExistingAgStatus.Id ,copyExistingAgStatus.Copy_Existing_Agreement_in_PE__c);
}*/
            
            for(OpportunityLineItem OppLineItemNull: oppLineItemsAS)
            {
                
                //System.debug('OppEnrichMap.get(OppLineItemNull.OpportunityId' + OppCopyExistingAgreementInPE.get(OppLineItemNull.OpportunityId));
                System.debug('OppEnrichMap.get(OppLineItemNull.crm_Discount__c' + OppLineItemNull.crm_Discount__c);
                
                if(!oppMaptosend.containskey(OppLineItemNull.opportunityid))
                {  
                    if(OppLineItemNull.crm_Discount__c == null )
                    {  
                        oppMaptosend.put(OppLineItemNull.opportunityid, false);          
                    }
                    else
                    { 
                        oppMaptosend.put(OppLineItemNull.opportunityid, true);    
                    }  
                } 
                else 
                { 
                    if(OppLineItemNull.crm_Discount__c == null )
                    {    
                        oppMaptosend.put(OppLineItemNull.opportunityid, false);          
                    }
                    else 
                    {
                        if(oppMaptosend.containskey(OppLineItemNull.opportunityid) && oppMaptosend.get(OppLineItemNull.opportunityid) )
                            oppMaptosend.put(OppLineItemNull.opportunityid, true);     
                    }  
                } 
                
            }
            //condition1-> verified by contract management = true , opp= closed won 
            
            System.debug('in callout opp' + opp);
            System.debug('in callout oldOpp ' + oldOpp);
            System.debug('oppMaptosend.get(opp.id)---------'+oppMaptosend.get(opp.id));
            System.debug('opp.crm_Do_not_create_Agreement__c---------'+opp.crm_Do_not_create_Agreement__c);
            System.debug('opp.StageName -------'+opp.StageName);
            System.debug('crm_Verified_by_Contract_Management__c--------'+opp.crm_Verified_by_Contract_Management__c);
            System.debug('oldOppcrm_Verified_by_Contract_Management__c--------'+oldOpp.crm_Verified_by_Contract_Management__c);
            System.debug('crm_Callout_Status__c---------'+opp.crm_Callout_Status__c);
            
            if (!opp.crm_Do_not_create_Agreement__c && oldOpp != opp && opp.StageName == 'Closed Won' && opp.crm_Verified_by_Contract_Management__c && !oldopp.crm_Verified_by_Contract_Management__c && opp.crm_Callout_Status__c == null &&  oppMaptosend.containskey(opp.id) &&  oppMaptosend.get(opp.id)) {
                System.debug('oppMaptosend.get(opp.id)---------'+oppMaptosend.get(opp.id));
                opp.crm_Callout_Status__c = 'Callout Pending';
                if(opp.Send_Shell_Agreement__c){
                    shellOppToSend.add(opp.Id);
                }
                else{
                    oppIdsTosend.add(opp.id);
                }
            }
            if (oldopp.crm_Agreement__c == null && opp.crm_Agreement__c == null && !opp.crm_Do_not_create_Agreement__c && oldOpp != opp && opp.StageName == 'Closed Won' && oldopp.crm_Verified_by_Contract_Management__c && oldopp.crm_Callout_Status__c == 'Callout Finished' && opp.crm_Callout_Status__c != 'Callout Pending') {
                if (oldopp.crm_Agreement_Start_Date__c !=  opp.crm_Agreement_Start_Date__c || oldopp.crm_Agreement_End_Date__c !=  opp.crm_Agreement_End_Date__c) {
                    opp.crm_Callout_Status__c = null;
                    opp.crm_Verified_by_Contract_Management__c = false;
                }
            }
            
            if (oldopp.crm_Agreement__c == null && opp.crm_Agreement__c != null && !opp.crm_Do_not_create_Agreement__c && oldOpp != opp && opp.StageName == 'Closed Won' && oldopp.crm_Verified_by_Contract_Management__c && oldopp.crm_Callout_Status__c == 'Callout Finished' && opp.crm_Callout_Status__c != 'Callout Pending' &&  oppMaptosend.containskey(opp.id) &&  oppMaptosend.get(opp.id)) {
                opp.crm_Callout_Status__c = 'Callout Pending';
                if(opp.Send_Shell_Agreement__c){
                    shellOppToSend.add(opp.Id);
                }
                else{
                    oppIdsTosend.add(opp.id);
                }
            }
            
            if (oppIdsTosend.size() > 0) {
                System.enqueueJob(new crm_agreementIntegrationController(oppIdsTosend, 'new'));
            }
            
            if(shellOppToSend.size() > 0){
                System.enqueueJob(new crm_agreementIntegrationController(shellOppToSend, 'shellagreement'));
            }
            
        }
    }
    
    
    
    public static void setnewservicegroup(List < Opportunity > oppList) {
        
        List < crm_Opportunity_Record_Type__mdt > recordtypes = [Select crm_IsNew__c, crm_Id__c from crm_Opportunity_Record_Type__mdt];
        Map < String, Boolean > recordtypeMap = new Map < String, Boolean > ();
        for (crm_Opportunity_Record_Type__mdt recordtype: recordtypes) {
            recordtypeMap.put(recordtype.crm_Id__c, recordtype.crm_IsNew__c);
        }
        
        for (Opportunity opp: oppList) {
            if (recordtypeMap.containskey(opp.recordtypeid))
            {
                opp.New_Service_Group__c = recordtypeMap.get(opp.recordtypeid);
                system.debug('opp >>> '+opp.New_Service_Group__c);
            }
            
        }
        
    }
    
    public static void checkoppinsameSF(List < Opportunity > oppList) {
        Set < Id > AcntIds = new Set < Id > ();
        for (Opportunity opp: oppList)
            AcntIds.add(opp.Accountid);
        
        
        List < Opportunity > openOppList = [Select id, AccountId, crm_Opp_Service_Family__c,crm_Opp_Service_group__c , crm_Agreement_Start_Date__c, crm_Agreement__c, stagename from Opportunity where Accountid in: AcntIds];
        
        Map < id, Set < String >> accountOppSFMap = new Map < id, Set < String >> ();
        Map < id, Set < String >> accountOppSGMap = new Map < id, Set < String >> ();
        for (Opportunity opp: openOppList) {
            
            
            if ((opp.stagename == 'New Opportunity') || (opp.stagename == 'Offer Sent') || (opp.Stagename == 'Closed Won' && opp.crm_Agreement__c == null)) {
                
                if (accountOppSFMap.containsKey(opp.AccountId)) {
                    Set < String > tempSet = new Set < String > ();
                    tempSet = accountOppSFMap.get(opp.AccountId);
                    tempset.add(opp.crm_Opp_Service_Family__c);
                    accountOppSFMap.put(opp.AccountId, tempset);
                    
                    Set < String > tempSGSet = new Set < String > ();
                    
                    tempSGSet = accountOppSFMap.get(opp.AccountId);
                    tempSGSet.add(opp.crm_Opp_Service_Group__c);
                    accountOppSGMap.put(opp.AccountId, tempSGSet);
                } else {
                    Set < String > tempSet = new Set < String > ();
                    tempset.add(opp.crm_Opp_Service_Family__c);
                    accountOppSFMap.put(opp.AccountId, tempset);
                    
                    Set < String > tempSGSet = new Set < String > ();
                    tempSGSet.add(opp.crm_Opp_Service_Group__c);
                    accountOppSGMap.put(opp.AccountId, tempSGSet);
                }
                
                
            }
            
        }
        for (Opportunity opp: oppList) {
            //US:23786 - Allow multiple opportunity creation for SF = Project Logistics
            if (opp.crm_Close_Behaviour__c != 'Renegotiate' && opp.crm_Close_Behaviour__c != 'Upsell' && opp.crm_Opp_Service_Group__c!='Post' && opp.crm_Opp_Service_Group__c!='Dialog' && opp.crm_Opp_Service_Family__c != 'Project Logistics') {
                Set < String > oppSFSet = new Set < String > ();
                Set < String > oppSGSet = new Set < String > ();
                System.debug('###accountOppSFMap' + accountOppSFMap);
                //new changes  for opp creation Supriya Goel30 may 2019 
                if (accountOppSFMap.containskey(opp.Accountid)) {
                    oppSFSet = accountOppSFMap.get(opp.AccountId);
                    oppSGSet = accountOppSGMap.get(opp.AccountId);
                }
                System.debug('###oppSFSet ' + oppSFSet);
                //US:23786 - Allow multiple opportunity creation for SF = Project Logistics
                if (oppSFSet.contains(opp.crm_Opp_Service_Family__c) && oppSGSet.contains(opp.crm_Opp_Service_Group__c) && opp.crm_Opp_Service_Group__c!='Post' && opp.crm_Opp_Service_Group__c!='Dialog' && opp.crm_Opp_Service_Family__c != 'Project Logistics') { //&& !flag
                    
                    String errordetails = 'There already exists an opportunity on this service family - ' + opp.crm_Opp_Service_Family__c + ' .Please refer the existing opportunity to make any changes.';
                    opp.addError(errordetails, false);
                    break;
                    
                }
                
            } //updell  check
            
        } //for loop 
        
        
    }
    
    public static void checksamedatesonopp(List < Opportunity > oppList) {
        Set < Id > AcntIds = new Set < Id > ();
        for (Opportunity opp: oppList)
            AcntIds.add(opp.Accountid);
        
        List < Opportunity > openOppList = [Select id, AccountId, crm_Opp_Service_Family__c,crm_Opp_Service_group__c , crm_Agreement_Start_Date__c, crm_Agreement__c, stagename from Opportunity where Accountid in: AcntIds ];     
        
        system.debug('###openOppList ' + openOppList ) ;
        Map < Id, Map < String, List < Opportunity >>> oppMap = new Map < Id, Map < String, List < Opportunity >>> ();
        
        for (Opportunity opp: openOppList) {
            if (oppMap.containskey(opp.Accountid)) {
                Map < String, List < Opportunity >> tempmap = new Map < String, List < Opportunity >> ();
                tempmap = oppMap.get(opp.accountid);
                if (tempmap.containskey(opp.crm_Opp_Service_Family__c)) {
                    list < Opportunity > tempopp = tempmap.get(opp.crm_Opp_Service_Family__c);
                    tempopp.add(opp);
                    tempmap.put(opp.crm_Opp_Service_Family__c, tempopp);
                    oppMap.put(opp.AccountId, tempmap);
                    
                } else {
                    list < Opportunity > tempopp = new List < Opportunity > ();
                    tempopp.add(opp);
                    tempmap.put(opp.crm_Opp_Service_Family__c, tempopp);
                    
                    oppMap.put(opp.AccountId, tempmap); //c1, opp1-upsell  3  cd  , opp2- ren   4 
                    
                }
                
            } //end of if map contains accountid
            else {
                
                Set < String > tempSet = new Set < String > ();
                tempset.add(opp.crm_Opp_Service_Family__c);
                Map < String, List < Opportunity >> tempmap = new Map < String, List < Opportunity >> ();
                if (tempmap.containskey(opp.crm_Opp_Service_Family__c)) {
                    list < opportunity > tempopp = tempmap.get(opp.crm_Opp_Service_Family__c);
                    tempopp.add(opp);
                    tempmap.put(opp.crm_Opp_Service_Family__c, tempopp);
                    oppMap.put(opp.AccountId, tempmap);
                    
                } else {
                    list < Opportunity > tempopp = new List < Opportunity > ();
                    tempopp.add(opp);
                    tempmap.put(opp.crm_Opp_Service_Family__c, tempopp);
                    
                    oppMap.put(opp.AccountId, tempmap); //c1, opp1-upsell  3  cd  , opp2- ren   4 
                    
                }
                
                
            } //end of else 
            
        } //end of for loop
        
        system.debug('###oppMap' + oppMap) ;
        
        for (Opportunity opp: oppList) {
            //if (opp.crm_Close_Behaviour__c == 'Renegotiate' || opp.crm_Close_Behaviour__c == 'Upsell') { //op3-> upsell  3  -> BD 
            Set < String > oppSFSet = new Set < String > ();
            
            
            if (oppMap.containskey(opp.Accountid)) {
                Map < String, List < Opportunity >> tempmap = new Map < String, List < Opportunity >> ();
                tempmap = oppMap.get(opp.accountid);
                if (tempmap.containskey(opp.crm_Opp_Service_Family__c)) {
                    list < opportunity > opptemplist = tempmap.get(opp.crm_Opp_Service_Family__c);
                    for (opportunity oppexisting: opptemplist) {
                        //US:23786 - Allow multiple opportunity creation for SF = Project Logistics
                        if (oppexisting.crm_Agreement_Start_Date__c == opp.crm_Agreement_Start_Date__c && opp.crm_Opp_Service_Group__c!='Post' && opp.crm_Opp_Service_Group__c!='Dialog' && opp.crm_Opp_Service_Family__c != 'Project Logistics') {
                            String errordetails = System.label.Existing_SF + ' - ' + opp.crm_Opp_Service_Family__c + ' for ' + opp.crm_Agreement_Start_Date__c.format();
                            opp.addError(errordetails, false);
                            break;
                        }
                        
                    }
                }
            }
            
            
            // }
            
        } //end of for loop
        
        
        
    }
    
    public static void SetPartyAccountOnConvertedFromLead(List < Opportunity > oppList) {
        
        String RelationLevelRecordTypeId = [Select id from RecordType where developername = 'business_account'
                                            and SobjectType = 'Account'
                                           ].id;
        crm_AccountRecordTypes__c rTProspect = crm_AccountRecordTypes__c.getValues('Prospect');
        Id ProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTProspect.crm_Record_Type_Label__c).getRecordTypeId();
        
        Set < Id > Oppid = new Set < Id > ();
        Set < Id > lstOfAccountId = new Set < Id > ();
        Map < Id, Id > OppleadMap = new Map < Id, Id > ();
        Map < Id, Id > LeadProspectAccountMap = new Map < Id, Id > ();
        Map < Id, Id > OppRelationAccountMap = new Map < Id, Id > ();
        Map < Id, Id > RelationParentid = new Map < Id, Id > ();
        Map < Id, Account > Relationdetails = new Map < Id, Account > ();
        
        for (Opportunity opp: oppList) {
            Oppid.add(opp.id);
            lstOfAccountId.add(opp.accountid);
        }
        
        //get all the leadids which are converted to opp 
        
        List < Lead > leadlist = [Select id, convertedopportunityid, crm_lead_id_new__c from lead where convertedopportunityid in: Oppid];
        for (Lead l: leadlist) {
            OppleadMap.put(l.convertedopportunityid, l.crm_lead_id_new__c);
        }
        
        List < Account > prospectAccounts = [Select id, crm_lead_id__c from account where crm_lead_id__c in: OppleadMap.values() and recordtypeid =: ProspectRecordTypeId];
        System.debug('@@@prospectAccounts' + prospectAccounts);
        for (Account a: prospectAccounts)
            LeadProspectAccountMap.put(a.crm_lead_id__c, a.id);
        
        Map < Id, Account > mapOfAccount = new Map < Id, Account > ([select id, Name, recordTypeId from Account where Id IN: lstOfAccountId]);
        Map < String, Id > Prospectmap = new Map < String, Id > ();
        Map < Id, String > OrgaMap = new Map < Id, String > ();
        
        List < Account > relationAccountList = [Select id, name, orga__c, parentid from Account where id in: lstOfAccountId and recordtypeid =: RelationLevelRecordTypeId];
        for (Account a: relationAccountList) {
            if (a.parentid != null) {
                RelationParentid.put(a.id, a.parentid);
            }
            
            Relationdetails.put(a.id, a);
            OrgaMap.put(a.id, a.orga__c);
            
        }
        
        List < Opportunity > RelationAccountOpplist = [Select id, accountid from Opportunity where accountid in: Relationdetails.keyset()];
        for (Opportunity opp: RelationAccountOpplist) {
            OppRelationAccountMap.put(opp.id, opp.accountid);
        }
        
        List < Account > ProspectAccountList = [Select id, orga__c from Account where orga__c in: OrgaMap.values() and recordtypeid =: ProspectRecordTypeId];
        for (Account a: ProspectAccountList) {
            Prospectmap.put(a.orga__c, a.id);
        }
        
        for (Opportunity opp: opplist) {
            Id leadid = OppLeadMap.get(opp.id);
            if (LeadProspectAccountMap.containskey(leadid)) {
                //user created  anew prospect 
                Id Accountid = LeadProspectAccountMap.get(leadid);
                opp.accountid = accountid;
            }
            //existing relation accccount 
            else if (OppRelationAccountMap.containskey(opp.id)) {
                //search for party or prospect 
                Id relationid = OppRelationAccountMap.get(opp.id);
                Account relationaccount = Relationdetails.get(relationid);
                if (RelationParentid.containskey(relationid)) {
                    opp.Accountid = RelationParentid.get(relationid);
                } else if (Prospectmap.containskey(relationaccount.orga__c)) {
                    opp.Accountid = Prospectmap.get(relationaccount.orga__c);
                    
                } else {
                    Account a = relationaccount.clone(false, true);
                    a.name = relationaccount.name;
                    a.recordtypeid = ProspectRecordTypeId;
                    insert a;
                    opp.accountid = a.id;
                    //create prospect
                }
                
            }
            
        }
    }
    
    
    public static void sendToPricingTool(List<Opportunity> oppList, Map<Id, Opportunity> oldOppMap, String dmlOperation){
        List<String> oppsToSend = New List<String>();
        Set<Id> oppIds = New Set<Id>();
        List<Opportunity> updateOppList = New List<Opportunity>();
        Boolean sentWhenCreated = true;
        
        if(oppList != null && oppList.size()>0){     
            for(Opportunity opp : oppList){
                oppIds.add(opp.Id);
            }
        }
        List<Opportunity> OpportunityList = New List<Opportunity>();
        
        List<Opportunity> newOppsList = [Select Id, name, ownerId, owner.Name, owner.Email, accountId, account.name, account.Orga__c, account.ShippingCountry, type, CurrencyIsoCode,crm_Opp_Service_Family__c, crm_Opp_Service_Group__c, 
                                         createdDate, Pricing_Tool_Callout_Status__c, Send_to_Pricing_Tool__c, LastModifiedDate from Opportunity where Id IN :oppIds];
        for(Opportunity o : newOppsList){
            Opportunity oldOpp = New Opportunity();
            if(oldOppMap != null){
                oldOpp = oldOppMap.get(o.id);
            }
            
            if(dmlOperation == 'Create'){
                if(o.Send_to_Pricing_Tool__c && o.Pricing_Tool_Callout_Status__c != 'Callout Pending'){
                    o.Pricing_Tool_Callout_Status__c = 'Callout Pending';
                    oppsToSend.add(o.Id);
                    updateOppList.add(o);  
                    opportunityList.add(o);
                }
            }
            else{
                if(o.Send_to_Pricing_Tool__c && o.Pricing_Tool_Callout_Status__c != 'Callout Pending' && oldOpp.Pricing_Tool_Callout_Status__c != 'Callout Pending'){
                    o.Pricing_Tool_Callout_Status__c = 'Callout Pending';
                    oppsToSend.add(o.Id);
                    updateOppList.add(o);
                    opportunityList.add(o);
                    if(!oldOpp.Send_to_Pricing_Tool__c && o.Send_to_Pricing_Tool__c && dmlOperation == 'update'){
                        dmlOperation = 'Create';
                    }
                }
            }
        }
        system.debug('updateOpp -->'+updateOppList);
        system.debug('oppToSend --> '+oppsToSend);
        system.debug('opportunityList -->'+opportunityList);
        if(updateOppList.size()>0){
            update updateOppList;
        }
        
        if(oppsToSend.size()>0)
            system.enqueueJob(New crm_OppToPricingToolIntegration(oppsToSend, dmlOperation,OpportunityList));
    }
    
    /*public static void RelationCustomersToOpportunity(List<Opportunity> oppList){

Id smallPickupRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Small Pick Up').getRecordTypeId();
}*/
    
    
    
}