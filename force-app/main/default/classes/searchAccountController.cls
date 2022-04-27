public with sharing class searchAccountController {
 
 @AuraEnabled
    
 public static List < account > fetchAccount(String Name) {
     
    
      string partyRecordtype = 'Party level Customer';
    string prospectRecordtype = 'Prospect';
      string searchquery='';
      if (String.isNotBlank(Name)  || String.isNotEmpty(Name) )
                   { 
    
   searchquery = 'select Name, recordtype.Name, Orga__c,crm_bus_addr_City__c,crm_bus_addr_Country__c, crm_bus_addr_Street__c, crm_bus_addr_Zip_Code__c, BillingStreet, BillingCity, BillingState, BillingPostalCode,  BillingCountry, crm_Company_Group_Name__c ,convertCurrency(crm_Revenue_Last_Year__c),convertCurrency(crm_Revenue_This_Year__c), crm_Count_of_Relation_level_Accounts__c from account where (name != null) and (recordtype.Name=:partyRecordtype or  recordtype.Name=:ProspectRecordtype )';
     //customer name check
     // String nameStr=Name.deleteWhitespace();
  
    searchquery  += ' and( name LIKE   \'%' +String.escapeSingleQuotes(Name)+ '%\''; 
    searchquery += ' or Orga__c  LIKE  \'%'  +String.escapeSingleQuotes(Name)+ '%\'' ;
                       //or Orga__c  LIKE  \'%'  +String.escapeSingleQuotes(nameStr)+ '%\')' ;
    searchquery  += ' or crm_Company_Group_Name__c LIKE   \'%' +String.escapeSingleQuotes(Name)+ '%\')';  
    searchquery += ' ORDER BY crm_Revenue_This_Year__c DESC NULLS LAST LIMIT 10000';    
                       System.debug('@@searchquery '+ searchquery );     
     
                  }else{
                    searchquery = 'select name, recordtype.Name, Orga__c,crm_bus_addr_City__c,crm_bus_addr_Country__c, crm_bus_addr_Street__c, crm_bus_addr_Zip_Code__c, BillingStreet, BillingCity, BillingState, BillingPostalCode,  BillingCountry, crm_Company_Group_Name__c ,convertCurrency(crm_Revenue_Last_Year__c),convertCurrency(crm_Revenue_This_Year__c), crm_Count_of_Relation_level_Accounts__c from account where name != null and (recordtype.Name=:partyRecordtype OR recordtype.Name=:ProspectRecordtype) limit 0';   
                      
                  }
        
        
        
            
      
  List < Account > returnList = new List < Account > ();
  List < Account > lstOfAccount = Database.query(searchquery);
      
  //    [select name, recordtype.Name, Orga__c,crm_bus_addr_City__c,crm_bus_addr_Country__c, crm_bus_addr_Street__c, crm_bus_addr_Zip_Code__c, BillingStreet, BillingCity, BillingState, BillingPostalCode,  BillingCountry, crm_Company_Group_Name__c ,convertCurrency(crm_Revenue_Last_Year__c),convertCurrency(crm_Revenue_This_Year__c), crm_Count_of_Relation_level_Accounts__c from account where Name LIKE: CustomernameKey AND  orga__c LIKE :organoKey];
 
  for (Account acc: lstOfAccount) {
      
 	 returnList.add(acc);
  }
  return returnList;
 }
}