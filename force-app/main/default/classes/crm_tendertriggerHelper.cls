/*
Created By: Supriya Goel
Object  :nderteamrole
Date: 22 August 2017
*/

    public class crm_tendertriggerHelper{

    public static void  calculatevalues (list<crm_Tender__c> TenderList, Map<id,crm_Tender__c> oldMap ){  
    Decimal ConversionRate = [ SELECT ConversionRate FROM CurrencyType WHERE IsCorporate = true ].ConversionRate ;

   Map<String, decimal> currencyMap= new Map<String, decimal>();
    List<CurrencyType> currencyList = [SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE];  
        for (CurrencyType ctype: currencyList ){
            currencyMap.put(ctype.ISOCode, ctype.ConversionRate );
        }
        
     
       
      for (crm_Tender__c tenderobj : TenderList )
      { 
      
        crm_tender__c old= oldMap.get(tenderobj.id);
      
        if(tenderobj.CurrencyISOCode != old.CurrencyISOCode ){
           
           Decimal totalvalue= 0;
           Decimal openvalue=0;
           Decimal Acceptedvalue=0;
            
           totalvalue=  tenderobj.crm_Total_Value__c / currencyMap.get(old.CurrencyISOCode);
           openvalue =tenderobj.crm_Open_Value__c /currencyMap.get(old.CurrencyISOCode);
           Acceptedvalue= tenderobj.crm_Accepted_value__c / currencyMap.get(old.CurrencyISOCode);
      
          
            tenderobj.crm_Accepted_value__c = Acceptedvalue *  currencyMap.get(tenderobj.CurrencyISOCode);
            tenderobj.crm_Total_Value__c = totalvalue  * currencyMap.get(tenderobj.CurrencyISOCode);
            tenderobj.crm_Open_Value__c  = openvalue  *  currencyMap.get(tenderobj.CurrencyISOCode);
        
       
       }
       
      }
    
    
    
    }  
    
     public static void sharerecord(list<crm_Tender__c> TenderList ){  
     Map<Id, Id> TenderOwnerMap = new Map<id, id>();
     for (crm_tender__c tenderobj : TenderList ){
         TenderOwnerMap.put(tenderobj.id, tenderobj.ownerid);
     
     }
     
     System.debug('@@@ successTenderOwnerMap' + TenderOwnerMap);
     
     Map<Id, id> userrolemap= new Map<id, id>();
     List<User> Userlist = [Select id, UserRoleId from User where id in : TenderOwnerMap.values()];
      for (User u : Userlist ){
        userrolemap.put(u.id, u.UserRoleId);
     
     }
     System.debug('@@@ successuserrolemap' + userrolemap);
      Map<Id, String> TenderRoleMap= new Map<id, String>();
      for ( Id tenderid : TenderOwnerMap.keyset()){
         Id role= userrolemap.get(TenderOwnerMap.get(tenderid));
         
         TenderRoleMap.put(tenderid,role);
     
     }
     
      System.debug('@@@ TenderRoleMap' + TenderRoleMap);
     Map<id, Set<Id>> RoleUsermap = new Map<id, Set<Id>>();
     
      Userlist = [Select  id, UserroleId from User where  UserRoleId =: TenderRoleMap.values() ];
     
      for (User u: Userlist ){
                    if (RoleUsermap.containsKey(u.Userroleid)){
                        Set<Id> temp = new Set<id>();
                        temp = RoleUsermap.get(u.Userroleid);
                        temp.add(u.id);
                        RoleUsermap.put(u.Userroleid,temp) ;
                       
                    }
                    else {
                        Set<Id> temp = new Set<id>();
                        temp.add(u.id);
                        RoleUsermap.put(u.Userroleid,temp) ;
                       
                    } 
                   
                }
                
                
                System.debug('@@@ RoleUsermap' + RoleUsermap);
      
     List<crm_Tender__Share> tenderShareList = new List<crm_Tender__Share>();
     
     for (Id tenderid : TenderRoleMap.keyset()){
         id Role= TenderRoleMap.get(tenderid);
         Set <Id> Userset=  RoleUsermap.get(role);
        
        for (Id userid :Userset){
         
         crm_Tender__Share jobShr  = new crm_Tender__Share();
         jobShr.ParentId = tenderid;
         jobShr.UserOrGroupId = userid;
         jobShr.AccessLevel = 'Edit';
         jobShr.RowCause = 'Manual'; 
         tenderShareList.add(jobShr); 
        
         }
         
       }
       
       System.debug('@@@ tenderShareList' + tenderShareList);
       
       List<Database.SaveResult>  srList = Database.insert(tenderShareList,false);
    for( Database.SaveResult sr: srList ){
    
    
    if(sr.isSuccess()){
             // Indicates success
            System.debug('@@@ success');
          }
          else {
             // Get first save result error.
             Database.Error err = sr.getErrors()[0];
             
             // Check if the error is related to trival access level.
             // Access level must be more permissive than the object's default.
             // These sharing records are not required and thus an insert exception is acceptable. 
             if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  
                      err.getMessage().contains('AccessLevel')){
                // Indicates success.
                System.debug('@@@ success1 ');
             }
             else{
                // Indicates failure.
                System.debug('@@@ fail');
             }
           }
    }
         
     
     
     }
     
   }