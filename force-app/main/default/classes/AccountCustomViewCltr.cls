public class AccountCustomViewCltr {
    
    private static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {
        
        Set<ID> currentRoleIds = new Set<ID>();
        
        // get all of the roles underneath the passed roles
        for(UserRole userRole :[select Id, name from UserRole where ParentRoleId 
                                IN :roleIds AND ParentRoleID != null]){
                                    
                                    currentRoleIds.add(userRole.Id);
                                }
        
        // go fetch some more rolls!
        // if(currentRoleIds.size() > 0)
        // currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
        
        return currentRoleIds;
        
    }
    
    
    @AuraEnabled
    public static List<Account> getAllAccounts() {
    
     
    Id RelationRecordTypeId;
    Id PartyRecordTypeId;
    Id ProspectRecordTypeId;
    Set<Id> SegmentIds=new Set<id>();
    Set<Id> AccountIds=new Set<id>();
        Id loggdInUserId=UserInfo.getUserId();
        
       
    
        crm_AccountRecordTypes__c Party= crm_AccountRecordTypes__c.getValues('Party level Customer');
       // PartyRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(Party.crm_Record_Type_Label__c).getRecordTypeId();
       PartyRecordTypeId= [SELECT id from RecordType where Name ='Party level Customer'].Id;
        crm_AccountRecordTypes__c Relation= crm_AccountRecordTypes__c.getValues('Relation level Customer');
       // RelationRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(Relation.crm_Record_Type_Label__c).getRecordTypeId();
       RelationRecordTypeId= [SELECT id from RecordType where Name ='Relation level Customer'].Id;
       
       ProspectRecordTypeId= [SELECT id from RecordType where Name ='Prospect' and sobjectType = 'Account'].Id;
        
        //Get all users below in the role heirarchy
        
        Id roleId = [select UserRoleId from User where Id = :loggdInUserId].UserRoleId;
        // get all of the roles underneath the user
        Set<Id> allSubRoleIds = getAllSubRoleIds(new Set<ID>{roleId});
        
        // get all of the ids for the users in those roles
        List<User> users = new List<User>([Select Id, Name From User where   UserRoleId IN :allSubRoleIds]);
        Set <Id> allUsers= new Set<Id>();
        for (User u : users){
            allusers.add(u.id);   
            
        }
        allusers.add(loggdInUserId);
        
        List<crm_segment__c> segmentList=  [Select id, crm_Sales_Responsible__c , crm_account__c, crm_account__r.recordtypeid  from crm_segment__c  where crm_Sales_Responsible__c in :allusers and crm_account__r.recordtypeid=:PartyRecordTypeId];
        for (crm_segment__c seg: segmentList ){
            SegmentIds.add(seg.crm_account__c);
            
        }
        
        segmentList=  [Select id, crm_Sales_Responsible__c , crm_account__c, crm_account__r.parentid, crm_account__r.recordtypeid  from crm_segment__c  where crm_Sales_Responsible__c in :allusers and crm_account__r.recordtypeid=:RelationRecordTypeId];
        for (crm_segment__c seg: segmentList ){
            SegmentIds.add(seg.crm_account__r.parentid);
        }
        
        List<Account> AccountList = [Select id,name, recordtype.Name, Orga__c,crm_bus_addr_City__c, crm_bus_addr_Country__c, crm_bus_addr_Street__c, crm_bus_addr_Zip_Code__c, BillingStreet, BillingCity, BillingState, BillingPostalCode,  BillingCountry, crm_Company_Group_Name__c ,crm_Revenue_Last_Year__c,crm_Revenue_This_Year__c, crm_Count_of_Relation_level_Accounts__c,crm_e_commerce_KAM__c, crm_Group_KAM__c from Account where ((id in :SegmentIds or crm_e_commerce_KAM__c in :allusers or crm_Group_KAM__c in :allusers ) and recordtypeid=:PartyRecordTypeId)  OR  (recordtypeid= :ProspectRecordTypeId AND ownerid = :loggdInUserId) order by name asc];
        for (Account a: AccountList){
            AccountIds.add(a.id) ;
        }

        
        return AccountList;
    }
    
    
    
}