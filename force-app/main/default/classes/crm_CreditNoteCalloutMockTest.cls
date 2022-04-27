@isTest
global class crm_CreditNoteCalloutMockTest implements HttpCalloutMock {
  
        protected Integer StatusCode;
        protected String Status;
        protected String body;
        protected Map<String, String> responseHeaders;
 
        public crm_CreditNoteCalloutMockTest(Integer code,String strmethod, String status, String body,
                                         Map<String, String> responseHeaders) {
            this.StatusCode = code;
            this.Status = status;
            this.body = body;
                                             
            this.responseHeaders = responseHeaders;
        }
 
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse resp = new HttpResponse();
            resp.setStatusCode(StatusCode);
            resp.setStatus(Status);
            resp.setBody(body);
            
            if (responseHeaders != null) {
                 for (String key : responseHeaders.keySet()) {
                resp.setHeader(key, responseHeaders.get(key));
                 }
            }
            return resp;
        }
    
    
    

}