public with sharing class Case_SubmitPlanWizardController {
    
    public class KATSsubmitPlanException extends Exception {}
    
    private Case c;
    public String caseId{ get; set; }
    private CsvReader csvReader;
    
    public Attachment csvFile{ get; set; }
    public integer fileSize { get; set; }
    
    public List<List<String>> csvTextList { get; set; }
    public List<Case> plannedShipments { get; set; }
    
    public String product {get; set;}
    public String PRU = 'PRU';
    public String POST_ABO = 'POST_ABO';
    public String POST_ABO_PL = 'POST_ABO_PL';

    //Private variable to hold Product information of 'Planlagt innlevering'
    private Code_Event__c planInn;    

    //Radiobutton for initiating type of csv-file
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption(PRU,'PRU')); 
        /*Commented by Rajesh Singh as part of Object Translation 
        options.add(new SelectOption(POST_ABO,System.Label.cs_Leaf)); 
        options.add(new SelectOption(POST_ABO_PL,System.Label.cs_Mail)); return options; 
        CSPhase2 Rajesh 
        
        Commented by Rajesh Singh as part of Object Translation
        Removed the options as a part of Terje Request */
       // options.add(new SelectOption(POST_ABO,System.Label.cs_Leaf)); 
       // options.add(new SelectOption(POST_ABO_PL,System.Label.cs_Mail));
        return options;
        
        //supriya 26 01 2017
    }
    
    //Constructor
    public Case_SubmitPlanWizardController() {
        caseId = ApexPages.currentPage().getParameters().get('case'); ApexPages.currentPage().getParameters().put('case', caseId);
        csvFile = new Attachment();
        product='PRU';

        //Fetching product with the name 'Planlagt innlevering'
        List<Code_Event__c> prods = new List<Code_Event__c>();
        prods = [SELECT Id, Name FROM Code_Event__c Where Name = 'Planlagt innlevering' AND IsActive__c = TRUE LIMIT 1];
        if(prods.size() > 0)
        {
            planInn = prods.get(0);
        }
        else
        {
            planInn = null;
        }
        
    }

    //Go to step 1 to upload cvs file
    public PageReference step1() {
        return Page.Case_submitPlanWizard_Step1;
    }

    //Go to step 2 to verify uploaded data
    public PageReference step2() {
        try {
            /*if(csvFile.Body == null){ throw new KATSsubmitPlanException('Vennligst legg til gyldig CSV fil'); }
            if(product == null){ throw new KATSsubmitPlanException('Vennligst huk av for type sendeplan'); }
              CSPhase2 Rajesh 
             Commented by Rajesh Singh as part of Object Translation*/
            if(csvFile.Body == null){ throw new KATSsubmitPlanException(System.Label.cs_error_csv); }
            if(product == null){ throw new KATSsubmitPlanException(System.Label.cs_Submit_Error); }
            if(csvFile.ContentType.equals('application/vnd.ms-excel')
                || csvFile.ContentType.equals('text/comma-separated-values')
                || csvFile.ContentType.equals('text/csv')
                || csvFile.ContentType.equals('application/csv')
                || csvFile.ContentType.equals('application/excel')
                || csvFile.ContentType.equals('application/vnd.msexcel')
                || csvFile.ContentType.equals('text/anytext')
            ) {
                CsvToTextList();
            } else {
            //throw new KATSsubmitPlanException('Feil filformat'); 
            //  CSPhase2 Rajesh 
                throw new KATSsubmitPlanException(System.Label.cs_Wrong_File_format);
            }
            
            
        } catch(KATSsubmitPlanException e) {
            ApexPages.addMessages(e);
            return null;
        }catch(Exception e) {            ApexPages.addMessages(e);            return null;        }
        return Page.Case_submitPlanWizard_Step2;
    }
    
    //Go to step 3 to see the created objects
    public PageReference step3() {
        c = [SELECT AccountId, ContactId, Type__c, Produkt__c, Priority, Reason, Waiting_for_unit__c, Id FROM Case WHERE Id = :caseId LIMIT 1];
        createPlannedShipment();
        return Page.Case_submitPlanWizard_Step3;
    }
    
    
    
    //Go to step 4 to store the uploade values in SF
    public PageReference save() {
        try {
            Database.DMLOptions dml = new Database.DMLOptions();
            dml.assignmentRuleHeader.useDefaultRule = true;
            database.insert(plannedShipments, dml);
            String ResumeDate;
           
            //DateToBeResumed depends on type of product 
            if (product.equals('PRU')){
               
                //setDateToBeResumed(plannedShipments, -35);
                
                //Added as part of change : C-06970 Change the days when importing sendeplan to Service Cloud
                ResumeDate = environment_settings__c.getInstance('ImportSendPlanDateToBeResumedPRU').value__c;         setDateToBeResumed(plannedShipments,Integer.valueof(ResumeDate));
                
            } else {
                 //setDateToBeResumed(plannedShipments, -28); 
                
                //Added as part of change : C-06970 Change the days when importing sendeplan to Service Cloud
                ResumeDate = environment_settings__c.getInstance('ImportSendPlanDateToBeResumed').value__c;
                setDateToBeResumed(plannedShipments,Integer.valueof(ResumeDate));      
            }
                        
            csvFile.ParentId = c.Id;    upsert csvFile;
        } catch(Exception e) {
            ApexPages.addMessages(e);
        }
        return Page.Case_submitPlanWizard_Step4;
    }
    
    //Convert the CVS file to text
    private void CsvToTextList() {
        csvTextList = new List<List<String>>();
        
        csvReader = new CsvReader(new CsvParser(), csvFile.Body.ToString(), '\n');
        List<List<String>> helper = csvReader.readAll();
        
        for(List<String> row: helper) {
            String content = '';
            for(String field : row) {
                content+= field;
            }
            if(content.trim().length() > 0) {
                csvTextList.add(row);
            }
        }
        
    }
    
    //Create plannedShipment case objects and store them in a list
    private void createPlannedShipment() {
        if(csvTextList != null && csvTextList.size() > 0) {
            
            plannedShipments= new List<Case>();
            
            for(integer i = 1; i < csvTextList.size(); i++) {
                List<String> row = csvTextList.get(i);
                if(!row.isEmpty()) {                    Case plannedShipment = new Case();                   
                    
                    /********
                    Explanation of field mapping from the csv-file
                    
                    row.get(0) = Subject
                    
                    row.get(1) = Submission_date__c
                    row.get(2) = Submission_place_TEXTONLY__c
                    row.get(3) = Vekt_pr_sending__c
                    
                    //Postreklame Uadressert
                    row.get(4) = Booking_date__c
                    row.get(5) = Release_deadline__c
                    row.get(6) = Distribution_date__c
                    row.get(7) = Number_of_circulation__c
                    
                    //Blad, tidsskrifter og katalog
                    row.get(4) = Total_number_of_submission_pr_submission__c
                    row.get(5) = Part_of_submission_number__c
                    row.get(6) = Number_of_shipment_A_pri_Big__c
                    row.get(7) = Number_of shipment_A_pri_maxi__c
                    row.get(8) = Number_of_shipment_B_ec_maxi_c
                    row.get(9) = Number_of_shipment_B_ec_big_c
                    row.get(10) = release_number__c
                    
                    //Postabonnement Pluss
                    row.get(4) +/n+
                    row.get(5) +/n/
                    row.get(6) +/n/
                    row.get(7) +/n/ 
                    row.get(8) +/n/
                    row.get(9)  =  description
                    
                    
                    *********/
                    
                    //Saksinformasjon
                    plannedShipment.Subject = row.get(0);    plannedShipment.RecordTypeId = KATSutilities.getRecordType('planned_distribution_case');
                    plannedShipment.Code_Event__c = planInn.Id;   plannedShipment.Category__c = planInn.Name;
                    plannedShipment.Origin = environment_settings__c.getInstance('ImportSendeplanOrigin').value__c;

                    if(c.AccountId != null){ plannedShipment.AccountId = c.AccountId; }
                    if(c.ContactId != null){ plannedShipment.ContactId = c.ContactId; }
                    //if(c.Type__c != null){ plannedShipment.Type__c = c.Type__c; }
                    //if(c.Produkt__c != null){ plannedShipment.Produkt__c = c.Produkt__c; }
                    //if(c.Category__c != null){ plannedShipment.Category__c = c.Category__c; } -> Category should not be set any more
                    //if(c.Reason != null){ plannedShipment.Reason = c.Reason; }
                    
                    plannedShipment.Status = 'Planlagt';
                    if(c.Waiting_for_unit__c != null){ plannedShipment.Waiting_for_unit__c = c.Waiting_for_unit__c; }
                    if(c.Id != null){ plannedShipment.ParentId = c.Id; }
                    if(c.Priority != null){ plannedShipment.Priority = c.Priority; }
                    
                    //Generell Sendingsinformasjon
                    if(row.get(1) != null && !row.get(1).equals('')){ plannedShipment.Submission_date__c = stringToDate(row.get(1)); }
                    
                    if(row.get(2) != null) { plannedShipment.Submission_place_TEXTONLY__c = row.get(2); }
                    if(row.get(3) != null && row.get(3) != '') { plannedShipment.Vekt_pr_sending__c = (Decimal.valueOf(row.get(3))/1000); }
                    
                   //Checking chosen product of the csv-file
                   if (product.equals('PRU')){setPRU(row, plannedShipment);}              if (product.equals('POST_ABO')){setPOST_ABO(row, plannedShipment);}
                   if (product.equals('POST_ABO_PL')){setPOST_ABO_PL(row, plannedShipment);}     plannedShipments.add(plannedShipment);
                }
            }
        }
    }
    
    private Date stringToDate(String s) {
        String[] stringDate = s.split('\\.'); Integer d =  Integer.valueOf(stringDate[0]);    Integer m = Integer.valueOf(stringDate[1]);     Integer y = Integer.valueOf(stringDate[2]);   return date.newInstance(y,m,d); 
    }
    
    //Postreklame Uadressert
    private void setPRU(List<String> row, Case plannedShipment) {
        if(row.get(4) != null && row.get(4) != ''){ plannedShipment.Booking_date__c = stringToDate(row.get(4).trim()); }
        if(row.get(5) != null && row.get(5) != ''){ plannedShipment.Release_deadline__c = stringToDate(row.get(5).trim()); }
        if(row.get(6) != null && row.get(6) != ''){ plannedShipment.Distribution_date__c = stringToDate(row.get(6).trim()); }
        if(row.get(7) != null && row.get(7) != '' && row.get(7).trim() != ''){ plannedShipment.Number_of_circulation__c = Decimal.valueOf(row.get(7).trim()); }
    }
    
    //Blad, tidsskrifter og katalog 
    private void setPOST_ABO(List<String> row, Case plannedShipment) {
    
        if(row.get(4) != null && row.get(4) != '' && row.get(4).trim() != ''){ plannedShipment.Total_number_of_shipment_pr_submission__c = Decimal.valueOf(row.get(4).trim()); }
        if(row.get(5) != null && row.get(5) != '' && row.get(5).trim() != ''){ plannedShipment.Part_of_submission_number__c = Decimal.valueOf(row.get(5).trim()); }
        if(row.get(6) != null && row.get(6) != '' && row.get(6).trim() != ''){ plannedShipment.number_of_shipment_A_Pri_Big__c = Decimal.valueOf(row.get(6).trim()); }
        if(row.get(7) != null && row.get(7) != '' && row.get(7).trim() != ''){ plannedShipment.Number_of_shipment_A_pri_maxi__c = Decimal.valueOf(row.get(7).trim()); }
        if(row.get(8) != null && row.get(8) != '' && row.get(8).trim() != ''){ plannedShipment.number_of_shipment_B_ec_big__c = Decimal.valueOf(row.get(8).trim()); }
        if(row.get(9) != null && row.get(9) != '' && row.get(9).trim() != ''){ plannedShipment.number_of_shipment_B_ec_maxi__c = Decimal.valueOf(row.get(9).trim()); }
        if(row.get(10) != null && row.get(10)!= ''){ plannedShipment.release_number__c = row.get(10); }
    }
    
    //Postabonnement Pluss
    private void setPOST_ABO_PL(List<String> row, Case plannedShipment) {
        if(row.get(4) != null && row.get(4) != '')
          { plannedShipment.description = System.Label.cs_Fulldistributiondate + row.get(4).trim() + '\n' + 
                                          System.Label.cs_submissions + row.get(5).trim() + '\n' +
                                          System.Label.cs_Receivergroup + row.get(6).trim() + '\n' +
                                          System.Label.cs_Number + row.get(7).trim() + '\n' +
                                          System.Label.cs_Areaofdistribution + row.get(8).trim();}
        plannedShipment.date_to_be_resumed__c = stringToDate(row.get(4)).addDays(-28);     removeTasks(plannedShipments);
    }
    
    private void setDateToBeResumed(List<Case>plannedShipments, Integer days) {
        for(Case plannedShipment: plannedShipments) {       if(plannedShipment.Submission_date__c != null){ plannedShipment.date_to_be_resumed__c = plannedShipment.Submission_date__c.addDays(days); }
        }
        upsert plannedShipments;      removeTasks(plannedShipments);
    }
    
    private void removeTasks (List<Case>plannedShipments){
       
       system.debug('I removeTasks');
       List<Id> caseIds = new List<Id>();      for(Case plannedShipment: plannedShipments) {      CaseIds.add(plannedShipment.id);   }
       
       List<Task> caseTasks = new List<Task>();  caseTasks = [SELECT id, whatId FROM Task WHERE whatId in :caseIds];    delete caseTasks;
       system.debug('Etter Delete');
    
    }
     
}