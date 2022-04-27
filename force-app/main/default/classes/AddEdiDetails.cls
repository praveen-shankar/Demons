public class AddEdiDetails {
    
    @AuraEnabled
    public static List<Edi_Information__c> performAction(String SelectedAccRecords,String CurrentID) {    
        
        list<Account > SelectedAccounts = new list<Account>();
        set<id> AccSet = new set<id>();
        SelectedAccounts = (Account[])JSON.deserialize(SelectedAccRecords, List<Account>.class); 
        system.debug('~~Acc ::'+SelectedAccounts);
        for (Account ac1 : SelectedAccounts ){
            AccSet.add(ac1.id);
        }
        // fetching current EDI record.     
        
        Edi_Information__c  CurrentEdI = new Edi_Information__c();
        CurrentEdI = [SELECT Id, Name, crm_Account__c, Active__c, EDI_Files_Approved__c,EDI_Files_Tested__c,EDI_Identificator__c, E_mail_for_LM_error_notifications__c,End_Date__c,
                      Equipment_Type_Qualifier__c,Expected_Number_of_Shipments_Letters__c,File_Transfer__c,File_Transfer_Detail__c,ID_Domain__c,ID_Format__c,ID_Subscriber__c,Integration_Type__c, Inbound_Message_Type__c, 
                      Kvalificator__c, Labels_Approved__c, LM_Report_Selection__c, Message_Format__c, My_Bring_ID__c,Number_Series_Assigned_By__c,
                      Outbound_Message_Type__c,Party__c,Path__c,Prefix__c,Type__c,Return_Addresses_for_Bulk_Split_Products__c,Serial_Number_Details__c,Serial_Numbers_Assigned__c,Sender_Address_for_Parcels_to_Norway__c,Service_Family__c,Service_Family_Comments__c,
                      Start_Date__c,Status__c, TA_Solution_at_Vendor__c, TA_Vendor__c FROM Edi_Information__c WHERE Id =:CurrentID];
        
        List<Account> RelAcc = [select id,Name from Account where Id in: AccSet];
        list<Edi_Information__c> toInsertEdi = new list<Edi_Information__c>();
        try{
            For(Account Acc1 : RelAcc){
                
                Edi_Information__c newEdi = CurrentEdI.clone(false, true, false, false);
                newEdi.Status__c ='New';
                newEdi.Party__c = null;
                newEdi.crm_Account__c =Acc1.Id;
                newEdi.Copied_From__c = CurrentEdI.Id;
                newEdi.EDI_Files_Approved__c = false;
                newEdi.Labels_Approved__c = false;
                toInsertEdi.add(newEdi);   
            } 
        }catch(exception e) {
            system.debug('~~~~exception::'+e);
            crm_Exception_handler.createExceptionRecords(e);
            throw new AuraHandledException(e.getMessage());
            
            
        }
        // By Passing the duplicate Rule
        if(toInsertEdi.size()>0){
            try{
                Database.DMLOptions dml = new Database.DMLOptions(); 
                dml.DuplicateRuleHeader.allowSave = true;
                //dml.DuplicateRuleHeader.runAsCurrentUser = true;
                Database.SaveResult[] sr = Database.insert(toInsertEdi, dml); 
            }catch(Exception e) {
                system.debug('~~~exception encountered'+e.getMessage());
                crm_Exception_handler.createExceptionRecords(e);
                throw new AuraHandledException(e.getMessage());
                
            } 
        }    
        
        Set<Id> ediIds= new set<Id>();
        if(toInsertEdi.size()>0){
            system.debug('~~~toInsertEdi::'+toInsertEdi.size());  
            for (Edi_Information__c ediObj: toInsertEdi)
                ediIds.add(ediObj.id);
        }    
        List<Edi_Information__c> updateEDIList = new list<Edi_Information__c>();
        updateEDIList=  [Select id,Name,Customer_Number__c,crm_Account__r.Name,EDI_Identificator__c,Kvalificator__c,Id__c from Edi_Information__c where id in :ediIds order by crm_Account__r.Orga__c];
        return updateEDIList;
        
    }
    
    /* wrapper class */  
    public class accountListWrapper {
        @AuraEnabled public boolean isChecked {get;set;}
        @AuraEnabled public  Account objAccount{get;set;}
        public accountListWrapper(boolean isChecked, Account objAccount){
            this.isChecked = isChecked;
            this.objAccount = objAccount;
        } 
    }
    
    public static accountListWrapper parse(String json){
        return (accountListWrapper) System.JSON.deserialize(json, accountListWrapper.class);
    }
    
    //Author : Rajeev Shekhar
    //Date: 09-12-2018
    @AuraEnabled
    public static List<accountListWrapper> getCustomers(String name, String acctType, String orgNo) {
        List<accountListWrapper> accountList = new List<accountListWrapper>();
        Map<String,Schema.RecordTypeInfo> rtMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        String recordtypeId =  rtMap.get('business_account').getRecordTypeId();
        String queryString = 'SELECT Id, Name, crm_Customer_Number__c, Orga__c,crm_Customer_Status_Role_3__c,crm_EDI_Customer__c FROM Account WHERE RecordTypeId = \'' + recordtypeId + '\'';
        if(acctType == 'party' && String.IsNotBlank(name)) {
            queryString += ' AND Parent.Name LIKE \'' + '%' + String.escapeSingleQuotes(name.trim()) + '%' + '\'';
        }    
        if(acctType == 'relation' && String.IsNotBlank(name)) {
            queryString += ' AND crm_Customer_Number__c = \'' + String.escapeSingleQuotes(name.trim()) + '\'';
        }    
        if(String.IsNotBlank(orgNo)) {
            queryString += ' AND Orga__c = \'' + String.escapeSingleQuotes(orgNo.trim()) + '\'';
        }   
        queryString += ' Order by Orga__c NULLS LAST LIMIT 1000';    
        System.debug('Query String' + queryString);
        
        for(Account ac : Database.Query(queryString)) {
            accountList.add(new accountListWrapper(false,ac));
        }
        
       return accountList; 
    }   
    
    
    @AuraEnabled
    public static boolean getprofilename() {
        Id profileId = Userinfo.getProfileId();
        String profileName = [Select Id,Name from Profile where Id=:profileId].Name;
        Map<string,string> profNameMap = new Map<string,string>();
        // Getting profiles names from custom setting 
        environment_settings__c profilenames = environment_settings__c.getValues('EDI_ReplicationTabVisibilty');
        string pnames = profilenames.value__c; 
        for(string st : pnames.split(',')){
            profNameMap.put(st, st);         
        }
        if(profNameMap.get(profileName)!=null){
            return true;
        }
        else{            
            return false;
        }
    }    
}