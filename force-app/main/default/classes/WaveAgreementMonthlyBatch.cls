global class WaveAgreementMonthlyBatch implements Database.Batchable<sObject>, Database.Stateful{

	global InsightsExternalData insightExternalData = new InsightsExternalData();
	global ID insightExternalDataId;
	
	global Decimal CONST_MAX_DATAPART_SIZE = 7.5 * 1024 * 1024;
	global Integer partNumber = 1;
    
    global Database.QueryLocator start(Database.BatchableContext BC){
      
		insightExternalData.EdgemartAlias = 'AgreementsMonthly';
        insightExternalData.EdgemartLabel = 'AgreementsMonthly';
        insightExternalData.MetadataJson = blob.valueOf('{"fileFormat": {"charsetName": "UTF-8","fieldsDelimitedBy": ",","fieldsEnclosedBy": "\\"","linesTerminatedBy": "\\n","numberOfLinesToIgnore": 0},"objects": [{"name": "AgreementsMonthly","fullyQualifiedName": "AgreementsMonthly","connector": "ScheduledConnector","label": "AgreementsMonthly","description": "","fields": [{"type": "Text","name": "key","label": "key","isUniqueId": false,"isSystemField": false,"isMultiValue": false,"fullyQualifiedName": "key","description": "","defaultValue": ""},{"type": "Text","name": "Id","label": "Id","isUniqueId": false,"isSystemField": false,"isMultiValue": false,"fullyQualifiedName": "Id","description": "","defaultValue": ""},{"type": "Text","name": "crm_Agreement_Service_Group__c","label": "crm_Agreement_Service_Group__c","isUniqueId": false,"isSystemField": false,"isMultiValue": false,"fullyQualifiedName": "crm_Agreement_Service_Group__c","description": "","defaultValue": ""},{"type": "Text","name": "crm_Agreement_Service_Family__c","label": "crm_Agreement_Service_Family__c","isUniqueId": false,"isSystemField": false,"isMultiValue": false,"fullyQualifiedName": "crm_Agreement_Service_Family__c","description": "","defaultValue": ""},{"type": "Text","name": "crm_Account__c","label": "crm_Account__c","isUniqueId": false,"isSystemField": false,"isMultiValue": false,"fullyQualifiedName": "crm_Account__c","description": "","defaultValue": ""},{"description": "","fullyQualifiedName": "crm_Monthly_Contracted_Value__c","label": "crm_Monthly_Contracted_Value__c","name": "crm_Monthly_Contracted_Value__c","isSystemField": false,"defaultValue": "0","isUniqueId": false,"type": "Numeric","precision": 10,"scale": 2},{"type": "Date","name": "crm_Agreement_Start_Date__c","label": "crm_Agreement_Start_Date__c","isUniqueId": false,"isSystemField": false,"fullyQualifiedName": "crm_Agreement_Start_Date__c","format": "yyyy-MM-dd HH:mm:ss","fiscalMonthOffset": 0,"description": ""},{"type": "Date","name": "crm_Agreement_End_Date__c","label": "crm_Agreement_End_Date__c","isUniqueId": false,"isSystemField": false,"fullyQualifiedName": "crm_Agreement_End_Date__c","format": "yyyy-MM-dd HH:mm:ss","fiscalMonthOffset": 0,"description": ""}]}]}');
        insightExternalData.Operation = 'Overwrite';
        insightExternalData.Action ='None';
		insightExternalData.Format = 'Csv';
        
        insert insightExternalData;
	  
		insightExternalDataId = insightExternalData.Id;
		
        return Database.getQueryLocator('SELECT Id, crm_Agreement_Start_Date__c, crm_Agreement_End_Date__c, crm_Monthly_Contracted_Value__c,' +
                                        ' crm_Agreement_Service_Group__c, crm_Agreement_Service_Family__c, crm_Account__c FROM crm_agreement__c' +
                                        ' WHERE crm_Agreement_Start_Date__c != null');
   }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){

        String key;
        Map<String,crm_agreement__c> result = new Map<String,crm_agreement__c>();
        
        for(sObject o : scope){
            
            crm_agreement__c agr = (crm_agreement__c) o;
            
            Integer monthStart = agr.crm_Agreement_Start_Date__c.month();
            Integer yearStart = agr.crm_Agreement_Start_Date__c.year();
            Integer monthEnd = agr.crm_Agreement_End_Date__c != null ? agr.crm_Agreement_End_Date__c.month() : 12;
            Integer yearEnd = agr.crm_Agreement_End_Date__c != null ? agr.crm_Agreement_End_Date__c.year() : 2020;
        
            Integer numberOfMonths = (Date.newInstance(yearStart,monthStart,1)).monthsBetween(Date.newInstance(yearEnd,monthEnd+1,1));
            
            for(Integer i = 0; i < numberOfMonths; i++){
                
                Date temp = agr.crm_Agreement_Start_Date__c.addMonths(i);
                
                crm_agreement__c agrResult = new crm_agreement__c(	Id = agr.Id, 
                                                                    crm_Agreement_Start_Date__c = agr.crm_Agreement_Start_Date__c,
                                                                    crm_Agreement_End_Date__c = temp,
                                                                    crm_Annual_Contract_Value__c = agr.crm_Monthly_Contracted_Value__c,
                                                                    crm_Agreement_Service_Group__c = agr.crm_Agreement_Service_Group__c,
                                                                    crm_Agreement_Service_Family__c = agr.crm_Agreement_Service_Family__c, 
                                                                    crm_Account__c = agr.crm_Account__c);
                                                                    //using Annual insteadOf Monthly because Monthly is readOnly (formula)
                
                key = agr.crm_Account__c + '-' + agr.crm_Agreement_Service_Group__c + '-' + agr.crm_Agreement_Service_Family__c + '-' + temp.year()+ '-' + temp.month();
                
				result.put(key,agrResult);

            }

        }
		
		//Wave Part
		
		String dataRow = '';
		List<String> soqlCSVList = new List<String>();  
		blob currCSVBlob;

        for(String thekey :  result.keyset()){
		
			crm_agreement__c agr = result.get(thekey);
        
            dataRow += '"' + 	thekey + '","' +
								agr.Id + '","' + 
                                agr.crm_Agreement_Service_Group__c + '","' + 
                                agr.crm_Agreement_Service_Family__c + '","' + 
                                agr.crm_Account__c + '",' + 
                                agr.crm_Annual_Contract_Value__c + ',' + 
                                agr.crm_Agreement_Start_Date__c + ',' +
                                agr.crm_Agreement_End_Date__c + '\n';
        
            currCSVBlob = blob.valueOf(dataRow);
        
            if(currCSVBlob.size() > CONST_MAX_DATAPART_SIZE){
                                soqlCSVList.add(dataRow);
        
                                dataRow = '';
            }
        }
                        
        if(dataRow != ''){
            soqlCSVList.add(dataRow);
        }
        
        if(soqlCSVList.size() > 0){
                        
            List<InsightsExternalDataPart> soqlExternalDataParts = new List<InsightsExternalDataPart>();
        
            InsightsExternalDataPart dataPart;
            
            //Create list of InsightsExternalDataPart
            for(Integer i=0; i<soqlCSVList.size(); i++){
                
                dataPart = new InsightsExternalDataPart();
                dataPart.DataFile = blob.valueOf(soqlCSVList[i]);
                dataPart.InsightsExternalDataId = insightExternalDataId;
                dataPart.PartNumber = partNumber;
                soqlExternalDataParts.add(dataPart);
                
                //Increase the data part number to keep trak of 
                // InsightsExternalDataPart number
                partNumber = partNumber +1;
            }
            
            //Insert the InsightsExternalDataPart list
            if(!Test.isRunningTest()){
                insert soqlExternalDataParts;
            }
        }
        
    }

    global void finish(Database.BatchableContext BC){
	        
			if(insightExternalDataId != null){            
            InsightsExternalData obj = new InsightsExternalData(Id = insightExternalDataId, 
                                                            Action = 'Process');
            
            if(!Test.isRunningTest())
				update obj;
                                                            
        }
   }	

}