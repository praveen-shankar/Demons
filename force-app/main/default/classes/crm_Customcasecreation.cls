/*
 * Update.insert cases in Salesforce  
 * Author: Supriya goel
 
*/
@RestResource(urlMapping = '/Customcasecreation/*')

global class crm_Customcasecreation {

 @HttpPost
 global static Casewrapper   insertCase() {
  RestRequest request = RestContext.request;
  Case caseobj = new Case ();
 

  //Extracting the data from the JSON HTTP request object sent from iPad
  RestRequest req = RestContext.request;
  RestResponse res = RestContext.response;
  Blob body = req.requestBody;
  String jsonToParse = body.toString();
  
  caseobj = (Case)System.JSON.deserialize(jsonToParse , Case.class);
  Casewrapper cwrapper = new Casewrapper();
   try
   {
    caseobj.RecordTypeId=KATSutilities.getRecordType('planned_distribution_case'); 
       
   if(caseobj.suppliedcompany.length() > 80 ){
    caseobj.suppliedcompany = caseobj.suppliedcompany.substring(0, 80);
}
   insert caseobj;
   
  Case caseobjinserted=[Select id, caseNumber, Status from case where id= :caseobj.id limit 1];
  cwrapper.caseId= caseobjinserted.id;
  cwrapper.caseNumber  = caseobjinserted.caseNumber;
  cwrapper.Status    = 'Success';
  
  
  }
  
  catch(Exception e){
   
  cwrapper.caseId= '';
  cwrapper.caseNumber  = '';
  cwrapper.Status    = 'Error:' +e.getMessage();
  
  }
 
 return cwrapper;
  
  }
  global class Casewrapper  {
   public String caseId{ get; set;}   
   public String caseNumber{ get; set;}   
   public String Status {get;set;}    
     
  
  }
  
  }