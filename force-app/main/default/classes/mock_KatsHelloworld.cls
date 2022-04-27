@isTest
public with sharing class mock_KatsHelloworld {
	
	private static final postenNoKatsHelloworld.Output_en_element helloWorld;
	
	static {
		helloWorld = new postenNoKatsHelloworld.Output_en_element();
		
		helloWorld.elementOut = 'TEST';
	}
	
	public class mock_helloWorld implements WebServiceMock {
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
			
				response.put('response_x', mock_KatsHelloworld.getHelloWorld());
		}
	}
	
	public static postenNoKatsHelloworld.Output_en_element getHelloWorld() {
		return helloWorld;
	}
}