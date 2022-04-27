@isTest

public class crm_Exception_handlerTest{


    static testMethod void test1(){
    
    crm_TestDataFactory.CreateCustomSetting();
    Exception exc;
    System.Test.startTest();
    
    crm_Exception_handler eh = new crm_Exception_handler();
    try{
        insert new Account();
    }Catch(Exception excp){
        exc = excp;
    }
    crm_Exception_handler.createExceptionRecords(exc);
    System.Test.stopTest();
    }

    static testMethod void test2(){
    
    crm_TestDataFactory.CreateCustomSetting();
    Exception exc;
    System.Test.startTest();
    
    crm_Exception_handler eh = new crm_Exception_handler();
    try{
        insert new Account();
    }Catch(Exception excp){
        exc = excp;
    }
    crm_Exception_handler.createExceptionRecordsAnyType(exc,'xyz');
    }
    
    static testMethod void test3(){
        System.Test.startTest();
        Account a = new Account(Name='test');
        insert a;
        crm_Exception_handler.createNonExceptionRecords('t',5,a.Id,'t','t');
        System.Test.stopTest();
    }    
}