/*Date: 25th jan 2019
Test class: Test class for the crm_Customcasecreation
*/

@isTest
public class crm_CustomcasecreationTest{
@isTest static void createcaseTest() {
String JSONMsg ='{"cobj":{"type":"Request","origin":"Min Addresse for Bedrift","reason":"create test case","status":"New","subject":"Test forwardingaddress from MAB","priority":"Low", "suppliedName":"test name","suppliedEmail":"mail@mail.no","suppliedPhone":"23232323"}}';

    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/Customcasecreation/';
    req.httpMethod = 'PATCH';
    req.requestBody = Blob.valueof(JSONMsg);

    RestContext.request = req;
    RestContext.response= res;
    crm_Customcasecreation.Casewrapper cwrapper = new crm_Customcasecreation.Casewrapper();
     
    Test.startTest();
   // crm_ContactIntegrationtoMyBring  rep= new crm_ContactIntegrationtoMyBring();
   cwrapper =crm_Customcasecreation.insertCase();
    
      
    Test.stopTest();
   
    }
    

}