@isTest
private class aaa_OEBS_OrderController {

	static testMethod void releaseOrderList_1() {
    	Test.setMock(WebServiceMock.class, new mock_Katsordereventr.mock_OK());
    	
    	list<Case> resultList;
    	
    	list<Case> caseToBeReleasedList = aaa_OEBS_OrderController.getOEBSTestCase(1);
    		caseToBeReleasedList.get(0).OEBS_order_release_reason__c = aaa_OEBS_OrderController.testReleaseReason;
    	
    	test.startTest();
    		resultList = OEBS_OrderController.releaseOrderList(caseToBeReleasedList);
    	test.stopTest();
    	
    	for(Case result : resultList){
	    	system.assertEquals('Released', result.OEBS_Order_Status__c);
	    	system.assertEquals(aaa_OEBS_OrderController.testReleaseReason, result.OEBS_order_release_reason__c);
    	}
    }
    
    static testMethod void releaseOrderList_2() {
    	Test.setMock(WebServiceMock.class, new mock_Katsordereventr.mock_FAILED());
    	
    	list<Case> resultList;
    	
    	list<Case> caseToBeReleasedList = aaa_OEBS_OrderController.getOEBSTestCase(1);
    		caseToBeReleasedList.get(0).OEBS_order_release_reason__c = aaa_OEBS_OrderController.testReleaseReason;
    	
    	test.startTest();
    		resultList = OEBS_OrderController.releaseOrderList(caseToBeReleasedList);
    	test.stopTest();
    	
    	for(Case result : resultList){
	    	system.assertEquals('Release failed', result.OEBS_Order_Status__c);
    	}
    }
    
    static testMethod void releaseOrder_1() {
    	Test.setMock(WebServiceMock.class, new mock_Katsordereventr.mock_OK());
    	Case result;
    	
    	Case caseToBeReleased = aaa_OEBS_OrderController.getOEBSTestCase(1).get(0);
    		caseToBeReleased.OEBS_order_release_reason__c = aaa_OEBS_OrderController.testReleaseReason;
    	
    	test.startTest();
    		result = OEBS_OrderController.releaseOrder(caseToBeReleased);
    	test.stopTest();
    	
    	system.assertEquals('Released', result.OEBS_Order_Status__c);
    	system.assertEquals(aaa_OEBS_OrderController.testReleaseReason, result.OEBS_order_release_reason__c);
    }
    
    static testMethod void releaseOrder_2() {
    	Test.setMock(WebServiceMock.class, new mock_Katsordereventr.mock_FAILED());
    	Case result;
    	
    	Case caseToBeReleased = aaa_OEBS_OrderController.getOEBSTestCase(1).get(0);
    		caseToBeReleased.OEBS_order_release_reason__c = aaa_OEBS_OrderController.testReleaseReason;
    	
    	test.startTest();
    		result = OEBS_OrderController.releaseOrder(caseToBeReleased);
    	test.stopTest();
    	
    	system.assertEquals('Release failed', result.OEBS_Order_Status__c);
    }
    
    /********************
    *	TEST HELPERS	*
    ********************/
    
    static String testReleaseReason = 'test release of order';
	static String testProduct = 'Test product';
	static String testDescription = 'Test description';
	static String testOrderURL = 'http:\\www.test.com';
	static String testContractName = 'Test kontrakt';
	static Integer orderNumber = 0000;
	static Integer orderId = 9999;
	static String contractNumber = '00000';
	
	static String getOrderNumber() {
		orderNumber++;
		return 'TestOEBS' + orderNumber;
	}
	
	static String getOrderId() {
		orderId--;
		return 'TestOEBS' + orderId;
	}
	
	static Id getAccountId() {
		return '0012000000u46jd';
	}
	
	static Id getPostalUnitId() {
		return 'a002000000IVnxI';
	}
    
    static List<Case> getOEBSTestCase(Integer nmbOfCases) {
		list<Case> cases = new list<Case>();
		for(Integer i = 0; i < nmbOfCases; i++) {
			cases.add(new Case(	OEBS_contract_name__c = aaa_OEBS_OrderController.testContractName,
							    OEBS_contract_number__c = aaa_OEBS_OrderController.contractNumber,
							    OEBS_order_line_id__c = aaa_OEBS_OrderController.getOrderId(),
							    OEBS_order_number__c = aaa_OEBS_OrderController.getOrdernumber(),
							    OEBS_Order_Status__c = null,
							    OEBS_order_URL__c = aaa_OEBS_OrderController.testOrderURL,
							    OEBS_producer__c = aaa_OEBS_OrderController.getAccountId(),
							    OEBS_top_article__c = aaa_OEBS_OrderController.testProduct,
							    OEBS_order_release_reason__c = null,
							    Submission_place__c = aaa_OEBS_OrderController.getPostalUnitId(), 
								description = aaa_OEBS_OrderController.testdescription,
								origin = 'OEBS'));
		}
		return cases;
	}
}