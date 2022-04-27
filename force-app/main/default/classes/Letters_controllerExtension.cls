public with sharing class Letters_controllerExtension {

    private static final String STATUS_WORK_IN_PROGRESS = 'Utkast';// api name
    private static final String STATUS_READY_FOR_PRINT = 'Klar til å skrive ut';//api name
    private static final String STATUS_PRINTED = 'Trykt';// api name
    //Csphase2 Supriya 27122016
    
    //private static final String STATUS_WORK_IN_PROGRESS = 'Draft';
    //private static final String STATUS_READY_FOR_PRINT = 'Ready to print';
    //private static final String STATUS_PRINTED = 'Printed';
    
    public Letter__c letter{ get; set; }    //Used when controlling single letter
    public list<Letter__c> letters{ get; set; } //Used when controlling batch letter print

    public boolean showTemplatePopup{ get; set; } 
    public list<Letter_Template__c> availableTemplates{ get; set; }
    public integer selectedTemplateIndex{ get; set; } // index in availableTemplates which is selected by the user
    public String templateSearchParam{ get; set; }

    public Letters_controllerExtension(ApexPages.StandardController stdController) {
        
        if(System.currentPagereference().getParameters().get('printQueue') == '1') {
            system.debug('Running in batch print mode');
            Integer soqlLimit = (System.currentPagereference().getParameters().get('n') != null) ? Integer.valueof(System.currentPagereference().getParameters().get('n')) : 200;
            letters = [select Id, Case__c, case__r.subject, case__r.Contact_post_address__c, Case__r.id, Recepient__c, Status__c, Letter_content__c, Name from Letter__c where status__c=:STATUS_READY_FOR_PRINT order by CreatedDate limit :soqlLimit];
        }
        else {
            system.debug('Running in single letter mode');          
            showTemplatePopup = false;
            availableTemplates = new list<Letter_Template__c>();
            
            if(stdController.getRecord().id == null) {
                system.debug('New letter');
                letter = (Letter__c)stdController.getRecord();
                
                //Setting fields related to case, if possible
                for(Case c: [select id, Contact_post_address__c, Subject from case where id=:letter.case__c]) { 
                    letter.Case__r = c; 
                    break;
                }
            }
            else {
                system.debug('Editing existing letter');
                letter = [select Id, Case__c, case__r.subject, case__r.Contact_post_address__c, Case__r.id, Recepient__c, Status__c, Letter_content__c, Name from Letter__c where id=:stdController.getRecord().id limit 1];
            }
    
            //Setting default search template search param
            templateSearchParam = (Letter.Case__c != null) ? Letter.Case__r.Subject : '';
            
    
            if(letter.id == null) {
                system.debug('New letter');
                letter.Recepient__c = (Letter.Case__c == null) ? '' : Letter.Case__r.Contact_post_address__c.replace('<br>', '\n');
                letter.Status__c = STATUS_WORK_IN_PROGRESS;
                letter.Name = 'Brev ' + Date.today().format();
            }
        }
    }
    
    public PageReference save() {
        upsert letter;
        return new ApexPages.StandardController(letter).view();
    }
    
    public boolean getIsLetterEditable() {
        return (Letter.Status__c != STATUS_PRINTED);
    }
    
    public PageReference selectTemplate() {
        
        system.debug('selecting template with index: ' + selectedTemplateIndex);
        if(selectedTemplateIndex >= 0) {
            applyTemplate();
        }
        
        showTemplatePopup = false;
        return null;
    }
    
    public PageReference showTemplateSelection() {
        selectedTemplateIndex = -1;
        showTemplatePopup = true;
        searchTemplate();
        return null;
    }
    
    public PageReference searchTemplate() {
        String soqlFields = 'Name, Description__c, Body__c, Category__c';
        String soqlOrder = 'Name';
        String soqlConditions = 'Enabled__c=TRUE';
        String soqlLimit = '100';
        
        if(KATSutilities.isEmpty(templateSearchParam)) {
            availableTemplates.clear();
        }
        else {  
            String sosl = 'FIND \'' + String.escapeSingleQuotes(templateSearchParam) + '\' IN ALL FIELDS RETURNING Letter_Template__c(' + soqlFields + ' WHERE ' + soqlConditions + ' ORDER BY ' + soqlOrder + ' LIMIT ' + soqlLimit + ')';
            system.debug('Searching for letter_template__cs using sosl: ' + sosl);
            
            availableTemplates = search.query(sosl).get(0);     
        }

        return null;

    }
    
    private Letter_Template__c getSelectedTemplate() {
        try {
            return availableTemplates.get(selectedTemplateIndex);
        }
        catch(Exception e) { return null; }
    }
    
    public String getCSSLeftMargin() {
        String v = (environment_settings__c.getInstance('letter_PDF_left_margin')==null) ? '0cm' : environment_settings__c.getInstance('letter_PDF_left_margin').value__c;
        return v;
    }
    public String getCSSTopMargin() {
        String v = (environment_settings__c.getInstance('letter_PDF_top_margin')==null) ? '0cm' : environment_settings__c.getInstance('letter_PDF_top_margin').value__c;
        return v;
    }
    public String getCSSContentAddressSpacing() {
        String v = (environment_settings__c.getInstance('letter_PDF_space_to_content')==null) ? '3cm' : environment_settings__c.getInstance('letter_PDF_space_to_content').value__c;
        return v;
    }
    
    /**
    *   Returns letter or letters (depending on the mode the controller is running in - single letter og batch) as a list.
    */
    public list<Letter__c> getLettersForPrint() {
        if(letter == null) {
            return letters;
        }
        return new letter__c[]{letter};
    }

    public PageReference applyTemplate() {
        String templateText = (getSelectedTemplate() == null) ? '' : getSelectedTemplate().body__c;
        system.debug('Template text: ' + templateText);
        system.debug('Running on case: ' + Letter.Case__c);
        set<String> fields = getListOfFields(templateText);
        
        if(Letter.Case__c != null) {
            //Create soql field list
            String fieldsSoql = '';
            //Create soql field lists for all supported one-to-many soql field lists
            String fieldsSoql_Sendings_hendelser = 'EventCode__c, ';
            
            for(String field:fields) { 
                system.debug('Building soql fields to select. Looking at: ' + field);
                if(isOneToManyField(field)) {
                    system.debug('The field value requested requires a one-to-many relationship traversation');
                    if(getShortFieldName(field) != '') {
                        fieldsSoql_Sendings_hendelser += getShortFieldName(field) + ', ';
                    }
                }
                else {
                    system.debug('Field is straight forward. Adding it so fieldsSoql');
                    fieldsSoql += field + ', '; 
                }
            }
            //Remove tailing characters and ensure proper values in fieldsSoqls
            fieldsSoql = (fieldsSoql=='') ? 'id' : fieldsSoql.subString(0, fieldsSoql.length()-2);
            fieldsSoql_Sendings_hendelser = (fieldsSoql_Sendings_hendelser=='') ? 'id' : fieldsSoql_Sendings_hendelser.subString(0, fieldsSoql_Sendings_hendelser.length()-2);
            
            //Create soql
            String soql = 'SELECT ' + fieldsSoql + ', (SELECT ' + fieldsSoql_Sendings_hendelser + ' FROM Sendings_hendelser__r order by Date__c DESC) FROM Case where id=\'' + Letter.Case__c + '\'';
            system.debug('Querying database with soql: ' + soql);
            Case templateData;
            try {
                templateData = Database.query(soql);
                
                system.debug('Looping through each field value in the template to replace values');
                list<String> currentFieldSplitted;
                String currentFieldValue;
                system.debug('templateData is now:' + templateData);
                for(String field:fields) {
                    system.debug('Splitting on value: ' + field);
                    
                    
                    currentFieldSplitted = field.split('\\.');
                    system.debug('(splitted: )' + currentFieldSplitted);

                    if(isOneToManyField(field)) {
                        if(isOneToManyFieldSupported(field)) {
                            system.debug('replacing value for one-to-many relationship value');
                            currentFieldValue = '';
                            
                            if(templateData.getSobjects(getOneToManyRelationField(field)) != null) {
                                for(LM_Shipment_Event__c shipmentEvent:templateData.getSobjects(getOneToManyRelationField(field))) {
                                    if(shipmentEvent.EventCode__c.toLowerCase() == getOneToManyParameter(field).toLowerCase()) {
                                        currentFieldValue = String.valueOf(shipmentEvent.get( getShortFieldName(field) ));
                                        break;
                                    }
                                }
                            }
                            else {
                                currentFieldValue = '';
                                //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Mal inneholder felter som ikke er aktuelle for sakens type (' + field + ')' ));
                            }
                        }
                        else {
                            system.debug('The one-to-many relationship field value is not supported. Field: ' + field);
                            currentFieldValue = 'TEMPLATE_FIELD__' + field + '__NOT_SUPPORTED';
                        }
                    }
                    else {
                        system.debug('replacing field on case or directly related to it');
                        system.debug('Inserts value for field:' + currentFieldSplitted[1]);
                        currentFieldValue = (currentFieldSplitted[0].toLowerCase() == 'case') ? String.valueOf(templateData.get(currentFieldSplitted[1].trim())) : String.valueOf(templateData.getSobject(currentFieldSplitted[0].trim()).get(currentFieldSplitted[1].trim())); 
                    }
                    
                    currentFieldValue = (currentFieldValue == null) ? '' : currentFieldValue;
                    templateText = templateText.replace(EMAIL_TEMPLATE_FIELD_START + field + EMAIL_TEMPLATE_FIELD_END, currentFieldValue);


                }
            }
            catch(Exception e) {
                system.debug('Error when querying template fields: ' + e.getMessage());
               //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Feil i mal. Data utfylling kann ikke fullføres. (' + e.getMessage() + ')' ));
               //CSPhase2, Supriya, 19122016 ->Added the labels
               KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , System.Label.cs_Error_in_template +'(' + e.getMessage() + ')' ));
               
            }
            
        }
        
        templateText = templateText.replace('\n', '<br>');
        letter.Letter_content__c = templateText;
        
        return null;
    }
    /**
    * Is the field described (e.g. case.subject) representing a one-to-many relationship traversation? (e.g. case.xxx(yyy).subject) 
    */
    private boolean isOneToManyField(String field) {
        return field.split('\\.').size() > 2;
    }
    /**
    * Is the field supported by the code? Assumes the field is a one-to-many traversation. If not, false is returned.
    */
    private boolean isOneToManyFieldSupported(String field) {
        try { 
            if(field.split('\\.')[1].toLowerCase().startsWith('sendings_hendelser__r')) {
                return true;
            }
        }
        catch(Exception e) { /*Do nothing - false will be returned.*/ }
        return false;
    }
    /**
    * Return the last part of the field name (e.g. Case.xxx(yyy).qqq and Case.qqq will both return qqq)
    */
    private String getShortFieldName(String field) {
        if(field == null) { return ''; }
        
        list<String> fieldSplitted = field.split('\\.');
        return fieldSplitted.get(fieldSplitted.size()-1);
    }
    /**
    * return the relationship name from a field name. Assumes the field name is refering to a one-to-many relationship
    */
    public String getOneToManyRelationField(String field) {
        try {
            String relationFieldWithParam = field.split('\\.')[1];
            return relationFieldWithParam.substring(0, relationFieldWithParam.indexOf('(') );
        }
        catch(Exception e) { /*Do nothing - false will be returned.*/ }
        return '';
    }
    /**
    * Return the one-to-many parameter part of the field value (e.g. Case.xxx(yyy).qqq returns 'yyy' and Case.xxx returns ''). Empty String if no parameter is found
    */
    public String getOneToManyParameter(String field) {
        try { 
            return field.subString( field.indexOf('(')+1, field.indexOf(')') );
        }
        catch(Exception e) { /*Do nothing - false will be returned.*/ }
        return '';
    }

    /**
    * Sets all letters in batch mode to printed
    **/
    public void setLettersAsPrinted() {
        if(letters != null) {
            for(Letter__c l:letters) {
                l.status__c = STATUS_PRINTED;
            }
            upsert letters;
        }
        //return null;
    }


    /**
    * go through the mailTemplate text and extraxt all {!object.field} texts and return them in an array without the {! and } characters
    */
    public static final String EMAIL_TEMPLATE_FIELD_START = '{!';
    public static final String EMAIL_TEMPLATE_FIELD_END = '}';
    public set<String> getListOfFields(String mailTemplate) {
        set<String> fields = new set<String>();
        integer nextTagStartPos = 0;
        integer nextTagEndPos = 0;
        
        while(true) {
            nextTagStartPos = mailTemplate.indexOf(EMAIL_TEMPLATE_FIELD_START, nextTagStartPos+1);
            if(nextTagStartPos == -1) { break;  }

            nextTagEndPos = mailTemplate.indexOf(EMAIL_TEMPLATE_FIELD_END, nextTagStartPos);
            if(nextTagEndPos == -1) {   break;  }
                
            fields.add(mailTemplate.substring(nextTagStartPos + EMAIL_TEMPLATE_FIELD_START.length(), nextTagEndPos));
        }

        return fields;
    }
    
    
    
    
    static testmethod void coverageTest() {
        //KatsTestUtilities ktu = new KatsTestUtilities();
        
        Case c = new Case(Subject='test123');
        upsert new Case[]{c};
        
        list<LM_Shipment_Event__c> shipmentEvents = new list<LM_Shipment_Event__c>();
        shipmentEvents.add(new LM_Shipment_Event__c(Case__c=c.id, date__c=Date.today(), EventCode__c='TESTAnkommet Postkontor', ReceivedBy__c='TEST_RECEIVEDBY'));
        shipmentEvents.add(new LM_Shipment_Event__c(Case__c=c.id, date__c=Date.today()-2, EventCode__c='TESTAnkommet Postkontor', ReceivedBy__c='TEST1_RECEIVEDBY'));
        upsert shipmentEvents;
        
        Letter_Template__c lt = new Letter_Template__c(Body__c='Test {!Case.subject} THE END', Enabled__c=true, Name='forAutoTest');
        upsert lt;
        
        Letters_controllerExtension l = new Letters_controllerExtension(new ApexPages.StandardController(new Letter__c(Case__c=c.id)));

        l.showTemplateSelection();
        l.selectedTemplateIndex = 0;
        l.selectTemplate();
        l.save();
        
        l.availableTemplates.clear();
        l.availableTemplates.add(lt);
        l.selectedTemplateIndex = 0;
        l.applyTemplate();
        system.assertEquals('Test test123 THE END', l.letter.Letter_content__c);

        Letter_Template__c lt1 = new Letter_Template__c(body__c='Test1 {!Case.Sendings_hendelser__r(TESTAnkommet Postkontor).ReceivedBy__c} THE END');
        l.availableTemplates.clear();
        l.availableTemplates.add(lt1);
        l.selectedTemplateIndex = 0;
        l.applyTemplate();
        l.getOneToManyParameter('Name');
        l.getLettersForPrint();
        l.getCSSTopMargin();
        l.getCSSLeftMargin();
        system.assertEquals('Test1 TEST_RECEIVEDBY THE END', l.letter.Letter_content__c);
        
    }

}