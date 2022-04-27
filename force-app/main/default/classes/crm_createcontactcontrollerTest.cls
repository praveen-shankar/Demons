/* Created By: Akshata Asukar
Date: 28th nov 2016
Test class: Test class for my crm_createcontactcontroller
*/

@isTest
public class crm_createcontactcontrollerTest{

 @testSetup static void setup() {
   crm_TestDataFactory.CreateCustomSetting();
   
    Account partyLevelacnt1= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt1;
      
       Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt1.parentId=partyLevelacnt1.id;
       insert  relationLevelacnt1;
       
       User u = crm_TestDataFactory.createUser();
       u.crm_user_type__c='Sales';
       insert u;
       
       Contact duplicateContact=new Contact();
       duplicateContact.lastName='testduplicate';
       duplicateContact.email='testduplicate@cg.com';
       duplicateContact.Status__c='Active';
       insert duplicateContact;
       }
       
       static TestMethod void testcreatecontact()
       {
           
           List<Account> acc=[Select id from account where parentid=null];
          // User u=[Select id from User where crm_user_type__c='Sales'];
           PageReference pageRef = Page.crm_CreateContact;
           Test.setCurrentPage(pageRef);
           ApexPages.currentPage().getParameters().put('accid',acc[0].id);
           Contact conStd=new Contact();
           ApexPages.StandardController sc = new ApexPages.StandardController(conStd);
           crm_createcontactcontroller controllerObj=new crm_createcontactcontroller(sc);
           controllerObj.getAccounts();
           Contact contactObj=new Contact();
           contactObj.lastName='testcontact1';
           contactObj.Email='contest@cap.com';
           controllerobj.con=contactObj;
           //con.Email='contest@cap.com';
        
               controllerObj.saveContact();
          
       
       }
       
       static testMethod void testduplicateContact()
       {
           List<Account> acc=[Select id from account where parentid=null];
          // User u=[Select id from User where crm_user_type__c='Sales'];
           PageReference pageRef = Page.crm_CreateContact;
           Test.setCurrentPage(pageRef);
           ApexPages.currentPage().getParameters().put('accid',acc[0].id);
           Contact conStd=new Contact();
           ApexPages.StandardController sc = new ApexPages.StandardController(conStd);
           crm_createcontactcontroller controllerObj=new crm_createcontactcontroller(sc);
           controllerObj.getAccounts();
           Contact contactObj=new Contact();
           contactObj.lastName='testcontact2';
           contactObj.Email='testduplicate@cg.com';
           controllerobj.con=contactObj;
           //con.Email='contest@cap.com';
            try
            {
               controllerObj.saveContact();
            }
            catch(Exception e)
            {
                System.assert(e.getMessage().contains('You\'re creating a duplicate record'));
            }
       }
       
      /* static testMethod void testCreateduplicateContact()
       {
           List<Account> acc=[Select id from account where parentid=null];
          // User u=[Select id from User where crm_user_type__c='Sales'];
           PageReference pageRef = Page.crm_CreateContact;
           Test.setCurrentPage(pageRef);
           ApexPages.currentPage().getParameters().put('accid',acc[0].id);
           Contact conStd=new Contact();
           ApexPages.StandardController sc = new ApexPages.StandardController(conStd);
           crm_createcontactcontroller controllerObj=new crm_createcontactcontroller(sc);
           List<Contact> contactlistDup=new List<Contact>();
           
           controllerObj.getAccounts();
           Contact contactObj=new Contact();
           contactObj.lastName='testcontact2';
           contactObj.Email='testduplicate@cg.com';
          
           controllerobj.con=contactObj;
           contactlistDup.add(contactObj);
            controllerobj.contactlist=contactlistDup;
           //con.Email='contest@cap.com';
            try
            {
               controllerObj.SaveDuplicate();
            }
            catch(Exception e)
            {
                
            }
       }*/
 }