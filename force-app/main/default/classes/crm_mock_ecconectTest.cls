public class crm_mock_ecconectTest {
  private static final postenNoEconnectCreatecustomerparty.CreateCustomerResponseType success;
  
  static {
    success = new postenNoEconnectCreatecustomerparty.CreateCustomerResponseType ();
    success.Result= 'S';
  }
  
  public class mock_OK implements WebServiceMock {
    public void doInvoke(
      Object stub,
      Object request,
      Map<String, Object> response,
      String endpoint,
      String soapAction,
      String requestName,
      String responseNS,
      String responseName,
      String responseType) {
        
        response.put('response_x', success); 
    }
  }
}