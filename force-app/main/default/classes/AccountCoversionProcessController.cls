public class AccountCoversionProcessController {
    
    @AuraEnabled
    public static Account getAccount(id Accountid) {
        return [select Id, Name,crm_Conv_Customer_Conversion_Group__c,crm_Conv_Total_Revenue__c,Customer_Converted__c,
                crm_Conv_Converison_Heat__c,crm_Conv_Order_Channel__c,Customer_Price_Ready__c,Conversion_Ready__c,Agreement_Proposition_Ready__c,
                crm_Conv_Conversion_Process__c,crm_Conv_Start_Date__c,crm_conv_Conversion_comment__c,crm_customer_converted_date__c,Username__c,Password__c,
                crm_conv_Count_Org_No_in_group__c,crm_conv_Customer_state__c,crm_cov_ListOrg_no_in_group__c,Connected_Agreements__c,List_of_connected_agreements__c,CRM_EDI_API_status__c
                ,API_Status__c
                from Account where id =: Accountid];     
    } 
 
    
    @AuraEnabled
    public static Map<String, String> getConverisonHeat()
    {
        Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult =  Account.crm_Conv_Converison_Heat__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.put(f.getLabel(), f.getValue());
        }  
        
        return options;
    }
    
    @AuraEnabled
    public static Map<String, String> getCustomerStatus()
    {
        Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult =  Account.Customer_Converted__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.put(f.getLabel(), f.getValue());
        }  
        
        return options;
    }
    
     
    @AuraEnabled
    public static Map<String, String> getConvCustomerConversionGroupc()
    {
        Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult =  Account.crm_Conv_Customer_Conversion_Group__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.put(f.getLabel(), f.getValue());
        }  
        
        return options;
    }
    
    @AuraEnabled
    public static Account getAccountRecord(Account Acct) {
        try{
        update Acct;
        return Acct;
        
        }catch(exception e){
            
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Map<String, String> getCoversionProcess()
    {
        Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult =  Account.crm_Conv_Conversion_Process__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.put(f.getLabel(), f.getValue());
        }  
        
        return options;
    }    
    
    @AuraEnabled
    public static boolean getConversionFlag(id Accountid) {
        string CustConvertedvalue ='';
        CustConvertedvalue = [select Id,Customer_Converted__c from Account where id =: Accountid].Customer_Converted__c;
        System.debug('CustConvertedvalue::'+CustConvertedvalue);
        if (CustConvertedvalue == 'Converted'){
            return true;            
        }
        else{
            return false;
        }
        
    }
    
    @AuraEnabled
    public static Map<String, String> getCustomerState()
    {
        Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult =  Account.crm_conv_Customer_state__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.put(f.getLabel(), f.getValue());
        }  
        
        return options;
    }
    
    
    @AuraEnabled
    public static Map<String, String> getConnectedAgreement()
    {
        Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult =  Account.Connected_Agreements__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.put(f.getLabel(), f.getValue());
        }  
        
        return options;
    }
    
    
    @AuraEnabled
     public static boolean getprofilename()
    {
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        system.debug('ProfileName'+profileName);
        Map<string,string> profNameMap = new Map<string,string>();
        // Getting profiles names from custom setting 
        AccountConversionProfileName__c profilenames = AccountConversionProfileName__c.getValues('Profiles');
        string pnames = profilenames.ProfileName__c; 
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
  
    
    
    @AuraEnabled
    public static boolean gethidecomponent(id Accountid)
    {
        string CustConvertedvalue ='';
        CustConvertedvalue = [select Id, Customer_Converted__c from Account where id =: Accountid].Customer_Converted__c;
        
        if (String.isBlank(CustConvertedvalue)){
            return true;            
        }
        else{
            return false;
        }
  
    }

    @AuraEnabled
    public static Map<String, String> getEDIStatus()
    {
        Map<String, String> options = new Map<String, String>();
        for( Schema.PicklistEntry f : Account.crm_EDI_API_status__c.getDescribe().getPicklistValues())
        {
            options.put(f.getLabel(), f.getValue());
        }  
        
        return options;
    }    
    
    @AuraEnabled
    public static Map<String, String> getApiStatus()
    {
        Map<String, String> options = new Map<String, String>();
        for( Schema.PicklistEntry f : Account.API_Status__c.getDescribe().getPicklistValues())
        {
            options.put(f.getLabel(), f.getValue());
        }  
        
        return options;
    }    
    
}