/*
@Author - Rajeev Shekhar
@Date - 30 March 2016
@Purpose - Handle exception across the CRM scope
*/


public class crm_Exception_handler{
    
    /*Initializations*/
    final Static String dmlExc = 'System.DmlException';
    Static Exception e;
    
    
    /*Method invoked by Apex to capture exceptions in a separate object*/
    public static void createExceptionRecords(Exception ex){
        e = ex;
        
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.allowFieldTruncation = true;

    Try{
        crm_Exception__c exc = new crm_Exception__c(
            crm_Message__c = e.getMessage(),
            crm_Stack_Trace__c = e.getStackTraceString(),
            crm_Type__c = e.getTypeName(),
            crm_Line_Number__c = e.getLineNumber(),
            crm_Dml_Id__c = getDMLIds().removeEnd(','),
            crm_Dml_Field_Names__c = getDMLfields().removeEnd(','),
            crm_Number_of_Failed_Rows__c = e.getNumDml()
        );
        
        exc.setOptions(dml);
        insert exc;
        
        }
        
         catch(exception ee){
        crm_Exception__c exc = new crm_Exception__c(
            crm_Message__c = e.getMessage(),
            crm_Stack_Trace__c = e.getStackTraceString(),
            crm_Type__c = e.getTypeName(),
            crm_Line_Number__c = e.getLineNumber(),
            crm_Dml_Id__c = getDMLIds().removeEnd(','),
            crm_Dml_Field_Names__c = getDMLfields().removeEnd(',')
            //crm_Number_of_Failed_Rows__c = e.getNumDml()
            );
            
           exc.setOptions(dml);
           insert exc; 
           }
            
    }
    
    
    /*Method to create a String of affected record Ids*/
    private Static String getDMLIds(){
        String dmlids = '';
        if(e.getTypeName() == dmlExc){
            for(integer i = 0;i<e.getNumDml();i++){
                dmlids = dmlids + e.getDmlId(i) + ',';
            }
        }
    return dmlids;
    }

    
    /*Method to create field names affecting the process*/
    private Static String getDMLfields(){
        String dmlfields = '';
        if(e.getTypeName() == dmlExc){
            for(integer i = 0;i<e.getNumDml();i++){
                dmlfields = dmlfields + e.getDmlFieldNames(i) + ',';
            } 
        }
    return dmlfields;
   }
 
   //Method to catch generic exception
   public static void createExceptionRecordsAnyType(Exception ex, String failedId){
        e = ex;
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.allowFieldTruncation = true;
        crm_Exception__c exc = new crm_Exception__c(
            crm_Message__c = e.getMessage(),
            crm_Stack_Trace__c = e.getStackTraceString(),
            crm_Type__c = e.getTypeName(),
            crm_Line_Number__c = e.getLineNumber(),
            crm_Dml_Id__c = failedId
        );
        
        exc.setOptions(dml);
        insert exc;    
   }  
   //Method created only for non exception records
   public static void createNonExceptionRecords(String statusMessage, Integer statusCode, Id failedId, String tId, String trace){
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.allowFieldTruncation = true;
        crm_Exception__c exc = new crm_Exception__c(
            crm_Message__c = statusMessage + '-' + tId,
            crm_Stack_Trace__c = trace,
            crm_Type__c =  'System.CalloutException',
            crm_Line_Number__c = null,
            crm_Dml_Id__c = failedId
        );
        
        exc.setOptions(dml);
        insert exc;    
   }      
}