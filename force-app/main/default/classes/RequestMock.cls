@isTest
public class RequestMock implements HttpCalloutMock {
    
    public Integer statusCode;
    public String status;
    public String body;
    
    public RequestMock(Integer statusCode, String status, String body){
        this.statusCode = statusCode;
        this.status = status;
        this.body = body;
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(statusCode);
        res.setStatus(status);
        res.setBody(body);
       return res; 
    }
}