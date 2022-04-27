/*
 * REST API Implementation  C-08738 Messages to Post in Shop by using Salesforce and PULS - establish contact between vendors
 * Author: Supriya goel
 
*/
@RestResource(urlMapping='/getPostalunitnumbers/*')

global without sharing class getPostalunitnumbersAPI {

    @HttpGet
    global static void getRecord() {
    
     //Getting request body
       RestRequest request = RestContext.request;
        // grab the caseId from the end of the URL
        
        String starttime = request.params.get('starttime');
        String endtime = request.params.get('endtime');
        
        System.debug('##starttime ' +  DateTime.valueOf(starttime) );
        
        String timestamp = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        DateTime starttimestamp, endtimestamp;
       if(String.isNotBlank(starttime) && String.isNotBlank(endtime) ) {
            
            starttimestamp=  DateTime.valueOf(starttime);
            endtimestamp=  DateTime.valueOf(endtime);
            //lasttimestamp =  lasttimestamp.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');  //2018-10-01 12:12:12
            
            }
            
            System.debug('##lasttimestamp ' + starttimestamp + endtimestamp );
            
        Set<String> pnos= new Set<String>(); 
        
        if(Schema.sObjectType.cs_case_pib_messages__c.isAccessible() && Schema.sObjectType.cs_case_pib_messages__c.fields.Postal_Unit_Number__c.isAccessible()){
        List<cs_case_pib_messages__c > pibmessagesList= [Select id , Postal_Unit_Number__c from cs_case_pib_messages__c where createddate >=:starttimestamp and createddate <= :endtimestamp limit 10 ];
        for ( cs_case_pib_messages__c  pib: pibmessagesList){
            if(String.isNotBlank(pib.Postal_Unit_Number__c )) {
                pnos.add(pib.Postal_Unit_Number__c );
            
        }
     }  
     
   
   if(pnos.size()>20 )
    {
      RestContext.response.statusCode = 400;     RestContext.response.headers.put('PAYLOAD_LIMIT_EXCEEDED','ONLY_20_JSON_RECORDS_PER_PAYLOAD_ALLOWED');    
    
    }
    
    else {
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(pnos));
     
      }
   }
     else {
                    RestContext.response.statusCode = 403;        RestContext.response.headers.put('PROFILE_ISSUE','NO_ACCESS_ON_PIB_TABLE');
               } 
     
     
    
    }
    
    }