public class AccountConversionCustomViewCltr 
{
    
    private static Set<ID> getAllSubRoleIds(Set<ID> roleIds) 
    {
        
        Set<ID> currentRoleIds = new Set<ID>();
        
        // get all of the roles underneath the passed roles
        for(UserRole userRole :[select Id, name from UserRole where ParentRoleId 
                                IN :roleIds AND ParentRoleID != null])
        {
            currentRoleIds.add(userRole.Id);
        }
        
        // go fetch some more rolls!
        // if(currentRoleIds.size() > 0)
        // currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
        
        return currentRoleIds;
        
    }
    
    
    @AuraEnabled
    public static List<Account> getAllAccounts() 
    {
        
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
        
        ProspectRecordTypeId= [SELECT id from RecordType where Name ='Prospect' and SobjectType = 'Account'].Id;
        
        //Get all users below in the role heirarchy
        
        Id roleId = [select UserRoleId from User where Id = :loggdInUserId].UserRoleId;
        // get all of the roles underneath the user
        Set<Id> allSubRoleIds = getAllSubRoleIds(new Set<ID>{roleId});
        
        // get all of the ids for the users in those roles
        List<User> users = new List<User>([Select Id, Name From User where   UserRoleId IN :allSubRoleIds]);
        Set <Id> allUsers= new Set<Id>();
        for (User u : users){
          if(!u.name.contains('Kanal'))
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
        
        String strfilter1 ='Business Delivery';
        
        String strfilter2 ='Delivery to Consumer';
        
        List<Account> AccountList = [Select id,name,(select Id,crm_Service_Group__c,crm_Sales_Responsible__r.Name,crm_Sales_Responsible__c  from  Divisions3__r where crm_Service_Group__c =:strfilter1 or crm_Service_Group__c =:strfilter2 limit 1),recordtype.Name, Owner.Name, Orga__c,crm_e_commerce_KAM__c, crm_Group_KAM__c,crm_Conv_Customer_Conversion_Group__c,crm_Conv_Total_Revenue__c,crm_Conv_Converison_Heat__c,crm_Conv_Order_Channel__c,crm_Conv_Start_Date__c,crm_conv_Conversion_comment__c,crm_conv_Count_Org_No_in_group__c,crm_conv_Customer_state__c,crm_cov_ListOrg_no_in_group__c,toLabel(Customer_Converted__c),crm_Conv_Conversion_Process__c,Customer_Price_Ready__c,Conversion_Ready__c,Agreement_Proposition_Ready__c from Account where ((id in :SegmentIds or crm_e_commerce_KAM__c in :allusers or crm_Group_KAM__c in :allusers ) and recordtypeid=:PartyRecordTypeId and Customer_Converted__c!=null) order by name asc];        
        for (Account a: AccountList){
            AccountIds.add(a.id) ;
        }
        System.debug(AccountList);
        
        return AccountList;
    }
    
     //Added By Sakshi For Search     
    @AuraEnabled
    public static List<Account> fetchAccount(String searchKeyword, String selectKeyword, Date dateSearchKeyword, String conversionHeatSearchKeyword, String convertedSearchKeyword, Boolean customerPriceSearchKeyword, Boolean agreementPropositionSearchKeyword , Boolean conversionReadySearchKeyword)
    {
        
         String strfilter1 ='Business Delivery';
        
        String strfilter2 ='Delivery to Consumer';
        system.debug('Inside Fetch Account Date ');
        String searchKey = '';
        if (!String.isBlank(searchKeyword ))
        {
            searchKey=  '%'  + searchKeyword + '%';
        }
        
        String selectSearchKey =  '';
        if (!String.isBlank(selectKeyword ))
        {
            selectSearchKey    = selectKeyword;
        }
        
        System.debug(dateSearchKeyword);
        Date dateSearchKey = null;             
        if (dateSearchKeyword !=null)
        {
            dateSearchKey = dateSearchKeyword;
        }
        
        System.debug('@@dateSearchKey' + dateSearchKey);
        
        String conversionHeatSearchKey = '';
        if (!String.isBlank(conversionHeatSearchKeyword ))
        {
            conversionHeatSearchKey  = conversionHeatSearchKeyword;
        }
        
        String convertedSearchKey = '';        
        if (!String.isBlank(convertedSearchKeyword ))
        {
            convertedSearchKey = convertedSearchKeyword;
        }
        
        Boolean  customerPriceSearchKey = null;
        if(customerPriceSearchKeyword!= null)
        {
            customerPriceSearchKey = customerPriceSearchKeyword; 
        }
        
        Boolean agreementPropositionSearchKey = null; 
        if(agreementPropositionSearchKeyword != null)
        {
            agreementPropositionSearchKey = agreementPropositionSearchKeyword; 
        }
        
        Boolean conversionReadySearchKey = null; 
        if(conversionReadySearchKeyword!=null)
        {
            conversionReadySearchKey = conversionReadySearchKeyword; 
        }
        
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
        
        ProspectRecordTypeId= [SELECT id from RecordType where Name ='Prospect' and SobjectType = 'Account'].Id;
        
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
        
        
       
        System.debug('Search Key: ' + searchKey + 'selectSearchKey aaa '+selectSearchKey   );
        String query ='SELECT ID, Name, (select Id,crm_Service_Group__c,crm_Sales_Responsible__r.Name,crm_Sales_Responsible__c  from  Divisions3__r where crm_Service_Group__c =:strfilter1 or crm_Service_Group__c =:strfilter2 limit 1), Owner.Name,crm_Conv_Conversion_Process__c, crm_Conv_Start_Date__c, crm_Conv_Converison_Heat__c, toLabel(Customer_Converted__c),Customer_Price_Ready__c, Agreement_Proposition_Ready__c, Conversion_Ready__c FROM Account where ((id in :SegmentIds or crm_e_commerce_KAM__c in :allusers or crm_Group_KAM__c in :allusers ) and recordtypeid=:PartyRecordTypeId and Customer_Converted__c != null   ';
        
        if (!String.isBlank(searchKey))
        {
            query+= ' AND Name LIKE :searchKey  ';            
        }
        
        if (!String.isBlank(selectSearchKey ))
        {
            query+= '  AND crm_Conv_Conversion_Process__c =:selectSearchKey ';
        }
        
        if (dateSearchKey !=null)
        {
            query+= '  AND crm_Conv_Start_Date__c  =  :dateSearchKey ';
        }
        
        if (!String.isBlank(conversionHeatSearchKey  ))
        {
            query+= '  AND crm_Conv_Converison_Heat__c = :conversionHeatSearchKey  ';
        }
        
        if (!String.isBlank(convertedSearchKey))
        {
            query+= '  AND Customer_Converted__c  = :convertedSearchKey';
        }
        
        if(customerPriceSearchKey != null)
        {
            query+= ' AND Customer_Price_Ready__c =: customerPriceSearchKey';
        }
        
        if(agreementPropositionSearchKey != null)
        {
            query+= ' AND Agreement_Proposition_Ready__c =: agreementPropositionSearchKey'; 
        }
        
        if(conversionReadySearchKey != null)
        {
            query+= ' AND Conversion_Ready__c  =: conversionReadySearchKey'; 
        }
       
        query+= ' )';
        
        System.debug('query '+query);        
        return database.query(query);
        
    }
            
    //Added By Sakshi For Search     
    /*@AuraEnabled
    public static List<Account> fetchAccount111(String searchKeyword , String selectKeyword , Date dateSearchKeyword , String conversionHeatSearchKeyword , String convertedSearchKeyword , Boolean customerPriceSearchKeyword , Boolean agreementPropositionSearchKeyword , Boolean conversionReadySearchKeyword)
    {
        system.debug('Inside Fetch Account Date ');
        String searchKey = '';
        if (!String.isBlank(searchKeyword ))
        {
            searchKey=  '%'  + searchKeyword + '%';
        }
        
        String selectSearchKey =  '';
        if (!String.isBlank(selectKeyword ))
        {
            selectSearchKey    = selectKeyword;
        }
        
        
        String conversionHeatSearchKey = '';
        if (!String.isBlank(conversionHeatSearchKeyword ))
        {
            conversionHeatSearchKey  = conversionHeatSearchKeyword;
        }
        
        String convertedSearchKey = '';        
        if (!String.isBlank(convertedSearchKeyword ))
        {
            convertedSearchKey = convertedSearchKeyword;
        }
        
        Date dateSearchKey =null;             
        if (dateSearchKeyword !=null)
        {
            dateSearchKey = dateSearchKeyword;
        }
        
        Boolean  customerPriceSearchKey = null;
        if(customerPriceSearchKey != null)
        {
            customerPriceSearchKey = customerPriceSearchKeyword; 
        }
        
        Boolean agreementPropositionSearchKey = null; 
        if(agreementPropositionSearchKey != null)
        {
            agreementPropositionSearchKey = agreementPropositionSearchKeyword; 
        }
        
        Boolean conversionReadySearchKey = null; 
        if(conversionReadySearchKey !=null)
        {
            conversionReadySearchKey = conversionReadySearchKeyword; 
        }
        
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
        
        ProspectRecordTypeId= [SELECT id from RecordType where Name ='Prospect'].Id;
        
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
        
        
        System.debug('Search Key: ' + searchKey+'   selectSearchKey '+selectSearchKey+' conversionHeatSearchKey '+conversionHeatSearchKey+' convertedSearchKey  '+convertedSearchKey);
        String query ='SELECT ID, Name, crm_Conv_Conversion_Process__c, crm_Conv_Start_Date__c, crm_Conv_Converison_Heat__c, Customer_Converted__c,Customer_Price_Ready__c, Agreement_Proposition_Ready__c, Conversion_Ready__c FROM Account where ((id in '+SegmentIds+ ' or crm_e_commerce_KAM__c in '+allusers+' or crm_Group_KAM__c in '+allusers+ ') and recordtypeid = \''+PartyRecordTypeId+ '\' and Customer_Converted__c! = null   ';
        
        if (!String.isBlank(searchKey))
        {
            query+= ' AND Name LIKE :searchKey  ';            
        }
        
        if (!String.isBlank(selectSearchKey ))
        {
            query+= '  AND crm_Conv_Conversion_Process__c =:selectSearchKey ';
        }
        
        if (!String.isBlank(convertedSearchKey))
        {
            query+= '  AND Customer_Converted__c  = :convertedSearchKey';
        }
        
        if (!String.isBlank(conversionHeatSearchKey  ))
        {
            query+= '  AND crm_Conv_Converison_Heat__c = :conversionHeatSearchKey  ';
        }
        
        if (dateSearchKey !=null)
        {
            query+= '  AND crm_Conv_Start_Date__c  =  :dateSearchKey ';
        }
        
        if(customerPriceSearchKey != null)
        {
            query+= 'AND Customer_Price_Ready__c =: customerPriceSearchKey';
        }
        
        if(agreementPropositionSearchKey != null)
        {
            query+= 'AND Agreement_Proposition_Ready__c =: agreementPropositionSearchKey'; 
        }
        
        if(conversionReadySearchKey != null)
        {
            query+= 'AND Conversion_Ready__c  =: conversionReadySearchKey'; 
        }
        
        query+= ' )';
        
        System.debug('query '+query);        
        return database.query(query);
        
    }*/
    
    @AuraEnabled 
    public static Map<String, String> getConversionProcessPicklist()
    {
        Map<String, String> optionMap = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult =  Account.crm_Conv_Conversion_Process__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntryList = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry objPicklist : picklistEntryList)
        {
            optionMap.put(objPicklist.getLabel(), objPicklist.getValue());
        }  
        
        return optionMap;
    }
    
    @AuraEnabled 
    public static Map<String, String> getConversionHeatPicklist()
    {
        Map<String, String> optionMap = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult =  Account.crm_Conv_Converison_Heat__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntryList = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry objPicklist : picklistEntryList)
        {
            optionMap.put(objPicklist.getLabel(), objPicklist.getValue());
        }  
        
        return optionMap;
    }
    
    @AuraEnabled 
    public static Map<String, String> getConvertedCustomerPicklist()
    {
        Map<String, String> optionMap = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult =  Account.Customer_Converted__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntryList = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry objPicklist : picklistEntryList)
        {
            optionMap.put(objPicklist.getValue(), objPicklist.getLabel());
        }  
        
        return optionMap;
    }
    
}