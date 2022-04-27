@isTest
public class crm_newContactWrapperTest{

@isTest 
static void parse(){
String Json=' {"usingCustomerNumber" :false , "firstName":"testname",  "lastName" : "lastname" , "userName":"userName","language":"EN","phoneNumber":"111",  "additionalDetails":{"key":"bbbuu"}}';
//crm_newContactWrapper con= new crm_newContactWrapper();
crm_newContactWrapper.parse(Json);
}
}