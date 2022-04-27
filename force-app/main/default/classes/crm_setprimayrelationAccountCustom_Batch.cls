/*
Created By:Supriya Goel
Date:8th Nov 2017
Calculate set the primary relation account

*/

global class crm_setprimayrelationAccountCustom_Batch implements Database.batchable<sObject>,Database.Stateful{
    public string accntid= '';   
  
       
    global crm_setprimayrelationAccountCustom_Batch (string accntid){
         this.accntid= accntid;
    
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
         crm_AccountRecordTypes__c rTParty= crm_AccountRecordTypes__c.getValues('Party level Customer');
         Id PartyLevelRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTParty.crm_Record_Type_Label__c).getRecordTypeId();
         
          crm_AccountRecordTypes__c rTRelation= crm_AccountRecordTypes__c.getValues('Relation level Customer');
         Id relationLevelRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTRelation.crm_Record_Type_Label__c).getRecordTypeId();
       
              
        //String query = 'Select id, crm_Count_of_Primary_Relation__c, crm_Count_of_Relation_level_Accounts__c, crm_Primary_Customer_Account__c from Account where RecordTypeId = :PartyLevelRecordTypeId'; 
        String query='select id, crm_Count_of_Relation_level_Accounts__c, crm_Primary_Customer_Account__c,createdbyid,crm_bus_addr_City__c , crm_bus_addr_Country__c,crm_bus_addr_Street__c, crm_bus_addr_Zip_Code__c  FROM account where  recordtypeid=:PartyLevelRecordTypeId and id =:accntid order by createddate asc ';
        return Database.getQueryLocator(query);                      
    }
    
     global void execute(Database.BatchableContext BC, List<Account> accList) {
        Set <Id> partylevelId = new Set<Id>();
        Map<id, Account> RelationPartyAccountMap = new Map<Id, Account>();
        Map<id, List<Account>> PartyRelationAccountMap = new Map<Id, List<Account>>();
        Map<Id,Id> ParentAccountOwnerMap = new Map<Id,Id>(); 
        
         for (account acnt : accList){
             ParentAccountOwnerMap.put(acnt.id, acnt.createdbyid); //party  , party owner
             partylevelId.add(acnt.id); 
         
         }
         
         List<Account> allrelationAccounts=[select id,parentid, crm_Customer_Number__c,crm_Count_of_Relation_level_Accounts__c, crm_Primary_Customer_Account__c,createdbyid,crm_Revenue_This_Year__c,crm_bus_addr_City__c , crm_bus_addr_Country__c,crm_bus_addr_Street__c, crm_bus_addr_Zip_Code__c  FROM account where  parentid in :partylevelId and crm_Customer_Number__c!=null order by parentid, createddate asc];
        
         
         //map of relation account , party 
          for (account acnt : allrelationAccounts){
                    
            
           if(PartyRelationAccountMap.containskey(acnt.parentid) ){
                 List<Account> tempList= PartyRelationAccountMap.get(acnt.parentid);
                 tempList.add(acnt);
                 PartyRelationAccountMap.put(acnt.parentid, tempList);
             }else {
                  List<Account> tempList= new List<Account>();
                  tempList.add(acnt);
                  PartyRelationAccountMap.put(acnt.parentid, tempList); 
                  
             }
        } //parentid,  list of all relation accnts
        
        System.debug('@@@PartyRelationAccountMap'+PartyRelationAccountMap);
        
         for (Id Acntid: PartyRelationAccountMap.keyset()){
         System.debug('@@@in Acntid'+Acntid);
         List<Account> relationaccounts= PartyRelationAccountMap.get(Acntid);
          Boolean checkprimary= false;
          Decimal highestRevenuethisyear = relationaccounts[0].crm_Revenue_This_Year__c;
          Id primaryRelationId=relationaccounts[0].id ;
          System.debug('@@@relationaccounts'+relationaccounts+ relationaccounts[0].crm_Revenue_This_Year__c);
          for(Account a: relationaccounts){
          
              if(a.crm_Primary_Customer_Account__c  == true) {
               System.debug('@@@in 1'+a );      
                  checkprimary=true; 
                  RelationPartyAccountMap.put(a.parentid, a);    
                  break;
                   
                   
              }
              
             
          }
          if(checkprimary == false){
           for(Account a: relationaccounts){
              
                 if(a.crm_customer_number__c.isNumeric()){
                          System.debug('@@@in 2' + a );
                                checkprimary=true;
                                RelationPartyAccountMap.put(a.parentid, a);
                               
                                
                                break;
                                
                        } //end of if
                                        
                   
                  
                   
               }//end of for
               
          }//end of checkprimary if
          
          
          
          
          
            if(!checkprimary) {//setprimarynow 
            Boolean ishighest = false;
               for(Account a: relationaccounts){          
                                      
                            if(a.crm_Revenue_This_Year__c > highestRevenuethisyear ){   
                             System.debug('@@@in 3' + a );
                             
                                primaryRelationId=a.id;
                                highestRevenuethisyear= a.crm_Revenue_This_Year__c;
                                ishighest=true;
                                RelationPartyAccountMap.put(a.parentid, a);
                               
                              
                                
                                }
                                
                                  
                                
                                
                        }
                        
                        if(!ishighest)
                        
                            RelationPartyAccountMap.put(Acntid, relationaccounts[0]);   
            }//check primary false    
            
            checkprimary= false;       
             
          }//end of loop
             
         
              List<Account> Acntlist= new List<Account>();
       
        for (Id acntid: RelationPartyAccountMap.keyset()){
        
            Account a = new Account();
            a.id=acntid;
            a.crm_Primary_Customer_Account__c = true; 
            Account relationAccount= RelationPartyAccountMap.get(acntid);
            Account a1 = new Account();
            a1.id=relationAccount.id;
            a1.crm_Primary_Customer_Account__c= true;
            AcntList.add(a1);
           // AcntList.add(a);
       
        }
        
        System.debug('@@@Aaaaa'+ AcntList);
         update Acntlist;
         
         
       
         setaddress(RelationPartyAccountMap, ParentAccountOwnerMap );
        
        }//end of execute
        
        
        public void setaddress(Map<id, Account> RelationPartyAccountMap , Map<Id,Id> ParentAccountOwnerMap){
        List<Account> Acntlist= new List<Account>();
        
         environment_settings__c  CDHuserid= environment_settings__c.getValues('CDHuserid');
         for (Id parentid : RelationPartyAccountMap.keyset()){
           Id Ownerid = ParentAccountOwnerMap.get(parentid);
           System.debug('@@Ownerid' +Ownerid  );
           Account relationAccount= RelationPartyAccountMap.get(parentid);
           Account a = new Account();
           a.id=parentid ;
             if(Ownerid!= String.valueof(CDHuserid)) //cdh user
             {
              System.debug('@@a' +a + a.crm_bus_addr_City__c + a.crm_bus_addr_Country__c   );
               if(a.crm_bus_addr_City__c  == null && a.crm_bus_addr_Country__c  == null &&  a.crm_bus_addr_Street__c ==null && a.crm_bus_addr_Zip_Code__c ==null){
               //address fields update 
               a.crm_bus_addr_City__c = relationAccount.crm_bus_addr_City__c ;
               a.crm_bus_addr_Country__c=relationAccount.crm_bus_addr_Country__c;
               a.crm_bus_addr_Street__c= relationAccount.crm_bus_addr_Street__c;
               a.crm_bus_addr_Zip_Code__c= relationAccount.crm_bus_addr_Zip_Code__c;
               Acntlist.add(a);
               }
             }
         
         }
         
         System.debug('@@@Aaaaa'+ AcntList);
        
        update Acntlist;
        
        
        }
        
         global void finish(Database.BatchableContext BC) {
         
        
         }
         
         
         }//end of class