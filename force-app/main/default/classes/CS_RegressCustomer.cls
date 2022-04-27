public class CS_RegressCustomer {
@AuraEnabled
 public static String searchDB(String objectName, String fld_API_Text, String fld_API_Val,
  Integer lim, String fld_API_Search, String searchText) {
  
  RecordType[] rtypes = [SELECT Id FROM RecordType Where DeveloperName = 'business_account' And sObjectType = 'Account' Limit 1];
     Id RelationLevelRecordTypeId = null;
     If(rtypes.size() > 0) {
     RelationLevelRecordTypeId = rtypes.get(0).Id;
     }
      
      rtypes = [SELECT Id FROM RecordType Where DeveloperName = 'person_account' And sObjectType = 'Account' Limit 1];
  Id personRecordTypeId=null;
      
      If(rtypes.size() > 0) {
     personRecordTypeId = rtypes.get(0).Id;
     }
      
      
 Set<String> customerStatus = new Set<String>();
 customerStatus.add('I');
 customerStatus.add('Inaktiv');
 customerStatus.add('Inactive');
 customerStatus.add('i');
      
      
  searchText = '\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';
  String query =   'select Id, Name from Account where ( recordtypeid= :relationLevelRecordTypeId or recordtypeid= :personRecordTypeId ) and crm_Customer_Status_Role_3__c not in :customerStatus and Name LIKE ' + searchText + ' order by Name limit ' +  lim;
   System.debug(query);

  List < Account> sobjList = Database.query(query);  
    
  List < ResultWrapper > lstRet = new List < ResultWrapper > ();

  for (Account s: sobjList) {
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