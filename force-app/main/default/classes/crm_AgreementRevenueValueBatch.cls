/*
Created By:Supriya Goel
Date: 29 March 2016 (Sprint 5)
update the value for the realised contract value
– if Agreement Start Date is within 365 days of TODAY, summarize Amount field from all Revenue Lines within 365 days of Agreement Start Date.  If Agreement Start Date is more than 365 days from TODAY, summarize Amount field for all Revenue Lines in most recent agreement year.  
I.e. if Agreement Start Date is 01.10.2014 and TODAY is 28.02.2016, Realized Contract Value should be sum of Revenue Lines in period 01.10.2015-TODAY.
*/

global class crm_AgreementRevenueValueBatch implements Database.batchable < sObject > , Database.Stateful {
 public string callback = '';

 global crm_AgreementRevenueValueBatch(String callback) {
  this.callback = callback;
 }

 global Database.QueryLocator start(Database.BatchableContext BC) {
   string status = 'Draft';
   //String agrid ='a1z1q000004fY3WAAU';
    //calculate for all active agreement
  String query = 'Select id,crm_Agreement_Start_Date__c,crm_account__c, crm_Realized_Contract_Value__c,crm_Status__c, Realized_New_Revenue_2018__c,Realized_New_Revenue_2019__c,Realized_New_Revenue_2020__c,Realized_New_Revenue_2021__c,CurrencyIsoCode, crm_Annual_Contract_Value__c, crm_Monthly_Contracted_Value__c from crm_Agreement__c  where crm_Status__c!= :status order by lastmodifieddate desc'; //
  return Database.getQueryLocator(query);
 }


 global void execute(Database.BatchableContext BC, List < crm_Agreement__c > agrlist) {

  Map < id, Decimal > AgrcontractvalueMap = new Map < id, Decimal > ();

  Map < id, Decimal > AgrNewRevValueMap = new Map < id, Decimal > ();
  Map < id, Decimal > AgrNewRevValue2018Map = new Map < id, Decimal > ();
  Map < id, Decimal > AgrNewRevValue2019Map = new Map < id, Decimal > ();
  Map < id, Decimal > AgrNewRevValue2020Map = new Map < id, Decimal > ();
  Map < id, Decimal > AgrNewRevValue2021Map = new Map < id, Decimal > ();
  List < crm_Revenue_Line__c > listUpdatedRevenueLine = new List < crm_Revenue_Line__c >();


  Set < Id > Agrids = new Set < Id > ();
  Map < Id, String > agrCurrencyMap = new Map < Id, String > ();
  //get all the system currency
  Map < String, decimal > currencyMap = new Map < String, decimal > ();
  List < CurrencyType > currencyList = [SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive = TRUE];
  for (CurrencyType ctype: currencyList) {
   currencyMap.put(ctype.ISOCode, ctype.ConversionRate);
  }

  Map < Id, Decimal > agrMap = new Map < Id, Decimal > ();

  Date dateToCompare = date.newInstance(Date.today().year(), Date.today().month(), 1).addyears(-1); //1st march 2018 
  System.debug('$$dateToCompare' + dateToCompare);
  Date startdate = Date.today();
  Date enddate = date.newInstance(Date.today().year(), Date.today().month(), 1).adddays(-1); //28th feb 2019  // ((MonthStart(Today()))-1day)  
  integer noOfMonths = 0;
  Map < ID, Decimal > ExpectedValueList = new map < ID, Decimal > ();
  Set < Id > AccntIds = new Set < Id > ();


  /*Expected  relaised revenue
         For less than 1 year, calculate number of months from Agreement start date TO ((MonthStart(Today()))-1day)
        Multiply this by MCV 
        */
  for (crm_Agreement__c agr: agrlist) {
   Agrids.add(agr.id);
   agrCurrencyMap.put(agr.id, agr.currencyisocode);
   if (agr.crm_Agreement_Start_Date__c >= dateToCompare) { // dattocompare = 1st march 2018 
    startdate = date.newInstance( agr.crm_Agreement_Start_Date__c.year(),  agr.crm_Agreement_Start_Date__c.month(), 1); 
    
   

    system.debug('startdate' + startdate);
    noOfMonths = startdate.monthsBetween(enddate) + 1;
    ExpectedValueList.put(agr.id, (noOfMonths * agr.crm_Monthly_Contracted_Value__c));


   } else {
    startdate=dateToCompare;
    ExpectedValueList.put(agr.id, agr.crm_Annual_Contract_Value__c);
   }
  }

  System.debug('$$Agrids' + Agrids);

  List < crm_Revenue_Line__c > revlinelist = [Select crm_Agreement__c,isTransactionDatePrecedeAgrStartDate__c, crm_Amount__c, crm_Agreement__r.crm_Monthly_Contracted_Value__c, crm_Agreement__r.crm_Annual_Contract_Value__c, crm_Agreement__r.crm_Agreement_Start_Date__c, crm_Transaction_Date__c, crm_Revenue_Type__c, crm_Transaction_Year__c, Currencyisocode from crm_Revenue_Line__c where crm_Transaction_Date__c <= TODAY and crm_Agreement__c in: Agrids];
  System.debug('$$revlinelist ' + revlinelist);
  for (crm_Revenue_Line__c rev: revlinelist) {


 if (rev.crm_Agreement__r.crm_Agreement_Start_Date__c >= dateToCompare) {
  
    startdate = date.newInstance(rev.crm_Agreement__r.crm_Agreement_Start_Date__c.year(), rev.crm_Agreement__r.crm_Agreement_Start_Date__c.month(), 1);  //1 march 2019 
    enddate=  date.newInstance(Date.today().year(), Date.today().month(), 1).adddays(-1); //28th feb 2019  // ((MonthStart(Today()))-1day) 

    //rev.crm_Agreement__r.crm_Agreement_Start_Date__c;   //jan  2018 

   } else {
    startdate = dateToCompare; //1st march 2018
   enddate= date.newInstance(Date.today().year(), Date.today().month(), 1).adddays(-1); //28th feb 2019  // ((MonthStart(Today()))-1day) 
   }

   System.debug('$$startdate ' + startdate + 'enddate' + enddate);


   /*
            
   start date = agreemnt start date = 1st march 2019 
    endddate= 28th feb 2019
            
   The Realized amount calculation needs to be updated
   As below
   All revenue with transaction date between     
   ( Agreement Start Date OR  ((MonthStart(Today()))-1year))    TO   ((MonthStart(Today()))-1day)
            
    the updated formula is 

   */
   //
   
   
   if ((rev.crm_Transaction_Date__c >= startdate && rev.crm_Transaction_Date__c <= enddate) || rev.isTransactionDatePrecedeAgrStartDate__c) {
    System.debug('$$rev.crm_Transaction_Date__c' + rev.crm_Transaction_Date__c);
    Decimal totalamount = 0;
    Decimal Amount = 0;
    if (AgrcontractvalueMap.containsKey(rev.crm_Agreement__c)) {
     Amount = rev.crm_amount__c.divide(currencyMap.get(rev.CurrencyISOCode), 2, System.RoundingMode.UP);  totalamount = AgrcontractvalueMap.get(rev.crm_Agreement__c) + Amount;  AgrcontractvalueMap.put(rev.crm_Agreement__c, totalamount);
    } else {
     Amount = rev.crm_amount__c.divide(currencyMap.get(rev.CurrencyISOCode), 2, System.RoundingMode.UP);  AgrcontractvalueMap.put(rev.crm_Agreement__c, Amount);
    }
    rev.isTransactionDatePrecedeAgrStartDate__c = false;
    listUpdatedRevenueLine.add(rev);

   }

  } //end of for 

  system.debug('ExpectedValueList' + ExpectedValueList); //((MonthStart(Today()))-1year));  

  System.debug('$$AgrcontractvalueMap' + AgrcontractvalueMap);

  revlinelist = [Select crm_Agreement__c, crm_Amount__c, crm_Transaction_Date__c, crm_Revenue_Type__c, crm_Transaction_Year__c, CurrencyIsoCode from crm_Revenue_Line__c where crm_Agreement__c in: Agrids and crm_Revenue_Type__c = 'New'];
  System.debug('$$revline' + revlinelist);
  for (crm_Revenue_Line__c rev: revlinelist) {
   Decimal totalamount = 0;
   Decimal Amount = 0;
   Decimal Amount2019 = 0;
   Decimal totalamount2019 = 0;
   Decimal Amount2020 = 0;
   Decimal totalamount2020 = 0;
   Decimal Amount2021 = 0;  
   Decimal totalamount2021 = 0; 
   

   if (AgrNewRevValueMap.containsKey(rev.crm_Agreement__c) && rev.crm_Revenue_Type__c == 'New') {
    Amount = rev.crm_amount__c.divide(currencyMap.get(rev.CurrencyISOCode), 2, System.RoundingMode.UP);
    totalamount = AgrNewRevValueMap.get(rev.crm_Agreement__c) + Amount;
    AgrNewRevValueMap.put(rev.crm_Agreement__c, totalamount);
   } else if (rev.crm_Revenue_Type__c == 'New') {
    Amount = rev.crm_amount__c.divide(currencyMap.get(rev.CurrencyISOCode), 2, System.RoundingMode.UP);
    AgrNewRevValueMap.put(rev.crm_Agreement__c, Amount);
   }

   if (AgrNewRevValue2018Map.containsKey(rev.crm_Agreement__c) && rev.crm_Transaction_Year__c == 2018 && rev.crm_Transaction_Date__c <= enddate && rev.crm_Revenue_Type__c == 'New') {
    Amount = rev.crm_amount__c.divide(currencyMap.get(rev.CurrencyISOCode), 2, System.RoundingMode.UP);
    totalamount = AgrNewRevValue2018Map.get(rev.crm_Agreement__c) + Amount;
    AgrNewRevValue2018Map.put(rev.crm_Agreement__c, totalamount);
   } else if (rev.crm_Revenue_Type__c == 'New' && rev.crm_Transaction_Year__c == 2018 && rev.crm_Transaction_Date__c <= enddate) {
    Amount = rev.crm_amount__c.divide(currencyMap.get(rev.CurrencyISOCode), 2, System.RoundingMode.UP);
    AgrNewRevValue2018Map.put(rev.crm_Agreement__c, Amount);
   }

   /* 2019 field changes */

   if (AgrNewRevValue2019Map.containsKey(rev.crm_Agreement__c) && rev.crm_Transaction_Year__c == 2019 && rev.crm_Transaction_Date__c <= enddate && rev.crm_Revenue_Type__c == 'New') {
    Amount2019 = rev.crm_amount__c.divide(currencyMap.get(rev.CurrencyISOCode), 2, System.RoundingMode.UP);
    totalamount2019 = AgrNewRevValue2019Map.get(rev.crm_Agreement__c) + Amount2019;    AgrNewRevValue2019Map.put(rev.crm_Agreement__c, totalamount2019);
   } else if (rev.crm_Revenue_Type__c == 'New' && rev.crm_Transaction_Year__c == 2019 && rev.crm_Transaction_Date__c <= enddate) {
    Amount2019 = rev.crm_amount__c.divide(currencyMap.get(rev.CurrencyISOCode), 2, System.RoundingMode.UP);    AgrNewRevValue2019Map.put(rev.crm_Agreement__c, Amount2019);
   }
    /* 2020 field changes */

   if (AgrNewRevValue2020Map.containsKey(rev.crm_Agreement__c) && rev.crm_Transaction_Year__c == 2020 && rev.crm_Transaction_Date__c <= enddate && rev.crm_Revenue_Type__c == 'New') {
    Amount2020 = rev.crm_amount__c.divide(currencyMap.get(rev.CurrencyISOCode), 2, System.RoundingMode.UP);
    totalamount2020 = AgrNewRevValue2020Map.get(rev.crm_Agreement__c) + Amount2020;    AgrNewRevValue2020Map.put(rev.crm_Agreement__c, totalamount2020);
   } else if (rev.crm_Revenue_Type__c == 'New' && rev.crm_Transaction_Year__c == 2020 && rev.crm_Transaction_Date__c <= enddate) {
    Amount2020 = rev.crm_amount__c.divide(currencyMap.get(rev.CurrencyISOCode), 2, System.RoundingMode.UP);    AgrNewRevValue2020Map.put(rev.crm_Agreement__c, Amount2020);
   }
    if (AgrNewRevValue2021Map.containsKey(rev.crm_Agreement__c) && rev.crm_Transaction_Year__c == 2021 && rev.crm_Transaction_Date__c <= enddate && rev.crm_Revenue_Type__c == 'New') { 
    Amount2021 = rev.crm_amount__c.divide(currencyMap.get(rev.CurrencyISOCode), 2, System.RoundingMode.UP); 
    totalamount2021 = AgrNewRevValue2021Map.get(rev.crm_Agreement__c) + Amount2021;    AgrNewRevValue2021Map.put(rev.crm_Agreement__c, totalamount2021);    
   } else if (rev.crm_Revenue_Type__c == 'New' && rev.crm_Transaction_Year__c == 2021 &&  rev.crm_Transaction_Date__c <= enddate) { 
    Amount2021 = rev.crm_amount__c.divide(currencyMap.get(rev.CurrencyISOCode), 2, System.RoundingMode.UP);    AgrNewRevValue2021Map.put(rev.crm_Agreement__c, Amount2021); 
   }

  }


  System.debug('@@AgrNewRevValue2018Map' + AgrNewRevValue2018Map);
  System.debug('@@AgrNewRevValue2020Map' + AgrNewRevValue2020Map); 
   System.debug('@@AgrNewRevValue2021Map' + AgrNewRevValue2021Map);     
 




  //update realized contract value for all the agreements 
  for (crm_Agreement__c agr: agrlist) {
   String agrCurrency = agrCurrencyMap.get(agr.id);
   if (AgrcontractvalueMap.containskey(agr.id)) {
    Decimal realisedvalue = AgrcontractvalueMap.get(agr.id) * currencyMap.get(agrCurrency);
    agr.crm_Realized_Contract_Value__c = realisedvalue;

   } else
    agr.crm_Realized_Contract_Value__c = 0;



   if (AgrNewRevValueMap.containskey(agr.id)) {

    Decimal realisednewvalue = AgrNewRevValueMap.get(agr.id) * currencyMap.get(agrCurrency);  agr.Realized_New_Revenue__c = realisednewvalue;

   } else
    agr.Realized_New_Revenue__c = 0;

   if (AgrNewRevValue2018Map.containskey(agr.id)) {
    Decimal realisednewvalue2018 = AgrNewRevValue2018Map.get(agr.id) * currencyMap.get(agrCurrency);
    agr.Realized_New_Revenue_2018__c = realisednewvalue2018;

   } else
    agr.Realized_New_Revenue_2018__c = 0;

   if (AgrNewRevValue2019Map.containskey(agr.id)) {
    Decimal realisednewvalue2019 = AgrNewRevValue2019Map.get(agr.id) * currencyMap.get(agrCurrency);    agr.Realized_New_Revenue_2019__c = realisednewvalue2019;

   } else
    agr.Realized_New_Revenue_2019__c = 0;

   if (AgrNewRevValue2020Map.containskey(agr.id)) {
    Decimal realisednewvalue2020 = AgrNewRevValue2020Map.get(agr.id) * currencyMap.get(agrCurrency);    agr.Realized_New_Revenue_2020__c = realisednewvalue2020;

   } else
    agr.Realized_New_Revenue_2020__c = 0;
    
     if (AgrNewRevValue2021Map.containskey(agr.id)) {   
    Decimal realisednewvalue2021 = AgrNewRevValue2021Map.get(agr.id) * currencyMap.get(agrCurrency);    agr.Realized_New_Revenue_2021__c = realisednewvalue2021;    
   } else   
    agr.Realized_New_Revenue_2021__c = 0;
   //check this
   if (ExpectedValueList.containsKey(agr.id))
    agr.Expected_Realized_Amount__c = ExpectedValueList.get(agr.id);


  }

  System.debug('$$$agrlist ' + agrlist);

  try {
   Database.update(agrlist, false);
   if(!listUpdatedRevenueLine.isEmpty()){
          Database.update(listUpdatedRevenueLine , false);
      
   }
  } catch (Exception e) {   crm_Exception_handler.createExceptionRecords(e);  }

  Map < id, Decimal > AccountResults = new Map < id, Decimal > ();
  List < Account > AccountList = [select id, crm_Realized_Contract_Value__c, Currencyisocode from Account where id in: AccntIds];
  Map < Id, String > accountCurrencyMap = new Map < Id, String > ();
  for (Account a: AccountList) {   accountCurrencyMap.put(a.id, a.currencyisocode);  }
  List < crm_agreement__c > agrList1 = [Select id, crm_Realized_Contract_Value__c, crm_Account__c, CurrencyISOCode from crm_agreement__c where crm_Realized_Contract_Value__c != null and crm_Account__c in: AccntIds];

  for (crm_agreement__c agr: agrList1) {
   Decimal totalamount = 0;
   Decimal Amount = 0;

   if (AccountResults.containsKey(agr.crm_Account__c)) {
    Amount = agr.crm_Realized_Contract_Value__c.divide(currencyMap.get(agr.CurrencyISOCode), 2, System.RoundingMode.UP);
    totalamount = AccountResults.get(agr.crm_Account__c) + Amount;   AccountResults.put(agr.crm_Account__c, totalamount);
   } else {
    Amount = agr.crm_Realized_Contract_Value__c.divide(currencyMap.get(agr.CurrencyISOCode), 2, System.RoundingMode.UP);  AccountResults.put(agr.crm_Account__c, Amount);
   }

  }

  /*  for(AggregateResult agg : [Select sum(crm_Realized_Contract_Value__c) amount,  crm_Account__c from crm_agreement__c where crm_Realized_Contract_Value__c !=null and crm_Account__c  in :AccntIds group by crm_Account__c ]){
               AccountResults.put((Id)agg.get('crm_Account__c'),(Decimal)agg.get('amount'));
               }*/

  System.debug('@@AccountResults' + AccountResults);
  for (Account acnt: AccountList) {
   if (AccountResults.containskey(acnt.id)) {
    Decimal realisedvalue = AccountResults.get(acnt.id) * currencyMap.get(acnt.CurrencyISOCode);  acnt.crm_Realized_Contract_Value__c = realisedvalue;
   } else
    acnt.crm_Realized_Contract_Value__c = 0;
  }
  try {
   if (AccountList.size() > 0)   Database.update(AccountList, false);
  } catch (Exception e) {   crm_Exception_handler.createExceptionRecords(e); }


 }

 global void finish(Database.BatchableContext BC) {
  String str = '';
  AsyncApexJob[] a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ApexClass.Name from AsyncApexJob where Id =: bc.getJobId()];
  if (callback != '' && callback != null)
   str += callback + '\n';

  if (a != null && a.size() > 0) {
   str += a[0].ApexClass.Name + ' ( ' + a[0].Id + ' ' + a[0].status + ')  processed ' + a[0].TotalJobItems + ' batches with ' + a[0].NumberOfErrors + ' failures.';
  }

  if (!Test.IsRunningTest())
   Database.executeBatch(new crm_AgreementCalculationBatch(str));
 }

}