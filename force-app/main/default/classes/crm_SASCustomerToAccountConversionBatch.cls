global class crm_SASCustomerToAccountConversionBatch implements Database.batchable<sObject>,Database.Stateful
{
        global Integer Faliurecount=0;

        String AccountQuery='Select Id,Name,AccountNumber,crm_Credit_Score__c,CurrencyIsoCode,Party_number__c,crm_Primary_Customer_Account__c,crm_Customer_Number__c,Orga__c,crm_Annual_Sales_Local_Currency__c,crm_CREDITLIMIT__c,crm_Credit_Rating_Code__c,'+
                            'crm_CURRENCYCODE__c,crm_CURRENCYCODEDESCRIPTION__c,crm_Customer_Blocked_Status__c,Phone,crm_Customer_Status_Role_1__c,BillingStreet,BillingCity,BillingState,BillingCountry,BillingPostalCode,'+
                            'crm_Customer_Status_Role_2__c,crm_Customer_Status_Role_3__c,crm_Customer_Status_Role_4__c,crm_Date_for_Credit_Rating__c,'+
                            'crm_Date_updated_external_company_data__c,crm_Domestic_Ultimate_Company_Cntry_Dsc__c,crm_Domestic_Ultimate_Company_Identifier__c,crm_Domestic_Ultimate_Company_Name__c,'+
                            'crm_Domestic_ultimate_National_ID__c,DUNS_number__c,NumberOfEmployees,crm_English_LOB_Code_2_description_NACE2__c, crm_English_LOB_description_NACE__c,'+
                            'crm_Fiscal_Year__c,crm_Global_Ultimate_Company_Identifier__c,crm_Global_Ultimate_Cmpny_Identifier_Owr__c,crm_Global_Ultimate_Country_Description__c,'+
                            'crm_Global_ultimate_National_ID__c,crm_Headquarter_Countrycode__c,crm_Headquarter_Country_Description__c,crm_Headquarter_Identifier_for_ext_comp__c,crm_Headquarter_Name__c,'+
                            'crm_Headquarter_National_ID__c,crm_Internal_Credit_Rating__c,crm_ISO_Countrycode_for_Customer_Company__c,crm_LOB_Code_2_NACE2__c,crm_Local_LOB_Code_2_description_NACE2__c,crm_Local_LOB_description_NACE__c,'+
                            'crm_Organization_number__c,crm_Out_Of_Business_Info_change_desc__c,crm_Out_Of_Busines_Info_Company_Name_for__c,crm_Out_Of_Busines_Info_Company_National__c,crm_Out_Of_Business_Info_Creditrating__c,'+
                            'crm_Out_Of_Busines_Info_DUNSno_for_reltn__c,crm_Out_Of_Business_Info_indicator_flag__c,crm_Out_Of_Business_Info_type_of_change__c,crm_Posten_Source_Comp_for_datarecord_ER__c,crm_Primary_LOB_Code_NACE__c,'+
                            'crm_Reason_for_Customer_Blocking__c,crm_bus_addr_Street__c,crm_bus_addr_City__c,crm_bus_addr_Country__c,crm_bus_addr_Zip_Code__c,crm_REGISTRYUPDATEDATE__c,Type,crm_Visit_Address_City__c,crm_Visit_Address_Street__c,crm_Visit_Address_Zipcode__c,crm_Visit_Address_Country__c, Website,Parentid,crm_Updated_by_CDH__c from Account';
        
        global Database.QueryLocator start(Database.BatchableContext BC){
            String query;
            String tempid ='a1u0E000000R609';
           // Set<String> customernumberset=new set<String>{'10027787836','4051421'};
            query = 'Select id,Name,crm_CUSTOMER_NUMBER__c,crm_ANNUALSALES__c,crm_COUNTRYTELCODE__c,crm_CREDITLIMIT__c,crm_RATING__c,crm_CURRENCYCODE__c,'+
                    'crm_CURRENCYCODEDESCRIPTION__c,crm_CUSTOMER_ADDRESS__c, crm_BLOCKSTATUS__c,crm_CUSTOMER_CITY__c,crm_CUSTOMER_COUNTRY__c,'+
                    'crm_TELNO__c,crm_STATUSROLE__c,crm_CUSTOMERROLE__c,crm_CUSTOMERSTATUS__c,crm_STATUSCODE__c, crm_CUSTOMER_ZIPCODE__c,crm_RATINGDATE__c,'+
                    'crm_REPORTDATE__c,crm_DUCOUNTRY__c,crm_DUDUNS__c,crm_DUNAME__c,crm_NATIDDU__c,crm_DUNSNR__c,crm_EMPLOYEEHERE__c,crm_DBNACETEXTEN2__c,'+
                    'crm_DBPRIMARYNACETEXTEN__c,crm_SALESYEAR__c,crm_GUDUNS__c,crm_GUNAME__c,crm_GUCOUNTRY__c,crm_NATIDGU__c,crm_HQCOUNTRYCODE__c,crm_HQCOUNTRY__c,'+
                    'crm_HQDUNS__c, crm_HQNAME__c,crm_NATIDHQ__c,crm_INTERNALRATING__c,crm_CUSTOMER_COUNTRYCODE__c,crm_DBNACECODE2__c,crm_DBNACETEXT2__c,'+
                    'crm_DBPRIMARYNACETEXT__c,crm_CUSTOMER_ORGANISATIONNUMBER__c,crm_OOBCONDITIONDESC__c,crm_OOBNAMERELATED__c,crm_OOBORGANISATIONNUMBERRELATED__c,'+
                    'crm_OOBRATINGDATE__c,crm_OOBDUNSRELATED__c, crm_OOBINDICATOR__c,crm_OOBCONDITION__c,crm_COMPANY__c,crm_DBPRIMARYNACECODE__c,'+
                    'crm_Processed__c,crm_BLOCKREASON__c,crm_REGISTRYUPDATEDATE__c,crm_INTERNALCOMPANY__c,crm_VISITCITY__c,crm_CUSTOMER_VISITADDRESS__c,'+
                    'crm_VISITZIPCODE__c,crm_HOMEPAGE__c,crm_Visit_Address_Country__c from crm_SAS_Customer_Import__c where crm_processed__c=false and crm_CUSTOMER_NUMBER__c!=null order by CreatedDate desc';
                    //and CreatedDate < 2016-11-29T00:00:00Z and CreatedDate > 2016-11-24T00:00:00Z
             //and crm_processed__c=false
                return Database.getQueryLocator(query);       
        
        } 
        
        global void execute(Database.BatchableContext BC, List<crm_SAS_Customer_Import__c> SasList) {
            System.debug('SasList'+SasList);
            Map<string, crm_SAS_Customer_Import__c> sasImportMap= new  Map<string, crm_SAS_Customer_Import__c>();
            Set<String> keys=new Set<String>();
            List<Account> partyAccountinsertList=new List<Account>();
            List<Account> relationAccountinsertList=new List<Account>();
            List<Account> updateAccountList=new List<Account>();
            List<Account> insertAccountList=new List<Account>();
            
            Map<String,Account> PartyAccountMap=new Map<String,Account>();
            List<Account> PartyAccountList=new List<Account>();
            
            Map<String,Account> ProspectAccountMap=new Map<String,Account>();
            List<Account> ProspectAccountList=new List<Account>();
            
            Map<String,Account> RelationAccountMap=new Map<String,Account>();
            List<Account> RelationAccountList=new List<Account>();
            
            Map<String,Account> RelationAccountParentNullMap=new Map<String,Account>();
            Map<String,crm_SAS_Customer_Import__c> SasRecordOrgNumberBlankMap=new Map<String,crm_SAS_Customer_Import__c>();
            
            List<crm_SAS_Customer_Import__c> ProcessedRecords=new List<crm_SAS_Customer_Import__c>();
            Map<String,List<Account>> CommanOrgNumMap=new Map<String,List<Account>>();
            Map<String,List<crm_SAS_Customer_Import__c>> CommanOrgSASMap=new  Map<String,List<crm_SAS_Customer_Import__c>>();
            
            crm_AccountRecordTypes__c rTRelation= crm_AccountRecordTypes__c.getValues('Relation level Customer');
            crm_AccountRecordTypes__c rTParty= crm_AccountRecordTypes__c.getValues('Party level Customer');
            crm_AccountRecordTypes__c rTProspect= crm_AccountRecordTypes__c.getValues('Prospect');
           
            Id PartyLevelRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTParty.crm_Record_Type_Label__c).getRecordTypeId();
            Id RelationLevelRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTRelation.crm_Record_Type_Label__c).getRecordTypeId();
            Id ProspectRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTProspect.crm_Record_Type_Label__c).getRecordTypeId();
            Set<id> ProspecttoUpadte=new Set<Id>();
            Boolean PrimaryAccountFound;
             String FailedOrgNumber;
             String FailedCustomerNumber;
            List<crm_Exception__c> errorlogs=new List<crm_Exception__c>();
            for(crm_SAS_Customer_Import__c sasObj: SasList)
            {  
                    if(sasObj.crm_CUSTOMER_ORGANISATIONNUMBER__c!=null)
                    {       
                            sasObj.crm_CUSTOMER_ORGANISATIONNUMBER__c=sasObj.crm_CUSTOMER_ORGANISATIONNUMBER__c.replaceall('[^0-9]', '');
                            String orgnumber=sasObj.crm_CUSTOMER_ORGANISATIONNUMBER__c.replaceall('0','');
                            if(orgnumber.length()==0)
                            {   
                                if(!SasRecordOrgNumberBlankMap.containsKey(sasObj.crm_CUSTOMER_NUMBER__c))
                                     SasRecordOrgNumberBlankMap.put(sasObj.crm_CUSTOMER_NUMBER__c,sasObj);
     
                            }
                            else
                            {
                                if(!sasImportMap.containsKey(sasObj.crm_CUSTOMER_NUMBER__c))
                                   {
                                       sasImportMap.put(sasObj.crm_CUSTOMER_NUMBER__c,sasObj);
                                       keys.add(sasObj.crm_CUSTOMER_ORGANISATIONNUMBER__c);
                                   }
                                   else
                                   {
                                    sasObj.crm_Processed__c=true;
                                    ProcessedRecords.add(sasObj);
                                   }
                              
                            }
                    }
                    else // if org number field is empty then create new relation level account
                    {    

                            if(!SasRecordOrgNumberBlankMap.containsKey(sasObj.crm_CUSTOMER_NUMBER__c))
                                 SasRecordOrgNumberBlankMap.put(sasObj.crm_CUSTOMER_NUMBER__c,sasObj);
                           else
                              {
                                 sasObj.crm_Processed__c=true;
                                 ProcessedRecords.add(sasObj);
                              }
                     }

                 
                                  
            }
            System.debug('@SasRecordOrgNumberBlankMap@'+SasRecordOrgNumberBlankMap.keySet()); 
            System.debug('@sasImportMap@'+sasImportMap.keyset());     
            PartyAccountList=DataBase.Query(AccountQuery+' where '+'RecordTypeId =: PartyLevelRecordTypeId and Orga__c IN '+':keys');
                    
            //Create Map of Org Number and Party Account
            for(Account PartyAccount: PartyAccountList)
            {
                    PartyAccountMap.put(PartyAccount.Orga__c,PartyAccount);
            }
                    
                   
            ProspectAccountList=DataBase.Query(AccountQuery+' where RecordTypeId=:ProspectRecordTypeId and  Orga__c in:keys');
                    
            //Create Map of Org Number and Prospect Account
            for(Account ProspectAccount: ProspectAccountList)
            {
                    ProspectAccountMap.put(ProspectAccount.Orga__c,ProspectAccount);
            }
                   
            keys=sasImportMap.keySet();
            RelationAccountList=DataBase.Query(AccountQuery+' where RecordTypeId =: RelationLevelRecordTypeId and crm_Customer_Number__c in :keys');                    
                
            for(Account relAccount: RelationAccountList)
            {
                    if(relAccount.ParentId!=null)
                     //Create Map of Org Number and Relation Account having Parent Account associated 
                      RelationAccountMap.put(relAccount.crm_Customer_Number__c,relAccount);
                    else
                     //Create Map of Org Number and Relation Account having no Parent Account associated 
                       RelationAccountParentNullMap.put(relAccount.crm_Customer_Number__c,relAccount);
            }
            
            keys=SasRecordOrgNumberBlankMap.keyset();
            List<Account> acctoUpdate=DataBase.Query(AccountQuery+' where RecordTypeId =: RelationLevelRecordTypeId and (crm_Customer_Number__c in :keys)');
            Map<String,Account> accMap=new  Map<String,Account>();
            
            for(Account acc:acctoUpdate)
            {
                accMap.put(acc.crm_Customer_Number__c,acc);
            }
            
            if(SasRecordOrgNumberBlankMap!=null)
            {
                //Update the Relation account if matching customer number is found in the system even if the organization number is blank in Customer table data
                    
                    for(crm_SAS_Customer_Import__c  sasObj:SasRecordOrgNumberBlankMap.values())
                    {
                        Account NewRelationAcc=new Account();
                        if(accMap.containsKey(sasObj.crm_CUSTOMER_NUMBER__c)&& sasObj.crm_CUSTOMER_ORGANISATIONNUMBER__c==null)
                        {
                          NewRelationAcc=accMap.get(sasObj.crm_CUSTOMER_NUMBER__c);
                          if(NewRelationAcc.crm_Updated_By_CDH__c!=true)
                          {
                              //String OrgaNumber=NewRelationAcc.Orga__c;
                              //Id Parentid=NewRelationAcc.ParentId;
                              NewRelationAcc=SASToAccountMap(new Account(),sasObj);
                              //Deparenting relation level account
                              newRelationAcc=UpdateRelationFields(NewRelationAcc,null,RelationLevelRecordTypeId);
                              newRelationAcc.crm_Primary_Customer_Account__c=false;
                              //newRelationAcc.Orga__c=OrgaNumber;
                              relationAccountinsertList.add(NewRelationAcc);
                          }
                        }
                        else // Create orphan relation account if org number is blank and customer number is not present in Account table
                        {
                         NewRelationAcc=SASToAccountMap(new Account(),sasObj);
                         newRelationAcc=UpdateRelationFields(NewRelationAcc,null,RelationLevelRecordTypeId);
                         relationAccountinsertList.add(NewRelationAcc);
                        }
                    
                        sasObj.crm_Processed__c=true;
                        ProcessedRecords.add(sasObj);
                    }
            }
            PrimaryAccountFound=false;
            for(crm_SAS_Customer_Import__c  sasObj:sasImportMap.values())
            {  
                    //if party level exists
                    if(PartyAccountMap.containsKey(sasObj.crm_CUSTOMER_ORGANISATIONNUMBER__c))
                    {
                        Account partyAcc=PartyAccountMap.get(sasObj.crm_CUSTOMER_ORGANISATIONNUMBER__c);
                            
                            //Get Relation level account for Party level and update
                        if(RelationAccountMap.containsKey(sasObj.crm_CUSTOMER_NUMBER__c))
                        {
                           Account relationAcc=RelationAccountMap.get(sasObj.crm_CUSTOMER_NUMBER__c);
                           if(relationAcc.crm_Updated_By_CDH__c!=true)
                           {
                              if(relationAcc.Orga__c==partyAcc.Orga__c)
                              {
                                    relationAcc=SASToAccountMap(RelationAccountMap.get(sasObj.crm_CUSTOMER_NUMBER__c),sasObj);
                                    relationAcc=UpdateRelationFields(relationAcc,partyAcc.id,RelationLevelRecordTypeId);
                                    updateAccountList.add(relationAcc);
                                    
                                    if(relationAcc.crm_Primary_Customer_Account__c==true && partyAcc.crm_Updated_By_CDH__c!=true)
                                    {
                                        partyAcc=SASToAccountMap(partyAcc,sasObj);
                                        updateAccountList.add(partyAcc);
                                    }
                                    
                                     if(!relationAcc.crm_Primary_Customer_Account__c && partyAcc.crm_Updated_By_CDH__c!=true)
                                    {
                                        partyAcc=SASToAccountMapCustomerrole(partyAcc,sasObj);
                                        updateAccountList.add(partyAcc);
                                    }
                                    
                                    
                                    
                               }
                               else if(relationAcc.Orga__c!=partyAcc.Orga__c)
                               {
                                    relationAcc=SASToAccountMap(RelationAccountMap.get(sasObj.crm_CUSTOMER_NUMBER__c),sasObj);
                                    relationAcc=UpdateRelationFields(relationAcc,partyAcc.id,RelationLevelRecordTypeId);
                                    relationAcc.crm_Primary_Customer_Account__c=false;
                                    updateAccountList.add(relationAcc);
                               }
                            }

                        }
                            //if relation account exists with the account number from Saas Import record, then assign existing party 
                            //account with matching the org number as the parent for orphan relation account 
                        else if(RelationAccountParentNullMap.containsKey(sasObj.crm_CUSTOMER_NUMBER__c))
                        {
                            Account relationAcc=RelationAccountParentNullMap.get(sasObj.crm_CUSTOMER_NUMBER__c);
                            relationAcc=SASToAccountMap(RelationAccountParentNullMap.get(sasObj.crm_CUSTOMER_NUMBER__c),sasObj);
                            relationAcc=UpdateRelationFields(relationAcc,partyAcc.id,RelationLevelRecordTypeId);
                            updateAccountList.add(relationAcc);
                                 
                        }
                            //Party level account with matching org number doesnot exist then create new Account of type Relation Level
                        if(!RelationAccountParentNullMap.containsKey(sasObj.crm_CUSTOMER_NUMBER__c) && !RelationAccountMap.containsKey(sasObj.crm_CUSTOMER_NUMBER__c))
                        {
                            Account acc=new Account();
                            acc=SASToAccountMap(acc,sasObj);
                            acc=UpdateRelationFields(acc,partyAcc.id,RelationLevelRecordTypeId);
                            relationAccountinsertList.add(acc);
                               
                        }
                    }//end of if
                        // if Party level with Org number is not present check for Prospect account
                    else if(ProspectAccountMap.containsKey(sasObj.crm_CUSTOMER_ORGANISATIONNUMBER__c))
                    {
                    // add values from sas object to account fields
                        Account prosAcc=SASToAccountMap(ProspectAccountMap.get(sasObj.crm_CUSTOMER_ORGANISATIONNUMBER__c),sasObj);
                        System.debug('@@@ProspecttoUpadte@@@'+ProspecttoUpadte);
                             if(!ProspecttoUpadte.contains(prosAcc.id))
                             {
                                   //Change record type from Prospect to Party 
                                   ProspecttoUpadte.add(prosAcc.id);
                                   prosAcc.RecordTypeId=PartyLevelRecordTypeId;   
                                   updateAccountList.add(prosAcc);
                                    //create  a new relation acnt ,assign Party account as Parent.
                                   Account childAcc=new Account();
                                   childAcc=prosAcc.clone(false,true);
                                   childAcc=UpdateRelationFields(childAcc,prosAcc.id,RelationLevelRecordTypeId);
                                   childAcc.crm_Primary_Customer_Account__c=true;
                                   relationAccountinsertList.add(childAcc);
                                   System.debug('@@@relationAccountinsertList@@'+relationAccountinsertList);
                             }
                             else// create relation level account with the sasobj data and assign parent account
                             {
                                  Account childAcc=new Account();
                                  childAcc=SASToAccountMap(childAcc,sasObj);
                                  childAcc=UpdateRelationFields(childAcc,prosAcc.id,RelationLevelRecordTypeId);
                                  relationAccountinsertList.add(childAcc);
                                  System.debug('@@@relationAccountinsertList@@276'+relationAccountinsertList);
                             }
                       
                              
                    }//end of else if
                    //if both party and prospect doesnot exist Create new party level account and Child account of type Relation level
                    else if(!PartyAccountMap.containsKey(sasObj.crm_CUSTOMER_ORGANISATIONNUMBER__c) && !ProspectAccountMap.containsKey(sasObj.crm_CUSTOMER_ORGANISATIONNUMBER__c) && sasObj.crm_CUSTOMER_ORGANISATIONNUMBER__c!=null)
                    {
                        System.debug('@@@'+CommanOrgNumMap);
                        if(!CommanOrgSASMap.containsKey(sasObj.crm_CUSTOMER_ORGANISATIONNUMBER__c))
                        {
                           List<crm_SAS_Customer_Import__c> sasrecList=new List<crm_SAS_Customer_Import__c>();
                           sasrecList.add(sasObj);
                           CommanOrgSASMap.put(sasObj.crm_CUSTOMER_ORGANISATIONNUMBER__c,sasrecList);
                            
                        }
                        else
                        {
                            List<crm_SAS_Customer_Import__c> sasrecList= CommanOrgSASMap.get(sasObj.crm_CUSTOMER_ORGANISATIONNUMBER__c);
                            sasrecList.add(sasObj);
                            CommanOrgSASMap.put(sasObj.crm_CUSTOMER_ORGANISATIONNUMBER__c,sasrecList);
                        }
                             //Create new Party account
                        
                    }//end of else if
                    sasObj.crm_Processed__c=true;
                    ProcessedRecords.add(sasObj);
                    System.debug('@ProcessedRecords@'+ProcessedRecords);  
            }// end of for
            if(CommanOrgSASMap.keyset()!=null)
             {  
                        for(String s:CommanOrgSASMap.keyset())
                        {
                            List<crm_SAS_Customer_Import__c> relationsasList = CommanOrgSASMap.get(s);
                            List<crm_SAS_Customer_Import__c> ascrelationsasList=new List<crm_SAS_Customer_Import__c>();
                                for(Integer i = relationsasList.size()-1; i>=0; i--)
                                {
                                ascrelationsasList.add(relationsasList[i]);
                                }
                                System.debug('@@ascrelationList@'+ascrelationsasList);
                                System.debug('@@CommanOrgNumMa438@'+CommanOrgSASMap);
                              CommanOrgSASMap.put(s,ascrelationsasList);
                          }
              }
              
             if(CommanOrgSASMap.keyset()!=null)
             {
                   for(String s:CommanOrgSASMap.keyset())
                   {
                       List<crm_SAS_Customer_Import__c> relationsasList = CommanOrgSASMap.get(s);
                       Account PartyAccount=new Account();
                       List<Account> relationaccountToNewParty=new  List<Account>();
                       PrimaryAccountFound=false;
                       for(crm_SAS_Customer_Import__c sasObj:relationsasList)
                       {
                               if(RelationAccountParentNullMap.containsKey(sasObj.crm_CUSTOMER_NUMBER__c))
                                {
                                     Account updateChildAcc=RelationAccountParentNullMap.get(sasObj.crm_CUSTOMER_NUMBER__c);
                                     updateChildAcc=SASToAccountMap(updateChildAcc,sasObj);
                                     if(PrimaryAccountFound!=true)
                                     {
                                         updateChildAcc.crm_Primary_Customer_Account__c=true;
                                        
                                         PartyAccount=SASToAccountMap(new Account(),sasObj);
                                         PartyAccount.RecordTypeId=PartyLevelRecordTypeId;
                                         PrimaryAccountFound=true;
                                    }
                                    else
                                    {
                                        updateChildAcc.crm_Primary_Customer_Account__c=false;
                                    }
                                    relationaccountToNewParty.add(updateChildAcc);
                                }
                                else if(RelationAccountMap.containsKey(sasObj.crm_CUSTOMER_NUMBER__c))
                                {
                                    Account relationAcc=RelationAccountMap.get(sasObj.crm_CUSTOMER_NUMBER__c);
                                   // if(relationAcc.Orga__c==partyAcc.Orga__c && relationAcc.crm_Updated_By_CDH__c!=true)
                                    if(relationAcc.crm_Updated_By_CDH__c!=true)
                                    {
                                        relationAcc=SASToAccountMap(RelationAccountMap.get(sasObj.crm_CUSTOMER_NUMBER__c),sasObj);
                                        if(PrimaryAccountFound!=true)
                                         {
                                            relationAcc.crm_Primary_Customer_Account__c=true;
                                            PrimaryAccountFound=true;
                                            PartyAccount=SASToAccountMap(new Account(),sasObj);
                                            PartyAccount.RecordTypeId=PartyLevelRecordTypeId;
 
                                        }
                                        else
                                        {
                                          relationAcc.crm_Primary_Customer_Account__c=false;
                                        }
                                        relationaccountToNewParty.add(relationAcc);
                                    }
                                }
                                else
                                {
                                    Account childAcc=new Account();
                                    childAcc=SASToAccountMap(childAcc,sasObj);
                                    relationaccountToNewParty.add(childAcc);
                                }    
                       }
                       
                       if(PrimaryAccountFound!=true)
                       {
                           System.debug('@@@relationaccountToNewParty@@@'+relationaccountToNewParty);
                           PartyAccount=relationaccountToNewParty[0].clone();
                           System.debug('@@@relationaccountToNewParty@@@'+relationaccountToNewParty[0]);
                           
                           relationaccountToNewParty[0].crm_Primary_Customer_Account__c=true;
                       }
                       PartyAccount.RecordTypeId=PartyLevelRecordTypeId;
                       PartyAccount.crm_Primary_Customer_Account__c=false;
                       partyAccountinsertList.add(PartyAccount);
                       System.debug('@@@partyAccountinsertList@@@'+partyAccountinsertList);
                       CommanOrgNumMap.put(s,relationaccountToNewParty);   
                        System.debug('@@@CommanOrgNumMap@@@'+CommanOrgNumMap); 
                   }
                   
             }
                
                 
            try
            {   
                       
                //for inserting child records of new party level account 
                if(partyAccountinsertList!=null)
                {              
                       //Insert all new party accounts
                       Database.SaveResult[] InsertResultList=Database.Insert(partyAccountinsertList,false);
                           for(Integer i = 0; i < InsertResultList.size(); i++)
                           {
                                if(InsertResultList[i].isSuccess()==false)
                                {
                                     Faliurecount++;
                                     FailedOrgNumber=partyAccountinsertList[i].orga__c;
                                     FailedCustomerNumber=partyAccountinsertList[i].crm_customer_number__c;
                                     for(Database.Error err : InsertResultList[i].getErrors()) {
                                     crm_Exception__c ex=new crm_Exception__c();
                                     if(err.getMessage().length()>255)
                                     {
                                     err.getMessage().abbreviate(252);
                                     }
                                     ex.crm_Message__c=err.getMessage();
                                     ex.crm_Dml_Field_Names__c=String.valueof(err.getFields());
                                     ex.crm_Stack_Trace__c='crm_SASCustomerToAccountConversionBatch FailedOrgNumber:'+FailedOrgNumber+' FailedOrgNumber:'+FailedCustomerNumber;
                                     errorlogs.add(ex);
                                     }
    
                                }
                            }
                        system.debug('@@@partyAccountinsertList@@'+partyAccountinsertList);
                        for(Account ac: partyAccountinsertList)
                        {
                              // crm_SAS_Customer_Import__c sasObj=sasImportMap.get(ac.Party_Number__c);
                              //Check if any account belonging to org number is present in the comman party map, in this case,
                              // the accounts in commanOrgNumMap are associated with the Party account.
                                if(CommanOrgNumMap.containskey(ac.Orga__c))
                                {
                                    List<Account> childAccList=CommanOrgNumMap.get(ac.Orga__c);
                                    System.debug('@@childAccList@@'+childAccList);  
                                    if(childAccList.size()!=0)
                                    {
                                        for(Account a:childAccList)
                                        {
                                            a=UpdateRelationFields(a,ac.id,RelationLevelRecordTypeId);
                                            relationAccountinsertList.add(a);
                                        }//end of for
                                    }//end of if
                                }//end of if
                            // Check if orphan account exists
                      
                               
                        }//end of for
      
                }//end of if
               
               //update updateAccountList;
               
               Map<Id, Account> updateAccountMap= new Map<Id, Account>();
               for (Account acnt : updateAccountList){
                   updateAccountMap.put(acnt.id,acnt);
                   
                   }
               
               Database.SaveResult[] UpdateResultList=Database.update(updateAccountMap.values(),false);

                for(Integer i = 0; i < UpdateResultList.size(); i++)
                 {
                            if(UpdateResultList[i].isSuccess()==false)
                            {
                                 Faliurecount++;
                                 FailedOrgNumber=updateAccountList[i].orga__c;
                                 FailedCustomerNumber=updateAccountList[i].crm_customer_number__c;
                                 for(Database.Error err : UpdateResultList[i].getErrors()) {
                                 crm_Exception__c ex=new crm_Exception__c();
                                 if(err.getMessage().length()>255)
                                 {
                                 err.getMessage().abbreviate(252);
                                 }
                                 ex.crm_Message__c=err.getMessage();
                                 ex.crm_Dml_Field_Names__c=String.valueof(err.getFields());
                                 ex.crm_Stack_Trace__c='crm_SASCustomerToAccountConversionBatch FailedOrgNumber:'+FailedOrgNumber+' FailedCustomerNumber:'+FailedCustomerNumber+' Account Id'+updateAccountList[i].id;
                                 errorlogs.add(ex);
                                 }

                            }
                }
                
                Schema.SObjectField upsertKey = Account.Fields.crm_Customer_Number__c;
                System.debug('@@relationAccountinsertList@'+relationAccountinsertList);
                Database.UpsertResult[] ResultList=Database.upsert(relationAccountinsertList, upsertKey ,false);
                for(Integer i = 0; i < ResultList.size(); i++)
                 {
                            if(ResultList[i].isSuccess()==false)
                            {
                                 Faliurecount++;
                                 FailedOrgNumber=relationAccountinsertList[i].orga__c;
                                 FailedCustomerNumber=relationAccountinsertList[i].crm_customer_number__c;
                                 for(Database.Error err : ResultList[i].getErrors()) {
                                 crm_Exception__c ex=new crm_Exception__c();
                                 if(err.getMessage().length()>255)
                                 {
                                 err.getMessage().abbreviate(252);
                                 }
                                 ex.crm_Message__c=err.getMessage();
                                 ex.crm_Dml_Field_Names__c=String.valueof(err.getFields());
                                 ex.crm_Stack_Trace__c='crm_SASCustomerToAccountConversionBatch FailedOrgNumber:'+FailedOrgNumber+' FailedCustomerNumber:'+FailedCustomerNumber;
                                 errorlogs.add(ex);
                                 }

                            }
                }
               
                system.debug('@failure'+Faliurecount);
                update ProcessedRecords;
                System.debug('@ProcessedRecords@'+ProcessedRecords.size()); 
                if(errorlogs.size()>0)
                    insert errorlogs;
                    System.debug('errorlogs@@'+errorlogs);
            }
            catch(Exception e){ crm_Exception_handler.createExceptionRecords(e); }
            
           /* List<User> userList= [Select id from user where alias='aadmi' limit 1];
            if (userList!= null && userList.size()>0) {
            
                List<Account> ownerAccountList= [Select id, ownerid from  Account where id in :ProspecttoUpadte];
                for (Account a: ownerAccountList) {
                    a.ownerid= userlist[0].id;
                
                }
                if (ownerAccountList.size()>0)
                    Database.update(ownerAccountList, false);
          } */ 
         
        }
           
        global void finish(Database.BatchableContext BC) {
        
           String str = 'Number for records failed'+''+Faliurecount;
            AsyncApexJob[] a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ApexClass.Name from AsyncApexJob where Id =:BC.getJobId()];
            if(a != null && a.size() > 0){
                    str += a[0].ApexClass.Name + ' ( '+ a[0].Id + ' ' + a[0].status + ')  processed ' + a[0].TotalJobItems + ' batches with '+ a[0].NumberOfErrors + ' failures.';
            }
        
          if(!Test.IsRunningTest())
          {
            Database.executeBatch(new crm_revenueTransformation_batch(str));
            }
        
        }
        
        private static Account UpdateRelationFields(Account acc,Id parentAccountid,Id RelationLevelRecordTypeId)
        {
            
            acc.crm_Active_Relation_Account__c =true;
            acc.Party_number__c=acc.AccountNumber;
            acc.crm_Customer_Number__c=acc.AccountNumber;
            acc.crm_Duplicate_Match__c='';
            if(acc.RecordTypeId!=RelationLevelRecordTypeId)
            {
                acc.RecordTypeId=RelationLevelRecordTypeId ;
            }
            
                acc.ParentId=parentAccountid;

            return acc;
        }
        
          //function for mapping field values from Saas Import to Account
        private static Account SASToAccountMapCustomerrole(Account accobj, crm_SAS_Customer_Import__c sasObj)
        {
            
            if(sasObj.crm_CUSTOMERSTATUS__c == 'A' ||  sasObj.crm_CUSTOMERSTATUS__c =='a')
                accobj.crm_Customer_Status_Role_3__c=sasObj.crm_CUSTOMERSTATUS__c;
           
            return accobj;
            
            
        }
        
        
        
        
        //function for mapping field values from Saas Import to Account
        private static Account SASToAccountMap(Account accobj, crm_SAS_Customer_Import__c sasObj)
        {
            accobj.Name=sasObj.Name;
            accobj.AccountNumber=sasObj.crm_CUSTOMER_NUMBER__c;
            accobj.crm_bus_addr_Street__c=sasObj.crm_CUSTOMER_ADDRESS__c;
            accobj.crm_bus_addr_City__c=sasObj.crm_CUSTOMER_CITY__c;
            if(sasObj.crm_CUSTOMER_COUNTRY__c!=null)
            {
            sasObj.crm_CUSTOMER_COUNTRY__c=sasObj.crm_CUSTOMER_COUNTRY__c.tolowerCase();
            accobj.crm_bus_addr_Country__c=sasObj.crm_CUSTOMER_COUNTRY__c.substring(0,1).toUpperCase()+ sasObj.crm_CUSTOMER_COUNTRY__c.substring(1,sasObj.crm_CUSTOMER_COUNTRY__c.length());
            }
            accobj.crm_bus_addr_Zip_Code__c=sasObj.crm_CUSTOMER_ZIPCODE__c;
            /*accobj.BillingStreet=sasObj.crm_CUSTOMER_ADDRESS__c;
            accobj.BillingCity=sasObj.crm_CUSTOMER_CITY__c;
            accobj.BillingCountry=sasObj.crm_CUSTOMER_COUNTRY__c;
            accobj.BillingPostalCode=sasObj.crm_CUSTOMER_ZIPCODE__c;*/
            accobj.crm_Annual_Sales_Local_Currency__c=sasObj.crm_ANNUALSALES__c;
            accobj.crm_CREDITLIMIT__c=sasObj.crm_CREDITLIMIT__c;
            if(sasObj.crm_CREDITLIMIT__c!=null)
                accobj.crm_credit_limit__c=Decimal.valueof(sasObj.crm_CREDITLIMIT__c);
            accobj.crm_Credit_Rating_Code__c=sasObj.crm_RATING__c;
            //if(String.isNotBlank(sasObj.crm_RATING__c))
            accobj.crm_Credit_Score__c = sasObj.crm_RATING__c;
            accobj.crm_CURRENCYCODE__c=sasObj.crm_CURRENCYCODE__c;
            if(sasObj.crm_CURRENCYCODE__c!=null)
            accobj.CurrencyIsoCode=sasObj.crm_CURRENCYCODE__c;
            accobj.crm_CURRENCYCODEDESCRIPTION__c=sasObj.crm_CURRENCYCODEDESCRIPTION__c;
            accobj.crm_Customer_Blocked_Status__c=sasObj.crm_BLOCKSTATUS__c;
            accobj.Phone=sasObj.crm_TELNO__c;
            accobj.crm_Customer_Status_Role_1__c=sasObj.crm_STATUSROLE__c;
            accobj.crm_Customer_Status_Role_2__c=sasObj.crm_CUSTOMERROLE__c;
            accobj.crm_Customer_Status_Role_3__c=sasObj.crm_CUSTOMERSTATUS__c;
            accobj.crm_Customer_Status_Role_4__c=sasObj.crm_STATUSCODE__c;
            if(sasObj.crm_RATINGDATE__c!=null && sasObj.crm_RATINGDATE__c!='.')
                accobj.crm_Date_for_Credit_Rating__c=formatDate(sasObj.crm_RATINGDATE__c);
            else
                accobj.crm_Date_for_Credit_Rating__c=sasObj.crm_RATINGDATE__c;
                
            if(sasObj.crm_REPORTDATE__c!=null && sasObj.crm_REPORTDATE__c!='.')
                accobj.crm_Date_updated_external_company_data__c=formatDate(sasObj.crm_REPORTDATE__c);
            else
                accobj.crm_Date_updated_external_company_data__c=sasObj.crm_REPORTDATE__c;
                
            accobj.crm_Domestic_Ultimate_Company_Cntry_Dsc__c=sasObj.crm_DUCOUNTRY__c;
            accobj.crm_Domestic_Ultimate_Company_Identifier__c=sasObj.crm_DUDUNS__c;
            accobj.crm_Domestic_Ultimate_Company_Name__c=sasObj.crm_DUNAME__c;
            accobj.crm_Domestic_ultimate_National_ID__c=sasObj.crm_NATIDDU__c;
            accobj.DUNS_number__c=sasObj.crm_DUNSNR__c;
            if(sasObj.crm_EMPLOYEEHERE__c!=null)
            accobj.NumberOfEmployees=Integer.valueOf(sasObj.crm_EMPLOYEEHERE__c);
            accobj.crm_English_LOB_Code_2_description_NACE2__c=sasObj.crm_DBNACETEXTEN2__c;
            accobj.crm_English_LOB_description_NACE__c=sasObj.crm_DBPRIMARYNACETEXTEN__c;
            accobj.crm_Fiscal_Year__c=sasObj.crm_SALESYEAR__c;
            accobj.crm_Global_Ultimate_Company_Identifier__c=sasObj.crm_GUDUNS__c;
            accobj.crm_Global_Ultimate_Cmpny_Identifier_Owr__c=sasObj.crm_GUNAME__c;
            accobj.crm_Global_Ultimate_Country_Description__c=sasObj.crm_GUCOUNTRY__c;
            accobj.crm_Global_ultimate_National_ID__c=sasObj.crm_NATIDGU__c;
            accobj.crm_Headquarter_Countrycode__c=sasObj.crm_HQCOUNTRYCODE__c;
            accobj.crm_Headquarter_Country_Description__c=sasObj.crm_HQCOUNTRY__c;
            accobj.crm_Headquarter_Identifier_for_ext_comp__c=sasObj.crm_HQDUNS__c;
            accobj.crm_Headquarter_Name__c=sasObj.crm_HQNAME__c;
            accobj.crm_Headquarter_National_ID__c=sasObj.crm_NATIDHQ__c;
            accobj.crm_Internal_Credit_Rating__c=sasObj.crm_INTERNALRATING__c;
            accobj.crm_ISO_Countrycode_for_Customer_Company__c=sasObj.crm_CUSTOMER_COUNTRYCODE__c;
            accobj.crm_LOB_Code_2_NACE2__c=sasObj.crm_DBNACECODE2__c;
            accobj.crm_Local_LOB_Code_2_description_NACE2__c=sasObj.crm_DBNACETEXT2__c;
            accobj.crm_Local_LOB_description_NACE__c=sasObj.crm_DBPRIMARYNACETEXT__c;
            accobj.crm_Organization_number__c=sasObj.crm_CUSTOMER_ORGANISATIONNUMBER__c;
            accobj.Orga__c=sasObj.crm_CUSTOMER_ORGANISATIONNUMBER__c;
            accobj.crm_Out_Of_Business_Info_change_desc__c=sasObj.crm_OOBCONDITIONDESC__c;
            accobj.crm_Out_Of_Busines_Info_Company_Name_for__c=sasObj.crm_OOBNAMERELATED__c;
            accobj.crm_Out_Of_Busines_Info_Company_National__c=sasObj.crm_OOBORGANISATIONNUMBERRELATED__c;
            if(sasObj.crm_OOBRATINGDATE__c!=null && sasObj.crm_OOBRATINGDATE__c!='.')
                accobj.crm_Out_Of_Business_Info_Creditrating__c=formatDate(sasObj.crm_OOBRATINGDATE__c);
            else
                accobj.crm_Out_Of_Business_Info_Creditrating__c=sasObj.crm_OOBRATINGDATE__c;
            
            accobj.crm_Out_Of_Busines_Info_DUNSno_for_reltn__c=sasObj.crm_OOBDUNSRELATED__c;
            accobj.crm_Out_Of_Business_Info_indicator_flag__c=sasObj.crm_OOBINDICATOR__c;
            accobj.crm_Out_Of_Business_Info_type_of_change__c=sasObj.crm_OOBCONDITION__c;
            accobj.crm_Posten_Source_Comp_for_datarecord_ER__c=sasObj.crm_COMPANY__c;
            accobj.crm_Primary_LOB_Code_NACE__c=sasObj.crm_DBPRIMARYNACECODE__c;
            accobj.crm_Reason_for_Customer_Blocking__c=sasObj.crm_BLOCKREASON__c;
            if(sasObj.crm_REGISTRYUPDATEDATE__c!=null && sasObj.crm_REGISTRYUPDATEDATE__c!='.')
                accobj.crm_REGISTRYUPDATEDATE__c=formatDate(sasObj.crm_REGISTRYUPDATEDATE__c);
            else
                accobj.crm_REGISTRYUPDATEDATE__c=sasObj.crm_REGISTRYUPDATEDATE__c;
                
            accobj.Type=sasObj.crm_INTERNALCOMPANY__c;
            accobj.crm_Visit_Address_City__c=sasObj.crm_VISITCITY__c;
            accobj.crm_Visit_Address_Street__c=sasObj.crm_CUSTOMER_VISITADDRESS__c;
            accobj.crm_Visit_Address_Zipcode__c=sasObj.crm_VISITZIPCODE__c;
            accobj.crm_Visit_Address_Country__c=sasObj.crm_Visit_Address_Country__c;
            accobj.Website=sasObj.crm_HOMEPAGE__c;
            accobj.crm_Updated_by_FKB__c=true;
            return accobj;
        }
        
        private static String formatDate(String datestring)
        {
            Integer day =  Integer.valueof(datestring.mid(0, 2));   
            Integer Month = Integer.valueof(datestring.mid(2, 2));
            Integer Year = Integer.valueof(datestring.mid(4, 4));
            System.debug('@@@day @@'+day );
            System.debug('@@@Month @@'+Month );
            System.debug('@@@Year @@'+Year );
            date myDate = date.newInstance(Year, Month, day);
             System.debug('@@@datestring@@'+datestring);
            System.debug('@@@myDate @@'+myDate );
            String norwegianformat = myDate.format();
           
            System.debug('@@@norwegianformat@@'+norwegianformat);
            return norwegianformat;
        }
       
}