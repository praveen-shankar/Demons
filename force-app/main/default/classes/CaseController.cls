//Cs-Phase 2- Akshata Asukar - 03/01/2017 - Replaced all occurance of Account.party_number__c with Account.crm_customer_number__c
public class CaseController {
    
    private static map<Id, Account> accountMap;
    private static list<Id> accountIdList;
    
    
    
    public static void copyAccountDetailsToCase(List<Case> caseNewList, Map<Id, Case> caseOldMap){
        CaseController.setAccountIdList(caseNewList);
        CaseController.loadAccounts();
        system.debug('## copying account details. new cases: '+caseNewList.size());
        String recordId=KATSutilities.getRecordType('person_account');
        for(Case newCase : caseNewList) {   
            Case oldCase = caseOldMap.get(newCase.Id);
            Account a=accountMap.get(newCase.AccountId);
            
            // Set email field
            if(newCase.SuppliedEmail!=null && newCase.AccountEmail__c==null){
                // Filter
                if(!(newCase.suppliedEmail.contains('@posten') || newCase.suppliedEmail.contains('@bring') || newCase.suppliedEmail.contains('@toll') || newCase.suppliedEmail.contains('katsforvaltning'))){
                    newCase.AccountEmail__c=newCase.SuppliedEmail;
                }           
            }
            
            if(newCase.AccountId!=null){
                if(a.RecordTypeId==recordId){ 
                  
                    if(!accountMap.containsKey(newCase.AccountId)){             
                        a=[select id, customer_segment__c, isPersonAccount, PersonContactId, recordtypeid, PersonEmail, Phone from Account where id=:newCase.AccountId limit 1];
                        accountMap.put(a.id, a);
                    } else {a=accountMap.get(newCase.AccountId); system.debug('MAP: HAS ID - '+a.Id);  }
                    // Copy Phone from account to Case
                   
                    if(a.Phone!=null){ newCase.AccountPhone__c=a.Phone; }
                }
            }
        }
    }
    public static void maintainPrivateAccountDetails(List<Case> caseNewList, Map<Id, Case> caseOldMap){
        CaseController.setAccountIdList(caseNewList);
        CaseController.loadAccounts();
        String recordId=KATSutilities.getRecordType('person_account');
        
        for(Case newCase : caseNewList) {   
            Case oldCase = caseOldMap.get(newCase.Id);
            Account a=accountMap.get(newCase.AccountId);
            Account b;
            
            // When removing customer from a case, set email on old account to null.
            if(oldCase.AccountId!=null && newCase.AccountId!=oldCase.AccountId){
                if(!accountMap.containsKey(oldCase.AccountId)){             
                    b=[select id, customer_segment__c, isPersonAccount, PersonContactId, recordtypeid, PersonEmail, Phone from Account where id=:oldCase.AccountId limit 1];
                    accountMap.put(b.id, b);
                } else {
                    b=accountMap.get(oldCase.AccountId);
                }
                if(b.RecordTypeId==recordId){
                    b.PersonEmail=null;
                    TriggerDispatcher.accToUpdate.put(b.id, b); 
                }                   
            }
            // If the case is not connected to a new account, no further updates are required
            if(a==null){
                return;
            }
            // Update new account
            else{
                // If case is connected to a new account, check if it is a person account
                if(a.recordTypeId==recordId){
                    // Copy email from case to account when they are conected
                    if(newCase.AccountId!=null && newCase.AccountId!=oldCase.AccountId){
                        if(newCase.AccountEmail__c!=null){
                            a.PersonEmail=newCase.AccountEmail__c;
                            TriggerDispatcher.accToUpdate.put(a.id,a);
                        }
                        //else if(newCase.SuppliedEmail!=null){
                        // Removed in pob 6236
                        //a.PersonEmail=newCase.SuppliedEmail;
                        //TriggerDispatcher.accToUpdate.put(a.id,a);
                        //}
                    }
                    // Phone on case is edited
                    if(newCase.AccountPhone__c!=oldCase.AccountPhone__c && a.Phone==null){
                        a.Phone=newCase.AccountPhone__c;
                        TriggerDispatcher.accToUpdate.put(a.id,a);
                    }
                    // Email field is edited    
                    if(newCase.AccountEmail__c!=oldCase.AccountEmail__c && newCase.AccountEmail__c!=null && newCase.accountId!=null){
                        a.PersonEmail=newCase.AccountEmail__c;
                        TriggerDispatcher.accToUpdate.put(a.id,a);  
                    }
                } 
                else {System.debug('Business account. Nothing to do');}
            } // End update new account
        } // End loop           
    }
    
    
    public static void resetCtiOnCase(Case newCase, Case oldCase) {
        if(newCase.OwnerId != oldCase.OwnerId && !newCase.IsClosed) {
            newCase.Assigned_to_CTI__c = false;
            newCase.Assigned_to_CTI_Agent__c = true;
        }
    }
    
    public static void copyAccountToContactIfPrivateAccount(List<Case> caseNewList){
        if(accountMap == null){
            CaseController.loadAccounts();
        }
        String recordId=KATSutilities.getRecordType('person_account');
        
        for(Case newCase : caseNewList) {   
            Account a=accountMap.get(newCase.AccountId);
            if(a != null && a.recordTypeId == recordId && a.PersonContactId != null){
                newCase.ContactId = a.PersonContactId;
            }   
        }       
    }
    
    
    public static void setResponsibleSeller(List<Case> newList, Map<Id, Case> oldMap)
    {
        List<Id> accountIds = new List<Id>();
        List<Id> prodIds = new List<Id>();
        
        for(Case newCase : newList)
        {
            if (newCase.accountId == null)
            {
                newCase.Hidden_responsible_seller_email__c = null;
                newCase.Division_link__c = null;
            } 
            else if (oldMap == null || newCase.accountId != oldMap.get(newCase.id).accountId || newCase.Service_Product__c != oldMap.get(newCase.id).Service_Product__c) 
            {
                accountIds.add(newCase.accountId);
                prodIds.add(newCase.Service_Product__c);
            }
        }
        
        if(accountIds.size() > 0)
        {
            Map<Id, Account> accounts = new Map<Id, Account>([select id, (select id, name, Sales_Person_Email__c from Divisions__r) from Account where id in: accountIds]);
            Map<Id, Service_Product__c> prods = new Map<Id, Service_Product__c>([SELECT id, Eier__c FROM Service_Product__c WHERE id IN :prodIds]);
            
            for(Case newCase : newList)
            {
                if(newCase.Service_Product__c != null && newCase.AccountId != null)
                { 
                    String divisionType = '';
                    Account a = accounts.get(newCase.AccountId);
                    Service_Product__c p = prods.get(newCase.Service_Product__c);
                    
                    if(a != null)
                    {  
                        try
                        {
                            Map<String, Division__c> divlist = new Map<String, Division__c>();
                            for(division_types__c div : division_types__c.getAll().values())
                            {
                                if(p.Eier__c.toLowerCase().contains(div.name.toLowerCase()))
                                {
                                    divisionType = div.name;
                                }
                            }
                            
                            for(Division__c div : a.Divisions__r)
                            {
                                divlist.put(div.name, div);
                            }
                            if(divlist.containsKey(divisionType))
                            {
                                newCase.Division_link__c = divlist.get(divisionType).id;
                                //Validate and prepare email
                                String mail = divlist.get(divisionType).Sales_Person_Email__c;
                                newCase.Hidden_responsible_seller_email__c = KATSutilities.washEmailAddress(mail);
                            }
                        } 
                        catch(System.NullPointerException e )
                        {
                            // String message='Det oppsto en feil i metoden setResponsibleSeller. Se artf2811098 \r\n CaseID: '
                            //CsPhase2 Supriya 23122016
                            
                            String message= System.Label.cs_error_in_methodology+ ' setResponsibleSeller. Se artf2811098 \r\n CaseID: '
                                +newCase.Id+ '\r\n Account: '+a +'\r\n Bruker: '+System.Userinfo.getUserId();
                            ExceptionController.handleException(false, true, e, message, '');
                        }
                    }
                }
            }
            
        }
    }
    
    public static void setCtiDeadline(List<Case> newList, Map<Id, Case> oldMap) {
        map<Id, QueueDetails__c> qdMap = new map<Id, QueueDetails__c>();
        Case oldCase = null;
        
        for(QueueDetails__c qd: KATSutilities.getQueueDetails().values()) {
            if(qd.fetch_from_cti__c){
                qdMap.put(qd.OwnerId, qd);
            }
        }
        
        for(Case newCase : newList) {
            if(qdMap.containsKey(newCase.OwnerId)) {
                if(oldMap != null) {
                    oldCase = oldMap.get(newCase.id);
                }
                if(oldCase == null || cti_CasePriority.isCaseCtiDeadlineExpired(oldCase, newCase)) {
                    cti_CasePriority.resetCtiDeadlineOnCase(newCase);
                }
            }
        }
    }
    
    public static void setUnitToBlameEmailAddress(Case newCase, Case oldCase) {
        if(String.isEmpty(newCase.unit_to_blame__c)){
            newCase.Hidden_Unit_Email__c = null;
        } else if(oldCase == null || newCase.unit_to_blame__c != oldCase.unit_to_blame__c) {
            PostalUnit__c pu = [SELECT email__c, distribution_type__c FROM PostalUnit__c WHERE Id = :newCase.unit_to_blame__c LIMIT 1];
            
            if(String.isNotBlank(pu.distribution_type__c) && pu.distribution_type__c.toLowercase() == 'post i butikk') {
                //CSphase2 Supriya 23122016 distribution type is text field
                newCase.Hidden_Unit_Email__c = environment_settings__c.getInstance('default_email_for_PIB_units').value__c;
            } else {
                newCase.Hidden_Unit_Email__c = pu.email__c;
            }
        }
    }
    
    /**
* Method containing the logic for setting/updating Postal Unit based on Pickup Area.
*      If Postal Unit is blank and Pickup Area is added/changed, update Postal Unit 
*      On Insert: If both Postal Unit and Pickup Area are set, check if Pickup Area belongs to the Postal Unit. If not, set Pickup Area blank.
*      On Update: If Postal Unit and Pickup Area are changed simultaneously, check if Pickup Area belongs to the Postal Unit. If not, set Pickup Area blank. 
*      On Update: If only Pickup Area is changed, update Postal Unit.
*      On Update: If only Postal Unit is changed, set Pickup Area blank.
*/
    public static void setUnitToBlameFromPickupArea(Case newCase, Case oldCase) {
        if(!String.isEmpty(newCase.pickup_area__c)){
            Pickup_area__c pa = [SELECT p.postal_unit__c, p.Id FROM Pickup_area__c p WHERE p.Id = :newCase.pickup_area__c LIMIT 1];
            
            if(oldCase == null){
                if(String.isEmpty(newCase.unit_to_blame__c)){
                    newCase.unit_to_blame__c = pa.postal_unit__c;
                } else if(newCase.unit_to_blame__c != pa.postal_unit__c){
                    newCase.pickup_area__c = null;
                }
                return;
            }
            
            if(String.isEmpty(newCase.unit_to_blame__c) && !String.isEmpty(oldCase.unit_to_blame__c)){
                if(newCase.pickup_area__c == oldCase.pickup_area__c ){
                    newCase.pickup_area__c = null;
                } else {
                    newCase.unit_to_blame__c = pa.postal_unit__c;
                }
            } else if(newCase.unit_to_blame__c != oldCase.unit_to_blame__c){
                if(newCase.unit_to_blame__c != pa.postal_unit__c){
                    newCase.pickup_area__c = null;
                }
            } else if(newCase.pickup_area__c != oldCase.pickup_area__c){
                newCase.unit_to_blame__c = pa.postal_unit__c;
            }
        }
    }
    
    public static void setForwardingAddress(List<Case> newList, Map<Id, Case> oldmap) {
        List<Case> changeAddressCases = new List<Case>();
        Case oldCase = null;
        for(Case newCase : newList){
            if(oldMap != null) {
                oldCase = oldMap.get(newCase.id);
            }
            if(oldCase == null || oldCase.change_address_ref_no__c != newCase.change_address_ref_no__c) {
                if(KATSutilities.isEmpty(newCase.change_address_ref_no__c)) {
                    newCase.forwardingAddress__c = null;
                } else {
                    changeAddressCases.add(newCase);
                }
            }
        }
        
        if(changeAddressCases.size() > 0) {
            CaseUtil.maintainPreviousForwardingAddress(changeAddressCases);
        }
    }
    
    public static void setSenderAndReviecerBasedOnAccount(Case newCase, Case oldCase)
    {
        // Rohit: I have removed the check for old record types Sending - Avsender and Sending - Motaker as they are no more used
        // Until we decide how we are going to differentiate between the two on the case object I have removed the auto processing for the time being
        if(oldCase == null || newCase.AccountId != oldCase.AccountId)
        {
            if(CaseUtil.isCargoClaims(newCase))
            {
                CaseUtil.assignSenderInfoToCase(newCase);
            }
        }
    }
    
    public static void setAccountFromSuppliedPartyNumber(List<Case> caseNewList){
        List<Case> casesToUpdate = new List<Case>();
        List<String> suppliedPartyNumberList = new List<String>();
        Map<String, Account> accMap= new Map<String, Account>();
        
        for(Case c : caseNewList) {
            if(KATSUtilities.isEmpty(c.AccountId) && !KATSUtilities.isEmpty(c.suppliedPartyNumber__c)){
                suppliedPartyNumberList.add(c.suppliedPartyNumber__c);
                casesToUpdate.add(c);
            }
        }
        
        try {
            if(suppliedPartyNumberList.size()>0){
                for (Account a : [SELECT Id, crm_customer_number__c FROM Account WHERE crm_customer_number__c in :suppliedPartyNumberList AND Id!=:KATSutilities.POSTEN_GLOBAL_ADRESSELISTE]){
                    accMap.put(a.crm_customer_number__c, a);
                }
            }
        } catch(Exception e) {
            System.debug('===> CaseController.setAccountFromWebformPartyNumber: Exception thrown when attempting to search for account.');
        }
        
        if(!accMap.isEmpty()){
            for(Case c : casesToUpdate) {
                Account acc = accMap.get(c.suppliedPartyNumber__c);
                if(acc != null) c.AccountId = acc.Id;
            }
        }       
    }
    
    public static void setWebformParameters(Case newCase) {
        if(String.isNotBlank(newCase.Origin) && newCase.Origin.contains('Web')) {
            
            newCase.Send_Autoresponse__c = true;
            if(!(KATSutilities.isEmpty(newCase.Shipment_identification__c) )&& (KATSutilities.isEmpty(newCase.Shipment_number__c)))
            {
            String ship = newCase.Shipment_identification__c;
            if(ship.length() <= 17)
            {
            newCase.Shipment_number__c = newCase.Shipment_identification__c;
            newCase.Shipment_identification__c = '';
            }
            
            }
            
            if(newCase.Webform_customer_input__c=='b:i:new:reklamation_av_paket')
            {
            
            if(newCase.Description!=null)
            newCase.Description = '\nDescription : ' + newCase.Description;
            else
            newCase.Description = 'Description : ';
            
            if(newCase.Kundenummer__c!=null)
            newCase.Description = newCase.Description + '\nCustomer Number : ' + newCase.Kundenummer__c;
            else
            newCase.Description = newCase.Description + '\nCustomer Number : ' ;
            
            if(newCase.Anledningen_til_din_reklamation__c!=null)
            newCase.Description = newCase.Description + '\n Reason for Complaint : ' + newCase.Anledningen_til_din_reklamation__c;
            else
            newCase.Description = newCase.Description + '\n Reason for Complaint : ';
            
            if(newCase.Annan_anledning__c!=null)
            newCase.Description = newCase.Description + '\n Another Reason for Complaint : ' + newCase.Annan_anledning__c;
            else
            newCase.Description = newCase.Description + '\n Another Reason for Complaint : ';
            
            if(newCase.Foretagsnamn__c!=null)
            newCase.Description = newCase.Description + '\n Customer Name : ' + newCase.Foretagsnamn__c;
            else
            newCase.Description = newCase.Description + '\n Customer Name : ';
            
            if(newCase.Kontaktperson__c!=null)
            newCase.Description = newCase.Description + '\n Contact Name : ' + newCase.Kontaktperson__c;
            else
            newCase.Description = newCase.Description + '\n Contact Name : ';
            
            if(newCase.Ja_jag_nskar_frakten_krediterad__c!= null)
            newCase.Description = newCase.Description + '\n Yes, I wish the freight credited : ' + newCase.Ja_jag_nskar_frakten_krediterad__c;
            else
            newCase.Description = newCase.Description + '\n Yes, I wish the freight credited : ';
                      
            }
           
            
            if(newCase.Webform_customer_input__c=='b:c:new:reklamation_av_henleverans')
            {            
            /*if(newCase.Description!=null)
            newCase.Description = '\nDescription : ' + newCase.Description;
            else
            newCase.Description = 'Description : '; */
            
            if(newCase.Description_Temp1__c!=null)
            newCase.Description = '\n Order Number : ' + newCase.Description_Temp1__c;
            else
            newCase.Description =  '\n Order Number : ' ;
            
            if(newCase.Anledningen_til_din_reklamation__c!=null)
            newCase.Description = newCase.Description + '\n Reason for Complaint : ' + newCase.Anledningen_til_din_reklamation__c;
            else
            newCase.Description = newCase.Description + '\n Reason for Complaint : ';
            
            if(newCase.Annan_anledning__c!=null)
            newCase.Description = newCase.Description + '\n Another Reason for Complaint : ' + newCase.Annan_anledning__c;
            else
            newCase.Description = newCase.Description + '\n Another Reason for Complaint : ';
            
            if(newCase.Description_Temp2__c!=null)
            newCase.Description = newCase.Description + '\n Item : ' + newCase.Description_Temp2__c;
            else
            newCase.Description = newCase.Description + '\n Item : ';
            
            if(newCase.Description_Temp3__c!=null)
            newCase.Description = newCase.Description + '\n Tilverkare : ' + newCase.Description_Temp3__c;
            else
            newCase.Description = newCase.Description + '\n Tilverkare : ';
            
            if(newCase.Description_Temp4__c!= null)
            newCase.Description = newCase.Description + '\n Artikelnummer : ' + newCase.Description_Temp4__c;
            else
            newCase.Description = newCase.Description + '\n Artikelnummer : ';

            if(newCase.Antal__c!= null)
            newCase.Description = newCase.Description + '\n Antal : ' + newCase.Antal__c;
            else
            newCase.Description = newCase.Description + '\n Antal : ';
                
            if(newCase.Description_Temp2__c!= null)
            newCase.Description = newCase.Description + '\n Produkttyp : ' + newCase.Description_Temp2__c;
            else
            newCase.Description = newCase.Description + '\n Produkttyp : ';                
            
            if(newCase.Description_Temp5__c!= null)
            newCase.Description = newCase.Description + '\n Other information about the complaint : ' + newCase.Description_Temp5__c;
            else
            newCase.Description = newCase.Description + '\n Other information about the complaint : ';
                      
            }
            
        if(newCase.Webform_customer_input__c=='b:c:new:reklamation_av_expressbud')
            {
            
           /* if(newCase.Description!=null)
            newCase.Description = '\nDescription : ' + newCase.Description;
            else
            newCase.Description = 'Description : '; */
            
            if(newCase.Kundenummer__c!=null)
            newCase.Description = '\nCustomer Number : ' + newCase.Kundenummer__c;
            else
            newCase.Description = '\nCustomer Number : ' ;
            
            if(newCase.Anledningen_til_din_reklamation__c!=null)
            newCase.Description = newCase.Description + '\n Reason for Complaint : ' + newCase.Anledningen_til_din_reklamation__c;
            else
            newCase.Description = newCase.Description + '\n Reason for Complaint : ';
            
            if(newCase.Annan_anledning__c!=null)
            newCase.Description = newCase.Description + '\n Another Reason for Complaint : ' + newCase.Annan_anledning__c;
            else
            newCase.Description = newCase.Description + '\n Another Reason for Complaint : ';
            
            if(newCase.Foretagsnamn__c!=null)
            newCase.Description = newCase.Description + '\n Customer Name : ' + newCase.Foretagsnamn__c;
            else
            newCase.Description = newCase.Description + '\n Customer Name : ';
            
            if(newCase.Kontaktperson__c!=null)
            newCase.Description = newCase.Description + '\n Contact Name : ' + newCase.Kontaktperson__c;
            else
            newCase.Description = newCase.Description + '\n Contact Name : ';
            
            if(newCase.Antal__c!= null)
            newCase.Description = newCase.Description + '\n Antal : ' + newCase.Antal__c;
            else
            newCase.Description = newCase.Description + '\n Antal : ';
            
            if(newCase.Description_Temp2__c!= null)
            newCase.Description = newCase.Description + '\n Bokningsdatum : ' + newCase.Description_Temp2__c;
            else
            newCase.Description = newCase.Description + '\n Bokningsdatum : ';
            
            if(newCase.Description_Temp1__c!= null)
            newCase.Description = newCase.Description + '\n Other information about the complaint : ' + newCase.Description_Temp1__c;
            else
            newCase.Description = newCase.Description + '\n Other information about the complaint : ';
                      
            }
                        

            if(newCase.Webform_customer_input__c=='b:c:new:reklamation')
            {
                                    
            if(newCase.Description_Temp2__c!=null)
            newCase.Description = '\n Andet produkt : ' + newCase.Description_Temp2__c;
            else
            newCase.Description = '\n Andet produkt: ';   
            
            if(newCase.Description_Temp1__c!=null)
            
            newCase.Description = newCase.Description + '\n Hvilket produkt omhandler reklamationen : ' + newCase.Description_Temp1__c;
            else
            newCase.Description = newCase.Description + '\n Hvilket produkt omhandler reklamationen : ';         
            
            if(newCase.Kundenummer__c!=null)
            newCase.Description = newCase.Description + '\nCustomer Number : ' + newCase.Kundenummer__c;
            else
            newCase.Description = newCase.Description + '\nCustomer Number : ' ;
            
            if(newCase.Description_Temp3__c!=null)
            newCase.Description = newCase.Description + '\n Anden årsag eller nærmere forklaring : ' + newCase.Description_Temp3__c;
            else
            newCase.Description = newCase.Description + '\n Anden årsag eller nærmere forklaring : ';
            
            if(newCase.Description_Temp4__c!=null)
            newCase.Description = newCase.Description + '\n Beskriv pakkens indhold og ydre emballage : ' + newCase.Description_Temp4__c;
            else
            newCase.Description = newCase.Description + '\n Beskriv pakkens indhold og ydre emballage : ';
            
            if(newCase.Foretagsnamn__c!=null)
            newCase.Description = newCase.Description + '\n Customer Name : ' + newCase.Foretagsnamn__c;
            else
            newCase.Description = newCase.Description + '\n Customer Name : ';
            
            if(newCase.Kontaktperson__c!=null)
            newCase.Description = newCase.Description + '\n Contact Name : ' + newCase.Kontaktperson__c;
            else
            newCase.Description = newCase.Description + '\n Contact Name : ';
                                  
            }           
                        
            
            
            if(!KATSutilities.isEmpty(newCase.Webform_customer_input__c)){
                CaseController.setWebformRecordType(newCase);
                CaseController.setWebformValuesFromCdsService(newCase);
            }
            
            CaseController.setTypeShipmentCase(newCase);
            CaseController.setTypeInvoiceCase(newCase);
        }
    }
    
    
    
       
    private static void setWebformRecordType(Case newCase) {
        List<webform_setting__c> wsList = webform_setting__c.getAll().values();
        for(webform_setting__c ws : wsList) {
            if(newCase.Webform_customer_input__c == ws.Customer_input__c) {
                if(KATSutilities.isEmpty(ws.Segment__c)){
                    newCase.recordtypeId = KATSutilities.getRecordType(ws.Record_type__c);
                    return;
                } else if (ws.Segment__c == CaseController.getCustomerSegment(newCase)){
                    newCase.recordtypeId = KATSutilities.getRecordType(ws.Record_type__c);
                    return;
                }
            }
        }
        
        
        // If no webform setting found matching newCase.Webform_customer_input__c, try to set record newCase.type by matching newCase.origin and type.
        for(webform_setting__c ws : wsList) {
            if(newCase.origin == ws.Origin__c && newCase.type == ws.Type__c) {
                newCase.recordtypeId = KATSutilities.getRecordType(ws.Record_type__c);
                return;
            }
        }
    }
    
    private static String getCustomerSegment(Case newCase) {
        if(!KATSutilities.isEmpty(newCase.AccountId)){
            Account a = CaseController.getAccountMap().get(newCase.AccountId);
            if(a != null && !KATSutilities.isEmpty(a.CRMStatus__c)) return 'Logistikk';
        }
        if(!KATSutilities.isEmpty(newCase.SuppliedEmail)){
            for(String s : new List<String>{'@staples.no','@emo.no','@trebuchet.no','@scanflex.no'} ){
                if(newCase.SuppliedEmail.contains(s)) return 'Logistikk';
            }   
        }
        return 'Post';
    }
    
    private static void setWebformValuesFromCdsService(Case newCase) {
        List<CDS_Service__c> serviceList;
        serviceList = [Select c.Id, c.Case_default_type__c, c.Case_default_division__c, c.Code_Event__c From CDS_Service__c c where c.CDS_Service_Group_Name__c = :newCase.Webform_customer_input__c LIMIT 1];
        if(!serviceList.isEmpty()){
            CDS_Service__c service = serviceList.get(0);
            if(!KATSutilities.isEmpty(service.Case_default_type__c)){
                newCase.Type__c = service.Case_default_type__c;
            }
            newCase.Code_Event__c = service.Code_Event__c;  
        }
    }
    
    private static void setTypeShipmentCase(Case newCase) {
        if(!KATSutilities.isEmpty(newCase.RecordTypeId) && (newCase.RecordTypeId == KATSutilities.getRecordType('shipment_case') || newCase.RecordTypeId == KATSutilities.getRecordType('shipment_case_reciever'))){
            if(!KATSutilities.isEmpty(newCase.Shipment_identification__c) || !KATSutilities.isEmpty(newCase.Shipment_number__c)) {
                newCase.Type__c = 'Registrert';
                // newCase.Type__c = 'Registered';
            } else {
                newCase.Type__c = 'Uregistrert';
                //newCase.Type__c = 'Registrert';
                //CSPhase2 Supriya 23122016
            }
        }
    }
    
    private static void setTypeInvoiceCase(Case newCase) {
        if(!KATSutilities.isEmpty(newCase.recordtypeId) && newCase.recordtypeId == KATSutilities.getRecordType('invoice_related_case')){
            if(!KATSutilities.isEmpty(newCase.Invoice_no__c)) {
                newCase.Type__c = 'Registrert';
                //newCase.Type__c = 'Registered';
            } else {
                newCase.Type__c = 'Uregistrert';
                
                //CSPhase2 Supriya 23122016
            }
        }
    }
    
    private static void setAccountIdList(list<Case> cases) {
        if(accountIdList == null) {
            accountIdList = new list<Id>();
        }
        for(Case c : cases) {
            if(c.AccountId == null) continue;
            accountIdList.add(c.accountId);
        }
    }
    
    private static void loadAccounts() {
        accountMap = new map<Id, Account>();
        if(!accountIdList.isEmpty()){
            for(Account acc : [select id, customer_segment__c, isPersonAccount, PersonContactId, recordtypeid, CRMStatus__c, PersonEmail, Phone from Account where id in : accountIdList]) {
                accountMap.put(acc.id, acc);
            }
        }
    }
    
    public static map<Id, Account> getAccountMap() {
        if(accountMap == null) {
            loadAccounts();
        }
        return accountMap;
    }
    
    public static void ResetParameters() {
        accountMap = null;
        if(accountIdList!=null)
            accountIdList.clear();
    }
    
    private static Boolean checkSendToNPScriteria(Case newCase){
        // Should only send case if it is closed and NPS status is blank.
        if(newCase.NPS_Status__c != null && newCase.NPS_Status__c != '') return false;
        if(!newCase.IsClosed) return false;
        //if(newCase.recordTypeId == KATSUtilities.getRecordType('internal_support')) return false;
        return (newCase.Status == 'Avsluttet' || newCase.Status == 'Avsluttet - henvendelse');
        //Csphase2 Supriya 23122016
        // return (newCase.Status == 'Closed' || newCase.Status == 'Closed - inquiry');
        
    }
    
    public static void setFacebookCaseParamsOnInsert(List<Case> newCasesList){  
        List<QueueSobject> socialQueue = new list<QueueSobject>();     
        socialQueue =[Select QueueId from QueueSobject where Queue.DeveloperName ='Sosialekanaler' and SobjectType='Case' limit 1];
        
        if(socialQueue!=null && socialQueue.size()>1)
        {
            for(Case c:newCasesList){
                if(c.Origin == 'Facebook') {    
                    //RecordTypeInfo caseType=Schema.SObjectType.Case.getRecordTypeInfosByName().get('R�dgivning/Informasjon');
                    //CSphase2 supriya 23122016
                    
                    //Commented after NPB release 21-03-2017 and replace with the recordtype id directly instead of fetching RecordTypeInfo 
                    //RecordTypeInfo caseType=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Consulting / Information');
                    
                    c.OwnerId =socialQueue.get(0).queueId;
                    c.RecordTypeId=KATSutilities.getRecordType('simple_inquiry'); 
                }
            }
        }     
        
    }
    
    
    // This function will accept a case and its related Queue Detail record
    // It will set the Default values for Henvendelsestype whenever there is a new Queue allocated to a Case
    // Author: Rohit Paul                    Date: 10-March-2015
    //
    public static void setHenvendelsestypeDefaults(Case c, QueueDetails__c qd)
    {
        if(qd.Code_Event__c != null)
        {
            c.Code_Event__c = qd.Code_Event__c;
            c.Category__c = qd.Code_Event__r.Name;
        }
        
        if(qd.Service_Product__c != null)
        {
            c.Service_Product__c = qd.Service_Product__c;
            c.Produkt__c = qd.Service_Product__r.Name;
        }
        
        if(qd.Code_Reason1__c != null)
        {
            c.Code_Reason1__c = qd.Code_Reason1__c;
            c.reason__c = qd.Code_Reason1__r.Name;
        }
        
        if(qd.Code_Reason2__c != null)
        {
            c.Code_Reason2__c = qd.Code_Reason2__c;
        }
    }
    
    public static void caseAfter(list<Id> idList) 
    {
        List<ID> casesToDummyUpdate = new List<ID>();
        ID defaultbh = Katsutilities.getDefaultBusinessHours();
        List<Case> cases = new List<Case>();
        
        if(idlist.size() > 0) 
        {
            cases = [select accountID, 
                     contactID, 
                     RecordType.DeveloperName, 
                     hidden_queue_id__c, 
                     origin, 
                     owner.email, 
                     owner.type,
                     owner.name,
                     owner.id,
                     Division__c, 
                     Assigned_to_CTI__c, BusinessHoursId
                     from case 
                     where id in :idlist];
        }
        
        Map<ID, QueueDetails__c> qdmap = new Map<ID,QueueDetails__c>();
        for(QueueDetails__c qd: KATSutilities.getQueueDetails().values()) 
        {
            qdmap.put(qd.ownerid, qd);
        }
        
        KATSutilities.removeAccountFromCase(cases);
        List<Case> updatedCase = new List<Case>();
        for(Case c:cases)
        {
            //Adding a check if the Owner is a Queue and different from the previous one
            if(c.Owner.Type == 'Queue' && (c.hidden_queue_id__c != c.OwnerId) && qdmap.containsKey(c.ownerid))
            {
                c.get_Queue_Defaults__c = true;
            }
            
            // We are not going to set defaults at the time of Case creation (insert) from Lightuser
            if(c.Origin.equalsIgnoreCase('lightuser') && String.isEmpty(c.hidden_queue_id__c))
            {
                c.get_Queue_Defaults__c = false;
            }
            
            c.hidden_owner_type__c = c.Owner.Type;
            if(c.Owner.Type=='Queue' && (!qdmap.containsKey(c.ownerid) || (qdmap.containsKey(c.ownerid) && !qdmap.get(c.ownerid).is_inactive_queue__c)))
            {
                c.hidden_queue_id__c = c.OwnerId;
                c.hidden_queue_name__c = c.Owner.Name;
                c.Assigned_to_CTI__c = false;
                
                if(qdmap.containsKey(c.ownerid))
                {
                    QueueDetails__c queueEntitlement = qdmap.get(c.ownerid);
                    
                    // Put the code here to set the 'To_be_Closed__c' checkbox as true, based on Queue Details field 'Auto_Close_Case__c'
                    if(qdmap.get(c.OwnerId).Auto_Close_Case__c == true)
                    {
                        c.To_be_Closed__c = true;
                    }
                    
                    // Checking if we have any Queue Email setup
                    if(!KATSutilities.isEmpty(queueEntitlement.queueEmailAddress__c))
                    {
                        c.hidden_queue_response_email__c = queueEntitlement.queueEmailAddress__c;
                    }
                    if(queueEntitlement.entitlement__c != null)
                    {
                        c.entitlementid = queueEntitlement.entitlement__c;
                        
                        if(c.Origin!='Facebook')
                        {
                            casesToDummyUpdate.add(c.id); }
                    }
                    else
                    {
                        c.entitlementid = null;
                        if(c.Origin!='Facebook')
                        {
                            casesToDummyUpdate.add(c.id);
                        } 
                    }
                    if(queueEntitlement.Business_Hours__c != null)
                    {
                        c.businesshoursid = queueEntitlement.Business_Hours__c;
                    }
                    else
                    {
                        c.businesshoursid = defaultbh;
                    }
                    
                    System.debug(c.Division__c);
                    
                    if(c.Division__c == null)
                    {
                        c.Division__c = queueEntitlement.Default_Division_In_Queue__c;
                    }
                }
                else
                {
                    c.entitlementid = null;
                    c.businesshoursid = defaultbh;
                    if(c.Origin!='Facebook')
                    {
                        casesToDummyUpdate.add(c.id); 
                    }
                }
            }
        }
        
        CaseLogUtils.LogQueue(cases);
        if(cases.size()!=0)
        {
            upsert cases;
        }
        
        if(casesToDummyUpdate.size()!=0 && !system.isFuture())
        {
            KATSutilities.dummyUpdateCase(casesToDummyUpdate);
        }
    }
    
    /*
*   Classes called upon by TriggerDispatcher
*/
    public class CaseController_Before_Insert implements TriggerDispatcher.ITriggerEntry
    {
        public void MainEntry(String TriggerObject,
                              boolean IsBefore, Boolean IsDelete,
                              Boolean IsAfter, Boolean IsInsert,
                              Boolean IsUpdate, Boolean IsExecuting,
                              List<Sobject> newList, Map<Id, SObject> newMap,
                              List<SObject> oldList, Map<ID,SObject> oldMap)
        {
            List<Case> caseNewList = (List<Case>)newList;
            List<Case> caseOldList = (List<Case>)newList;
            Map<Id, Case> caseNewMap = (Map<Id, Case>)newMap;
            Map<Id, Case> caseOldMap = (Map<Id, Case>)oldMap;
            
            System.debug('Case Before Insert '+ newList);                      
        
            List<Case> OEBScaseList = new List<Case>();
            
            for(case c : caseNewList)
            {
                if(c.origin.contains('Epost') || c.origin.contains('Brev') || c.origin.contains('Raw') || c.origin.contains('Web') ) //added this line for incident resolution on 21 mar 19 independent change
                   c.contactid = null;
             }
            
            caseController.setFacebookCaseParamsOnInsert(caseNewList); 
            
            System.debug(LoggingLevel.ERROR,'MS 1 caseNewList:'+caseNewList);
            System.debug(LoggingLevel.ERROR,'MS 1 accountID:'+caseNewList[0].accountid);
            KATSutilities.getContactFromEmail(caseNewList);
            System.debug(LoggingLevel.ERROR,'MS 2 caseNewList:'+caseNewList);
            CaseController.setAccountFromSuppliedPartyNumber(caseNewList);
            CaseController.setAccountIdList(newList);
            CaseController.setCtiDeadline(caseNewList, caseOldMap);
            CaseController.setForwardingAddress(caseNewList, caseOldMap);
            CaseController.setResponsibleSeller(caseNewList, caseOldMap);
            CaseController.copyAccountToContactIfPrivateAccount(caseNewList);
            System.debug(LoggingLevel.ERROR,'MS 3 caseNewList:'+caseNewList);
            
            for(Case newCase : caseNewList)
            {
                CaseController.setUnitToBlameEmailAddress(newCase, null);
                CaseController.setUnitToBlameFromPickupArea(newCase, null);
                CaseController.setSenderAndReviecerBasedOnAccount(newCase, null);
                
                newCase.hashed_URL__c = KATSUtilities.setHashedUrlOnCase(newCase);
                newCase.Last_Status_Change__c = System.now();
                newCase.Time_With_Customer__c = 0;
                newCase.Time_With_Support__c = 0;
                //newCase.view_Backend_Invoices__c = true;//Making this field default true to allow agents to see invoices - CTI Project - Rajeev S 08-10-2017
                
                if(newCase.Origin == 'OEBS') {
                    OEBScaseList.add(newCase);
                }
                
                //Supriya 3april 2017 to resolve the email to case priority issue
                
                if(newCase.Priority== 'Low') {
                    newCase.Priority='Lav';  
                }
                
                CaseController.setWebformParameters(newCase);
            }
            
            if(OEBScaseList.size() > 0) {
                OEBS_OrderController.onInsert(OEBScaseList);
            }
            
            SLA_Controller.setSolutionAndResponse(caseNewList);
            SLA_Controller.CaseBeforeInsertSetSolutionAndResponseSLA(caseNewList);
            System.debug(LoggingLevel.ERROR,'MS 4 caseNewList:'+caseNewList);
        }
        
        public void InProgressEntry(String TriggerObject,
                                    boolean IsBefore, Boolean IsDelete,
                                    Boolean IsAfter, Boolean IsInsert,
                                    Boolean IsUpdate, Boolean IsExecuting,
                                    List<Sobject> newList, Map<Id, SObject> newMap,
                                    List<SObject> oldList, Map<ID,SObject> oldMap)
        {
            return;
        }
    }
    
    public class CaseController_Before_Update implements TriggerDispatcher.ITriggerEntry {
        public void MainEntry(String TriggerObject,
                              boolean IsBefore, Boolean IsDelete,
                              Boolean IsAfter, Boolean IsInsert,
                              Boolean IsUpdate, Boolean IsExecuting,
                              List<Sobject> newList, Map<Id, SObject> newMap,
                              List<SObject> oldList, Map<ID,SObject> oldMap)
        {
            List<Case> caseNewList = (List<Case>)newList;
            List<Case> caseOldList = (List<Case>)newList;
            Map<Id, Case> caseNewMap = (Map<Id, Case>)newMap;
            Map<Id, Case> caseOldMap = (Map<Id, Case>)oldMap;
           
              
              
              /*****commented ****/
            List<Case> OEBScaseList = new List<Case>();            
            System.debug(LoggingLevel.ERROR,'MS 5 caseNewList:'+caseNewList);
            KATSutilities.getContactFromEmail(caseNewList);            
            System.debug(LoggingLevel.ERROR,'MS 6 caseNewList:'+caseNewList);
            CaseController.setAccountIdList(newList);
            CaseController.setCtiDeadline(caseNewList, caseOldMap);
            CaseController.setForwardingAddress(caseNewList, caseOldMap);
            CaseController.setResponsibleSeller(caseNewList, caseOldMap);
            SLA_Controller.CalculateBusinessHoursAges(caseNewList, caseOldMap);
            
            Set<id> CommunitycaseSet= new Set<Id>();
            
            CaseController.copyAccountDetailsToCase(caseNewList, caseOldMap);
            CaseController.copyAccountToContactIfPrivateAccount(caseNewList);
            
             Map<String,List<Case>> caseMap =new Map<String,List<Case>>();
            Map<String,List<Case>> caseParcelMap =new Map<String,List<Case>>();
            List<Case> errorListt=new List<Case>(); 
            //List<Case> errorListt1=new List<Case>(); 
            List<Case> caseId;
            
            for(Case newCase : caseNewList) {
                Case oldCase = caseOldMap.get(newCase.id);
                
                //newCase.view_Backend_Invoices__c = true;//Making this field default true to allow agents to see invoices - CTI Project - Rajeev S 08-10-2017
                
                //Supriya 26th paril for the community assignmente
                
                if(oldCase.category__c != newCase.category__c && newCase.origin=='Community') {
                    CommunitycaseSet.add(newCase.id);
                }  
                
              
                CaseController.setUnitToBlameFromPickupArea(newCase, oldCase);
                CaseController.setUnitToBlameEmailAddress(newCase, caseOldMap.get(newCase.id));
                CaseController.setSenderAndReviecerBasedOnAccount(newCase, caseOldMap.get(newCase.id));
                CaseController.resetCtiOnCase(newCase, caseOldMap.get(newCase.id));
                if(newCase.Origin == 'OEBS') {
                    OEBScaseList.add(newCase);
                }
                
                if(
                    (newCase.IsClosed == true && newCase.IsClosed == oldCase.IsClosed) &&
                    ((newCase.unread_action__c == true && newCase.unread_action__c != oldCase.unread_action__c) ||
                     (newCase.case_new_Comment__c == true && newCase.case_new_Comment__c != oldCase.case_new_Comment__c))
                ) {
                    newCase.Assigned_to_CTI__c = false;
                    newCase.Assigned_to_CTI_Agent__c = true;
                    
                    if(newCase.hidden_owner_type__c != 'Queue' && newCase.hidden_queue_id__c != null && newCase.hidden_queue_id__c != '') {
                        newCase.OwnerId = newCase.hidden_queue_id__c;
                    }
                }
                
                if(newCase.Shipment_identification__c != oldCase.Shipment_identification__c) {
                    newCase.Status_shipment_update__c = 'Not synchronized';
                }  
                
              /*  if (!newCase.Bypass_Duplicate_Check__c && !(newCase.Origin.contains('Mybring') || newCase.Origin.contains('Web')  ||  newCase.Origin.contains('Eksterne systemer') )){
                if(newCase.Shipment_number__c!=null){
                if(caseMap.containsKey(newCase.Shipment_number__c))
                   {
                    caseId= new List<Case>();
                    caseId=caseMap.get(newCase.Shipment_number__c);
                    caseId.add(newCase);
                    caseMap.put(newCase.Shipment_number__c,caseId);
                }
                else{
                    caseId= new List<Case>();
                    caseId.add(newCase);
                    caseMap.put(newCase.Shipment_number__c,caseId);
                    }
                  }
                    //parcel number
                  if(newCase.Shipment_identification__c!=null){
                    if(caseParcelMap.containsKey(newCase.Shipment_identification__c))
                   {
                    caseId= new List<Case>();
                    caseId=caseMap.get(newCase.Shipment_identification__c);
                    caseId.add(newCase);
                    caseParcelMap.put(newCase.Shipment_identification__c,caseId);
                }
                else{
                    caseId= new List<Case>();
                    caseId.add(newCase);
                    caseParcelMap.put(newCase.Shipment_identification__c,caseId);
                    } 
                  }
                  
                  }*/
                  
                
                       
                
            }//end of loop
            
         /*  Map<String,String> ErrorMapshipment = new Map<String,String>();
                Map<String,String> ErrorMap = new Map<String,String>();
            
            for(Case cs:[Select Id,Shipment_number__c,Shipment_identification__c,casenumber From Case Where Shipment_number__c IN:caseMap.keySet() or Shipment_identification__c IN: caseParcelMap.keySet() LIMIT 5]){
               if (!caseNewMap.containsKey(cs.Id)){
                if(caseMap.containsKey(cs.Shipment_number__c)){
                errorListt.addAll(caseMap.get(cs.Shipment_number__c));
                ErrorMapshipment.put(cs.Shipment_number__c ,cs.casenumber);
                }
                 if(caseParcelMap.containsKey(cs.Shipment_identification__c )){
                errorListt.addAll(caseParcelMap.get(cs.Shipment_identification__c ));
                ErrorMap.put(cs.Shipment_identification__c ,cs.casenumber);
                }
            }
            }
             if (errorListt.size()>0){
            for(Case i:errorListt){
               
                if(ErrorMap.get(i.Shipment_identification__c)!=null){i.Shipment_identification__c.addError( 'This is a case with duplicate Parcel Number with cases ' + ErrorMap.get(i.Shipment_identification__c));}
              if(ErrorMapshipment.get(i.Shipment_number__c)!=null){
                i.Shipment_number__c.addError('This is a case with duplicate shipment Number with cases ' + ErrorMapshipment.get(i.Shipment_number__c));} 
                                                     }
                    }*/
            //System.debug('MS 7 caseNewList:'+caseNewList);
            /*  if(CommunitycaseSet.size()>0){
KATSutilities.setCommunityassignmentrule(CommunitycaseSet);

}*/
            System.debug(LoggingLevel.ERROR,'MS 7 caseNewList:'+caseNewList);
        }
        
        public void InProgressEntry(String TriggerObject,
                                    boolean IsBefore, Boolean IsDelete,
                                    Boolean IsAfter, Boolean IsInsert,
                                    Boolean IsUpdate, Boolean IsExecuting,
                                    List<Sobject> newList, Map<Id, SObject> newMap,
                                    List<SObject> oldList, Map<ID,SObject> oldMap)
        {
            return;
        }
    }
    
    public class CaseController_After_Insert implements TriggerDispatcher.ITriggerEntry {
        public void MainEntry(String TriggerObject,
                              boolean IsBefore, Boolean IsDelete,
                              Boolean IsAfter, Boolean IsInsert,
                              Boolean IsUpdate, Boolean IsExecuting,
                              List<Sobject> newList, Map<Id, SObject> newMap,
                              List<SObject> oldList, Map<ID,SObject> oldMap)
        {
            List<Case> caseNewList = (List<Case>)newList;
            List<Case> caseOldList = (List<Case>)newList;
            Map<Id, Case> caseNewMap = (Map<Id, Case>)newMap;
            Map<Id, Case> caseOldMap = (Map<Id, Case>)oldMap;
            
            List<id> postnumbercaseList = new List<id>();
            List<ID> idlist = new List<ID>();
            List<ID> casesToDummyUpdate = new List<ID>();
            
            System.debug(LoggingLevel.ERROR,'MS 8 caseNewList:'+caseNewList);
            
            List<ID> changeAddressCases = new List<ID>();
            List<ID> searchAccountFromShipmentIdCases = new List<ID>(); // kollinummer
            List<ID> searchAccountFromShipmentNumberCases = new List<ID>(); // Sendings/fraktbrevnummer
            List<ID> searchAccountFromInvoiceNumberCases = new List<ID>();
            List<ID> searchAccountFromAddressRefCases = new List<ID>();
            
            List<Case> OEBScaseList = new List<Case>();
            
            system.debug('After insert');
            
            for(Case newCase : caseNewList) {
                if(newCase.Origin == 'OEBS') {
                    OEBScaseList.add(newCase);
                }
                
                
                
                
                if(String.isNotBlank(newCase.change_address_ref_no__c)) {
                    if(newCase.Origin.startsWith('Web')){
                        searchAccountFromAddressRefCases.add(newCase.id);
                    } else {
                        changeAddressCases.add(newCase.id);
                    }
                }
                
                if(newCase.PostNumber__c != null && newCase.Webform_customer_input__c.contains('p:i:flytting_av_postkasse')) {
                    System.debug('');
                    postnumbercaseList.add(newCase.id);
                }
                
                // For all cases with origin Web - If shipment id, shipment number or invoice number is provided, try to search for the related account in back systems.
                if(newCase.Origin!=null && newCase.Origin.startsWith('Web')){
                    if(String.isNotBlank(newCase.Shipment_identification__c) && newCase.RecordTypeId == KATSUtilities.getRecordType('shipment_case')){
                        searchAccountFromShipmentIdCases.add(newCase.id);
                    } else if(String.isNotBlank(newCase.Shipment_number__c) && newCase.RecordTypeId == KATSUtilities.getRecordType('shipment_case')){
                        searchAccountFromShipmentNumberCases.add(newCase.id);
                    } else if(String.isNotBlank(newCase.Invoice_no__c)){
                        searchAccountFromInvoiceNumberCases.add(newCase.id);
                    }
                }
                
                idlist.add(newCase.Id);
                
                //All inserts could potentially result in a case milestone being added. Copying of milestone data to case must happen @future (because case milestones are not added until after this trigger has completed). Therefore all inserts are added to the @future queue
                // not facebook cases
                //casesToDummyUpdate.addAll(trigger.newMap.keySet());
                for(ID i: trigger.newMap.keySet()){
                    //  Case c=(Case)trigger.newMap.get(i);
                    if(((Case)trigger.newMap.get(i)).Origin != 'Facebook'){
                        casesToDummyUpdate.add(i);
                    }               
                }
            }
            
            if(changeAddressCases.size()>0 && !system.isFuture()){
                CaseUtil.maintainPreviousForwardingAddressFuture(changeAddressCases, false);
            }
            
            if(searchAccountFromShipmentIdCases.size()>0 && !system.isFuture()){
                CaseUtil.searchAccountFromShipmentIdFuture(searchAccountFromShipmentIdCases);
            }
            
            if(searchAccountFromShipmentNumberCases.size()>0 && !system.isFuture()){
                CaseUtil.searchAccountFromShipmentNumberFuture(searchAccountFromShipmentNumberCases);
            }
            
            if(searchAccountFromInvoiceNumberCases.size()>0 && !system.isFuture()){
                CaseUtil.searchAccountFromInvoiceNumberFuture(searchAccountFromInvoiceNumberCases);
            }
            
            if(searchAccountFromAddressRefCases.size()>0 && !system.isFuture()){
                CaseUtil.maintainPreviousForwardingAddressFuture(searchAccountFromAddressRefCases, true);
            }
            
            if(idlist.size()>0) {
                CaseController.caseAfter(idlist);
            }
            
            
            //Handles all OEBS cases on update
            OEBS_OrderController.onAfterInsert(OEBScaseList);
            
            //Handle Tasks on Cases
            SLA_Controller.CaseAfterInsertFollowUpTaskMaintainer(caseNewList);
            
            if(postnumbercaseList.size() > 0){
                System.debug('~~~postnumbercaseList::'+postnumbercaseList);
                Helperclass.updateEmailToCase(postnumbercaseList);
            }
            System.debug(LoggingLevel.ERROR,'MS 9 caseNewList:'+caseNewList);
            
            //Queueable job to set custom Omni Channel routing mechanism
            if(IsInsert && !System.IsFuture() && checkRecursive.runOnce())
            System.enqueueJob(new OmniChannelCustomRoutingHandler(caseNewMap));
        }
        
        public void InProgressEntry(String TriggerObject,
                                    boolean IsBefore, Boolean IsDelete,
                                    Boolean IsAfter, Boolean IsInsert,
                                    Boolean IsUpdate, Boolean IsExecuting,
                                    List<Sobject> newList, Map<Id, SObject> newMap,
                                    List<SObject> oldList, Map<ID,SObject> oldMap)
        {
            return;
        }
    }
    
    public class CaseController_After_Update implements TriggerDispatcher.ITriggerEntry {
        public void MainEntry(String TriggerObject,
                              boolean IsBefore, Boolean IsDelete,
                              Boolean IsAfter, Boolean IsInsert,
                              Boolean IsUpdate, Boolean IsExecuting,
                              List<Sobject> newList, Map<Id, SObject> newMap,
                              List<SObject> oldList, Map<ID,SObject> oldMap)
        {
            System.debug('Case After Update');
            List<Case> caseNewList = (List<Case>)newList;
            List<Case> caseOldList = (List<Case>)newList;
            Map<Id, Case> caseNewMap = (Map<Id, Case>)newMap;
            Map<Id, Case> caseOldMap = (Map<Id, Case>)oldMap;
            
            List<ID> idlist = new List<ID>();
            List<ID> casesToDummyUpdate = new List<ID>();
            
            List<ID> closeMilestones = new List<ID>();
            List<ID> openMilestones = new List<ID>();
            
            List<ID> changeAddressCases = new List<ID>();
            
            List<Id> NPScaseList = new List<Id>();
            
            Set<Id> CommunitycaseSet= new Set<Id>();
            
            system.debug('After update');
            
            System.debug(LoggingLevel.ERROR,'MS 10 caseNewList:'+caseNewList);
            
            SLA_Controller.caseAfterUpdateEscalation(caseNewList, caseOldMap);
            CaseController.maintainPrivateAccountDetails(caseNewList, caseOldMap);
            
            CaseLogUtils.LogEventPostalUnit(caseNewList, caseOldMap);
            CaseLogUtils.LogEventUnreadEmail(caseNewList, caseOldMap);
            
            //Queueable job to set custom Omni Channel routing mechanism
            If(IsUpdate && !System.IsFuture() && checkRecursive.runOnce())
            System.enqueueJob(new OmniChannelCustomRoutingHandler(caseNewMap));
            
            for(Case newCase : caseNewList) {
                Case oldCase = caseOldMap.get(newCase.Id);
                
                //Supriya 26th paril for the community assignmente
                
                if(oldCase.category__c != newCase.category__c && newCase.origin=='Community') {
                    CommunitycaseSet.add(newCase.id);
                    
                    
                }//end if if
                
                //All updates involving a change in status, account, or recordtype could result in case milestones being updated. Copying of milestone data to case must happen @future (because case milestones are not added until after this trigger has completed). Therefore changes to any of these fields are added to the @future queue
                if( (newCase.status != oldCase.status || newCase.accountId != oldCase.accountId || newCase.RecordTypeId != oldCase.RecordTypeId)) { 
                    
                    if(newCase.Origin!='Facebook' && !(newCase.status =='Under behandling' && newCase.recordtypeId == KATSutilities.getRecordType('simple_inquiry')) ){    
                        //if(newCase.Origin!='Facebook' && !(newCase.status =='Prosessing' && newCase.recordtypeId == KATSutilities.getRecordType('simple_inquiry')) ){
                        //CSphase2 Supriya 23122016
                        casesToDummyUpdate.add(newCase.id);
                    }
                }
              /*  if (newCase.status != oldCase.status && newCase.status =='Pending other unit'){
                    newCase.Customer_Email_Time__c= datetime.now()+4;
                    System.debug('Inside Pending other Unit'+ newCase.Customer_Email_Time__c);
                    casesToDummyUpdate.add(newCase.id);
                }*/

                if ((newCase.OwnerId != oldCase.OwnerId) || (newCase.Omni_Channel__c)){
                    idlist.add(newCase.Id);
                }
                
                if(newCase.change_address_ref_no__c != oldCase.change_address_ref_no__c) {
                    if(KATSutilities.isEmpty(newCase.change_address_ref_no__c)) {
                        //  newCase.forwardingAddress__c = null;
                    } else {
                        changeAddressCases.add(newCase.id);
                    }
                }
                
                if (newCase.IsClosed == true && newCase.IsClosed != oldCase.IsClosed){
                    closeMilestones.add(newCase.Id);
                }
                if (newCase.IsClosed == false && newCase.IsClosed != oldCase.IsClosed){
                    openMilestones.add(newCase.Id);
                }
                
                if (checkSendToNPScriteria(newCase)){
                    NPScaseList.add(newCase.Id);
                }
                
                if(CommunitycaseSet.size()>0){
                    KATSutilities.setCommunityassignmentrule(CommunitycaseSet);
                    
                }
            }
            
            if(TriggerDispatcher.accToUpdate.size()>0){update TriggerDispatcher.accToUpdate.values();}
            
            SLA_Controller.CaseAfterUpdateFollowUpTaskMaintainer(caseNewList, caseOldMap);
            
            //Run after update
            if(closeMilestones.size()>0){
                KATSutilities.completeAllMilestones(closeMilestones, System.now());
            }
            //Run after update
            if(openMilestones.size()>0){
                KATSutilities.reopenMilestone(openMilestones, 'Løsningsfrist');
            }
            
            if(changeAddressCases.size()>0 && !system.isFuture()){
                CaseUtil.maintainPreviousForwardingAddressFuture(changeAddressCases, false);
            }
            
            if(idlist.size()>0) {
                CaseController.caseAfter(idlist);
            }
            
            if(casesToDummyUpdate.size()!=0 && !system.isFuture()) {
                KATSutilities.dummyUpdateCase(casesToDummyUpdate);
            }
            
            if(NPScaseList.size()>0 && !system.isFuture()) {
                Case_SendToNPS.sendCasesToNPS(NPScaseList);
            }
            
            
            
            System.debug(LoggingLevel.ERROR,'MS 11 caseNewList:'+caseNewList);
        }
        
        
        
        public void InProgressEntry(String TriggerObject,
                                    boolean IsBefore, Boolean IsDelete,
                                    Boolean IsAfter, Boolean IsInsert,
                                    Boolean IsUpdate, Boolean IsExecuting,
                                    List<Sobject> newList, Map<Id, SObject> newMap,
                                    List<SObject> oldList, Map<ID,SObject> oldMap)
        {
            return;
        }
    }
}