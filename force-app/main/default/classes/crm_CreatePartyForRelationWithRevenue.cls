global class crm_CreatePartyForRelationWithRevenue implements Database.batchable<sObject>,Database.Stateful
{
    crm_AccountRecordTypes__c rTRelation= crm_AccountRecordTypes__c.getValues('Relation level Customer');
    Id RelationLevelRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTRelation.crm_Record_Type_Label__c).getRecordTypeId();
    
    crm_AccountRecordTypes__c rTParty= crm_AccountRecordTypes__c.getValues('Party level Customer');
    Id PartyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTParty.crm_Record_Type_Label__c).getRecordTypeId();
     
         
     public string callback = ''; 
     
      global crm_CreatePartyForRelationWithRevenue (string callback){
         this.callback = callback;
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
      
        string query='Select id,name, parentid,Orga__c,crm_Customer_Number__c,crm_Count_of_Relation_level_Accounts__c, crm_Primary_Customer_Account__c,createdbyid,crm_Revenue_This_Year__c,crm_bus_addr_City__c , crm_bus_addr_Country__c,crm_bus_addr_Street__c, crm_bus_addr_Zip_Code__c from Account where Orga__c!=null and parentid=null and Account.RecordTypeid=:RelationLevelRecordTypeId';
       
        return Database.getQueryLocator(query);  
           
    } 
    
    
    
    global void execute(Database.BatchableContext BC, List<Account> AccountList)  {
        System.debug('~~AccountList'+AccountList);
        list<crm_Revenue_Line__c> renuenueLinelist = new list<crm_Revenue_Line__c> ();
        list<Account> accountstoUpdate= new list<Account> ();
        Set<String> orgaSet = new Set<String>();        
         Map<string,Account> RelationAccountMap=new Map<string,Account>();
         Set<Id> relationids = new Set<Id> ();
        for (Account acc:AccountList ){            
                relationids.add(acc.id) ; 
              //  RelationAccountMap.put(acc.crm_Customer_Number__c,acc);
        }
        
            if(relationids.size()>0) {
              renuenueLinelist = [Select id,crm_Account__c,crm_Account__r.Orga__c,crm_Account__r.Name,crm_Account__r.crm_Customer_Number__c from crm_Revenue_Line__c where crm_Account__c in : relationids];  
            }
            
           Map<String, List<Account>>  custRelationAccountmap = new  Map<String, List<Account>>();
           
           if(renuenueLinelist!=null && renuenueLinelist.size()>0)
           { 
           
         for (crm_Revenue_Line__c rev:renuenueLinelist)
         { 
             orgaSet.add(rev.crm_account__r.orga__c);
         
         } 
         List<Account> allRelationAccounts=[Select id,name, parentid,Orga__c,crm_Customer_Number__c,crm_Count_of_Relation_level_Accounts__c, crm_Primary_Customer_Account__c,createdbyid,crm_Revenue_This_Year__c,crm_bus_addr_City__c , crm_bus_addr_Country__c,crm_bus_addr_Street__c, crm_bus_addr_Zip_Code__c from Account where Orga__c in :OrgaSet  and Account.RecordTypeid=:RelationLevelRecordTypeId order by createddate asc]; 
           
           for (Account a: allRelationAccounts) {
            
                  if(custRelationAccountmap.containskey(a.Orga__c))
                  {
                  List<Account> temprelAccounts= new List<Account>();
                  
                  temprelAccounts = custRelationAccountmap.get(a.Orga__c);
                  temprelAccounts.add(a);
                  custRelationAccountmap.put(a.Orga__c,temprelAccounts);
                  }
                  
                  else
                  {
                  List<Account> temprelAccounts= new List<Account>();
                  temprelAccounts.add(a);
                  custRelationAccountmap.put(a.Orga__c,temprelAccounts); 
                  
                  }
                  
             }
          
         
           } //end of rev size
           System.debug('##custRelationAccountmap' +  custRelationAccountmap);
           
           Map<String, Account> RelationPartyAccountMap = new Map<String, Account>();
           
         for (String orgno: custRelationAccountmap.keyset()){
         
         List<Account> relationaccounts= custRelationAccountmap.get(orgno);
          Boolean checkprimary= false;
          Decimal highestRevenuethisyear = relationaccounts[0].crm_Revenue_This_Year__c;
          Id primaryRelationId=relationaccounts[0].id ;
          
          for(Account a: relationaccounts){
          
              if(a.crm_Primary_Customer_Account__c  == true) {
                     
                  checkprimary=true; 
                  RelationPartyAccountMap.put(a.orga__c, a);    
                  break;
                   
                   
              }
              
             
          }
          if(checkprimary == false){
           for(Account a: relationaccounts){
              
                 if(a.crm_customer_number__c.isNumeric()){
                          
                                checkprimary=true;
                                RelationPartyAccountMap.put(a.orga__c, a);
                                                              
                                break;
                                
                        } //end of if
                                        
                   
                  
                   
               }//end of for
               
          }//end of checkprimary if
         
            if(!checkprimary) {//setprimarynow 
            Boolean ishighest = false;
               for(Account a: relationaccounts){          
                                      
                            if(a.crm_Revenue_This_Year__c > highestRevenuethisyear ){   
                                primaryRelationId=a.id;
                                highestRevenuethisyear= a.crm_Revenue_This_Year__c;
                                ishighest=true;
                                RelationPartyAccountMap.put(a.orga__c, a);
                                
                                }
                                
                        }
                        
                        if(!ishighest)
                        
                            RelationPartyAccountMap.put(orgno, relationaccounts[0]);   
            }//check primary false    
            
            checkprimary= false;       
             
          }//end of loop
           System.debug('##RelationPartyAccountMap' +  RelationPartyAccountMap);
          
          List<Account> AcntList = new List<Account>();
          
           for (String orgno: custRelationAccountmap.keyset()){
            
            Account party= new Account();
            if(RelationPartyAccountMap.containskey(orgno)){
                Account primaryrelationAccount= RelationPartyAccountMap.get(orgno);
                party=primaryrelationAccount.clone(false, true);
                party.crm_Customer_Number__c='';
                insert party;
                party.recordtypeid = PartyRecordTypeId ;
                party.crm_Primary_Customer_Account__c=false;
                party.crm_Revenue_This_Year__c=null;
                update party;
                
                Account a1 = new Account(); //relation 
                a1.id=primaryrelationAccount.id;
                a1.crm_Primary_Customer_Account__c= true;
                a1.parentid=party.id;
                update a1;
              
                
                List<Account> relAccounts= custRelationAccountmap.get(orgno);
                for (Account a:relAccounts){
                    if(a.id!=a1.id){
                    a.parentid=party.id;
                    AcntList.add(a);
                    }
                }
           
           
       
        }
     
      update Acntlist;
        
    }   
    
   }
    
    global void finish(Database.BatchableContext BC) 
    {    
       String str = '';
         
        AsyncApexJob[] a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ApexClass.Name from AsyncApexJob where Id =:bc.getJobId() ];
        
        if(callback != '' && callback != null)
                  str += callback + '\n';
        if(a != null && a.size() > 0){
                    str += a[0].ApexClass.Name + ' ( '+ a[0].Id + ' ' + a[0].status + ')  processed ' + a[0].TotalJobItems + ' batches with '+ a[0].NumberOfErrors + ' failures.';
                }
        
        
        if(!Test.IsRunningTest())
            Database.executeBatch(new crm_CreatePartyFromProspect(str));
        
    }
    
}