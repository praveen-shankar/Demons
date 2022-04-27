/*
 * Update.insert contacts in Salesforce  
 * Author: Supriya goel
 
*/
@RestResource(urlMapping = '/ContactIntegrationtoMyBring/*')

global without sharing class crm_ContactIntegrationtoMyBring {

 @HttpPatch
 global static String processContact() {
  RestRequest request = RestContext.request;
  Contact conobj = new Contact();
  
  
 

  //Extracting the data from the JSON HTTP request object sent from iPad
  RestRequest req = RestContext.request;
  RestResponse res = RestContext.response;
  Blob body = req.requestBody;
  String jsonToParse = body.toString();
  System.debug('body'+ jsonToParse);

  crm_ContactWrapper wrapper = crm_ContactWrapper.parse(jsonToParse);
  System.debug('wrapper ' + wrapper);
  //update
 
  String mybringuserid=String.valueof(wrapper.mybringUserId);
  
   List<Contact> conobjList =[Select id ,My_Bring_Userid__c from contact where My_Bring_Userid__c = :mybringuserid limit 1];
     
     //Changes made here. Searching for CS contacts based on email.
   //List<Contact> CS_ConList = [Select id from contact where lastname = :wrapper.lastname and email = :wrapper.userEmail and crm_contact_type__c = 'Customer Service'];
   List<Contact> CS_ConList = [Select id from contact where email = :wrapper.userEmail and crm_contact_type__c = 'Customer Service'];
     Set<Id> csContactIds = New Set<Id>();
     if(!CS_ConList.isEmpty()){
         for(Contact c : CS_ConList){
            csContactIds.add(c.Id); 
         }
         if(!csContactIds.isEmpty()){
             updateCSContacts(csContactIds, wrapper);
             system.debug('CS_ConList --> '+CS_ConList);
             system.debug('Calling updateCSContacts method');
         }
     } 
     //Changes Ends Here
 
  conobj.firstName = wrapper.firstName;  conobj.lastName = wrapper.lastName;
  if(wrapper.lastUpdatedTime != null && wrapper.lastUpdatedTime !='')
        conobj.lastmodifieddate__c   = Datetime.valueof(wrapper.lastUpdatedTime);
        
  if(wrapper.createdDateTime!= null && wrapper.createdDateTime!='')      
      conobj.Mybring_Created_Date__c = Datetime.valueof(wrapper.createdDateTime);
      
  if(wrapper.lastLoginDateTime!= null && wrapper.lastLoginDateTime!='')      
              
  conobj.crm_myBring_last_login__c = Datetime.valueof(wrapper.lastLoginDateTime);
  
  if(wrapper.mybringUserId!= null && wrapper.mybringUserId!='') 
  conobj.My_Bring_Userid__c = String.valueof(wrapper.mybringUserId);  

  conobj.mybringStatus__c = wrapper.mybringStatus;
  conobj.mobilePhone = wrapper.mobileNumber;
 

  if (wrapper.salesforceStatus == 'active')
   conObj.status__c = 'Aktiv'; // c.status__c;
  else
  if (wrapper.salesforceStatus == 'inactive')   conObj.status__c = 'Inaktiv'; //= 'inactive';
   
   
   //setting the mobile country code field
   
  environment_settings__c mobilecountrycodes= environment_settings__c.getValues('MobileCountryCodes');
  List < String > mobilevaluesList = new List < String > ();
  Map < String, string > MobileCountryCodesMap= new Map < String, String > ();
  List < String > MobileStrList= new List < String > ();
  if (mobilecountrycodes != null && mobilecountrycodes.value__c != null) {
   mobilevaluesList = mobilecountrycodes.value__c.split(',');

   for (String str: mobilevaluesList ) {
    MobileStrList = str.split('=');    mobilecountrycodesMap.put(MobileStrList[0].trim(), MobileStrList[1].trim());

   }

  }
  
  if (wrapper.mobileCountryCode!= null && mobilecountrycodesMap.containskey(wrapper.mobileCountryCode))
   conObj.et4ae5__Mobile_Country_Code__c = mobilecountrycodesMap.get(wrapper.mobileCountryCode);
  else
   conObj.et4ae5__Mobile_Country_Code__c = 'NO';
  
  
  //setting language
  environment_settings__c prefLanguage = environment_settings__c.getValues('Preferred_Language');
  List < String > valuesList = new List < String > ();
  List < String > value = new List < String > ();
  Map < String, string > prefLanguageMap = new Map < String, String > ();
  if (prefLanguage != null && prefLanguage.value__c != null) {
   valuesList = prefLanguage.value__c.split(',');

   for (String str: valuesList) {
    value = str.split('=');    prefLanguageMap.put(value[1], value[0]);

   }

  }
  Boolean isinserted=false;
  Boolean isupdatedwithnoaccount= false;

  if (wrapper.userLanguage != null && prefLanguageMap.containskey(wrapper.userLanguage))
   conObj.Preferred_Language__c = prefLanguageMap.get(wrapper.userLanguage);  else   conObj.Preferred_Language__c = 'English';
	
  conobj.crm_Contact_Type__c = 'Sales';
  if (wrapper.lastLoginDateTime != '' && wrapper.lastLoginDateTime != null)   conobj.crm_myBring_last_login__c = Datetime.valueof(wrapper.lastLoginDateTime);
  else
   conobj.crm_myBring_last_login__c = null;
   
   System.debug('@@' + conobj.My_Bring_Userid__c);
   String marketActivityAgreedTo_str = '';
   if(conobjList.size()>0 ){
   if(conobjList[0].My_Bring_Userid__c!=null  && conobjList[0].My_Bring_Userid__c!='')
   {
         if( Boolean.valueof(wrapper.aggreedMarketingActivities)){
        /* conobj.yes_to_industry_and_service_development__c = true;
         conobj.yes_to_insights_trends_and_analysis__c = true; */
         /*conobj.crm_Has_Agreed_To_Email__c = Boolean.valueof(wrapper.agreedToEmail); 
         conobj.crm_Has_Agreed_to_SMS__c = Boolean.valueof(wrapper.agreedToSms);
         conobj.crm_Has_Agreed_To_MyBring__c = Boolean.valueof(wrapper.agreedToMybring);*/
         conobj.crm_Has_agreed_to_Marketing_actvities__c = Boolean.valueof(wrapper.aggreedMarketingActivities);
             
		 marketActivityAgreedTo_str += Boolean.valueof(wrapper.agreedToEmail) ? 'Email;' : '';
         marketActivityAgreedTo_str += Boolean.valueof(wrapper.agreedToSms) ? 'SMS;' : '';
         marketActivityAgreedTo_str += Boolean.valueof(wrapper.agreedToMybring) ? 'MyBring;' : '';

		 if(marketActivityAgreedTo_str.length()>0 && marketActivityAgreedTo_str != '' && marketActivityAgreedTo_str.endsWith(';')){
              marketActivityAgreedTo_str = marketActivityAgreedTo_str.subString(0,marketActivityAgreedTo_str.length() - 1);
         }
        
         conobj.Marketing_Activities_Agreed_To__c = marketActivityAgreedTo_str;
         }
         else if(Boolean.valueof(wrapper.declinedMarketingActivities)) {
          /*conobj.yes_to_industry_and_service_development__c = false;
          conobj.yes_to_insights_trends_and_analysis__c = false; */
         /* conobj.crm_Has_Agreed_To_Email__c = Boolean.valueof(wrapper.agreedToEmail);
          conobj.crm_Has_Agreed_to_SMS__c = Boolean.valueof(wrapper.agreedToSms);
          conobj.crm_Has_Agreed_To_MyBring__c = Boolean.valueof(wrapper.agreedToMybring);*/
          conobj.crm_No_to_Marketing_activities__c = Boolean.valueof(wrapper.declinedMarketingActivities);
         
          marketActivityAgreedTo_str += Boolean.valueof(wrapper.agreedToEmail) ? 'Email;' : '';
          marketActivityAgreedTo_str += Boolean.valueof(wrapper.agreedToSms) ? 'SMS;' : '';
          marketActivityAgreedTo_str += Boolean.valueof(wrapper.agreedToMybring) ? 'MyBring;' : '';

		  if(marketActivityAgreedTo_str.length()>0 && marketActivityAgreedTo_str != '' && marketActivityAgreedTo_str.endsWith(';')){
              marketActivityAgreedTo_str = marketActivityAgreedTo_str.subString(0,marketActivityAgreedTo_str.length() - 1);
          }
        
          conobj.Marketing_Activities_Agreed_To__c = marketActivityAgreedTo_str;
         }
         
        /* conobj.crm_Has_agreed_to_Marketing_actvities__c = Boolean.valueof(wrapper.aggreedMarketingActivities);
          conobj.crm_No_to_Marketing_activities__c = Boolean.valueof(wrapper.declinedMarketingActivities);
          conobj.crm_Has_Agreed_To_Email__c = Boolean.valueof(wrapper.agreedToEmail);
          conobj.crm_Has_Agreed_to_SMS__c = Boolean.valueof(wrapper.agreedToSms);*/
          
          conobj.Phone = wrapper.phoneNumber;
          conobj.crm_function_working_area__c = wrapper.workingArea;
          
   }
   
 } 

 
  List < Contact > clist = [Select id, email,lastname, firstname, accountid from Contact where email =: wrapper.userEmail and crm_Contact_Type__c = 'Sales' order by status__c asc
   
  ];//and status__c = 'Aktiv'
     
  if (clist.size() > 0 && clist[0].email != null && clist[0].accountid!=null) { 
    if(clist[0].lastname.tolowercase() == wrapper.lastName.tolowercase () ) {
    System.debug(clist[0]);
    System.debug(conobj);
    conobj.id = clist[0].id;   
        
         //Code for contact Log Creation by bhupendra Starts  
   
      List<Contact> contactlogList = New List<Contact>();
      contactlogList.add(conObj);
      String NameCheck = 'Last Name Matched';
      InsertOrUpdateLogResult('update',contactlogList,NameCheck);
      
    //Code for contact Log Creation by bhupendra Ends    
        //update conobj;
}
else {
conobj.id = clist[0].id;
    System.debug('##in else email matched , last name did not match (account!=null)');
//Code for contact Log Creation by bhupendra Starts  
   
      List<Contact> contactlogList = New List<Contact>();
      contactlogList.add(conObj);
      String NameCheck = 'last name did not match';
      InsertOrUpdateLogResult('update',contactlogList,NameCheck);
      
    //Code for contact Log Creation by bhupendra Ends     
//customer update //last name is not matching 
}
  }
  
  else if(clist.size() > 0 && clist[0].email != null && clist[0].accountid==null){
  
  if(clist[0].lastname.tolowercase() == wrapper.lastName.tolowercase () )  {   conobj.id = clist[0].id;   isupdatedwithnoaccount=true;} 
  else {
  
  conobj.id = clist[0].id;
      System.debug('##in else email matched , last name did not match (account==null)');
      //customers update
//Code for contact Log Creation by bhupendra Starts  
   
      List<Contact> contactlogList = New List<Contact>();
      contactlogList.add(conObj);
      String NameCheck = 'last name did not match';
      InsertOrUpdateLogResult('update',contactlogList,NameCheck);
      
    //Code for contact Log Creation by bhupendra Ends 

      
  }
  
  } else {
   conObj.email = wrapper.userEmail;
   isinserted=true;
   }

  List < crm_ContactWrapper.cls_customer > customerdataList = new List < crm_ContactWrapper.cls_customer > ();
 
  customerdataList = wrapper.customers;
  conobj.MyBring_Customer_data__c= String.valueof(customerdataList) ;
  //crm_ContactWrapper.cls_customer customerdata =  new crm_ContactWrapper.cls_customer();
  // customerdata = wrapper.accounts;
  
  Set<String> custNumbers= new Set<String>();
  Map<String, List<String>> custnosMap=  new Map<String, List<String>>();
  if(customerdataList.size()>0){
  for (crm_ContactWrapper.cls_customer cust: customerdataList){
      if(cust.customerMasterNumber!=null && cust.customerMasterNumber!=''){
          //search in SF and craete a indirect relationship
          custNumbers.add(cust.customerMasterNumber);
          custnosMap.put(cust.customerMasterNumber, cust.roles);
       
          
          }
        System.debug('##cust.possibleCustomerNumbers'+ cust.possibleCustomerNumbers);
        if(cust.possibleCustomerNumbers!=null){
         
             System.debug('b4##custNumbers'+ custNumbers); 
             if(custNumbers!=null){
             Boolean t1= custNumbers.addAll(cust.possibleCustomerNumbers);
             //for(Integer i =0; i< cust.possibleCustomerNumbers.size(); i++)
              for (String c: cust.possibleCustomerNumbers)
                 
              custnosMap.put(c, cust.roles);
             }
                 
              else
                 custNumbers= cust.possibleCustomerNumbers;
             System.debug('after##custNumbers'+ custNumbers);
        } 
         
  }
  }//end of size check 
/*  else {
  
    environment_settings__c dummyAcnt= environment_settings__c.getValues('MybringdummyAccount'); 
         if (dummyAcnt!= null && dummyAcnt.value__c != null) { 
           conobj.accountId= dummyAcnt.value__c;   
            update conobj; 
            }
  
 /* List<AccountContactRelation> relationshiplistAvailable= [Select accountid, contactid, Created_from_mybring__c from  AccountContactRelation where contactid=:conObj.id and  isdirect =false]; // and accountId  in :accntids
    
       
       if(relationshiplistAvailable.size()>0)
           delete relationshiplistAvailable; 
      
  
  }
  */  
  
  System.debug('##custNumbers'+ custNumbers);
  System.debug('##isupdatedwithnoaccount'+ isupdatedwithnoaccount);
  
  
 
  List <Messaging.SingleEmailMessage > allmsg = new List < Messaging.SingleEmailMessage > ();
  if(isupdatedwithnoaccount){
  List<Account> relAccountList= [Select id, crm_customer_number__c, parentid from Account where crm_customer_number__c in :custNumbers and parentid!=null];
  if(relAccountList.size()>0){ 
    conobj.accountId= relAccountList[0].parentid;      
      
     //Code for contact Log Creation by bhupendra Starts  
   
      List<Contact> contactlogList = New List<Contact>();
      contactlogList.add(conObj);
      String NameCheck ='Condition Not checked';
      InsertOrUpdateLogResult('update',contactlogList,NameCheck);
      
    //Code for contact Log Creation by bhupendra Ends    
      
      //update conobj;
    
   }
   else
   {
         environment_settings__c dummyAcnt= environment_settings__c.getValues('MybringdummyAccount'); 
         if (dummyAcnt!= null && dummyAcnt.value__c != null) {   conobj.accountId= dummyAcnt.value__c;        
                                                              
  //Code for contact Log Creation by bhupendra Starts  
   
      List<Contact> contactlogList = New List<Contact>();
      contactlogList.add(conObj);
      String NameCheck ='Condition Not checked';
      InsertOrUpdateLogResult('update',contactlogList,NameCheck);
      
    //Code for contact Log Creation by bhupendra Ends                                                                                                          
                                                              //update conobj;  
     }
 }  
   
   }//end of update with no account
 
  if(isinserted){
      List<Account> relAccountList= [Select id, crm_customer_number__c, parentid from Account where crm_customer_number__c in :custNumbers and parentid!=null];
  if(relAccountList.size()>0){ 
    conobj.accountId= relAccountList[0].parentid;
      
    //Code for contact Log Creation by bhupendra Starts  
    // boolean flag =true; 
      List<Contact> contactlogList = New List<Contact>();
      contactlogList.add(conObj);
      String NameCheck ='Condition Not checked';
      InsertOrUpdateLogResult('insert',contactlogList,NameCheck);
      
    //Code for contact Log Creation by bhupendra Ends  
   //  insert conobj;
   }
   else 
   {
         environment_settings__c dummyAcnt= environment_settings__c.getValues('MybringdummyAccount'); 
         if (dummyAcnt!= null && dummyAcnt.value__c != null) { 
           conobj.accountId= dummyAcnt.value__c;         
             
                //Code for contact Log Creation by bhupendra Starts  
   
      List<Contact> contactlogList = New List<Contact>();
      contactlogList.add(conObj);
      String NameCheck ='Condition Not checked';
      InsertOrUpdateLogResult('insert',contactlogList,NameCheck);
      
    //Code for contact Log Creation by bhupendra Ends  
             
             //insert conobj;  
           
          // send email to salesforce@bring.com
           /* Contact newObj= [Select  id , name from  Contact where id = :conobj.id limit 1];
          
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List < string > toAddress = new List < string > ();         
            
            ///setting emaail notification
  environment_settings__c emailnotifications = environment_settings__c.getValues('MyBringEmailNotification');
  List < String > valuesList1 = new List < String > ();
  
  if (emailnotifications != null && emailnotifications.value__c != null) 
   valuesList1 = emailnotifications.value__c.split(',');

       for (String emailuser:valuesList1 )  
          
            toAddress.add(emailuser);
            mail.setToAddresses(toAddress );
            //mail.setTargetObjectId(opps.crm_Primary_Opportunity_Contact__c);
            mail.setSaveAsActivity(false);            mail.setUseSignature(false);
            mail.setSubject('Mybring Contact is attached to dummy Account');
            String reason = '';

            string emailbody = 'Hello ' + ',';
            emailbody = emailbody + '<br/> <br/> The contact ' + newObj.Name + '  is attached to the dummy account';
            emailbody  = emailbody + '<br/> ';            emailbody = emailbody + '<br/> <br/> Thanks, <br/> Salesforce Support';
            mail.setHtmlBody(emailbody );

            allmsg.add(mail);
            try {               Messaging.SendEmailResult[] emailResults=  Messaging.sendEmail(allmsg, false);         system.debug('emailResults'+ emailResults);
            } catch (Exception e) {                System.debug(e.getMessage());            }
            
            system.debug('allmsg'+ allmsg);*/
            
            
         
         } //end of check dummy account
         
   }
  }//end of inserted 
  createAccountContactrelation(custNumbers, conobj.id, custnosMap);     
  System.debug(customerdataList);

  return String.valueof(conobj.id);
 }
 
 public static void createAccountContactrelation(Set<String> Custnos, String conId, Map<String, List<String>>custnosMap){
 System.debug('@@@Custnos'+ Custnos);
  List<Account> AccountList= [Select id, crm_customer_number__c from Account where crm_customer_number__c in :Custnos];
  if(AccountList.size()>0){
      Set<Id> accntids = new Set<Id>();
      Set<Id> availableaccntids = new Set<Id>();
      Set<Id> relaccntIdstoadd = new Set<Id>();
      Map<String, String>custidMap =  new Map<String, String>();
      for (Account a : AccountList){
          accntids.add(a.id);
          custidMap.put(a.id, a.crm_customer_number__c);
          
      }
          System.debug('@@@accntids'+ accntids);//2 accounts
          
    List<AccountContactRelation> relationshiptodelete= new List<AccountContactRelation>();
    
    List<AccountContactRelation> relationshiplistAvailable= [Select accountid, contactid, Created_from_mybring__c from  AccountContactRelation where contactid=:conId ]; // and accountId  in :accntids
    if(relationshiplistAvailable.size()>0){
    for(AccountContactRelation rel: relationshiplistAvailable){ //123456 
           availableaccntids.add(rel.accountId); 
        //   if (rel.Created_from_mybring__c)
          //     relationshiptodelete.add(rel);//123456
           }
       }
       System.debug('@@@availableaccntids'+ availableaccntids);
            System.debug('@@@relationshiptodelete'+ relationshiptodelete);
       
      // if(relationshiptodelete.size()>0)
        //   delete relationshiptodelete;        
           
           
     for (String AccntId : accntids){
         if( !availableaccntids.contains(AccntId))
             relaccntIdstoadd.add(AccntId );
           }   
   
  List<AccountContactRelation> relationshiplist=new List<AccountContactRelation>();
   System.debug('@@@relaccntIdstoadd'+ relaccntIdstoadd);
   for (String AccntId :relaccntIdstoadd){
   
        AccountContactRelation  relationship= new AccountContactRelation();
        relationship.Accountid = AccntId; //accountid;
        relationship.Contactid = conId;
        relationship.Created_from_mybring__c= true;    
        String custumerno = custidMap.get(AccntId);
        List<String> rolesList =new List<String>();
        if(custnosMap.containskey(custumerno))
            rolesList= custnosMap.get(custumerno);
        String str='';
        for (String c: rolesList)
            str+=c +' ,';
            
            if(str.length()!=0)
                str= str.substring(0, str.length()-1);
            
            relationship.roles__c = str; 
        relationshiplist.add(relationship);
    
   }
    System.debug(relationshiplist);
   
   if(relationshiplist.size()>0)
       insert relationshiplist;
   
  
  }
   
 
 }
//code Starts for Log creation of Update and Insert by Bhupendra 
  
       //Insert or Update result log
    public static void InsertOrUpdateLogResult(String operationName, List<Contact> insertUpdateResultList,String NameCheck)
    {
        List<ContactLogCreation__c> logList = new List<ContactLogCreation__c>();
       // String NameCheckError = NameCheck;
        // logList.addAll(insertResultList);
        if(operationName.equalsIgnoreCase('insert'))
        {
            Database.SaveResult[] srList = Database.insert(insertUpdateResultList, false);
            for (Database.SaveResult ur: srList) 
            {               
                if (ur.isSuccess())
                {
                    logList.add(createContactLog(insertUpdateResultList[0], NameCheck, ur, 'Success', operationName)); 
                }
                else
                {
                    logList.add(createContactLog(insertUpdateResultList[0], NameCheck, ur, 'Error', operationName));
                }
            }
        }
            if(!logList.isEmpty())
            {
                Insert logList;
            }   
        else if(operationName=='update')
        {
            if (NameCheck.equalsIgnoreCase('last name did not match'))
            {
                logList.add(createContactLog(insertUpdateResultList[0], NameCheck, null, 'Error', operationName));
            }
            else
            {
                Database.SaveResult[] srList = Database.update(insertUpdateResultList, false);
                for (Database.SaveResult ur: srList)
                {
                    if (ur.isSuccess())
                    {
                        logList.add(createContactLog(insertUpdateResultList[0], NameCheck, ur, 'Success', operationName)); 
                    }
                    else
                    {   
                        logList.add(createContactLog(insertUpdateResultList[0], NameCheck, ur, 'Error', operationName));  
                    }
                }
            }
            
        }
        if(!logList.isEmpty())
        {
            database.Insert(logList, false);
            Savepoint sp = Database.setSavepoint();
        }
}
  //code Ends for Log creation of Update and Insert  by Bhupendra  
  
     /*
* Method Name: createContactLog
* Parameter 1 : insertUpdateResult--> instance of contact being inserted or updated
* Parameter 2 : NameCheck --> Error from the required checks
* Parameter 3 : SaveRslt --> Result of the DML operation on the contact
* Parameter 4 : OpType --> type of the save result, expected values are "Success"/"Error"
*/
    public static ContactLogCreation__c createContactLog(Contact InsertUpdateResult, String NameCheck, Database.SaveResult SaveRslt, string OpType, string OpName)
    {
        ContactLogCreation__c ContactLog = new ContactLogCreation__c();
        if (insertUpdateResult != null)
        {
            ContactLog.Type__c = OpType;
            ContactLog.MyBring_Last_Login__c= insertUpdateResult.crm_myBring_last_login__c;
            ContactLog.My_Bring_Userid__c= insertUpdateResult.My_Bring_Userid__c;
            ContactLog.MyBring_User__c = insertUpdateResult.crm_myBring_user__c;
            ContactLog.Contact_Id__c = InsertUpdateResult.id;
            system.debug('Save result >>>' +SaveRslt);
            if(OpType.equalsIgnoreCase('Error'))
            {
               if(SaveRslt != null)
                   ContactLog.Error_Description__c= OpName +' - ' + NameCheck+ ' - ' +String.valueOf(SaveRslt.getErrors()[0].getMessage());
                else
                    ContactLog.Error_Description__c= OpName +' - ' + NameCheck ;
            }
                
            ContactLog.Object__c = 'Contact';
            ContactLog.Record_Id__c = InsertUpdateResult.id;
        }
        return ContactLog;
    }
    
    
    

//Changes made here. Adding a method to set the mybring user flag true for relation level customer.    
 public static void updateCSContacts(Set<Id> csContactIds, crm_ContactWrapper wrapper){
     system.debug('Inside updateCSContacts method');
     
     List<Contact> csContactList = [Select Id, Mybring_User__c, crm_myBring_last_login__c, My_Bring_Userid__c, crm_myBring_user__c from contact where Id IN :csContactIds];
     system.debug('csContactList --> '+csCOntactList);
     
     List<Contact> contactsToUpdate = New List<Contact>();
     Set<String> inactiveContactList = New Set<String>();
     
     if(csContactList.size() > 0){
     for(Contact conObj : csContactList){
         if(wrapper.mybringStatus.equalsIgnoreCase('active')){
             conObj.Mybring_User__c = true;
                 
             List<Contact> contactlogList = New List<Contact>();
      		 contactlogList.add(conObj);
     		 String NameCheck ='Active MyBring User';
     		 InsertOrUpdateLogResult('update',contactlogList,NameCheck);
                 
             //contactsToUpdate.add(conObj);
         
         	//Update Roles in Account Contact Relation
         
         	 List<crm_ContactWrapper.cls_customer> custList = New List<crm_ContactWrapper.cls_customer>();
             custList = wrapper.customers;
             Set<String> custNumbers= new Set<String>();
             Map<String, List<String>> custnosMap=  new Map<String, List<String>>();
        
             if(custList.size()>0){
             	for (crm_ContactWrapper.cls_customer cust: custList){
          			if(cust.customerMasterNumber!=null && cust.customerMasterNumber!=''){
                        //search in SF and create a indirect relationship
                        custNumbers.add(cust.customerMasterNumber);
                        custnosMap.put(cust.customerMasterNumber, cust.roles);
              		}
             		System.debug('##cust.possibleCustomerNumbers'+ cust.possibleCustomerNumbers);
             		if(cust.possibleCustomerNumbers!=null){
             
                        System.debug('b4##custNumbers'+ custNumbers); 
                        if(custNumbers!=null){
                            Boolean t1= custNumbers.addAll(cust.possibleCustomerNumbers);
                            for (String c: cust.possibleCustomerNumbers){
                                custnosMap.put(c, cust.roles);
                            }
                        }
                         
                        else{
                            custNumbers= cust.possibleCustomerNumbers;
                        }
                            
                        System.debug('after##custNumbers'+ custNumbers);
            		} 
             
       			}
             	insertUpdateCSContactrelation(custNumbers, conobj.id, custnosMap);
     		  }
             else{
                 system.debug('custList --> '+ custList);
                 system.debug('No Customers in the payload for the given contact');
             }
			}
            else if(wrapper.mybringStatus.equalsIgnoreCase('inactive')){
                 conObj.Mybring_User__c = false;
                 List<Contact> contactlogList = New List<Contact>();
                 contactlogList.add(conObj);
                 String NameCheck ='Inactive MyBring User';
                 InsertOrUpdateLogResult('update',contactlogList,NameCheck);
                 inactiveContactList.add(conObj.Id);
            }
 		}
                 system.debug('inactiveContactList --> '+inactiveContactList);
         
        //Delete roles from inactive contacts.
        List<AccountContactRelation> removeRolesList = New List<AccountContactRelation>();
         if(inactiveContactList.size()>0){
             for(AccountContactRelation acrObj : [Select Id, Roles__c from accountContactRelation where contactId IN :inactiveContactList]){
             	 system.debug('acrObj --> '+acrObj);
                 acrObj.Roles__c = '';
                 removeRolesList.add(acrObj);
             }
                 system.debug('removeRolesList --> '+removeRolesList);
             update removeRolesList;
         }
        
     }
     
     //update contactsToUpdate;
     //update Roles finished
     
     Set<Id> accId = New Set<Id>();
     
     for(accountContactRelation acr : [Select accountId, account.RecordType.Name from accountContactRelation where contactId IN :csContactIds]){
         if(acr.account.RecordType.Name == 'Relation Level Customer'){
         accId.add(acr.accountId);
         }
     }
     
     system.debug('accId --> '+ accId);
     
     integer count = 0;
     List<AccountContactRelation> acrList = New List<AccountContactRelation>();
     acrList = [Select contactid, AccountId, contact.mybring_user__c from AccountContactRelation where accountId IN :accId];
     system.debug('acrList --> '+acrList);
     
     Map<Id, List<Contact>> acrMap = new Map<Id, List<Contact>>();
     for(accountContactRelation acr : acrList){
         if (!acrMap.containsKey(acr.AccountId)) {
             acrMap.put(acr.AccountId, new List<Contact>());
         }
         Contact c = New Contact();
         c.id = acr.contactId;
         c.Mybring_User__c = acr.contact.mybring_user__c;
         
         acrMap.get(acr.AccountId).add(c);
         
     }
     system.debug('acrMap --> '+acrMap); 
     List<Account> accToUpdate = New List<Account>();
     for(Account a : [Select Id, Has_Mybring_Account__c from Account Where Id in :acrMap.keySet()]){
         for(Contact c : acrMap.get(a.Id)){
             if(c.mybring_user__c == True){
               count+= 1;
             }
             else{
                a.Has_Mybring_Account__c = False;
             }
         }
         If(count>0){
             a.Has_Mybring_Account__c = True;
         }
         accToUpdate.add(a);
       }
      update accToUpdate;
     }
    
    public static void insertUpdateCSContactrelation(Set<String> Custnos, String conId, Map<String, List<String>>custnosMap) {
      System.debug('@@@Custnos'+ Custnos);
      List<Account> AccountList= [Select id, crm_customer_number__c from Account where crm_customer_number__c in :Custnos];
      if(AccountList.size()>0) {
          Set<Id> accntids = new Set<Id>();
          Set<Id> availableaccntids = new Set<Id>();
          Set<Id> relaccntIdstoadd = new Set<Id>();
          Set<Id> availableAccContactRelation = new Set<Id>();
          Map<String, String>custidMap =  new Map<String, String>();
          for (Account a : AccountList){
              accntids.add(a.id);
              custidMap.put(a.id, a.crm_customer_number__c);
              
          }
              System.debug('@@@accntids'+ accntids);//2 accounts
              
        List<AccountContactRelation> relationshiptodelete= new List<AccountContactRelation>();
        
        List<AccountContactRelation> relationshiplistAvailable= [Select accountid, contactid, Created_from_mybring__c from  AccountContactRelation where contactid=:conId ]; // and accountId  in :accntids
        if(relationshiplistAvailable.size()>0){
        for(AccountContactRelation rel: relationshiplistAvailable){ //123456 
               availableaccntids.add(rel.accountId); 
            //   if (rel.Created_from_mybring__c)
              //     relationshiptodelete.add(rel);//123456
               }
           }
           System.debug('@@@availableaccntids'+ availableaccntids);
                System.debug('@@@relationshiptodelete'+ relationshiptodelete);
           
          // if(relationshiptodelete.size()>0)
            //   delete relationshiptodelete;        
               
               
         for (String AccntId : accntids){
             if( !availableaccntids.contains(AccntId)){
                 relaccntIdstoadd.add(AccntId );
             }
             else{
             	  availableAccContactRelation.add(AccntId);
             }
      }
      List<AccountContactRelation> relationshiplist=new List<AccountContactRelation>();
       System.debug('@@@relaccntIdstoadd'+ relaccntIdstoadd);
          if(relaccntIdstoadd.size() > 0){
       		for (String AccntId :relaccntIdstoadd){
       
                AccountContactRelation  relationship= new AccountContactRelation();
                relationship.Accountid = AccntId; //accountid;
                relationship.Contactid = conId;
                relationship.Created_from_mybring__c= true;    
                String custumerno = custidMap.get(AccntId);
                List<String> rolesList =new List<String>();
                if(custnosMap.containskey(custumerno))
                    rolesList= custnosMap.get(custumerno);
                String str='';
                for (String c: rolesList)
                    str+=c +' ,';
                    
                    if(str.length()!=0)
                        str= str.substring(0, str.length()-1);
                    
                    relationship.roles__c = str; 
                relationshiplist.add(relationship);
        
       }
      }
        System.debug(relationshiplist);
       
       if(relationshiplist.size()>0)
           insert relationshiplist;
          
         //Update Method 
         List<AccountContactRelation> updateContactRolesList = New List<AccountContactRelation>();
         List<String> updatedRoles = New List<String>();
         
       if(availableAccContactRelation.size()>0){
           List<AccountContactRelation> acrToUpdate = [Select Id, roles__c, AccountId from AccountContactRelation where contactId = :conId AND accountId IN :availableAccContactRelation];
           system.debug('acrToUpdate --> '+acrToUpdate);
           for(AccountContactRelation acr : acrToUpdate){
                 String customerno = custidMap.get(acr.AccountId);
               system.debug('Customerno --> '+customerNo);
                 if(custnosMap.containskey(customerno))
            		 updatedRoles= custnosMap.get(customerno);
               system.debug('updatedRoles --> '+UpdatedRoles);
       				 String str='';
        			for (String c: updatedRoles)
            			str+=c +' ,';
            
            		if(str.length()!=0)
                		str= str.substring(0, str.length()-1);
               system.debug('Roles --> '+str);
            
            		acr.roles__c = str; 
        			updateContactRolesList.add(acr);
           }    
           update updateContactRolesList;
       }
          
       //Delete roles for contacts for which their is no relationship in mybring payload
          Set<String> acrNotInMybring = New Set<String>();
          system.debug('relationshiplistAvailable -->'+relationshiplistAvailable);
          system.debug('accntIds --> '+accntIds);
          for(AccountContactRelation acr : relationshiplistAvailable){
              if(!accntIds.contains(acr.AccountId)){
                  acrNotInMybring.add(acr.AccountId);
              }
          }
          system.debug('acrNotInMybring --> '+acrNotInMybring);
          
          List<AccountContactRelation> accountContactRolesToDelete = [Select Id, accountId, contactId, roles__c from accountContactRelation where contactId = :conId and accountId IN :acrNotInMybring];
          List<AccountContactRelation> removeAccountContactRoles = New List<AccountContactRelation>();
          for(AccountContactRelation acr : accountContactRolesToDelete){
              acr.Roles__c = '';
              removeAccountContactRoles.add(acr);
          }
          system.debug('removeAccountContactRoles --> '+removeAccountContactRoles);
          system.debug('accountContactRolesToDelete --> '+accountContactRolesToDelete);
          update removeAccountContactRoles;
      }
     }
    
}