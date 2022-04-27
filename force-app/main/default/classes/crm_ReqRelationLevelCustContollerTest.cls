@isTest
public class crm_ReqRelationLevelCustContollerTest{

  private static testMethod void testReqRelationLevelCustomerContoller_1() {
     crm_TestDataFactory.CreateCustomSetting();
    Test.setMock(WebServiceMock.class, new crm_mock_ecconectTest.mock_OK());
    crm_nps_settings_sales__c nps =  new crm_nps_settings_sales__c();
    nps.endpoint_url__c = 'test.com';
    nps.Username__c='unsmae';
    nps.Password__c='pass';
    nps.crm_timeout__c = 1200;
    nps.Name = 'eConnect ICC';
    insert nps;
      crm_ISO_Country_Codes__c iso = new crm_ISO_Country_Codes__c();
      iso.crm_Country__c='ca';
      iso.crm_ISO_Country_Code__c='ca';
      iso.NAme = '10';
      insert iso;
    PageReference pageRef = Page.crm_Create_Party_Level_Customer;
    Test.setCurrentPage(pageRef);
    Account acc= new Account(Name ='Test',Orga__c='test',ShippingStreet='ca',crm_Credit_Limit__c=34353,BillingCity='ca',BillingState='ca',BillingCountry='ca',ShippingPostalCode='12121',ShippingCity='ca',ShippingState='ca',BillingStreet='ca',BillingPostalCode='2121',ShippingCountry='ca', crm_ISO_Countrycode_for_Customer_Company__c='Angola');
     insert acc;
    ApexPages.currentPage().getParameters().put('id', acc.id);
    ApexPages.StandardController std = new ApexPages.StandardController(acc);
    crm_ReqRelationLevelCustomerContoller cls = new crm_ReqRelationLevelCustomerContoller(std);
    test.startTest();
      cls.customerObj.crm_Billing_Postal_Code__c = '121212';
      cls.customerObj.crm_Shipping_Postal_Code__c = '121212';
    cls.requestcustomer();
     test.stopTest();
  }
  private static testMethod void testReqRelationLevelCustomerContoller_2() {
   crm_TestDataFactory.CreateCustomSetting();
      crm_ISO_Country_Codes__c iso = new crm_ISO_Country_Codes__c();
      iso.crm_Country__c='ca';
      iso.crm_ISO_Country_Code__c='ca';
      iso.NAme = '10';
      insert iso;
    Test.setMock(WebServiceMock.class, new crm_mock_ecconectTest.mock_OK());
    crm_nps_settings_sales__c nps =  new crm_nps_settings_sales__c();
    nps.endpoint_url__c = 'test.com';
    nps.Username__c='unsmae';
    nps.crm_timeout__c = 1200;
    nps.Password__c='pass';
    nps.Name = 'eConnect ICC';
    insert nps;
    PageReference pageRef = Page.crm_Create_Party_Level_Customer;
    Test.setCurrentPage(pageRef);
    Account acc= new Account(Name ='Test',ShippingStreet='ca',Orga__c='test',BillingCity='ca',BillingState='ca',BillingCountry='ca',ShippingPostalCode='12121',ShippingCity='ca',ShippingState='ca',BillingStreet='ca',BillingPostalCode='2121',ShippingCountry='ca', crm_ISO_Countrycode_for_Customer_Company__c='Angola');
     insert acc;
     Contact con = new Contact();
     con.FirstName = 'test';
     con.LastName = 'Test';
     con.Phone = '7878787878';
     con.AccountId = acc.id;
     con.Email = 'a@a.com';
     insert con;
     
    ApexPages.currentPage().getParameters().put('id', acc.id);
    ApexPages.StandardController std = new ApexPages.StandardController(acc);
    crm_CreatePartyCustomer cls = new crm_CreatePartyCustomer(std);
    test.startTest();
    cls.convertToParty();
     test.stopTest();

  }
  
    private static testMethod void testReqRelationLevelCustomerContoller_3() {
    
    test.startTest();
    postenNoEconnectCreatecustomerparty.CreateExceptionType a= new postenNoEconnectCreatecustomerparty.CreateExceptionType();
    postenNoEconnectCreatecustomerparty.IDType b= new postenNoEconnectCreatecustomerparty.IDType();
    postenNoEconnectCreatecustomerparty.CitySubDivisionNameType c= new postenNoEconnectCreatecustomerparty.CitySubDivisionNameType();
    postenNoEconnectCreatecustomerparty.OrganizationCustomerType d= new postenNoEconnectCreatecustomerparty.OrganizationCustomerType();
    postenNoEconnectCreatecustomerparty.CreateOrgnizationCustomerRequestType e= new postenNoEconnectCreatecustomerparty.CreateOrgnizationCustomerRequestType();
    postenNoEconnectCreatecustomerparty.CustomerAccountSiteType f= new postenNoEconnectCreatecustomerparty.CustomerAccountSiteType();
    postenNoEconnectCreatecustomerparty.CodeType g= new postenNoEconnectCreatecustomerparty.CodeType();
    postenNoEconnectCommonExceptionV1.Error_element  test22 = new postenNoEconnectCommonExceptionV1.Error_element ();

    postenNoEconnectCommonExceptionV1.ServiceExceptionType  test2 = new postenNoEconnectCommonExceptionV1.ServiceExceptionType();
    postenNoEconnectCommonHeaderV1.HeaderType  hdr = new postenNoEconnectCommonHeaderV1.HeaderType ();
    
    test.stopTest();

  }
}