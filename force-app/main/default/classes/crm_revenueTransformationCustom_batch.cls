/*
Created By: Supriya Goel
Object  :Revenue Batch
Date: sprint 5
Revenue transformation batch
*/

global class crm_revenueTransformationCustom_batch implements Database.Batchable<SObject>{

        String queryString = '';
        String id= '';
        public string callback = '';
         public Set <string> tempid=  new Set<String>();
         
                   
        public crm_revenueTransformationCustom_batch(String id){
            this.id= id;
            /* get the custom setting for rev batch on off*/
            
           tempid.add('a2A1q000001RLwQ');
           tempid.add('a2A2X00000C1rzU');
            
            crm_Revenue_Batch_setting__c  RevBatchstatus=  crm_Revenue_Batch_setting__c.getValues('RevenueBatch');
            Boolean IsBatch= RevBatchstatus.crm_Revenue_Batch_Status__c;
            
            String limitStr =' limit 0';
                       
            queryString += 'SELECT Id,crm_Customer_Number__c,crm_Currency__c,crm_Invoice_Date__c,crm_Price__c,crm_Processed__c,crm_Product__c,';
            queryString += 'crm_Source__c,crm_Customer_Unique__c FROM crm_SalesImport__c WHERE crm_Processed__c = FALSE and id =:id order by crm_Customer_Number__c , crm_Product__c, createddate desc';
            System.debug('queryString========'+queryString);
            if(!IsBatch) {
                 queryString +=  limitStr ;
            
            }
          
        }

       global Database.QueryLocator start(Database.BatchableContext bcMain){   
            return Database.getQueryLocator(queryString);
        }
  
       global void execute(Database.BatchableContext bcMain, List<crm_SalesImport__c> sales_import){
       System.debug('sales_import========'+sales_import);
            Map<String,crm_SalesImport__c> AccountSalesMap = new Map<String,crm_SalesImport__c>();
            Set<String> relationAccounts = new Set<String>();
            Set<String> ERP_productIds = new Set<String>();
            List<crm_SalesImport__c> ToUpdateSalesData= new List<crm_SalesImport__c>();
            String cust_no='';
            //map for account to save id + date + amount 
            Map<String, crm_SalesImport__c> Sales_importMap= new Map<String, crm_SalesImport__c>(); 
            for(crm_SalesImport__c sales : sales_import){
              cust_no= '';
              // if(sales.crm_Customer_Unique__c.contains('BLNOCMP')){
              if(sales.crm_Customer_Number__c!=null){
                       cust_no = sales.crm_Customer_Number__c;
                       relationAccounts.add(sales.crm_Customer_Number__c); 
                       
                      
                      /* }
                else{
                    cust_no = sales.crm_Customer_Unique__c; 
                    relationAccounts.add(sales.crm_Customer_Unique__c);  
                   }  */  
               
             
                   
                if(String.isNotBlank(sales.crm_Product__c))
                    ERP_productIds.add(sales.crm_Product__c);
                    Integer salesMonth = Integer.valueof(sales.crm_Invoice_Date__c.mid(2, 2));
                    Integer salesYear = Integer.valueof(sales.crm_Invoice_Date__c.mid(4, 4));
                    
                    string key =  cust_no + '@'+ sales.crm_Product__c+'@'+salesMonth+ '@'+salesYear;
                    if(AccountSalesMap.containskey(key)){
                       // crm_SalesImport__c temp =  AccountSalesMap.get(key);
                        //temp.crm_Price__c = String.valueOf(Decimal.valueof(sales.crm_Price__c) +Decimal.valueof(temp.crm_Price__c));
                       // AccountSalesMap.put(key, temp) ;
                        //Sales_importMap.put(sales.crm_Customer_Number__c, temp);
                        sales.crm_Processed__c= true;
                        System.debug('##Processed 1');
                        ToUpdateSalesData.add(sales);
                         
                     }else{
                       
                        AccountSalesMap.put(key, sales) ;   
                        Sales_importMap.put(cust_no, sales);
                    }
                    
                   }//check of customer number not blank //to fix the 50001 query rows exception
                    else
                    {
                        sales.crm_Processed__c= true;
                        System.debug('##Processed 2');
                        ToUpdateSalesData.add(sales);
                    
                    } 
                    
               }//end of for
           try{
                    Database.update (ToUpdateSalesData, false);
                }catch(Exception e) {  crm_Exception_handler.createExceptionRecords(e);  }     
               
            System.debug('@@relationAccounts '+ relationAccounts );
             //map for cust, no, account    
            Map<String,Id> relationAccountsMap = new Map<String,Id>();
            Map<Id, string> relationAccountIdSalesMap = new Map<Id, string>();
            for (Account a :[SELECT crm_Customer_Number__c, Id FROM Account WHERE  crm_Customer_Number__c IN :relationAccounts ]){
                if(String.isNotBlank(a.crm_Customer_Number__c)){
                    relationAccountsMap.put(a.crm_Customer_Number__c,a.id);
                    relationAccountIdSalesMap.put(a.id, a.crm_Customer_Number__c);
                    System.debug('@@relationAccountsMap'+ relationAccountsMap);
                    System.debug('@@relationAccountIdSalesMap'+ relationAccountIdSalesMap);
                }
            }
               
            //get all revenue lines for accounts 
            Map<Id, List<crm_Revenue_Line__c>> AccountRevenueMap = new Map<Id, List<crm_Revenue_Line__c>>();
            List<crm_Revenue_Line__c> revLines=[Select crm_Account__c ,crm_Amount__c , crm_Transaction_Date__c, crm_Product_ERP_ID__c  from crm_Revenue_Line__c where crm_Account__c in :relationAccountsMap.values()order by createddate desc]; 
         System.debug('@@revLines'+ revLines);
            for (crm_Revenue_Line__c rev: revLines)   {
                if (AccountRevenueMap.containsKey(rev.crm_Account__c)){
                    List<crm_Revenue_Line__c> templist = new List<crm_Revenue_Line__c>();
                    templist = AccountRevenueMap.get(rev.crm_Account__c);
                    templist.add(rev);
                    AccountRevenueMap.put(rev.crm_Account__c,templist ) ;
                     System.debug('@@AccountRevenueMap if----- '+ AccountRevenueMap);
                }
                else {
                    List<crm_Revenue_Line__c> templist = new List<crm_Revenue_Line__c>();
                    templist.add(rev);
                    AccountRevenueMap.put(rev.crm_Account__c,templist) ;
                     System.debug('@@AccountRevenueMapelse---- '+ AccountRevenueMap);
                } 
                       
              }  
              
           //get all agreemnts from the party level account
          
            String Status ='Active';
            List<crm_Agreement__c> agreementList = [Select crm_Account__c,crm_Agreement_End_Date__c, crm_Status__c,crm_Agreement_Name__c,crm_Agreement_Service_Family__c,crm_Agreement_Start_Date__c, crm_New_Revenue_Start_Date__c from crm_Agreement__c where crm_Status__c =:Status and  crm_Account__c in (Select parentid from account where id in : relationAccountsMap.values())];
                System.debug('@@agreementList ---- '+ agreementList);
            List<Account> ParentaccountList =[Select id , parentid from Account where id in  :relationAccountsMap.values()];
            Map<Id,Set<Id>> ParentaccountMap =new Map<Id,Set<Id>>();
            Map<Id,Id> RelationaccountMap =new Map<Id,Id>();
            
            Map<Id, String> AccountStatusMap = new Map<Id, String>();
            for (Account a: ParentaccountList ){
                if (ParentaccountMap.containsKey(a.parentid)){
                    Set<Id> temp = new Set<id>();
                    temp = ParentaccountMap.get(a.parentid);
                    temp.add(a.id);
                    ParentaccountMap.put(a.parentid,temp) ;
                   
                }
                else {
                    Set<Id> temp = new Set<id>();
                    temp.add(a.id);
                    ParentaccountMap.put(a.parentid,temp) ;
                   
                } 
                if(a.parentid!=null)
                    RelationaccountMap.put(a.id, a.parentid);
            }
              System.debug('@@RelationaccountMap---- '+ RelationaccountMap);
            
            List<Account> Accountstatuslist =[Select id,  Customer_Converted__c from Account where  id in  :ParentaccountMap.keyset()];
             System.debug('@@Accountstatuslist ---- '+ Accountstatuslist );
            
            for (Account a : Accountstatuslist)
                    AccountStatusMap.put(a.id,a.Customer_Converted__c);
                  
            Map<id, List<crm_Agreement__c>> partyAccountAgrMap = new  Map<id, List<crm_Agreement__c>>();
            for (crm_Agreement__c agr: agreementList){
                             
                if (partyAccountAgrMap.containsKey(agr.crm_Account__c)){
                    List<crm_Agreement__c> templist = new List<crm_Agreement__c>();
                    templist = partyAccountAgrMap.get(agr.crm_Account__c);
                    templist.add(agr);
                    partyAccountAgrMap.put(agr.crm_Account__c,templist );
                }
                else {
                    List<crm_Agreement__c> templist = new List<crm_Agreement__c>();
                    templist.add(agr);
                    partyAccountAgrMap.put(agr.crm_Account__c,templist) ;
                } 
                       
              }  
              
            Map<Id,List<crm_Agreement__c>>  RelationAccountAgrMap = new Map<Id,List<crm_Agreement__c>>();
             
            for (Id parentacntid: ParentaccountMap.keyset() ){
                 Set <Id> relationacntIds =ParentaccountMap.get(parentacntid);
                 for (Id relationid: relationacntIds ){
                    if(partyAccountAgrMap.containskey(parentacntid)){
                        RelationAccountAgrMap.put(relationid,partyAccountAgrMap.get(parentacntid));
                    
                    }
                 
                 }
         
             }
          
           List <Account> AccountKamDetails= [Select crm_e_commerce_KAM__c, crm_Group_KAM__c from Account where id in :ParentaccountMap.keyset()];
           
           Map<id,Account> AccountKamMap= new Map<id,Account>();       
           
            for (account acnt: AccountKamDetails) {
                AccountKamMap.put(acnt.id, acnt);
            
            }
            
        //map for Product<cust unique no, Product list>
            List<Product2> ProductList= [Select id, crm_global_Service_Group__c, crm_ERP_Product_ID__c ,crm_global_Service_Family__c, New_ERP_Service_ID__c from Product2 where crm_ERP_Product_ID__c IN :ERP_productIds];
            Map<String,Product2> ERPProductMap = new Map<String,Product2>();
            
            for(Product2 Prod: ProductList){
                ERPProductMap.put(Prod.crm_ERP_Product_ID__c,Prod);
            }   
            
            
            Map<Id, String> AccountProductMap= new Map<Id, String>();
              
            for(crm_SalesImport__c sales : sales_import){
              // if(sales.crm_Customer_Unique__c.contains('BLNOCMP')){
                                        
                    if(sales.crm_Product__c!=null && relationAccountsMap.containskey(sales.crm_Customer_Number__c)){
                         AccountProductMap.put(relationAccountsMap.get(sales.crm_Customer_Number__c),sales.crm_Product__c);
                     }
                /* }
                 else {
                  if(sales.crm_Product__c!=null && relationAccountsMap.containskey(sales.crm_Customer_Unique__c )){
                         AccountProductMap.put(relationAccountsMap.get(sales.crm_Customer_Unique__c ),sales.crm_Product__c);
                 
                 }
                 
            }*/
         }//end of for                   
            List<crm_Revenue_Line__c> updateRevenueLineList=new List<crm_Revenue_Line__c>();
            List<crm_SalesImport__c > ToinsertSalesImportList=new List<crm_SalesImport__c >();
              
            for(crm_SalesImport__c sales : AccountSalesMap.values()){ //sales_import
                Id AccountId= relationAccountsMap.get(sales.crm_Customer_Number__c);
                String ERPId='';
                if(ERPProductMap.containskey(sales.crm_Product__c)) {
                    ERPId = ERPProductMap.get(sales.crm_Product__c).crm_ERP_Product_ID__c;
                }  //end of product check else insert with no product 
                
                System.debug('@@AccountRevenueMap'+AccountRevenueMap);
                 
                if(AccountRevenueMap.containsKey(AccountID)){  // && ERPId == AccountProductMap.get(AccountID)   removed this for duplicate rev line issue
                   System.debug('@@contains both'+AccountRevenueMap);       
                //check dates  if matched product +account  then update 
                    List<crm_Revenue_Line__c> revList = AccountRevenueMap.get(AccountID);
                    Integer counter =0;
                    for(crm_Revenue_Line__c revenue :revList){
                        
                        Integer salesday =  Integer.valueof(sales.crm_Invoice_Date__c.mid(0, 2));   
                        Integer salesMonth = Integer.valueof(sales.crm_Invoice_Date__c.mid(2, 2));
                        Integer salesYear = Integer.valueof(sales.crm_Invoice_Date__c.mid(4, 4));
                        System.debug('@@revenue'+revenue);   
                        if(revenue.crm_Transaction_Date__c!=null){
                            Integer revMonth =  Integer.valueof(revenue.crm_Transaction_Date__c.month());
                            Integer revYear  =  Integer.valueof(revenue.crm_Transaction_Date__c.year());
                            Integer revDate  =  Integer.valueof(revenue.crm_Transaction_Date__c.day());
                            
                            String Parentid= RelationaccountMap.get(AccountID);
                            String acntStatus= AccountStatusMap.get(parentid);
                        
                              Product2 prd = new Product2();
                            if(ERPProductMap.containskey(sales.crm_Product__c)){
                                    prd = ERPProductMap.get(sales.crm_Product__c ) ; //old 
                        
                            }
                            System.debug('##prd.New_ERP_Service_ID__c'+ prd.New_ERP_Service_ID__c);
                           /********************************************/
                            if(salesMonth  == revMonth  && salesYear == revYear &&  sales.crm_Product__c == revenue.crm_Product_ERP_ID__c &&  acntStatus!='Converted' ){
// && salesday > revDate 


System.debug('@@date matched both need to update the price '+AccountRevenueMap);     
revenue.crm_Amount__c = Decimal.valueof(sales.crm_Price__c);
//Integer year = Integer.valueof(sales.crm_Invoice_Date__c.mid(4, 4));
revenue.CurrencyIsoCode=sales.crm_Currency__c;
revenue.crm_Transaction_Date__c = Date.newInstance(salesYear , salesMonth , salesday );
updateRevenueLineList.add(revenue);
sales.crm_Processed__c=true;
System.debug('##Processed 3');
break;
}


else if(acntStatus=='Converted' ){


list<New_Service_Mapping__mdt>  ERPList  = [Select New_ERP_Id__c, Old_ERP_Id__c from New_Service_Mapping__mdt  where  Old_ERP_Id__c = :sales.crm_Product__c limit 1];
System.debug('##ERPList  '+ ERPList  );
if(ERPList.size()>0 && ERPList!=null) {

if(salesMonth  == revMonth  && salesYear == revYear && (revenue.crm_Product_ERP_ID__c == ERPList[0].New_ERP_Id__c || revenue.crm_Product_ERP_ID__c == sales.crm_Product__c)) {

List<Product2> newprodlist=[Select id,crm_ERP_Product_ID__c  from Product2 where crm_ERP_Product_ID__c =:ERPList[0].New_ERP_Id__c limit 1 ];

revenue.crm_Amount__c = Decimal.valueof(sales.crm_Price__c);
//Integer year = Integer.valueof(sales.crm_Invoice_Date__c.mid(4, 4));
revenue.CurrencyIsoCode=sales.crm_Currency__c;
revenue.crm_Transaction_Date__c = Date.newInstance(salesYear , salesMonth , salesday );
updateRevenueLineList.add(revenue);
sales.crm_Processed__c=true;
if(newprodlist.size()>0)
revenue.crm_Product__c =newprodlist[0].id;
System.debug('##Processed 3');
break;


}//condition check 
  else { //insert revlines
                                counter = counter +1;
                            
                                   // ToinsertSalesImportList.add(sales);
                           
                           } 

}//erplist size
else  if(salesMonth  == revMonth  && salesYear == revYear &&  revenue.crm_Product_ERP_ID__c == sales.crm_Product__c) {
revenue.crm_Amount__c = Decimal.valueof(sales.crm_Price__c);
//Integer year = Integer.valueof(sales.crm_Invoice_Date__c.mid(4, 4));
revenue.CurrencyIsoCode=sales.crm_Currency__c;
revenue.crm_Transaction_Date__c = Date.newInstance(salesYear , salesMonth , salesday );
updateRevenueLineList.add(revenue);
sales.crm_Processed__c=true;
System.debug('##Processed 3');
break;



}
else {
counter = counter +1;
system.debug('!!!nowhere in converted');
}
}//end of converted 
                                
                        else { //insert revlines
                                counter = counter +1;
                            
                                   // ToinsertSalesImportList.add(sales);
                           
                           } 
                           
                            
                       }   //end ofdate check 
                       else
                       {
                        counter = counter +1;
                       }
                     
                 
                 
                    }//end of for of rev line 
                    System.debug(counter  + revList.size());
                    if (counter==revList.size()){
                          ToinsertSalesImportList.add(sales);   
                           System.debug('added to list');     
                    
                    }
              }//end of if    
              
            
                    else { //insert revlines
                            ToinsertSalesImportList.add(sales);
                      System.debug('added to list in else');     
                    }
                           
               }
                //update rev line
                try{
                    //Database.update (updateRevenueLineList, false);
                    Database.update (sales_import, false);
                }catch(Exception e) {  crm_Exception_handler.createExceptionRecords(e);  }      
                   
             //map of account, segment list// get all segments from  party level and relation level
                Map<Id, list<crm_Segment__c>>  AccountSegmentMap = new  Map<Id, List<crm_Segment__c>>(); 
              
                List<crm_Segment__c> SegmentList= [Select id, crm_Sales_Responsible__c,crm_Sales_Responsible__r.firstname , crm_Sales_Responsible__r.lastname ,crm_Service_Group__c,crm_Sales_Team__c, crm_Account__c  from  crm_Segment__c where  (crm_Account__c in :relationAccountsMap.values()) OR (crm_Account__c in :RelationaccountMap.values()) ];    
             System.debug('^^^SegmentList' + SegmentList);
                for (crm_Segment__c seg: SegmentList ){
                    crm_Segment__c division = new crm_Segment__c();
                  
                    if (AccountSegmentMap.containsKey(seg.crm_Account__c)){
                        List<crm_Segment__c> templist = new List<crm_Segment__c>();
                        templist = AccountSegmentMap.get(seg.crm_Account__c);
                        templist.add(seg);
                        AccountSegmentMap.put(seg.crm_Account__c,templist ) ;
                    }
                    else {
                        List<crm_Segment__c> templist = new List<crm_Segment__c>();
                        templist.add(seg);
                        AccountSegmentMap.put(seg.crm_Account__c,templist ) ;
                    } 
                }
                
                System.debug('^^^AccountSegmentMap ' + AccountSegmentMap);
                   
            // search the division map for service 
          Map<id, crm_Segment__c> AccountsegmentServiceGroupMap= new Map<id, crm_Segment__c>(); 
            for (Id AccountId: AccountSegmentMap.keySet()) {
                List<crm_Segment__c> AccountSegmentList = AccountSegmentMap.get(AccountId);
                
                String productERPid='';
                if( AccountProductMap.containskey(AccountId))    {
                productERPid= AccountProductMap.get(AccountId);
                
                }
                System.debug('@@productERPid :'+ productERPid );
                System.debug('@@AccountProductMap:'+ AccountProductMap);
                System.debug('@@ParentaccountMap:'+ ParentaccountMap);
                
                if(productERPid == '' || productERPid==null &&  ParentaccountMap.containskey(AccountId)){
                    Set<Id>  relationAcntList= ParentaccountMap.get(AccountId);
                     System.debug('@@relationAcntList:'+ relationAcntList);
                      //System.debug('@@relationAcntList:'+ relationAcntList.size());
                     if(relationAcntList!=null){
                    for (Id relationid: relationAcntList){
                           
                              System.debug('@@relationid:'+ relationid);
                        if (AccountProductMap.containskey(relationid) )
                            productERPid = AccountProductMap.get(relationid);
                            break;
                        
                        }
                  }  //end of size
                   
          }
               system.debug('^^^AccountSegmentList ' + AccountSegmentList ) ;
                  
               if (ERPProductMap.containskey(productERPid)) {
                Product2 prd = ERPProductMap.get(productERPid);
                
                for (crm_segment__c seg: AccountSegmentList) {
                    
                    if (prd.crm_global_Service_Group__c == seg.crm_Service_Group__c) {
                        AccountsegmentServiceGroupMap.put(AccountId, seg);
                        
                        break;
                    }
                } //end of product check
                
            }
            
    }
    
        Map<Id, crm_agreement__c> AgrementAccountMap= new Map<id, crm_agreement__c>();
        for (Id AccountId: RelationAccountAgrMap.keySet()) {
            List<crm_Agreement__c> AgrementAccountList = RelationAccountAgrMap.get(AccountId);
            String productERPid = AccountProductMap.get(AccountId);
            if(ERPProductMap.containskey(productERPid)){
            Product2 prd= ERPProductMap.get(productERPid);
                       
            for (crm_Agreement__c agr: AgrementAccountList ) {
              //chek dates pending
                if(prd.crm_global_Service_Family__c.tolowercase()== agr.crm_Agreement_Service_Family__c.toLowercase()  ){ 
                   Date salesDate =null;
                   if(agr.crm_Agreement_Start_Date__c !=null  ){
                    if( Sales_importMap.containskey(relationAccountIdSalesMap.get(AccountId)) ){
                       crm_SalesImport__c sales =  Sales_importMap.get(relationAccountIdSalesMap.get(AccountId)) ; 
                     
                           if (sales.crm_Invoice_Date__c!=null){
                                Integer day =  Integer.valueof(sales.crm_Invoice_Date__c.mid(0, 2));
                                Integer month = Integer.valueof(sales.crm_Invoice_Date__c.mid(2, 2));
                                Integer year = Integer.valueof(sales.crm_Invoice_Date__c.mid(4, 4));
                                salesDate = Date.newInstance(year, month, day);
                  
                            }
                            
                 }//end of contains
                          
                    if((agr.crm_Agreement_End_Date__c == null && salesDate >=agr.crm_Agreement_Start_Date__c) ||
                       ( agr.crm_Agreement_End_Date__c != null && salesDate >=agr.crm_Agreement_Start_Date__c && salesDate <=agr.crm_Agreement_End_Date__c))
                           {
                            AgrementAccountMap.put(AccountId, agr);
                            break;    
                         
                          }
    
            }//end of null chk of start date                  
        }//end of check family
      }  //end of for     
    }//end of prd check    
}//end of account for
             
            List<crm_Revenue_Line__c>  revenueLines = new List<crm_Revenue_Line__c>();
            System.debug('##ToinsertSalesImportList' + ToinsertSalesImportList);
            for(crm_SalesImport__c sales : ToinsertSalesImportList){
              cust_no='';
              System.debug('added to list'+sales );     
                crm_Revenue_Line__c rev = new crm_Revenue_Line__c();
               
                
               // if(sales.crm_Customer_Unique__c.contains('BLNOCMP')){
                    cust_no=sales.crm_Customer_Number__c;
              /*  }
                else{
                cust_no=sales.crm_Customer_Unique__c;
                
                }*/
                
                    System.debug('ERPProductMap---'+ERPProductMap);
                    
                    System.debug('RelationaccountMap--'+RelationaccountMap);
                    System.debug('sales.crm_Product__c--'+sales.crm_Product__c);
                    
                     System.debug('relationAccountsMap.containskey(cust_no)--'+relationAccountsMap.containskey(cust_no));
                      System.debug('ERPProductMap.containskey(sales.crm_Product__c)----'+ERPProductMap.containskey(sales.crm_Product__c));
                    if(relationAccountsMap.containskey(cust_no) && ERPProductMap.containskey(sales.crm_Product__c)){
                    Id Parentid=null;
                    
                    Parentid= RelationaccountMap.get(relationAccountsMap.get(cust_no));
                    String acntStatus= AccountStatusMap.get(parentid);
                    System.debug('Parentid-------'+Parentid);
                    Product2 prd = new Product2();
                    if (ERPProductMap.containskey(sales.crm_Product__c) && AccountStatusMap.get(parentid)== 'Converted') 
                    {
                    System.debug('Parentid-enterssss------'+Parentid);
                    List<New_Service_Mapping__mdt>  ERPList  = [Select New_ERP_Id__c, Old_ERP_Id__c from New_Service_Mapping__mdt  where  Old_ERP_Id__c = :sales.crm_Product__c limit 1];
                    if(!ERPList.isempty()) 
                    {
                        List<Product2> newprodlist=[Select id,crm_ERP_Product_ID__c  from Product2 where crm_ERP_Product_ID__c =:ERPList[0].New_ERP_Id__c limit 1 ];                           
                        if(!newprodlist.isempty()) 
                            rev.crm_Product__c = newprodlist[0].id;
                    }
                    else {
                        prd = ERPProductMap.get(sales.crm_Product__c);
                        rev.crm_Product__c = prd.id;
                    }
                    System.debug('rev.crm_Product__c-----'+rev.crm_Product__c);
                }
                if (ERPProductMap.containskey(sales.crm_Product__c) && AccountStatusMap.get(parentid)!= 'Converted') 
                {
                    prd = ERPProductMap.get(sales.crm_Product__c);
                    rev.crm_Product__c = prd.id;
                }
                    
                    rev.crm_Account__c = relationAccountsMap.get(cust_no);
                    rev.crm_Amount__c = Decimal.valueof(sales.crm_Price__c);
                    rev.CurrencyIsoCode=sales.crm_Currency__c;
                    rev.crm_Source__c= 'NAV-OEBS';
                   // Division__c segmentobj = AccountsegmentServiceGroupMap.get( relationAccountsMap.get(sales.crm_Customer_Unique__c));
                   
                    String responsibleseller='';
                    
                    //AccountSegmentMap   acnt lisst of segments
                    List<crm_segment__c> Segmentlist1 = new List<crm_segment__c> ();
                     if (AccountSegmentMap.containskey(Parentid))
                         Segmentlist1 =      AccountSegmentMap.get(Parentid)  ; 
                         else  if (AccountSegmentMap.containskey(rev.crm_Account__c))
                         Segmentlist1 =      AccountSegmentMap.get(rev.crm_Account__c)  ; 
                          
                    for ( crm_segment__c seg : Segmentlist1 ){
                   
                   
                   
                        if (seg.crm_Service_Group__c == prd.crm_global_Service_Group__c){
                            rev.crm_Responsible_Seller__c =  seg.crm_Sales_Responsible__c; 
                            
                             if (seg.crm_Sales_Team__c !=null) 
                        rev.crm_Revenue_Responsible__c = seg.crm_Sales_Team__c; 
                    else {
                        String name= '';
                        if(seg.crm_Sales_Responsible__r.firstname!='' || seg.crm_Sales_Responsible__r.firstname !=null)
                            name= seg.crm_Sales_Responsible__r.firstname + ' ';
                        else
                        name= seg.crm_Sales_Responsible__r.lastname;    
                        
                        
                        rev.crm_Revenue_Responsible__c = name;
                        }
                        }
                    } 
                     
                   
                    System.debug('@@ line 459 '+ rev);
                    System.debug('@@ line 5426 '+ relationAccountsMap);
                     System.debug('@@ line 5426 '+ AgrementAccountMap);
                    
                    if(AgrementAccountMap.containskey(relationAccountsMap.get(cust_no)))
                        rev.crm_Agreement__c= AgrementAccountMap.get(relationAccountsMap.get(cust_no)).id;
                    if(AccountKamMap.containsKey(Parentid)){
                   
                        Account ParentAccount =AccountKamMap.get(Parentid);
                        
                        if(ParentAccount.crm_e_commerce_KAM__c!=null)
                            rev.crm_e_commerce_KAM__c= ParentAccount.crm_e_commerce_KAM__c;
                            
                        if(ParentAccount.crm_Group_KAM__c!=null)    
                            rev.crm_Group_KAM__c= ParentAccount.crm_Group_KAM__c;
                        
                    } //end of check ecommerce kam and group kam    
                    //rev.crm_Transaction_Date__c = System.today();  //sales.crm_Invoice_Date__c;
                    
                    if (sales.crm_Invoice_Date__c!=null){
                        Integer day =  Integer.valueof(sales.crm_Invoice_Date__c.mid(0, 2));
                        Integer month = Integer.valueof(sales.crm_Invoice_Date__c.mid(2, 2));
                        Integer year = Integer.valueof(sales.crm_Invoice_Date__c.mid(4, 4));
                        rev.crm_Transaction_Date__c = Date.newInstance(year, month, day);
                        
                        /*
                        
                        changes for duplicate rev lines 17th feb 2017
                        
                        */
                        
                        rev.crm_Transaction_Month_Text__c= String.valueof(sales.crm_Invoice_Date__c.mid(2, 2));
                        rev.crm_Transaction_Month_Number__c= Integer.valueof(sales.crm_Invoice_Date__c.mid(2, 2));
                        rev.crm_Transaction_Year_Text__c= String.valueof(sales.crm_Invoice_Date__c.mid(4, 4));
                        rev.crm_Rev_Line_Unique_Id__c=  sales.crm_Customer_Number__c+ sales.crm_Product__c+ String.valueof(sales.crm_Invoice_Date__c.mid(2, 2)) + String.valueof(sales.crm_Invoice_Date__c.mid(4, 4))+ 'NAV-OEBS';
                        
                       
                    }
                       
                    if(AgrementAccountMap.containskey(relationAccountsMap.get(cust_no))){
                        crm_agreement__c linkedAgreement = AgrementAccountMap.get(relationAccountsMap.get(cust_no));
                     
                      /*  if (rev.crm_Transaction_Date__c >= System.today().addYears(-1))
                            rev.crm_Revenue_Type__c = 'New' ;  //getRevenuetype(sales.crm_Invoice_Date__c);
                        else
                            rev.crm_Revenue_Type__c = 'Existing' ;  //getRevenuetype(sales.crm_Invoice_Date__c);    
                       
                        }*/ 
                        
                        //US- 460
                        
                       // if (linkedAgreement.crm_New_Revenue_Start_Date__c >= rev.crm_Transaction_Date__c.addYears(-1))
                        if( rev.crm_Transaction_Date__c >=linkedAgreement.crm_New_Revenue_Start_Date__c  &&  rev.crm_Transaction_Date__c <= linkedAgreement.crm_New_Revenue_Start_Date__c.addYears(1) )
                            rev.crm_Revenue_Type__c = 'New' ;  //getRevenuetype(sales.crm_Invoice_Date__c);
                        else
                            rev.crm_Revenue_Type__c = 'Existing' ;  //getRevenuetype(sales.crm_Invoice_Date__c);    
                      }  
                          else {
                            rev.crm_Revenue_Type__c ='';
                            rev.crm_Agreement__c=null;
                            }
                            
                            
                            
                            System.debug('###Agreement'+ rev);
                    
                    revenueLines.add(rev);
                    sales.crm_Processed__c=true;
                   
                   
               } //end of accountcheck
           }
            
           // updateRevenueLineList = UpdateExistingRevenue(updateRevenueLineList,AccountSegmentMap,ERPProductMap,relationAccountsMap,RelationaccountMap);
            System.debug('##revenueLines' + revenueLines);
                    
           try{
               Database.insert (revenueLines, false);
               Database.update (sales_import, false);
               Database.Update (updateRevenueLineList, false);
           }catch(Exception e) {   crm_Exception_handler.createExceptionRecords(e);   }   
           
            
     }
     

    global void finish(Database.BatchableContext bc){
    String str = '';
    AsyncApexJob[] a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ApexClass.Name from AsyncApexJob where Id =:bc.getJobId() ];
    
    if(callback != '' && callback != null)
              str += callback + '\n';
    
    if(a != null && a.size() > 0){
        str += a[0].ApexClass.Name + ' ( '+ a[0].Id + ' ' + a[0].status + ')  processed ' + a[0].TotalJobItems + ' batches with '+ a[0].NumberOfErrors + ' failures.';
    }
        
       // if(!Test.IsRunningTest())
        //    Database.executeBatch(new crm_revenueTransformationNPBOEBS_batch(str));
    
    }
        
   /* Public List<crm_Revenue_Line__c> UpdateExistingRevenue(List<crm_Revenue_Line__c> updateRevenueLineList, 
                                      Map<id, List<crm_Segment__c>> AccountSegmentMap, 
                                     Map<String,Product2> ERPProductMap,Map<String,Id> relationAccountsMap,
                                                          Map<Id,Id> RelationaccountMap){
                                                          
      system.debug('###updateRevenueLineList'+updateRevenueLineList);
    
      
      Product2 prd = new Product2();                                         
      for(crm_Revenue_Line__c rev : updateRevenueLineList){
            crm_segment__c  segmentobj = new crm_segment__c (); 
            
            
              system.debug('###relationAccountsMap relatuon account '+relationAccountsMap);
              
                system.debug('###RelationaccountMap  paren '+RelationaccountMap);
                  Id Parentid=null;
                if(RelationaccountMap.containskey(rev.crm_account__c))
                   Parentid=RelationaccountMap.get(rev.crm_Account__c);
                   
            if(ERPProductMap.containskey(rev.crm_Product_ERP_ID__c))
                prd= ERPProductMap.get(rev.crm_Product_ERP_ID__c);
                
              system.debug('###rev.crm_Account__c'+rev.crm_Account__c);
              system.debug('###Parentid'+Parentid);
       
       //AccountSegmentMap   acnt lisst of segments
                    List<crm_segment__c> Segmentlist1 = new List<crm_segment__c> ();
                     if (AccountSegmentMap.containskey(Parentid))
                         Segmentlist1 =      AccountSegmentMap.get(Parentid)  ; 
                         else  if (AccountSegmentMap.containskey(rev.crm_Account__c))
                         Segmentlist1 =      AccountSegmentMap.get(rev.crm_Account__c)  ; 
                          
                    for ( crm_segment__c seg : Segmentlist1 ){
                   
                   
                   
                        if (seg.crm_Service_Group__c == prd.crm_global_Service_Group__c){
                            rev.crm_Responsible_Seller__c =  seg.crm_Sales_Responsible__c; 
                            
                       if (seg.crm_Sales_Team__c !=null) 
                        rev.crm_Revenue_Responsible__c = seg.crm_Sales_Team__c; 
                    else {
                        String name= '';
                        if(seg.crm_Sales_Responsible__r.firstname!='' || seg.crm_Sales_Responsible__r.firstname !=null)
                            name= seg.crm_Sales_Responsible__r.firstname + ' ';
                        else
                        name= seg.crm_Sales_Responsible__r.lastname;    
                        
                        
                        rev.crm_Revenue_Responsible__c = name;
                        }
                        }
                    } 
                     
            
        }                                                   
         return updateRevenueLineList;                                
    }*/
}