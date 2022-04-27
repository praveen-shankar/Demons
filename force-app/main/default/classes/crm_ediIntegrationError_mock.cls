@IsTest
public class crm_ediIntegrationError_mock implements HttpCalloutMock 
{
    public HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setStatus('OK');
        res.setBody('{"Message" : "Done",  "Status": "ERROR" , "Code" :"404" , "Summary": "all Done", "Details": "ERROR","IdSubscriber":"1234"}');
        
        return res; 
    }
}