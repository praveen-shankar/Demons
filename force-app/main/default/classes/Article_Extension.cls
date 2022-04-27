//Replaced Product__c by Service_Product__c | P3 Project | 19th July | Rajeev S

public with sharing class Article_Extension {
    
    /* VARIOUS PARAMETERS */
    //CSphase2, Dinesh, 27/12/2016 
    private final string MANUAL_HANDLING_TRANSACTION = 'Manuell Behandling';//'Manuell behandling';
    //private final string MANUAL_HANDLING_TRANSACTION = 'Manual Handling';
    private final string EMPTY_HANDLING_TRANSACTION = '--None--';
    private final string SHOW_AUTO_PRODUCTS = 'AUTO';
    private final string SHOW_ALL_PRODUCTS = 'EMPTY';
    private final string REGRESS = 'Regress';
   //CSphase2, Dinesh, 27/12/2016 
    private final string KREDITTNOTA = 'Kredittnota';
    //private final string KREDITTNOTA = 'Credit Memo';
    //CSphase2, Akash, 16122016 
    //private final string TYPE_HELPTEXT = 'Manuell Behandling kan ikke kombineres med andre utbetalingstyper i samme sak. Opprett eventuelt egen sak.';
    private final string TYPE_HELPTEXT = System.Label.cs_TransactionLineItemHT;
   //CSphase2, Dinesh, 27/12/2016 
   //private final string ACCOUNT_STATUS_OK = 'Gyldig';
    private final string ACCOUNT_STATUS_OK = 'Valid';
    private final string ACCOUNT_STATUS_ACTIVE = 'Active';

    /* CONTROLLER PARAMETERS */
    private Monetary_Transaction_Line_Item__c monetarytransline; 
    private Monetary_Transaction__c monetarytrans;
    private Case transcase;
    private Case regcase;
    private Account transaccount;
    private String Product;
    private String messages = '';
    private set<String> existingtranslines = new set<String>();
    private List<Monetary_Transaction_Line_Item__c> items = null;
    private List<Monetary_Transaction_Line_Item__c> motpostItems = null;
    PageReference pageRef = null;

    /* CONSTRUCTOR */
    public Article_Extension(ApexPages.StandardController controller) {
        this.monetarytransline = (Monetary_Transaction_Line_Item__c)controller.getRecord(); 
        monetarytransline.Transaksjon__c = System.currentPagereference().getParameters().get('TransId'); 
        monetarytransline.Description__c = 'AUTO';               
    }
    
    /* GET/SET EXISTING LINE ITEMS  FOR THE TRANSACTION */
    public List<Monetary_Transaction_Line_Item__c> getItems() {
        if(items == null ){
            loadLineItems();
        }
        return items;
    }
    
    public void loadLineItems(){
        List<Monetary_Transaction_Line_Item__c> lineItems = 
            [Select id,
            Description__c,
            is_motpost__c, 
            Transaksjon__c, 
            name, Type__c, 
            Regress_type__c, 
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
            FROM Monetary_Transaction_Line_Item__c where Transaksjon__c  = :monetarytrans.id ORDER BY CreatedDate DESC];
        if(lineItems.size() > 0 ){
            system.debug('Returning Items : ' + lineItems);
            items = lineItems;
        } else {
            items = null;
        }
    }
    
    
    /* GET RELATED TRANSACTION, CASE AND ACCOUNT */
    public void loadData(){        
        if(monetarytransline.Transaksjon__c != null){
                monetarytrans = [Select id, name, tolabel(RecordType.Name),RecordType.DeveloperName, Transaction_Action__c,   Other_information__c, Service_Product__c, case__r.Service_Product__r.Name, case__c, Valutakode__c,Form_of_Transaction__c   from Monetary_Transaction__c where id = :monetarytransline.Transaksjon__c];
        }
        for(Monetary_Transaction_Line_Item__c trli : [select Type__c from Monetary_Transaction_Line_Item__c where Transaksjon__c = :monetarytransline.Transaksjon__c]){
                existingtranslines.add(trli.Type__c);
        }
        
        product = getMTProduct();
        
        if(monetarytrans.case__c != null){
            transcase = [Select id, Accountid, RecordType.Name, RecordType.DeveloperName from Case where id = :monetarytrans.case__c];
            regcase = [Select id, car_number__c, transporter__c from Case where id = :monetarytrans.case__c];
             //commented line 93 to change "transporter__c" field to picklist according to CR C-08673 Carrier field
        }
        
        if(transcase.AccountId != null){
            transaccount = [Select id, name, status__c from Account where id = :transcase.AccountId];
        }

    }


    /* METHODS FOR THE addMonetaryTransactionLineItem.page */
    
    public PageReference validateAndSave(){
                boolean validationbeforesave = validation();
                boolean fwd = true;
                if(validationbeforesave){
                        try{
                        System.debug('@@@monetary@@'+monetarytransline);
                        insert monetarytransline;
                        upsert regcase;
                        
                }catch(DmlException ex){
                        ApexPages.addMessages(ex);
                        fwd = false;
                }
                        if(fwd){
                                pageRef = new PageReference('/'+getMTid());        
                        pageRef.setRedirect(true);
                        }
                        else{
                                pageRef = null;
                        }       
                }
                return pageRef;
    }

    public Boolean validation()
    {
        boolean status = true;
        if(transaccount == null){
                        //CSphase2, Dinesh, 27/12/2016 
                        //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Du har inget Kundenavn på saken'));
                        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_Article_Extension_if_error1));
                        status = false;
        }
        else if( !(transaccount.status__c == ACCOUNT_STATUS_OK || transaccount.status__c == ACCOUNT_STATUS_ACTIVE) && monetarytransline.Type__c != MANUAL_HANDLING_TRANSACTION){
               //CSphase2, Dinesh, 27/12/2016 
               // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Transaksjonen er ikke tillatt når kunden ikke er Gyldig'));
               KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_Article_Extension_if_error2));
               status = false;
        }
        if(transcase == null){
                       //CSphase2, Dinesh, 27/12/2016 
                       // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Du har ingen sak på Transaksjonen'));
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_Article_Extension_if_error3));        
                status = false;
        }
        if(monetarytransline.Type__c == ''|| monetarytransline.Type__c == null){
                //CSphase2, Dinesh, 27/12/2016 
                //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Du må angi en utbetalningstype på transaksjonslinjen'));
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_Article_Extension_if_error4));
                status = false;
        }
        if(existingtranslines.contains(monetarytransline.Type__c) 
            && !(monetarytransline.Type__c == MANUAL_HANDLING_TRANSACTION 
                || monetarytransline.Type__c == REGRESS
                || monetarytransline.Type__c == KREDITTNOTA)){
                //CSphase2, Dinesh, 27/12/2016 
                // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Du kan kun registrere en transaksjonslinje per Utbetalingstype'));
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_Article_Extension_if_error5));
                status = false;
        }
        if(monetarytransline.Type__c == REGRESS && KATSutilities.isEmpty(monetarytransline.Regress_type__c)){
                //CSphase2, Dinesh, 27/12/2016 
                //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Hvis utbetalingstype er Regress må Regresstype også fylles ut'));
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_Article_Extension_if_error6));
                status = false;
        }
        if(monetarytransline.Type__c == REGRESS && KATSutilities.isEmpty(monetarytransline.Regress_Account__c)){
                //CSphase2, Dinesh, 27/12/2016 
                //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Hvis utbetalingstype er Regress må Kunde(Regress) også fylles ut'));
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_Article_Extension_if_error7));
                status = false;
        }
        if((monetarytransline.Type__c == REGRESS  || monetarytransline.Type__c == KREDITTNOTA) && KATSutilities.isEmpty(monetarytransline.Description__c)){
                //CSphase2, Dinesh, 27/12/2016 
                //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Beskrivelse må fylles ut'));
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_Article_Extension_if_error8));
                status = false;
        }
        if((monetarytransline.Type__c == REGRESS  || monetarytransline.Type__c == KREDITTNOTA) && KATSutilities.isEmpty(monetarytransline.cargo_product_code__c)){
                //CSphase2, Dinesh, 27/12/2016 
                //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Produktkode må fylles ut'));
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_Article_Extension_if_error9));
                status = false;
        }
        if((monetarytransline.Type__c == REGRESS  || monetarytransline.Type__c == KREDITTNOTA) && KATSutilities.isEmpty(monetarytransline.cargo_division_code__c)){
                //CSphase2, Dinesh, 27/12/2016 
                //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Avdelingskode må fylles ut'));
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_Article_Extension_if_error10));
                status = false;
        }
        if((monetarytransline.Type__c == REGRESS  || monetarytransline.Type__c == KREDITTNOTA) && KATSutilities.isEmpty(monetarytransline.vare_number_NAV__c)){
                //CSphase2, Dinesh, 27/12/2016 
                //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Vare må fylles ut'));
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_Article_Extension_if_error11));
                status = false;
        }
        return status;
    }
    

    
    //builds a picklist of articles based on the product
    public List<selectOption> getAllowedArticles() 
    {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
       // if(monetarytrans.RecordType.Name == 'Transaksjon Valuta')
        if(monetarytrans.RecordType.DeveloperName == 'Manual_Currency_Transaction')
     
        {
            options.add(new selectOption('', EMPTY_HANDLING_TRANSACTION));
            options.add(new selectOption( MANUAL_HANDLING_TRANSACTION,System.Label.cs_Payment_type_value1));
        }
        
        //CSphase2, Dinesh, 28/12/2016 
        //else if((transcase.RecordType.Name == 'Reklamasjon Gods')||(transcase.RecordType.Name == 'Klage' && blocked_products__c.getAll().containsKey(monetarytrans.case__r.Service_Product__r.Name)))
        
       //added as part of chnage : C05583 - New value to the field “Method of settlement” - Start
       else if((transcase.RecordType.DeveloperName == 'Cargo_Claims')||(transcase.RecordType.DeveloperName == 'complaint')  && monetarytrans.Form_of_Transaction__c == 'Settlement by insurance company third party')
       {   
           options.add(new selectOption('', EMPTY_HANDLING_TRANSACTION));
           options.add(new selectOption( MANUAL_HANDLING_TRANSACTION, System.Label.cs_Payment_type_value1));
       }
       
       //added as part of chnage : C05583 - New value to the field “Method of settlement” - end
       
    else if((transcase.RecordType.DeveloperName == 'Cargo_Claims')||(transcase.RecordType.DeveloperName == 'complaint' && blocked_products__c.getAll().containsKey(monetarytrans.case__r.Service_Product__r.Name)))
        {
            options.add(new selectOption('', EMPTY_HANDLING_TRANSACTION));
            if(monetarytrans.Transaction_Action__c == SHOW_ALL_PRODUCTS)
            {
                options.add(new selectOption( MANUAL_HANDLING_TRANSACTION, System.Label.cs_Payment_type_value1));
                options.add(new selectOption( KREDITTNOTA ,System.Label.cs_Credit_Memo));
                options.add(new selectOption(REGRESS,REGRESS));
            } 
            else if (monetarytrans.Transaction_Action__c == SHOW_AUTO_PRODUCTS) 
            {
                options.add(new selectOption(KREDITTNOTA, System.Label.cs_Credit_Memo));
                options.add(new selectOption(REGRESS,REGRESS));
            }
            else
            {
                options.add(new selectOption(MANUAL_HANDLING_TRANSACTION,System.Label.cs_Payment_type_value1));
            }
        } 
        else 
        {
            options.add(new selectOption('', EMPTY_HANDLING_TRANSACTION)); //add the --None-- option of 'Manuell Behandling' in case the user doesn't want to select a value or in case no values are returned from query below

            if(monetarytrans.Transaction_Action__c != SHOW_AUTO_PRODUCTS)
            {
                    options.add(new selectOption(MANUAL_HANDLING_TRANSACTION,System.Label.cs_Payment_type_value1)); //add the first option of 'Manuell Behandling' in case the user doesn't want to select a value or in case no values are returned from query below
            }
            
            //TODO: remove accountcheck when status is investigated and testdata has correct status
            if(monetarytrans.Transaction_Action__c == SHOW_AUTO_PRODUCTS || monetarytrans.Transaction_Action__c == SHOW_ALL_PRODUCTS)
            {
                Set<String> distinctOptions = new Set<String>();
                List<Id> prodId_Lst = new List<Id>();
                     
                //query for articles allowed on the product
                for(Service_Product__c p: [Select Id From Service_Product__c Where Name = :product])
                {
                    prodId_Lst.add(p.Id);
                }
                
                Schema.DescribeFieldResult fieldResult = Article_Number__c.Transaction_Type__c.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
   

                //This fetched all the Transaction Type (Utbetalingstype), based on the Article Number setup based on the Product ID
                for (Article_Number__c arts : [SELECT id, Name, toLabel(Transaction_Type__c)   FROM Article_Number__c WHERE Service_Product__c IN :prodId_Lst]) 
                {     
                    if(!distinctOptions.contains(arts.Transaction_Type__c))
                    {
                    
                     for(Schema.PicklistEntry f : ple)
                           {
                              if(f.getLabel() == arts.Transaction_Type__c){
                              options.add(new selectOption(f.getValue(), arts.Transaction_Type__c)); //for all records found - add them to the picklist options
                              distinctOptions.add(arts.Transaction_Type__c);
                               break;
                               } 
                           }
                                                
                       //options.add(new selectOption(arts.Transaction_Type__c, arts.Transaction_Type__c)); //for all records found - add them to the picklist options
                         //     distinctOptions.add(arts.Transaction_Type__c);
                    }
                }
            }
        }

        return options; //return the picklist options
    }
    
    /* METHODS FOR THE createMotpostLineItem.page */
    
    public List<Monetary_Transaction_Line_Item__c> getMotpostItems() {
        if(motpostItems == null ){
            system.debug('Running setMotpostItems()');
            setMotpostItems();
        }
        system.debug('Returning getMotpostItems(). motpostItems are currently: ' + motpostItems);
        return motpostItems;
    }
    
    public void setMotpostItems() {
        Map<Id,Monetary_Transaction_Line_Item__c> motpostMap = new Map<Id,Monetary_Transaction_Line_Item__c>();
        // Add all transaction lines which are not motposts to the list
        for (Monetary_Transaction_Line_Item__c tl : getItems()){
            if(!tl.is_motpost__c){
                tl.Description__c = '';
                motpostMap.put(tl.id, tl);
            }
        }
        // Remove all transaction lines for which a motpost already has been created.
        for (Monetary_Transaction_Line_Item__c tl : getItems()){
            if(tl.is_motpost__c && tl.hidden_motpost_reference__c != null){
                motpostMap.remove(tl.hidden_motpost_reference__c);
            }
        }
        motpostItems = motpostMap.values();
    }
    
    public PageReference validateAndSaveMotpost(){

        boolean validationPass = validateMotpost();
        if(!validationPass){
            return null;
        }
        
        if(String.isBlank(monetarytrans.Other_information__c)){
           // CSphase2, Dinesh, 28/12/2016 
           // monetarytrans.Other_information__c = 'Denne godkjenningen gjelder motposter. Detaljer: ';
            monetarytrans.Other_information__c = System.Label.cs_monetarytrans_Other_information_c;
        }
        
        List<Monetary_Transaction_Line_Item__c> newMotpostItems= new List<Monetary_Transaction_Line_Item__c>();
        // Iterate all items where checkbox is checked and add them to the list of new motposts
        for (Monetary_Transaction_Line_Item__c tl : motpostItems){
            if(tl.is_motpost__c){
                newMotpostItems.add(createMotpost(tl));
                // CSphase2, Dinesh, 28/12/2016 
                // monetarytrans.Other_information__c += 'Motpost til ' + tl.Name + ' av typen '+ tl.Type__c + ', beløp ' + tl.Line_Amount__c + '. Kommentar fra bruker: ' + tl.Description__c + '.';
                monetarytrans.Other_information__c += System.Label.cs_monetarytrans_Other_information_c_1 + tl.Name + System.Label.cs_monetarytrans_Other_information_c_2 + tl.Type__c + System.Label.cs_monetarytrans_Other_information_c_3 + tl.Line_Amount__c + System.Label.cs_monetarytrans_Other_information_c_4 + tl.Description__c + '.';
            }
        }
            
        boolean fwd = true;
        if(newMotpostItems.size() > 0){
            try{
                insert newMotpostItems;
                update monetarytrans;
            }catch(DmlException ex){
                ApexPages.addMessages(ex);
                fwd = false;
            }
            if(fwd){
                pageRef = new PageReference('/'+getMTid());     
                pageRef.setRedirect(true);
            }
            else{
                pageRef = null;
            } 
        }
        return pageRef;
    }
    
    /*
    *  validateMotpost() fails if:
    *  1) No line items are checked
    *  2) The Description field is blank for any checked line items
    */
    public Boolean validateMotpost(){
        if(motpostItems == null){
            // CSphase2, Dinesh, 28/12/2016 
            // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Noe har gått galt. Vennligst prøv igjen.'));
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_Article_Extension_if_error12));
            return false;
        } else {
            Integer counter = 0;
            for (Monetary_Transaction_Line_Item__c tl : motpostItems){
                if(tl.is_motpost__c){
                    counter++;
                }
            }
            if(counter == 0){
                // CSphase2, Dinesh, 28/12/2016 
                // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Vennligst velg minst en transaksjonslinje du ønsker å opprette motpost på.'));
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_Article_Extension_if_error13));
                return false;
            }
        }
        //OPTIONAL: MAKE DESCRIPTION REQUIRED
        for (Monetary_Transaction_Line_Item__c tl : motpostItems){
            if(tl.is_motpost__c && String.isBlank(tl.Description__c)){
                // CSphase2, Dinesh, 28/12/2016 
                // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Du må fylle inn beskrivelse på alle transaksjonsliner du skal opprette motpost på.'));
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_Article_Extension_if_error14));
                return false;
            }
        }
        return true;
    }
    
    public Monetary_Transaction_Line_Item__c createMotpost(Monetary_Transaction_Line_Item__c tl){
        return new Monetary_Transaction_Line_Item__c(
            Description__c = 'Motpost til ' + tl.Name + '. Kommentar fra bruker: ' + tl.Description__c,
            is_motpost__c = tl.is_motpost__c , 
            Transaksjon__c = tl.Transaksjon__c , 
            Type__c = tl.Type__c + ' - Motpost', 
            Regress_type__c = tl.Regress_type__c , 
            Line_Amount__c = 0 - tl.Line_Amount__c , 
            cargo_division_code__c = tl.cargo_division_code__c , 
            Invoice_number__c = tl.Invoice_number__c , 
            cargo_product_code__c = tl.cargo_product_code__c , 
            Amount_foreign_currency__c = tl.Amount_foreign_currency__c ,
            Article_Number__c = tl.Article_Number__c,
            hidden_motpost_reference__c = tl.id
        );
    }
    
    /* VARIOUS METHODS */    
    
    public PageReference cancelAndBack(){
        PageReference pageRef = new PageReference('/'+getMTid());        
        pageRef.setRedirect(true);
    
        return pageRef;
    }

    public String getMessages(){
        return messages;
    }
    
    public String getTrans() {
        return regcase.transporter__c;
        //commented line 441 to change "transporter__c" field to picklist according to CR C-08673 Carrier field
    }
    
    public void setTrans(String input) {
        regcase.transporter__c = input;
         //commented line 446 to change "transporter__c" field to picklist according to CR C-08673 Carrier field
    }
    
    public String getBil() {
        return regcase.car_number__c;
    }
    
    public void setBil(String input) {
        regcase.car_number__c = input;
    }
    
    public void savelineitem(){
        upsert monetarytransline;
    }
    public String getMTProduct(){
        return monetarytrans.Service_Product__c;
    }
    public String getMTName(){
        return monetarytrans.Name;
    }
    public String getAccountStatus(){
        return transaccount.status__c;
    }
    public Id getMTid(){
        return monetarytrans.Id;
    }
    public String getMTRecordTypeName(){
       return monetarytrans.RecordType.Name;
      
    
    }
    public String getMTCurrency(){
        return monetarytrans.Valutakode__c; 
    }
    
    public string getTypeHelptext(){
        return TYPE_HELPTEXT;
    }

    /* TEST HELPER METHODS */     
    public void setIsMotpostTrue() {
        for (Monetary_Transaction_Line_Item__c tl : motpostItems){
            tl.is_motpost__c = true;
        }
    }
    
    public void setMotpostDesc(String text) {
        for (Monetary_Transaction_Line_Item__c tl : motpostItems){
            tl.Description__c = text;
        }
    }

}