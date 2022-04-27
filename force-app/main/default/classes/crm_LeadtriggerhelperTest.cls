/*Date: 28th Nov 2018
Test class: Test class for the leadtriggerhelper
*/

@isTest
public class crm_LeadtriggerhelperTest{

public static testmethod void testleadcreation(){

    Lead l = new lead();
    l.lastname ='test lead';
    l.company='test company';
    l.email= 'testlead@test.com';
    l.crm_website_country__c='NO';
    l.crm_Has_Agreed_to_Marketing_Activities__c = true;
    insert l;
    
    l.crm_Has_Agreed_to_Marketing_Activities__c= false;
    update l;
    l.crm_Has_declined_Marketing_activities__c= true;
    l.crm_website_country__c='SE';
    update l;
    l.crm_website_country__c='DK';
    update l;
    l.crm_website_country__c='FI';
    update l;
    l.crm_website_country__c='NO';
    update l;
    l.Marketing_Activities_Agreed_To__c = 'Email';
    update l;
    l.crm_Has_declined_Marketing_activities__c = true;
    update l;
    l.crm_Has_Agreed_to_Marketing_Activities__c = true;
    update l;
   
    }

}