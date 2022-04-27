public class OEBS_OrderController {
	
	private static final String ORIGIN = 'OEBS';
	
	/*
	*	This method must be used on every case with Case Origin OEBS and it does the following:
	*		- Reopens OEBS cases by updating the old one and deleting the new
	*		- Prepares new cases by setting subject, recordtype etc.
	*/
	public static void onInsert (List<Case> cases) {
		List<String> oldCasesOEBS_OLIID = new List<String>();
		List<ID> updateMilestonesOnCases = new List<ID>();
		List<Case> casesToUpdate = new List<Case>();
		List<CaseComment> addedComments = new List<CaseComment>();
		
		Map<String, ID> oldCasesOEBS_OLIID_update = new Map<String, ID>();
		
		//Get list of all OEBS order id's
		for (Case newCase : cases){
			if(String.isNotEmpty(newCase.OEBS_order_line_id__c)){
				oldCasesOEBS_OLIID.add(newCase.OEBS_order_line_id__c);
			}
		}
		
		//See if any cases with the same OEBS order id have been created the last 15 days
		for (Case caseOLIID : [select OEBS_order_line_id__c, id from Case where OEBS_order_line_id__c in :oldCasesOEBS_OLIID and createdDate = LAST_N_DAYS:15]){
			oldCasesOEBS_OLIID_update.put(caseOLIID.OEBS_order_line_id__c, caseOLIID.id);
		}
		
		//If any old cases exists reopen them by reassigning and updating the old cases and adding a case comment 
		if(!oldCasesOEBS_OLIID_update.isEmpty()){
			for (Case c : cases){
				if(oldCasesOEBS_OLIID_update.containsKey(c.OEBS_order_line_id__c)){
					Case updateCase = new Case(id=oldCasesOEBS_OLIID_update.get(c.OEBS_order_line_id__c));
					updateCase.Status = c.Status;
					updateCase.Description = c.Description;
					updateCase.OEBS_Order_Status__c = null;
					updateCase.OEBS_order_release_reason__c = null;
					
					addedComments.add(new CaseComment(ParentId = updateCase.Id, CommentBody='Case reopened by OEBS'));
					
					Database.DMLOptions dml = new Database.DMLOptions();
					dml.assignmentRuleHeader.useDefaultRule = true;
					updateCase.setOptions(dml);
	
					casesToUpdate.add(updateCase);
					c.OEBS_to_be_deleted__c = true;
									
					updateMilestonesOnCases.add(updateCase.id);	
					
				}
			}
		
			if(casesToUpdate.size() > 0) {
				upsert casesToUpdate;
				KATSUtilities.reopenMilestone(updateMilestonesOnCases, 'Løsningsfrist');
			}
			
			if(addedComments.size() > 0){
				upsert addedComments;
			}
		}

		//Set correct subject, recordtype, product etc.
		for(Case newCase : cases) 
		{
			newCase.RecordTypeId = KATSutilities.getRecordType('deviation_case');
	        if(String.isEmpty(newCase.subject)){
	            newCase.Subject = 'Avvik Ordre';
	        }
            
            if(String.isNotEmpty(newCase.OEBS_order_number__c)) {
            	newCase.Subject += ' ' + newCase.OEBS_order_number__c;
            }
            
            if(String.isNotEmpty(newCase.OEBS_top_article__c)) {
				newCase.Produkt__c = newCase.OEBS_top_article__c;
				newCase.Type__c = ''; 
			}

			newCase.Category__c = 'Avvik avdekket av inntektssikring';

		}
	}
	
	public static void onAfterInsert(List<Case> newCases) {
		List<String> oldCasesOEBS_OID = new List<String>(); //List of OEBS ordernumber from newCases
		Map<String, ID> parentCaseOEBS_ID_update = new Map<String, ID>();
		
		//Get list of all the ordernumbers to be treated in this execution
		for(Case newCase : newCases) {
			oldCasesOEBS_OID.add(newCase.OEBS_order_number__c);
		}
		
		for(Case caseOID : [select OEBS_order_number__c, id from Case where Parentid = null and OEBS_order_number__c in :oldCasesOEBS_OID and createdDate = LAST_N_DAYS:15 order by OEBS_order_number__c, CreatedDate LIMIT 200]){
	        if(!parentCaseOEBS_ID_update.containsKey(caseOID.OEBS_order_number__c)){
	            parentCaseOEBS_ID_update.put(caseOID.OEBS_order_number__c, caseOID.id);
	        }
	    }
	    
	    for (Case c : newCases){
	        if(c.OEBS_to_be_deleted__c){
	            Case removeCase = new Case(id=c.id);
	            TriggerDispatcher.casesToDelete.put(removeCase.id, removeCase);
	        }
	        if(!c.OEBS_to_be_deleted__c){
	            Database.DMLOptions dml = new Database.DMLOptions();
	            dml.assignmentRuleHeader.useDefaultRule = true;
	            Case caseAssign = new Case(id=c.id);
	            
	            if(c.ParentId == null && parentCaseOEBS_ID_update.containsKey(c.OEBS_order_number__c)){
	                if(c.id != parentCaseOEBS_ID_update.get(c.OEBS_order_number__c)){
	                    caseAssign.ParentId = parentCaseOEBS_ID_update.get(c.OEBS_order_number__c);
	                }
	            }
	            
	            caseAssign.setOptions(dml);
	            TriggerDispatcher.casesToUpdate.put(caseAssign.id, caseAssign);
	        }
	    }
	}
	
	static public Messaging.SingleEmailMessage createOrderReleaseEmail(Case releasedCase) {
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		list<String> toAddressList = new list<String>();
		String emailBody = '';
		String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
		
		emailBody += 'Ordre ' + releasedCase.OEBS_order_number__c + ' er frigitt';
		emailBody += '\n';
		emailBody += '\n';
		emailBody += 'For å gå til sak gå til: '+baseUrl+'/' + releasedCase.id;
		emailBody += '\n';
		emailBody += 'For å avslutte sak gå til: '+baseUrl+'/s?retURL=%2F' + releasedCase.id; 
		emailBody += '\n';
		emailBody += '\n';
		emailBody += 'Denne e-posten er automatisk utsendt av systembrukeren';
		
		//For some reason the owner email dissapears while running tests.
		//Adding this as a way to test
		if(Test.isRunningTest()) {
			toAddressList.add(KatsTestUtilities.getTestKundekonsulentUser().email);
		} else {
			toAddressList.add(releasedCase.Owner.Email);
		}
		
		mail.setToAddresses(toAddressList);
		mail.setSenderDisplayName('KATS Ordrefrigivelse');
		mail.setEmailPriority('High');
		
		mail.setSubject('Ordre ' + releasedCase.OEBS_order_number__c + ' er frigitt');
		mail.setPlainTextBody(emailBody);
		mail.setSaveAsActivity(true);
		mail.setWhatId(releasedCase.id);
		
		return mail;
	}
	
	static public list<Messaging.SendEmailResult> sendOrderReleaseEmail(list<Case> releasedCaseList) {
		list<Messaging.Email> emailList = new list<Messaging.Email>();
		list<Messaging.SendEmailResult> emailResultList;
		
		for(Case releasedCase : releasedCaseList) {
			if(releasedCase.OEBS_Order_Status__c == 'Released') {
				Messaging.Email notifyEmail = OEBS_OrderController.createOrderReleaseEmail(releasedCase);
				emailList.add(notifyEmail);
			}
		}
		
		//Governor limit is 10 emails.
		emailResultList = Messaging.sendEmail(emailList);
		
		for(Messaging.SendEmailResult emailResult : emailResultList) {
			if(emailResult.isSuccess() == false) {
				String errorMessage = 'Feil i forbindelse med utsendelse av e-post:'; 
				for(Messaging.Sendemailerror emailError : emailResult.getErrors()) {
					errorMessage += '\n*Objekt ID: ' + emailError.getTargetObjectId();
					errorMessage += '\n\tFeilmelding:' + emailError.getMessage();
				}
				
				ExceptionController.handleException(false, true, new ExceptionController.KATSexception('Email ecxeption'), errorMessage, '');
			}
		}
		
		return emailResultList;
	}
	
	/**
	* 	
	*	@Future method for releaseing orders
	*
	*	@param caseIdToBeReleasedList 	The list of Case Ids to be released from OEBS.
	* 	
	*/
	@future(callout=true)
	static public void releaseOrderListFuture(List<Id> caseIdToBeReleasedList) {
		update OEBS_OrderController.releaseOrderIdList(caseIdToBeReleasedList);
	}
	
	@future(callout=true)
	static public void releaseOrderListNotifyOwnerFuture(List<Id> caseIdToBeReleasedList) {
		OEBS_OrderController.releaseOrderListNotifyOwner(caseIdToBeReleasedList);
	}
	
	static public void releaseOrderListNotifyOwner(List<Id> caseIdToBeReleasedList) {
		list<Case> releasedCaseList = new list<Case>();
		
		releasedCaseList = OEBS_OrderController.releaseOrderIdList(caseIdToBeReleasedList);
		
		update releasedCaseList;
		
		OEBS_OrderController.sendOrderReleaseEmail(releasedCaseList);
	}
	
	/**
	* 	Releases orders from OEBS via eConnect. An order is registrerd with a case in Salesforce.
	* 	If the release is successful the Case.OEBS_Order_Status__c = 'Released'. Otherwise the OEBS_Order_Status__c = 'Release failed', 
	*	the error is logged via a CaseComment including the originial release reason. OEBS_order_release_reason__c is emptied on failure.
	*
	*	@param caseIdToBeReleasedList 	The list of Case Ids to be released from OEBS.
	* 	
	*/
	static public list<Case> releaseOrderIdList(list<Id> caseIdToBeReleasedList ) {
		list<Case> releasedCaseList = new list<Case>();
		List<Case> caseToBeReleasedList = [SELECT id,
												OEBS_order_line_id__c,
												OEBS_order_release_reason__c,
												OEBS_Order_Status__c,
												OEBS_order_number__c,
												Owner.id,
												Owner.Username,
												Owner.Email,
												CaseNumber
											FROM Case
											WHERE Id in :caseIdToBeReleasedList];
		if(caseToBeReleasedList.size() > 0) {
			releasedCaseList = OEBS_OrderController.releaseOrderList(caseToBeReleasedList);
			return releasedCaseList;
		}
		
		return null;
	}
	
	/*
	*	Releases a whole list of cases to OEBS, this method use the OEBS_OrderController.releaseOrder
	*	method for releasing one order at the time.
	*	
	*	Salesforce governor limits only allows for 10 callouts per excecution, so if more than ten cases
	*	are submitted a controlled exception is thrown, there is also displayed understandable error messages
	*	to the user and an automatic email is sent to the Admin Admin user.
	*
	*	@param caseToBeReleasedList 	The list of Cases to be released from OEBS.
	**/
	static public list<Case> releaseOrderList(list<Case> caseToBeReleasedList ) {
		if(caseToBeReleasedList.size() > 10) {
			String developerMessage = 'Det er forsøkt å frigi ' + caseToBeReleasedList.size() + 'ordre, det har derfor blitt sendt ut en kontrollert exception.';
			String userMessage = 'Du har forsøkt å frigi mer enn ti ordre, KATS kan frigi maks ti ordre av gangen.';
			
			ExceptionController.handleException(true,
												true,
												new ExceptionController.KATSexception(),
												developerMessage,
												userMessage);
			return null;
		}
		
		for(Case caseToBeReleased : caseToBeReleasedList) {
			OEBS_OrderController.releaseOrder(caseToBeReleased);
		}
		
		return caseToBeReleasedList;
	}
	
	/*
	*	Releases an order from OEBS via eConnect. An order is registrerd with a case in Salesforce.
	* 	If the release is successful the Case.OEBS_Order_Status__c = 'Released'. Otherwise the OEBS_Order_Status__c = 'Release failed', 
	*	the error is logged via a CaseComment including the originial release reason. OEBS_order_release_reason__c is emptied on failure.
	*
	*	Releases one single case to OEBS (there is no support sending collections) and
	*	returns the case without persisting it.
	*
	*	When an order release fails a e-mail notification is sent, a seperate workflow rule exists see "Order release failed alert case owner"
	*
	*	Note: The release will appear to be successful even if it might have failed. eConnect does not handle and propagate error situations 
	*	occuring in OEBS.
	*
	*	@param caseToBeReleased 	The Case to be released from OEBS.
	**/
	static public Case releaseOrder(Case caseToBeReleased ) {
		Case c = caseToBeReleased;
		String status = '';
		postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
		
		try{
			status = eConnect.orderEventRelease(c.OEBS_order_line_id__c, c.OEBS_order_release_reason__c 
			, c.Owner.Username, c.CaseNumber);
		} catch (CalloutException ce) {
			ExceptionController.handleException(true, false, ce, '', 'Ordre ' + c.OEBS_order_line_id__c + ' på sak ' + c.CaseNumber + ' ble ikke frigitt, problem med koblingen mot eConnect og OEBS');
			status = 'FAILED';
		} catch (Exception e) {
			ExceptionController.handleException(true, true, e, '', 'Ordre ' + c.OEBS_order_line_id__c + ' på sak ' + c.CaseNumber + ' ble ikke frigitt, noe gikk galt');
			status = 'FAILED';
		}
		if(status == 'OK') {
			c.OEBS_Order_Status__c = 'Released';
		} else  {
			c.OEBS_Order_Status__c = 'Release failed';
		}
		return c;
	}
}