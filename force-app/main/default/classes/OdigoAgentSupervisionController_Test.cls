/*
    Author - Rajeev Shekhar
    Test class for OdigoAgentSupervisionController class
    Posten Odigo CTI Project

*/



@isTest

private with sharing class OdigoAgentSupervisionController_Test{
    
    /*The test class assumes that Odigo package is pre-installed in the system.
      We are leveraging a class from managed package to display results on the VF page.Hence, there was
      not much control while writing the test class. As a result, the testMethod has been annotated with
      seeAllData as true.
      This class heavily relies on OdigoAgentSupervisionControllerTestData document record because this document
      provides a fake JSON string to the test class for processing.
    */
    @isTest(SeeAllData=true)
    static void testGetStats(){
        Test.startTest();
        User u = [Select Id from User Where Alias = 'aadmi'];
        System.runAs(u){
            OdigoAgentSupervisionController od = new OdigoAgentSupervisionController();           
           
        }
        Test.stopTest(); 
    }
    
}