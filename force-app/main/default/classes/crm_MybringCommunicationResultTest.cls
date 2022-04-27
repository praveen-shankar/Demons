/*
Test class: Test class for crm_MybringCommunicationResultController
*/
@isTest
public class crm_MybringCommunicationResultTest {
@isTest static void MybringCommResultTest() {
 String JSONMsg ='{"messageName":"Test Message1","messageSubject":"Test Subject1","messageBody":"Test Message Body 1","email":"arunkumar.kaligotla1@posten.no", "contactkey":"0031q00000QnVxg","open":"true",  "sentDate":"2020-05-13T14:23:44", "messageOpenedDate":"2020-06-25T14:23:44"}';

    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/MybringCommunicationResult/';
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JSONMsg);

    RestContext.request = req;
    RestContext.response= res;
     Test.startTest();
   
    String conId=crm_MybringCommunicationResultController.MybringCommResult();
      req.requestBody = Blob.valueof(JSONMsg);
      RestContext.request = req;
    RestContext.response= res;
     String conId1=crm_MybringCommunicationResultController.MybringCommResult();
      
    Test.stopTest();
  }
}