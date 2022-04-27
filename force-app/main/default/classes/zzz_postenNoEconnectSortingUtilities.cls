@isTest
private class zzz_postenNoEconnectSortingUtilities {

	
	class TestData {
		public postenNoEconnectKatsSaksearchcustome.Customer_element customer1 = new postenNoEconnectKatsSaksearchcustome.Customer_element();
		public postenNoEconnectKatsSaksearchcustome.Customer_element customer2 = new postenNoEconnectKatsSaksearchcustome.Customer_element();
		public postenNoEconnectKatsSaksearchcustome.Customer_element customer3 = new postenNoEconnectKatsSaksearchcustome.Customer_element();
		public postenNoEconnectKatsSaksearchcustome.Customer_element customer4 = new postenNoEconnectKatsSaksearchcustome.Customer_element();
		public postenNoEconnectKatsSaksearchcustome.RevenueType rev1 = new postenNoEconnectKatsSaksearchcustome.RevenueType();
		public postenNoEconnectKatsSaksearchcustome.RevenueType rev2 = new postenNoEconnectKatsSaksearchcustome.RevenueType();
		public postenNoEconnectKatsSaksearchcustome.RevenueType rev3 = new postenNoEconnectKatsSaksearchcustome.RevenueType();
		public postenNoEconnectKatsSaksearchcustome.RevenueType rev4 = new postenNoEconnectKatsSaksearchcustome.RevenueType();
		public postenNoEconnectKatsSaksearchcustome.CustomerList_element customers = new postenNoEconnectKatsSaksearchcustome.CustomerList_element();
		
		public TestData() {
	    	customers.Customer = new List<postenNoEconnectKatsSaksearchcustome.Customer_element>();
	    	
	    	rev1.TotalRevenueCurrentYear_L = 300;
	    	rev1.TotalRevenuePreviousYear_L = 0;
	    	rev1.TotalRevenueCurrentYear_P = 300;
	    	rev1.TotalRevenuePreviousYear_P = 0;
	    	customer1.Revenues = rev1;
	    	customer1.PartyName = 'My test company';
	    	customers.Customer.add(customer1);
	    	rev2.TotalRevenueCurrentYear_L = 400;
	    	rev2.TotalRevenuePreviousYear_L = 0;
	    	rev2.TotalRevenueCurrentYear_P = 400;
	    	rev2.TotalRevenuePreviousYear_P = 0;
	    	customer2.Revenues = rev2;
	    	customer2.PartyName = 'My test company';
	    	customers.Customer.add(customer2);
	    	rev3.TotalRevenueCurrentYear_L = 0;
	    	rev3.TotalRevenuePreviousYear_L = 100;
	    	rev3.TotalRevenueCurrentYear_P = 0;
	    	rev3.TotalRevenuePreviousYear_P = 100;
	    	customer3.Revenues = rev3;
	    	customer3.PartyName = 'My test company';
	    	customers.Customer.add(customer3);
	    	rev4.TotalRevenueCurrentYear_L = 0;
	    	rev4.TotalRevenuePreviousYear_L = 200;
	    	rev4.TotalRevenueCurrentYear_P = 0;
	    	rev4.TotalRevenuePreviousYear_P = 200;
	    	customer4.Revenues = rev4;
	    	customer4.PartyName = 'My test company';
	    	customers.Customer.add(customer4);
		}
		
		
	}
	
	@isTest 
	static void testSortingCustomerSearchResultsByRevenue () {
    	TestData data = new TestData();
    	
    	Test.startTest();
    	postenNoEconnectSortingUtilities sortingUtil = new postenNoEconnectSortingUtilities(postenNoEconnectSortingUtilities.REVENUE.POST_AND_LOGISTIKK);
    	List<postenNoEconnectKatsSaksearchcustome.Customer_element> sortedCustomers = sortingUtil.sort(data.customers.Customer);
    	Test.stopTest();
    	

		assertValues(sortedCustomers, data);
    }
    
    @isTest 
    static void testSortingCustomerSearchResultsByPostRevenue() {
    	TestData data = new TestData();
    	
    	Test.startTest();
    	postenNoEconnectSortingUtilities sortingUtil = new postenNoEconnectSortingUtilities(postenNoEconnectSortingUtilities.REVENUE.POST);
    	List<postenNoEconnectKatsSaksearchcustome.Customer_element> sortedCustomers = sortingUtil.sort(data.customers.Customer);
    	Test.stopTest();

    	assertValues(sortedCustomers, data);
    }
    
    @isTest 
    static void testSortingCustomerSearchResultsByLogistikkRevenue() {
    	TestData data = new TestData();
    	
    	Test.startTest();
    	postenNoEconnectSortingUtilities sortingUtil = new postenNoEconnectSortingUtilities(postenNoEconnectSortingUtilities.REVENUE.LOGISTIKK);
    	List<postenNoEconnectKatsSaksearchcustome.Customer_element> sortedCustomers = sortingUtil.sort(data.customers.Customer);
    	Test.stopTest();

    	assertValues(sortedCustomers, data);
    }
    
    private static void assertValues(List<postenNoEconnectKatsSaksearchcustome.Customer_element> sortedCustomers, TestData data) {
    	System.assertEquals(sortedCustomers.get(0), data.customer2);
    	System.assertEquals(sortedCustomers.get(1), data.customer1);
    	System.assertNotEquals(sortedCustomers.get(0), data.customer1);
    	System.assertNotEquals(sortedCustomers.get(1), data.customer2);
    	System.assertEquals(sortedCustomers.get(2), data.customer4);
    	System.assertEquals(sortedCustomers.get(3), data.customer3);
    }
}