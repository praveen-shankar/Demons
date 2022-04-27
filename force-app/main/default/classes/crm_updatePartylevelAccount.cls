public class crm_updatePartylevelAccount
{
     @InvocableMethod
    public static void UpdateParent(List<Id> accountIds)
    {
        if(System.isBatch()==false)
        {
        String AccountQuery='Select Id,Name,AccountNumber,Party_number__c,crm_Primary_Customer_Account__c,crm_Customer_Number__c,Orga__c,crm_Annual_Sales_Local_Currency__c,crm_CREDITLIMIT__c,crm_Credit_Rating_Code__c,'+
                            'crm_CURRENCYCODE__c,crm_CURRENCYCODEDESCRIPTION__c,crm_Customer_Blocked_Status__c,Phone,crm_Customer_Status_Role_1__c,BillingStreet,BillingCity,BillingState,BillingCountry,BillingPostalCode,'+
                            'crm_Customer_Status_Role_2__c,crm_Customer_Status_Role_3__c,crm_Customer_Status_Role_4__c,crm_Date_for_Credit_Rating__c,'+
                            'crm_Date_updated_external_company_data__c,crm_Domestic_Ultimate_Company_Cntry_Dsc__c,crm_Domestic_Ultimate_Company_Identifier__c,crm_Domestic_Ultimate_Company_Name__c,'+
                            'crm_Domestic_ultimate_National_ID__c,DUNS_number__c,NumberOfEmployees,crm_English_LOB_Code_2_description_NACE2__c, crm_English_LOB_description_NACE__c,'+
                            'crm_Fiscal_Year__c,crm_Global_Ultimate_Company_Identifier__c,crm_Global_Ultimate_Cmpny_Identifier_Owr__c,crm_Global_Ultimate_Country_Description__c,'+
                            'crm_Global_ultimate_National_ID__c,crm_Headquarter_Countrycode__c,crm_Headquarter_Country_Description__c,crm_Headquarter_Identifier_for_ext_comp__c,crm_Headquarter_Name__c,'+
                            'crm_Headquarter_National_ID__c,crm_Internal_Credit_Rating__c,crm_ISO_Countrycode_for_Customer_Company__c,crm_LOB_Code_2_NACE2__c,crm_Local_LOB_Code_2_description_NACE2__c,crm_Local_LOB_description_NACE__c,'+
                            'crm_Organization_number__c,crm_Out_Of_Business_Info_change_desc__c,crm_Out_Of_Busines_Info_Company_Name_for__c,crm_Out_Of_Busines_Info_Company_National__c,crm_Out_Of_Business_Info_Creditrating__c,'+
                            'crm_Out_Of_Busines_Info_DUNSno_for_reltn__c,crm_Out_Of_Business_Info_indicator_flag__c,crm_Out_Of_Business_Info_type_of_change__c,crm_Posten_Source_Comp_for_datarecord_ER__c,crm_Primary_LOB_Code_NACE__c,'+
                            'crm_Reason_for_Customer_Blocking__c,crm_REGISTRYUPDATEDATE__c,Type,crm_Visit_Address_City__c,crm_Visit_Address_Street__c,crm_Visit_Address_Zipcode__c,Website,Parentid,crm_Updated_by_CDH__c from Account where Id in:accountids';
       List<Account> AccountList=Database.query(AccountQuery);
       Map<id,Account> AccountMap=new Map<id,Account>();
       System.debug('@@accountIds'+accountIds);
       for(Account a:AccountList)
       {
           AccountMap.put(a.id,a);
       }
        Set<id> ParentAccountid=new Set<id>();
        for(Account a:AccountMap.values())
        {
            ParentAccountid.add(a.Parentid);
        }
        System.debug('@@ParentAccountid'+ParentAccountid);
        String ParentAccountQuery='Select Id,Name,AccountNumber,Party_number__c,crm_Primary_Customer_Account__c,crm_Customer_Number__c,Orga__c,crm_Annual_Sales_Local_Currency__c,crm_CREDITLIMIT__c,crm_Credit_Rating_Code__c,'+
                            'crm_CURRENCYCODE__c,crm_CURRENCYCODEDESCRIPTION__c,crm_Customer_Blocked_Status__c,Phone,crm_Customer_Status_Role_1__c,BillingStreet,BillingCity,BillingState,BillingCountry,BillingPostalCode,'+
                            'crm_Customer_Status_Role_2__c,crm_Customer_Status_Role_3__c,crm_Customer_Status_Role_4__c,crm_Date_for_Credit_Rating__c,'+
                            'crm_Date_updated_external_company_data__c,crm_Domestic_Ultimate_Company_Cntry_Dsc__c,crm_Domestic_Ultimate_Company_Identifier__c,crm_Domestic_Ultimate_Company_Name__c,'+
                            'crm_Domestic_ultimate_National_ID__c,DUNS_number__c,NumberOfEmployees,crm_English_LOB_Code_2_description_NACE2__c, crm_English_LOB_description_NACE__c,'+
                            'crm_Fiscal_Year__c,crm_Global_Ultimate_Company_Identifier__c,crm_Global_Ultimate_Cmpny_Identifier_Owr__c,crm_Global_Ultimate_Country_Description__c,'+
                            'crm_Global_ultimate_National_ID__c,crm_Headquarter_Countrycode__c,crm_Headquarter_Country_Description__c,crm_Headquarter_Identifier_for_ext_comp__c,crm_Headquarter_Name__c,'+
                            'crm_Headquarter_National_ID__c,crm_Internal_Credit_Rating__c,crm_ISO_Countrycode_for_Customer_Company__c,crm_LOB_Code_2_NACE2__c,crm_Local_LOB_Code_2_description_NACE2__c,crm_Local_LOB_description_NACE__c,'+
                            'crm_Organization_number__c,crm_Out_Of_Business_Info_change_desc__c,crm_Out_Of_Busines_Info_Company_Name_for__c,crm_Out_Of_Busines_Info_Company_National__c,crm_Out_Of_Business_Info_Creditrating__c,'+
                            'crm_Out_Of_Busines_Info_DUNSno_for_reltn__c,crm_Out_Of_Business_Info_indicator_flag__c,crm_Out_Of_Business_Info_type_of_change__c,crm_Posten_Source_Comp_for_datarecord_ER__c,crm_Primary_LOB_Code_NACE__c,'+
                            'crm_Reason_for_Customer_Blocking__c,crm_REGISTRYUPDATEDATE__c,Type,crm_Visit_Address_City__c,crm_Visit_Address_Street__c,crm_Visit_Address_Zipcode__c,Website,Parentid,crm_Updated_by_CDH__c from Account where id in:ParentAccountid';
        
       List<Account> ParentAccountList=Database.query(ParentAccountQuery);
       Map<id,Account> ParentAccountMap=new Map<id,Account>();
       List<Account> UpdateAccount=new List<Account>();
       for(Account a:ParentAccountList)
       {
           ParentAccountMap.put(a.id,a);
       }
       System.debug('@@ParentAccountMap'+ParentAccountMap);
        for(Account a:AccountMap.values())
        {
            if(a.crm_Primary_Customer_Account__c==true)
            {
                Account ParentAccount=ParentAccountMap.get(a.ParentId);
                if(ParentAccount.crm_Updated_By_CDH__c!=true)
                {
                    ParentAccount=MapPrimaryAccountToParty(ParentAccount,a);
                    UpdateAccount.add(ParentAccount);
                }
            }
        }
         System.debug('@@UpdateAccount'+UpdateAccount);
        if(updateAccount.Size()!=0)
        {
            update updateAccount;
        } 
        }        
    }
    
    public static Account MapPrimaryAccountToParty(Account Parent,Account Relation)
    {
            Parent.Name=Relation.Name;
            Parent.AccountNumber=Relation.AccountNumber;
            Parent.BillingStreet=Relation.BillingStreet;
            Parent.BillingCity=Relation.BillingCity;
            Parent.BillingCountry=Relation.BillingCountry;
            Parent.BillingPostalCode=Relation.BillingPostalCode;
            Parent.crm_Annual_Sales_Local_Currency__c=Relation.crm_Annual_Sales_Local_Currency__c;
            Parent.crm_CREDITLIMIT__c=Relation.crm_CREDITLIMIT__c;
            Parent.crm_Credit_Rating_Code__c=Relation.crm_Credit_Rating_Code__c;
            Parent.crm_CURRENCYCODE__c=Relation.crm_CURRENCYCODE__c;
            Parent.crm_CURRENCYCODEDESCRIPTION__c=Relation.crm_CURRENCYCODEDESCRIPTION__c;
            Parent.crm_Customer_Blocked_Status__c=Relation.crm_Customer_Blocked_Status__c;
            Parent.Phone=Relation.Phone;
            Parent.crm_Customer_Status_Role_1__c=Relation.crm_Customer_Status_Role_1__c;
            Parent.crm_Customer_Status_Role_2__c=Relation.crm_Customer_Status_Role_2__c;
            Parent.crm_Customer_Status_Role_3__c=Relation.crm_Customer_Status_Role_3__c;
            Parent.crm_Customer_Status_Role_4__c=Relation.crm_Customer_Status_Role_4__c;
            Parent.crm_Date_for_Credit_Rating__c=Relation.crm_Date_for_Credit_Rating__c;
            Parent.crm_Date_updated_external_company_data__c=Relation.crm_Date_updated_external_company_data__c;
            Parent.crm_Domestic_Ultimate_Company_Cntry_Dsc__c=Relation.crm_Domestic_Ultimate_Company_Cntry_Dsc__c;
            Parent.crm_Domestic_Ultimate_Company_Identifier__c=Relation.crm_Domestic_Ultimate_Company_Identifier__c;
            Parent.crm_Domestic_Ultimate_Company_Name__c=Relation.crm_Domestic_Ultimate_Company_Name__c;
            Parent.crm_Domestic_ultimate_National_ID__c=Relation.crm_Domestic_ultimate_National_ID__c;
            Parent.DUNS_number__c=Relation.DUNS_number__c;
            if(Relation.NumberOfEmployees!=null)
            Parent.NumberOfEmployees=Integer.valueOf(Relation.NumberOfEmployees);
            Parent.crm_English_LOB_Code_2_description_NACE2__c=Relation.crm_English_LOB_Code_2_description_NACE2__c;
            Parent.crm_English_LOB_description_NACE__c=Relation.crm_English_LOB_description_NACE__c;
            Parent.crm_Fiscal_Year__c=Relation.crm_Fiscal_Year__c;
            Parent.crm_Global_Ultimate_Company_Identifier__c=Relation.crm_Global_Ultimate_Company_Identifier__c;
            Parent.crm_Global_Ultimate_Cmpny_Identifier_Owr__c=Relation.crm_Global_Ultimate_Cmpny_Identifier_Owr__c;
            Parent.crm_Global_Ultimate_Country_Description__c=Relation.crm_Global_Ultimate_Country_Description__c;
            Parent.crm_Global_ultimate_National_ID__c=Relation.crm_Global_ultimate_National_ID__c;
            Parent.crm_Headquarter_Countrycode__c=Relation.crm_Headquarter_Countrycode__c;
            Parent.crm_Headquarter_Country_Description__c=Relation.crm_Headquarter_Country_Description__c;
            Parent.crm_Headquarter_Identifier_for_ext_comp__c=Relation.crm_Headquarter_Identifier_for_ext_comp__c;
            Parent.crm_Headquarter_Name__c=Relation.crm_Headquarter_Name__c;
            Parent.crm_Headquarter_National_ID__c=Relation.crm_Headquarter_National_ID__c;
            Parent.crm_Internal_Credit_Rating__c=Relation.crm_Internal_Credit_Rating__c;
            Parent.crm_ISO_Countrycode_for_Customer_Company__c=Relation.crm_Internal_Credit_Rating__c;
            Parent.crm_LOB_Code_2_NACE2__c=Relation.crm_LOB_Code_2_NACE2__c;
            Parent.crm_Local_LOB_Code_2_description_NACE2__c=Relation.crm_Local_LOB_Code_2_description_NACE2__c;
            Parent.crm_Local_LOB_description_NACE__c=Relation.crm_Local_LOB_description_NACE__c;
            Parent.crm_Organization_number__c=Relation.crm_Organization_number__c;
            Parent.Orga__c=Relation.Orga__c;
            Parent.crm_Out_Of_Business_Info_change_desc__c=Relation.crm_Out_Of_Business_Info_change_desc__c;
            Parent.crm_Out_Of_Busines_Info_Company_Name_for__c=Relation.crm_Out_Of_Busines_Info_Company_Name_for__c;
            Parent.crm_Out_Of_Busines_Info_Company_National__c=Relation.crm_Out_Of_Busines_Info_Company_National__c;
            Parent.crm_Out_Of_Business_Info_Creditrating__c=Relation.crm_Out_Of_Business_Info_Creditrating__c;
            Parent.crm_Out_Of_Busines_Info_DUNSno_for_reltn__c=Relation.crm_Out_Of_Busines_Info_DUNSno_for_reltn__c;
            Parent.crm_Out_Of_Business_Info_indicator_flag__c=Relation.crm_Out_Of_Business_Info_indicator_flag__c;
            Parent.crm_Out_Of_Business_Info_type_of_change__c=Relation.crm_Out_Of_Business_Info_type_of_change__c;
            Parent.crm_Posten_Source_Comp_for_datarecord_ER__c=Relation.crm_Posten_Source_Comp_for_datarecord_ER__c;
            Parent.crm_Primary_LOB_Code_NACE__c=Relation.crm_Primary_LOB_Code_NACE__c;
            Parent.crm_Reason_for_Customer_Blocking__c=Relation.crm_Reason_for_Customer_Blocking__c;
            Parent.crm_REGISTRYUPDATEDATE__c=Relation.crm_REGISTRYUPDATEDATE__c;
            Parent.Type=Relation.Type;
            Parent.crm_Visit_Address_City__c=Relation.crm_Visit_Address_City__c;
            Parent.crm_Visit_Address_Street__c=Relation.crm_Visit_Address_Street__c;
            Parent.crm_Visit_Address_Zipcode__c=Relation.crm_Visit_Address_Zipcode__c;
            Parent.Website=Relation.Website;
            return Parent;
    }
}