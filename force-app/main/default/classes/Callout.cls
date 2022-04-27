public class Callout
{
    
    public static  string getEmail(string postnumber)
    {  
        string postnr = postnumber;
        WebTransferMailBox__c Mbox = WebTransferMailBox__c.getValues('WebTransferMailBox');
        String username = Mbox.Username__c;
        String password = Mbox.Password__c;
        String url = Mbox.Url__c + 'PostNr='+ postnr+'&DistribusjonsType=B';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setEndpoint(url);
        request.setMethod('GET');
        request.setTimeout(120000);
        string result ='';
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        
        try{
            response = http.send(request);
        }
        catch(Exception e){   
            crm_Exception_handler.createExceptionRecords(e);
        }
        if(response.getStatusCode() == 200){
            try{    
                String responseString = response.getBody();
                system.debug('******responseString:: '+responseString); 
                result =  Parser.xmlparser(responseString);
                system.debug('******result:: '+result); 
                
            }catch(exception e){
                crm_Exception_handler.createExceptionRecords(e);
            }
        } 
        return result;
    } 
    
}