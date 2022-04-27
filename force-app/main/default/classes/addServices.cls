public with sharing class addServices {
  //delete multiple contact record in LWC
  @AuraEnabled(cacheable=true)
       public static List<Product2> fetchProduct2Record(String tabselectedapi,String searchKey){
    
    //Code for Search Functionality starts here

    List<Product2> conList = new List<Product2>();
    String strgkeyword = '%'+searchKey+'%';
    // string query = 'SELECT Id, Name, AccountNumber, Type  FROM Account WHERE OwnerId=: userId' ; 
    // if(!String.isEmpty(searchKey)){
    //     query += ' AND Name LIKE \'%'+searchKey+'%\';
    // }
    // conList = Database.query(query);
    // return conList;


    //Code for Search Functionality ends here
    
        //  tabselectedapi='abc';
      String filterTabValue=tabselectedapi;
      System.debug('Apex class value of FilterTabValue' + filterTabValue);
    //  console.log('Apex class value of tabselectedapi' + tabselectedapi);
       System.debug('Apex class value of tabselectedapi' + tabselectedapi);
        // String tabselected= '%'+tabselected+'%';
        String TabName=filterTabValue.replace('"','');
        // If(TabName=='All'){
        //   List<Product2> conList = [Select Id, Name,crm_global_Service_Group__c From Product2 where isActive=true and crm_Service_Type__c ='Actual Service' ];      
        //   return conList;    
        // }else{
        //       List<Product2> conList = [Select Id, Name,crm_global_Service_Group__c From Product2 where SF_II_ServiceType__c =TabName ];                          
            
        //       return conList;
        //     }
            if (TabName=='All') {

              //For Search Functionality starts
              String actualService='Actual Service';
               string query = 'Select Id,Name,crm_global_Service_Group__c,Minimum_Price_check__c,Free_PickUp_Check__c,Passive_Return_Check__c,Weight_Interval_From_Check__c,Weight_Interval_To_Check__c,Local_Domestic_Check__c,Conversion_Factor_Check__c,Is_Payer_Receiver_or_Sender_Check__c,Terminals_Check__c,Direction_Terminals_Check__c,Annual_Service_Value_Check__c,Discount_Check__c From Product2 where isActive=true and crm_Service_Type__c =:actualService'; 
              if(!String.isEmpty(searchKey)){
                   query += ' AND Name LIKE \'%'+searchKey+'%\'';
              }
              conList = Database.query(query);
              return conList;
              //For Search Functionality ends




              // List<Product2> conList = [Select Id, Name,crm_global_Service_Group__c,	Minimum_Price_check__c,
              // Free_PickUp_Check__c,Passive_Return_Check__c,Weight_Interval_From_Check__c,Weight_Interval_To_Check__c,Local_Domestic_Check__c,Conversion_Factor_Check__c,Is_Payer_Receiver_or_Sender_Check__c,Terminals_Check__c,Direction_Terminals_Check__c,Annual_Service_Value_Check__c,Discount_Check__c From Product2 where isActive=true and crm_Service_Type__c ='Actual Service' ];      
              // return conList;  
            } else If(TabName!='All') {
               string query ='Select Id, Name,crm_global_Service_Group__c,	Minimum_Price_check__c,Free_PickUp_Check__c,Passive_Return_Check__c,Weight_Interval_From_Check__c,Weight_Interval_To_Check__c,Local_Domestic_Check__c,Conversion_Factor_Check__c,Is_Payer_Receiver_or_Sender_Check__c,Terminals_Check__c,Direction_Terminals_Check__c,Annual_Service_Value_Check__c,Discount_Check__c From Product2 where SF_II_ServiceType__c=:TabName and isActive=true ';
             if(!String.isEmpty(searchKey)){
                query += ' AND Name LIKE \'%'+searchKey+'%\'';
           }
             conList = Database.query(query);
            return conList;

              // List<Product2> conList = [Select Id, Name,crm_global_Service_Group__c,	Minimum_Price_check__c,
              // Free_PickUp_Check__c,Passive_Return_Check__c,Weight_Interval_From_Check__c,Weight_Interval_To_Check__c,Local_Domestic_Check__c,Conversion_Factor_Check__c,Is_Payer_Receiver_or_Sender_Check__c,Terminals_Check__c,Direction_Terminals_Check__c,Annual_Service_Value_Check__c,Discount_Check__c From Product2 where SF_II_ServiceType__c=:TabName and isActive=true];                                      
              // return conList;
            } else {
              return null;
            }
           
           
    
  }




      //   If(filterTabValue=='"All"'){
      //         List<Product2> conList = [Select Id, Name,crm_global_Service_Group__c From Product2 where isActive=true and crm_Service_Type__c ='Actual Service' ];      
      //         return conList;    
      //       }
      //     else If(filterTabValue=='"B2B"') {
      //             List<Product2> conList = [Select Id, Name,crm_global_Service_Group__c From Product2 where SF_II_ServiceType__c ='B2B' ];                          
                
      //             return conList;
      //           }
      //          else If(filterTabValue=='"B2C"'){
      //                 List<Product2> conList = [Select Id, Name,crm_global_Service_Group__c From Product2 where SF_II_ServiceType__c ='B2C' ];    
      //                 return conList;
      //               } 

      //      else if (filterTabValue=='"Product"') {
      //       List<Product2> conList = [Select Id, Name,crm_global_Service_Group__c From Product2 where SF_II_ServiceType__c ='Product' ];
      //       return conList;
      //     }
      //   // List<Product2> conList = [Select Id, Name From Product2 Limit 10 ];
      //   return null;
      // }


      //Experimental Code for Lightning data table Scrolling-->

      public class DataTableWrapper{
        @AuraEnabled
        public String Name;
        @AuraEnabled
        public String crmGlobalServiceGroupC;
        // @AuraEnabled
        // public String empPhone;
        // @AuraEnabled
        // public String empWebsite;
        @AuraEnabled
        public String Id;
    }

    // @AuraEnabled(cacheable=false)
    // public static List<Product2>  imperativeCall(String tabselectedapi,Integer recToReturn){
    //     return fetchProduct2Recordnew(tabselectedapi,recToReturn);
    // }

    // @AuraEnabled(cacheable=true)
    // public static List<Product2>  wireCall(String tabselectedapi,Integer recToReturn){
    //     return fetchProduct2Recordnew(tabselectedapi,recToReturn);
    // }

      // @AuraEnabled(cacheable=false)
  //     private static List<Product2> fetchProduct2Recordnew(String tabselectedapi,Integer recToReturn){
  //    //  tabselectedapi='abc';
  //    String filterTabValue=tabselectedapi;
  //    System.debug('Apex class value of FilterTabValue' + filterTabValue);
  //  //  console.log('Apex class value of tabselectedapi' + tabselectedapi);
  //     System.debug('Apex class value of tabselectedapi' + tabselectedapi);
  //      // String tabselected= '%'+tabselected+'%';
  //      If(filterTabValue=='"All"'){
  //            List<Product2> conList = [Select Id, Name,crm_global_Service_Group__c From Product2 where isActive=true and crm_Service_Type__c ='Actual Service' Limit:recToReturn ];      
  //            return conList;    
  //          }
  //        else If(filterTabValue=='"B2B"') {
  //                List<Product2> conList = [Select Id, Name,crm_global_Service_Group__c From Product2 where SF_II_ServiceType__c ='B2B' Limit:recToReturn ];                          
               
  //                return conList;
  //              }
  //             else If(filterTabValue=='"B2C"'){
  //                    List<Product2> conList = [Select Id, Name,crm_global_Service_Group__c From Product2 where SF_II_ServiceType__c ='B2C' Limit:recToReturn ];    
  //                    return conList;
  //                  } 

  //         else if (filterTabValue=='"Product"') {
  //          List<Product2> conList = [Select Id, Name,crm_global_Service_Group__c From Product2 where SF_II_ServiceType__c ='Product' Limit:recToReturn ];
  //          return conList;
  //        }
  //      // List<Product2> conList = [Select Id, Name From Product2 Limit 10 ];
  //      return null;
  //    }

//Get picklist Values ends
@AuraEnabled(cacheable=true)
     public static List<String> getPickListValuesIntoList(){
      List<String> pickListValuesList= new List<String>();
   Schema.DescribeFieldResult fieldResult = Product2.SF_II_ServiceType__c.getDescribe();
  //  Schema.DescribeFieldResult fieldResult = ObjectApiName.FieldApiName.getDescribe();
  //  Product2.SF_II_ServiceType__c'
   List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
   for( Schema.PicklistEntry pickListVal : ple){
     pickListValuesList.add(pickListVal.getLabel());
   }     
   System.debug('pickListValuesList '+pickListValuesList);
   return pickListValuesList;
   }
//Get picklist Values ends

      //Experimental code for lightning data table Scrolling ends
     
        //  If(tabselected=='All'){
        //     List<Product2> conList = [Select Id, Name From Product2 Limit 10 ];      
        //     return conList;    
        //   }
        //  If(tabselected=='B2B') {
        //     List<Product2> conList = [Select Id, Name From Product2 where SF_II_ServiceType__c ='B2B' ];                          
          
        //     return conList;
        //   }
          
  
        //   If(tabselected=='B2C'){
        //     List<Product2> conList = [Select Id, Name From Product2 where SF_II_ServiceType__c ='B2C' ];    
        //     return conList;
        //   } 
         
        //   If(tabselected=='Product') {
        //     List<Product2> conList = [Select Id, Name From Product2 where SF_II_ServiceType__c ='Product' ];
        //     return conList;
        //   }
      
  
      //  @AuraEnabled
      //  public static List<Product2> deleteMultipleProduct2Record(List<String> conObj){
      //      List<Product2> conObjItem = new   List<Product2>();
      //    List<Product2> conObjList = [Select Id, Name  From Product2 Where Id IN:conObj];
      //    for(Product2 con:conObjList){
      //      conObjItem.add(con);
      //    }
      //    if(conObjItem.size()>0){
      //        try{
      //          delete conObjItem;           
      //        }
      //        catch (Exception exp) {
      //          throw new AuraHandledException(exp.getMessage());
      //      }
      //    }
      //    return fetchProduct2Record();
      //  }
  }