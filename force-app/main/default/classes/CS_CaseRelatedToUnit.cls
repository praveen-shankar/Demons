public class CS_CaseRelatedToUnit {
@AuraEnabled
 public static String searchDB(String objectName, String fld_API_Text, String fld_API_Val,
  Integer lim, String fld_API_Search, String searchText) {
  
 
  searchText = '\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';
  String query =   'select Id, Name from PostalUnit__c where is_active__c  = true and Name LIKE ' + searchText + ' order by Name limit ' +  lim;
   System.debug(query);

  List < PostalUnit__c > sobjList = Database.query(query);  
    
  List < ResultWrapper > lstRet = new List < ResultWrapper > ();

  for (PostalUnit__c  s: sobjList) {
   ResultWrapper obj = new ResultWrapper();
   obj.text=String.valueOf(s.get('Name'));
   obj.textId= String.valueOf(s.get('Id'));  
  
   lstRet.add(obj);
  }
      
  
      
  return JSON.serialize(lstRet);
    
  }
    
   public class ResultWrapper {
   public String text { get; set;}   
   public String textId { get; set;}   
   
     
    }
}