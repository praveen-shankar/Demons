/* Created By: Supriya Goel
Date: 30 Aug  2016
Test class: crm_populateFederationId
*/

@isTest
public class crm_populateFederationIdTest{

@testSetup static void setup() {
    User u = crm_TestDataFactory.createUser();
    u.EmployeeNumber='12345';
    insert u;
  }
  
    testMethod static void TestFederationID()
    {
        User u= [Select id from user where email = 'admin@test.com'];
        User u1 = crm_TestDataFactory.createSalesUser();
        insert u1;
        
           
        u.EmployeeNumber='123456';
        update u1;
    }
  
}