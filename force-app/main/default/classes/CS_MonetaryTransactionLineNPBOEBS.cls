public class CS_MonetaryTransactionLineNPBOEBS {

@AuraEnabled
 public static List<Monetary_Transaction_Line_Item__c> loadLineItems(String monetarytransId){
        List<Monetary_Transaction_Line_Item__c> lineItems = new List<Monetary_Transaction_Line_Item__c>();
        lineItems =
            [Select id,
            Description__c,
            is_motpost__c, 
            Transaksjon__c, 
            name, Type__c, 
            Regress_type__c, 
            cs_Accounting_Unit_Name__c,
            Line_Amount__c, 
            cargo_division_code__c, 
            Invoice_number__c, 
            cargo_product_code__c, 
            Line_Amount_inc_vat__c, 
            Amount_foreign_currency__c,
            Valutakode__c,
            Article_Number__c,
            hidden_motpost_reference__c,
            CreatedDate           
            FROM Monetary_Transaction_Line_Item__c where Transaksjon__c  = :monetarytransId ORDER BY CreatedDate DESC];
            
      return lineItems ;
    }
    
    @AuraEnabled
    public static Monetary_Transaction__c loadtransaction(String monetarytransId){
    Monetary_Transaction__c  transobj= new Monetary_Transaction__c ();
    transobj =[Select id, name, tolabel(RecordType.Name),RecordType.DeveloperName, Transaction_Action__c,   Other_information__c, Service_Product__c, case__r.Service_Product__r.Name, case__c, Valutakode__c,Form_of_Transaction__c, Regress_Customer__r.Name  from Monetary_Transaction__c where id =  :monetarytransId];
    return transobj;
    }
    
     @AuraEnabled
    public static Case loadcase(String monetarytransId){
    Monetary_Transaction__c  transobj= new Monetary_Transaction__c ();
    transobj =[Select id, name, tolabel(RecordType.Name),RecordType.DeveloperName, Transaction_Action__c,   Other_information__c, Service_Product__c, case__r.Service_Product__r.Name, case__c, Valutakode__c,Form_of_Transaction__c , Regress_Customer__c  from Monetary_Transaction__c where id =  :monetarytransId];
   
    Case transcase = new Case();
    transcase = [Select id, Accountid,Account.status__c, RecordType.Name, RecordType.DeveloperName, transporter__c, car_number__c from Case where id = :transobj.case__c];
    return transcase ;
    }
    
     @AuraEnabled
        public static  Map<String, String> getAllowedArticles(String monetarytransId)  {
       Map<String, String> options  = new Map<String, String>();
       
          Monetary_Transaction__c  monetarytrans= new Monetary_Transaction__c ();
         monetarytrans =[Select id, name, tolabel(RecordType.Name),RecordType.DeveloperName, Transaction_Action__c,   Other_information__c, Service_Product__c, case__r.Service_Product__r.Name, case__c, Valutakode__c,Form_of_Transaction__c   from Monetary_Transaction__c where id =  :monetarytransId];
         
      
         
          string EMPTY_HANDLING_TRANSACTION = System.label.Cs_None;
             string MANUAL_HANDLING_TRANSACTION = 'Manuell Behandling';
             string SHOW_ALL_PRODUCTS = 'EMPTY';
             string KREDITTNOTA = 'Kredittnota';
             string REGRESS = 'Regress';
             string SHOW_AUTO_PRODUCTS = 'AUTO';
       
       
           if(monetarytrans.RecordType.DeveloperName == 'Transaction_Currency_NPB_OEBS')
     
        {
             options.put('', EMPTY_HANDLING_TRANSACTION);
             options.put(MANUAL_HANDLING_TRANSACTION,System.Label.cs_Payment_type_value1);
        }
        
        
         else if(monetarytrans.Form_of_Transaction__c == 'Settlement by insurance company third party')
       {   
            options.put('', EMPTY_HANDLING_TRANSACTION);
            options.put( MANUAL_HANDLING_TRANSACTION, System.Label.cs_Payment_type_value1);
       }
       
        //CSphase2, Dinesh, 28/12/2016 
        //else if((transcase.RecordType.Name == 'Reklamasjon Gods')||(transcase.RecordType.Name == 'Klage' && blocked_products__c.getAll().containsKey(monetarytrans.case__r.Service_Product__r.Name)))
    else if(monetarytrans.RecordType.DeveloperName == 'Transaction_Regress_NPB_OEBS'){
        options.put('', EMPTY_HANDLING_TRANSACTION);
        options.put(REGRESS,REGRESS);
    }    
    else if(monetarytrans.RecordType.DeveloperName != 'Transaction_Regress_NPB_OEBS')
        {
            options.put('', EMPTY_HANDLING_TRANSACTION);
            if(monetarytrans.Transaction_Action__c == SHOW_ALL_PRODUCTS)
            {
                options.put( MANUAL_HANDLING_TRANSACTION, System.Label.cs_Payment_type_value1);
                //options.add(new selectOption( KREDITTNOTA ,System.Label.cs_Credit));
                //options.add(new selectOption(REGRESS,REGRESS));
                options.put( 'Kompensasjon' ,'Kompensasjon');
                options.put( 'Erstatning' ,'Erstatning');
                options.put( 'Refusjon' ,'Refusjon');
            } 
            else if (monetarytrans.Transaction_Action__c == SHOW_AUTO_PRODUCTS) 
            {
                //options.add(new selectOption(KREDITTNOTA, System.Label.cs_Credit));
                //options.add(new selectOption(REGRESS,REGRESS));
                options.put( 'Kompensasjon' ,'Kompensasjon');
                options.put( 'Erstatning' ,'Erstatning');
                options.put( 'Refusjon' ,'Refusjon');
            }
            else
            {
                options.put(MANUAL_HANDLING_TRANSACTION,System.Label.cs_Payment_type_value1);
            }
        }
        return options; //return the picklist options
    }
    
 
@AuraEnabled
 public static  Map<String, String> getRegressType()
{
Map<String, String> options = new Map<String, String>();

Schema.DescribeFieldResult fieldResult =
Monetary_Transaction_Line_Item__c.Regress_type__c.getDescribe();
List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

for( Schema.PicklistEntry f : ple)
{
options.put(f.getValue(), f.getLabel());
}       
return options;
}

@AuraEnabled
public static  String  savetransactionline (String json )
{
MonetarylineWrapper wrapper=MonetarylineWrapper.parse(json);
 Monetary_Transaction_Line_Item__c  lineObj= new Monetary_Transaction_Line_Item__c();
 Case caseObj= new Case();
 Monetary_transaction__c transObj= new Monetary_transaction__c();
    if(String.isNotBlank(wrapper.transactionId)) {
        lineObj.Transaksjon__c = wrapper.transactionId;
        
 transObj =[Select id, case__c, Regress_Customer__c from Monetary_transaction__c where id= :wrapper.transactionId  limit 1]      ;
    
 caseObj =[select id , transporter__c,  car_number__c from case where id= : transObj.case__c limit 1]   ;
        
        
    if(String.isNotBlank(wrapper.paymentType)) 
        lineObj.Type__c = wrapper.paymentType;
        
    if(String.isNotBlank(wrapper.regressType)) 
        lineObj.Regress_type__c = wrapper.regressType;
        
    if(String.isNotBlank(wrapper.forwarder)) 
        caseObj.transporter__c = wrapper.forwarder;
        
    if(String.isNotBlank(wrapper.carNumber)) 
        caseObj.car_number__c = wrapper.carNumber;
        
    if(String.isNotBlank(wrapper.accountingUnit)) {
        lineObj.cs_Accounting_Unit__c = wrapper.accountingUnit;
        String searchText = '\'%' + String.escapeSingleQuotes(wrapper.accountingUnit.trim()) + '%\'';
        System.debug('##searchText ' + searchText );
          String query = 'Select id, Name, DRM_id__c from PostalUnit__c where is_active__c=true and DRM_id__c  like ' + searchText + ' order by name limit 1 ';
        List<PostalUnit__c> postalunit=Database.query(query);      
        System.debug('##postalunit'+ postalunit);
        if(postalunit!=null && postalunit.size()>0)
          lineObj.cs_Accounting_Unit_Name__c= postalunit[0].Name;
        }
    
    if(String.isNotBlank(wrapper.description)) 
        lineObj.Description__c = wrapper.description;

    if(String.isNotBlank(transObj.Regress_Customer__c)) 
        lineObj.Regress_Account__c = transObj.Regress_Customer__c;
        
    if(String.isNotBlank(wrapper.invoiceNumber)) 
        lineObj.Invoice_number__c = wrapper.invoiceNumber;
        
    if(String.isNotBlank(wrapper.lineAmountvalue)) 
        lineObj.Line_Amount__c = Decimal.valueof(wrapper.lineAmountvalue);
        
        System.debug('##lineObj' + lineObj)       ;
        
    }
    try {
    update caseObj;
    insert lineObj;
    }
    catch(Exception e){
    return e.getMessage();
    }

return 'success';
}

@AuraEnabled
public static  Map<String, String>  getOperatingUnit(String monetarytransId )
{
   // loadData();
   Map<String, String> options = new Map<String, String>();
    List<PostalUnit__c> OppUnitList = new list<PostalUnit__c>();
     string EMPTY_HANDLING_TRANSACTION =  System.label.Cs_None;
    
     Monetary_Transaction__c  transobj= new Monetary_Transaction__c ();
    transobj =[Select id, name, tolabel(RecordType.Name),RecordType.DeveloperName,case__r.Service_Product__r.postal_unit_operating_code__c, Transaction_Action__c,   Other_information__c, Service_Product__c, case__r.Service_Product__r.Name, case__c, Valutakode__c,Form_of_Transaction__c   from Monetary_Transaction__c where id =  :monetarytransId];
   
    String search = transobj.case__r.Service_Product__r.postal_unit_operating_code__c;
    if(search !=null && search.length() ==6){
   
      search = 'enh.PNAS..'+search;

    OppUnitList = [Select id,Name,DRM_id__c  from PostalUnit__c where DRM_id__c like : search and is_active__c=true order by name];
    system.debug('~~~OppUnitList::'+OppUnitList+'size::'+OppUnitList.size());
    }else{
    
    search = '___.'+search+'.%';
    //search = '%'+search;
    OppUnitList = [Select id,Name,DRM_id__c  from PostalUnit__c where DRM_id__c like : search and is_active__c=true and unit_number_in_subsidiary__c!=null order by name limit 999];
 }  
    options.put('', EMPTY_HANDLING_TRANSACTION);
    for( PostalUnit__c f : OppUnitList )
    {
    options.put(f.DRM_id__c.substring(f.DRM_id__c.lastIndexOfIgnoreCase('.')+1), f.Name);
    // options.put(f.Name, f.Name);
    }    
    return options;
}



}