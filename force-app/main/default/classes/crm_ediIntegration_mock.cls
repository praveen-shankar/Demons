@IsTest
public class crm_ediIntegration_mock implements HttpCalloutMock 
{
    public string status; 
    
    public crm_ediIntegration_mock(String status)
    {
        this.status = status;
    }
    
    public HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        if(status == 'NOT_OK')
        {
            res.setStatusCode(200);
            res.setStatus('OK');
            res.setBody('');
        }
        
        if(status == 'SUCCESS')
        {
            res.setStatusCode(200);
            res.setStatus('OK');
            res.setBody('{"Message" : "Done",  "Status": "SUCCESS" , "Code" :"200" , "Summary": "all Done", "Details": "Success","IdSubscriber":"1234"}');
        }
        
        if(status == 'ERROR')
        {
            res.setStatusCode(200);
            res.setStatus('OK');
            res.setBody('{"Message" : "Done",  "Status": "ERROR" , "Code" :"200" , "Summary": "all Done", "Details": "Success","IdSubscriber":"1234"}');
        }
        
        if(status == 'NORESPONSE')
        {
            res.setStatusCode(400);
            res.setStatus('ERROR');
            res.setBody('{"Message" : "Done",  "Status": "ERROR" , "Code" :"200" , "Summary": "all Done", "Details": "Success","IdSubscriber":"1234"}');
        }
        
        return res; 
    }
}