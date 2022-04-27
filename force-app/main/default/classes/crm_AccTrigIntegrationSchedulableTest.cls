@isTest
public class crm_AccTrigIntegrationSchedulableTest{  

    public static testmethod void accIntrgrationTest(){
        Test.startTest();
        List<Id> lstAccParty = new List<Id>();
            Id partyRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('crm_Party_level_Customer').getRecordTypeId();
            Id relationRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('business_account').getRecordTypeId();
            Account[] partyCustomerList = new List<Account>();
            for (Integer i=0;i< 10;i++) {
            Account ac = new Account(Name = 'Account ' + i, 
                                    RecordTypeID = partyRecordTypeID , 
                                    crm_customer_converted_date__c = System.today().addDays(-2),
                                    crm_Updated_by_CDH__c  = true,
                                    Customer_Converted__c = 'Converted',
                                    CreatedDate = system.today().addDays(-2));
                partyCustomerList.add(ac);
            }
        insert partyCustomerList ;
    
    
         Account relationCustomer = new Account();
         relationCustomer.Name = ' Test Relation Account' ;
         relationCustomer.RecordTypeID = relationRecordTypeId ;
         relationCustomer.crm_Updated_by_CDH__c  = true;
         relationCustomer.ParentId = partyCustomerList[1].Id;
         relationCustomer.orga__c = '9856244';
         
         insert relationCustomer;
        lstAccParty.add(partyCustomerList[1].Id);
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        String jobId = System.schedule('Test', CRON_EXP, new crm_AccountTriggerIntegrationSchedulable(lstAccParty));  
       
        Test.stopTest();
    }  

}