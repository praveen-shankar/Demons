public class mock_Katsordereventr {
	private static final postenNoEconnect20087Katsordereventr.OrderEventReleaseResponseComplexType success;
	private static final postenNoEconnect20087Katsordereventr.OrderEventReleaseResponseComplexType failure;
	
	static {
		success = new postenNoEconnect20087Katsordereventr.OrderEventReleaseResponseComplexType();
			success.Status = 'OK';
			
		failure = new postenNoEconnect20087Katsordereventr.OrderEventReleaseResponseComplexType();
			failure.Status = 'FAILED';
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
	
	public class mock_FAILED implements WebServiceMock {
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
			
				response.put('response_x', failure); 
		}
	}
	
	public static postenNoEconnect20087Katsordereventr.OrderEventReleaseResponseComplexType getMockResponseElement_Success() {
		return success;
	}
	
	public static postenNoEconnect20087Katsordereventr.OrderEventReleaseResponseComplexType getMockResponseElement_Failure() {
		return failure;
	}
}