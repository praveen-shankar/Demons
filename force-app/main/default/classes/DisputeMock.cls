@isTest
global class DisputeMock implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
        // start - specify the response you want to send
        postenNoEconnectDisputeinvoic.DisputeInvoiceResponseType response_x = 
            new postenNoEconnectDisputeinvoic.DisputeInvoiceResponseType();
        response_x.DisputeResponse = null;
        response_x.ServiceException= null;
        // end
        response.put('response_x', response_x); 
   }
}