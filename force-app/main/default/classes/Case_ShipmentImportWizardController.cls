public with sharing class Case_ShipmentImportWizardController {
    public Attachment csvFile{ get; set; }
    public integer fileSize { get; set; }
    public List<List<String>> csvTextList { get; set; }
    public List<List<Cell>> csvCellList { get; set; }
    private CsvReader csvReader;
    public String firstColumn { get; set; }
    public List<List<SelectOption>> allFieldNameOptions { get; set; }
    private Map<String, String> fieldNames;
    private Map<String, String> humanReadableFieldNames;
    public List<SelectOptionHelper> selectOptionHelpers { get; set; }
    public List<SelectOption> fieldNameOptions { get; set; }
    public List<Case> cases {get; set;}
    private Case parentCase; 
    public String caseId{ get; set; }
    
    public class ShipmentWizardException extends Exception {}

    //Private variables to hold the Record Type Id of Case Record Type: KLAGE and BESTILLINGER
    //Commented Line 20, 21 for CR C-08669
    //private Id klageRecTypeId = KATSutilities.getRecordType('complaint');//used api name no change needed for CSphase2
    //private Id bestRecTypeId = KATSutilities.getRecordType('planned_distribution_case');//used api name no change needed for CSphase2

    //Private variable to hold Product information of 'Planlagt innlevering'
    private Code_Event__c planInn;
    private Service_Product__c product;
    private Code_Reason1__c reason1;
    private Code_Reason2__c reason2;
    

    public Case_ShipmentImportWizardController()
    {
        csvFile = new Attachment();
        initFieldNameOptions();
        String caseId = ApexPages.currentPage().getParameters().get('case');

        List<Case> cases = [Select Id from Case where id= :caseId LIMIT 1];
     
     /*   
        //Fetching product with the name 'Planlagt innlevering'
        List<Code_Event__c> inquiryType = new List<Code_Event__c>();
        inquiryType = [SELECT Id, Name FROM Code_Event__c Where Name = 'Planlagt innlevering' AND IsActive__c = TRUE LIMIT 1];   
        
        //CSphase2, Supriya, 14122016 no change needed
        if(inquiryType.size() > 0)
        {
            planInn = inquiryType.get(0);
            System.debug('Case Shipment Wizard: Product Found');
        }
        else
        {
            planInn = null;
        }*/
        
        
        if(cases.size() > 0)
        {
                parentCase = [Select Id,Category__c,Code_Event__c,Produkt__c,Service_Product__c,reason__c,Code_Reason1__c,Code_Reason2__c, 
                                Submission_date__c,
                                Vekt_pr_sending__c,
                                 Delivery_place__c,
                                LM_sender_reference__c,
                                shipper_name__c,
                                Sender_terminal__c,
                                 shipper_address__c,
                                shipper_zip_code__c,
                                 shipper_postal_address__c,
                                 shipper_country__c,
                                 Shipper_CountryCode__c,
                                Category_shipment_content__c,
                                external_description__c,
                                LM_current_country_code__c,
                                LM_current_postal_address__c,
                                LM_current_zip_code__c,
                                LM_current_country__c,  
                             RecordType.Name,RecordType.DeveloperName, RecordTypeId from Case where id= :caseId LIMIT 1];
        }


    }
    
    
    
    private void initFieldNameOptions() 
    {
        humanReadableFieldNames = new Map<String, String>();
        
        fieldNames = new Map<String, String> 
                {
                        'Subject'                                               => 'Subject',
                        //'Forretningsområde'                     => 'Division__c', // bør velges manuelt
                        //'Case Origin'                                         => 'Origin',
                        'Description'                                   => 'Description',
                        'Sendingsnummer'                                => 'Shipment_number__c',
                        'Kollinummer'                                   => 'Shipment_identification__c',
                        'Avsender'                                              => 'shipper_name__c',
                        'Avsenders adresse'                     => 'shipper_address__c',
                        'Avsender postnummer'                   => 'shipper_zip_code__c',
                        'Avsender poststed'                             => 'shipper_postal_address__c',
                        'Avsender land'                                 => 'shipper_country__c',
                        'Avsender Landkode'                             => 'Shipper_CountryCode__c',
                        'Avsender Referanse'                            =>'LM_sender_reference__c',
                        'Mottaker'                                              => 'reciever_name__c',
                        'Mottakers adresse'                     => 'reciever_address__c',
                        'Mottaker postnummer'                   => 'reciever_zip_code__c',
                        'Mottaker poststed'                             => 'reciever_postal_address__c',
                        'Mottaker land'                                 => 'reciever_country__c',
                        'Mottaker Landkode'                             => 'Reciever_CountryCode__c',
                        'Innleveringsdato'                              => 'Submission_date__c',
                        'Sak relatert til enhet'                => 'unit_to_blame__c',
                        'Ytre/gjenstand Beskrivelse'    => 'external_description__c',
                        'Innholds Beskrivelse'                  => 'content_description__c',
                        'Vekt pr. sending'                              => 'Vekt_pr_sending__c',
                        'PO-Beløp'                                               => 'PO_Amount__c',
                        'Innleveringssted'                              => 'Delivery_place__c',
                        'Web Aktørnummer'                                => 'suppliedPartyNumber__c'
                };
        
        for(String humanName: fieldNames.keySet()) {
                humanReadableFieldNames.put(fieldNames.get(humanName), humanName);
        }
        
    }
    
    public class SelectOptionHelper {
        public String selectedFieldName { get; set; }
        public List<SelectOption> selectOptions { get; set; }
        public Boolean isMapped { get; set; }
        public Integer fieldNumber {get; set; }
        
        
        private Map<String, String> fieldNames;
        
        public SelectOptionHelper(Map<String, String> fieldNames) {
                        this.fieldNames = fieldNames;
                        createSelectOptions();
                        /*
                        fieldNumber = numberOfFields;
                        numberOfFields++;
                        */
        }
        
        private void createSelectOptions() {
                selectOptions = new List<SelectOption>();
                List<String> orderedKeys = new List<String>();
                orderedKeys.addAll(fieldNames.keySet());
                orderedKeys.sort();
                
               //  selectOptions.add(new SelectOption('not_selected', '-- '+ System.Label.cs_Not_Used+' --'));
               
                // //CSphase2, Supriya, 14122016  add labels
                
                 selectOptions.add(new SelectOption('not_selected', '-- '+ System.Label.cs_Not_Used+' --'));
                for(String key : orderedKeys) {
                        selectOptions.add(new SelectOption(fieldNames.get(key), key));
                }
        }
    }
    
    public PageReference step1() {
        return Page.Case_ShipmentImportWizard_Step1;
    }
    
    public PageReference step2() {
        //Go to step 2 to verify uploaded data
        try {
           // if(csvFile.Body == null){ throw new ShipmentWizardException('Vennligst legg til gyldig CSV fil'); }
           // //CSphase2, Supriya, 14122016 add labels  
              if(csvFile.Body == null){ throw new ShipmentWizardException(System.Label.cs_error_csv); }
            if(csvFile.ContentType.equals('application/vnd.ms-excel')
                || csvFile.ContentType.equals('text/comma-separated-values')
                || csvFile.ContentType.equals('text/csv')
                || csvFile.ContentType.equals('application/csv')
                || csvFile.ContentType.equals('application/excel')
                || csvFile.ContentType.equals('application/vnd.msexcel')
                || csvFile.ContentType.equals('text/anytext')
            ) {
                CsvToTextList();
                        initSelectOptions();
            } else {
                //throw new ShipmentWizardException('Feil filformat');
                // //CSphase2, Supriya, 14122016 add labels 
                throw new ShipmentWizardException(System.Label.cs_Wrong_File_format);
               
            }
            
            
        } catch(ShipmentWizardException e) {
            ApexPages.addMessages(e);
            return null;
        }catch(Exception e) {
                if(Test.isRunningTest()) {
                        throw e;
                } else {
                ApexPages.addMessages(e);
                }
            return null;
        }
        
        
        return Page.Case_ShipmentImportWizard_Step2;
    }
    
    public PageReference step3() {
        createCasesFromMapping();
        return Page.Case_ShipmentImportWizard_Step3;
    }
    
    private void createCasesFromMapping() 
    {
        cases = new List<Case>();
        Map<String, Schema.SObjectField> fieldMap = Schema.sObjectType.Case.fields.getMap();
                
        String previousValue, newValue;
        for(Integer i = 1; i < csvTextList.size(); i++)
        {
                Case c = new Case(ParentId = parentCase.Id);
                setDefaultFieldValues(c);
                List<Cell> row = csvCellList.get(i);
                for(Integer j = 0; j < row.size(); j++) {
                        Cell cell = row.get(j);
                        if(!selectOptionHelpers.get(j).selectedFieldName.equals('not_selected')) {
                                if(selectOptionHelpers.get(j).selectedFieldName.equals('Description')) {
                                        // description is often used for columns with no suitable field
                                        // so customer service need to know the original cells column name.
                                        newValue = cell.columnName + ': ' + cell.value;
                                        
                                        if(c.Description != null) {
                                                newValue = c.Description + '\n' + newValue; // keep existing description
                                        }
                                }
                                else
                                        newValue = cell.value;
                                DisplayType currentFieldType = fieldMap.get(selectOptionHelpers.get(j).selectedFieldName).getDescribe().getType();
                                
                                if(currentFieldType == DisplayType.TextArea || currentFieldType == DisplayType.String) {
                                        c.put(selectOptionHelpers.get(j).selectedFieldName, newValue);
                                }
                                else if(currentFieldType == DisplayType.Double) {
                                        newValue = newValue.replaceFirst(',', '.');
                                        try {
                                                c.put(selectOptionHelpers.get(j).selectedFieldName, Double.valueOf(newValue));
                                        }
                                        catch(Exception e) {
                                                String humanReadableFieldName = humanReadableFieldNames.get(selectOptionHelpers.get(j).selectedFieldName);
                                                c.addError('Ugyldig tall i kolonne ' + humanReadableFieldName + ': ' + newValue);
                                        }
                                } else if(currentFieldType == DisplayType.Date) {
                                        newValue = newValue.trim();
                                        if(newValue != '') {
                                                try {
                                                        c.put(selectOptionHelpers.get(j).selectedFieldName, Date.parse(newValue));
                                                }
                                                catch(Exception e) {
                                                        String humanReadableFieldName = humanReadableFieldNames.get(selectOptionHelpers.get(j).selectedFieldName);
                                                        c.addError(System.Label.cs_Invalid_date + humanReadableFieldName + ': ' + newValue);
                                                }
                                        }
                                }
                        }
                        
                }
                    cases.add(c);
        }
        
    }
    
    private void setDefaultFieldValues(Case c) 
    {
    
        //Commented next if-else part for CR C-08669    
        /*if(parentCase.RecordType.DeveloperName.toLowerCase().contains('complaint'))
        {
            c.RecordTypeId = klageRecTypeId;
        }
        else
        {
            c.RecordTypeId = bestRecTypeId;
            
        }  */ 
        
         c.RecordTypeId = parentCase.RecordTypeId;

            //If the Child Cases are getting created with the button Import SendAPlan the Henvendelsestype should be set by default
          /*  if(planInn != null)
            {
                c.Code_Event__c = planInn.Id;
                c.Category__c = planInn.Name;
            }*/
            
            if(parentCase.Category__c!=null)
            {
                   c.Code_Event__c = parentCase.Code_Event__c;
                   c.Category__c = parentCase.Category__c;  
                      
            }
            
            if(parentCase.Service_Product__c !=null)
            {      
                      
                   c.Service_Product__c = parentCase.Service_Product__c ;  
                   c.Produkt__c = parentCase.Produkt__c;    
            }
            
            if(parentCase.Code_Reason1__c !=null)
            {
                   c.Code_Reason1__c = parentCase.Code_Reason1__c ;   
                   c.reason__c =  parentCase.reason__c;  
            }
            
             if(parentCase.Code_Reason2__c !=null)
            {
                   c.Code_Reason2__c = parentCase.Code_Reason2__c;    
                     
            }
            
           /* c.Submission_date__c = parentCase.Submission_date__c;
            c.Vekt_pr_sending__c = parentCase.Vekt_pr_sending__c;
            c.Delivery_place__c = parentCase.Delivery_place__c;
            c.LM_sender_reference__c = parentCase.LM_sender_reference__c;
            c.shipper_name__c = parentCase.shipper_name__c;
            c.Sender_terminal__c = parentCase.Sender_terminal__c;
            c.shipper_address__c = parentCase.shipper_address__c;
            c.shipper_zip_code__c = parentCase.shipper_zip_code__c;
            c.shipper_postal_address__c = parentCase.shipper_postal_address__c;
            c.shipper_country__c = parentCase.shipper_country__c;
            c.Shipper_CountryCode__c = parentCase.Shipper_CountryCode__c;
            c.Category_shipment_content__c = parentCase.Category_shipment_content__c;
            c.external_description__c = parentCase.external_description__c;
            c.LM_current_country_code__c = parentCase.LM_current_country_code__c;
            c.LM_current_postal_address__c = parentCase.LM_current_postal_address__c;
            c.LM_current_zip_code__c = parentCase.LM_current_zip_code__c;
            c.LM_current_country__c = parentCase.LM_current_country__c;*/
                    
        
        //Change C-01468 from hardcoded value to use environment setting.
        c.Origin = environment_settings__c.getInstance('ImportShipmentOrigin').value__c;
        //c.Origin = 'Manuelt'; hardcoded value
        //c.Division__c = 'Logistikk Bedrift';     this field is no longer used
        //c.Type__c = 'Registrert';                this field is no longer used
        c.Shipment_identification__c = '0';
        
         //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'i AM out OF CASE DEFAULT'));
    }
    
    private void initSelectOptions()
    {
        selectOptionHelpers = new List<SelectOptionHelper>();
        if(csvTextList != null && csvTextList.size() != 0 && csvTextList.get(0) != null)
        {
                List<String> csvHeaderNames = csvTextList.get(0);
                for(Integer i = 0; i < csvHeaderNames.size(); i++)
            {
                        selectOptionHelpers.add(new SelectOptionHelper(fieldNames));
                }
        }
        
    }
    
    class Cell {
        String columnName {set; get;}
        String value { set; get; }
        
        public Cell(String columnName, String value) {
                this.columnName = columnName;
                this.value = value;
        }
    }
    
    private void CsvToTextList() {
        csvTextList = new List<List<String>>();
        csvCellList = new List<List<Cell>>();
        
        csvReader = new CsvReader(new CsvParser(), csvFile.Body.ToString(), '\n');
        List<List<String>> helper = csvReader.readAll();

        List<String> columnNames = new List<String>();
        for(String field : helper.get(0)) {
                        columnNames.add(field);
        }
        
        for(List<String> row: helper) {
            String content = '';

            for(String field : row) {
                content+= field;
            }

            if(content.trim().length() > 0) {
                csvTextList.add(row);
                List<Cell> rowCell = new List<Cell>();
                                for(Integer i = 0; i < row.size(); i++) {
                        rowCell.add(new Cell(columnNames.get(i), row.get(i)));
                }
                csvCellList.add(rowCell);
            }
        }
        
    }
    
    public void saveShipmentCases() {
        
        try
        {
        insert cases;
        }
        
        catch(Exception e)
        {
        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception'));
        }
        
    }
    
}