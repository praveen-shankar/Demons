@isTest
global class MockHttpResponseGeneratorWebform implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
                
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setBody('<?xml version="1.0" encoding="utf-8"?><DataSet xmlns="http://posten.creuna.no/SalgsnettService/"><xs:schema id="NewDataSet" xmlns="" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata"><xs:element name="NewDataSet" msdata:IsDataSet="true" msdata:UseCurrentLocale="true"><xs:complexType><xs:choice minOccurs="0" maxOccurs="unbounded"><xs:element name="Table"><xs:complexType><xs:sequence><xs:element name="EnhetsNr" type="xs:string" minOccurs="0" /><xs:element name="Navn" type="xs:string" minOccurs="0" /><xs:element name="Epost" type="xs:string" minOccurs="0" /></xs:sequence></xs:complexType></xs:element></xs:choice></xs:complexType></xs:element></xs:schema><diffgr:diffgram xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" xmlns:diffgr="urn:schemas-microsoft-com:xml-diffgram-v1"><NewDataSet xmlns=""><Table diffgr:id="Table1" msdata:rowOrder="0"><EnhetsNr>181751</EnhetsNr><Navn>DD Lillestrøm D.Enhet</Navn><Epost>Lillestrom.distribusjonsenhet@posten.no</Epost></Table></NewDataSet></diffgr:diffgram></DataSet>' );

        res.setStatusCode(200);
        return res;
    }
}