/*Date: 11 th nov 2019
Test class: Test class for the getPostalunitnumbersAPI 
*/

@isTest
public class getPostalunitnumbersAPITest{
@isTest static void getRecordTest() {

   //do request
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/getPostalunitnumbers';  
        req.addParameter('starttime', '2018-05-19 00:00:00');
        req.addParameter('endtime', '2019-01-03 00:00:00');
       

        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        getPostalunitnumbersAPI.getRecord();



   
    }
    

}