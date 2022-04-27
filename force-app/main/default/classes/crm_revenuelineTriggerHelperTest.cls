/* Created By: Supriya goel
Date: 21 july  2016
Test class: crm_revenuelineTriggerHelper
*/

@isTest
public class crm_revenuelineTriggerHelperTest{
    @testSetup static void setup() {
    
        crm_TestDataFactory.CreateCustomSetting();  
        //create party level account
        Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
        insert  partyLevelacnt;

        //create relation level account
        Account relationLevelacnt= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelacnt.parentId=partyLevelacnt.id;
        insert  relationLevelacnt;

        Account relationLevelacnt2= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelacnt.parentId=partyLevelacnt.id;
        insert  relationLevelacnt2;

        
    }
    
    static testMethod void testrevenueonparty(){
        Account partyLevelacnt=[Select id, name , crm_Revenue_This_Year__c  from Account where name='parent test' limit 1];
        List<Account> relationacnts= [Select id, parentid from Account where parentid=:partyLevelacnt.id ];
        system.assertequals(relationacnts.size(),1);
        
        //create product
        Product2 prdobj = crm_TestDataFactory.createProduct();
        prdobj.crm_ERP_Product_ID__c ='123' ;
        prdobj.crm_global_Service_Area__c='Logistics';
        prdobj.crm_global_Service_Group__c ='Linehaul';
        prdobj.crm_global_Service_Family__c ='Linehaul';
        prdobj.IsActive = true;
        insert prdobj;

        //create revenue line
        list<crm_Revenue_Line__c> revLineList= new List<crm_Revenue_Line__c>();
        crm_Revenue_Line__c revLineObj1=crm_TestDataFactory.createRevenueLine();
        revLineObj1.crm_Account__c = relationacnts[0].id;
        revLineObj1.crm_Product__c= prdobj.id;
        revLineObj1.crm_Amount__c = 500;
        revLineObj1.crm_Transaction_Date__c = System.today();
        revLineList.add(revLineObj1);
        
        //create revenue line
        crm_Revenue_Line__c revLineObj2=crm_TestDataFactory.createRevenueLine();
        revLineObj2.crm_Account__c = relationacnts[0].id;
        revLineObj2.crm_Product__c= prdobj.id;
        revLineObj2.crm_Amount__c = 400;
        revLineObj2.crm_Transaction_Date__c = System.today();
        revLineList.add(revLineObj2);
       
        crm_Revenue_Line__c revLineObj3=crm_TestDataFactory.createRevenueLine();
        revLineObj3.crm_Account__c = relationacnts[0].id;
        revLineObj3.crm_Product__c= prdobj.id;
        revLineObj3.crm_Amount__c = 500;
        revLineObj3.crm_Transaction_Date__c = System.today();
        revLineList.add(revLineObj3);
        
        insert revLineList;
        
        for(Integer i=0; i<3; i++){
            revLineList[i].crm_Amount__c = 1000;
        }
        
        update revLineList;
        
        delete revLineList;
        
       
    }

}