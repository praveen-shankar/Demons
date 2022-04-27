@isTest
global class edi_getRejectedLM_API_Mock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
                
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Status": "00","SQLCode": "0","ReturnStatusText": null,"RejectedEDI": [{"ParcelNumber": "370438101313558119","EDIIdent": "98466118504","RunNumber": null,"FailureMessage": "FEIL I,ERROR:Sending er feil","Timestamp": "2019-02-11T10:16:24.388862+01:00"}]}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}