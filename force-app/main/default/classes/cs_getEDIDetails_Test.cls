@isTest
public class cs_getEDIDetails_Test {
    @TestSetup
    public static void setupTestData(){
        account a = new account(name='test account');
        insert a;
        case c = New case(cs_EDI_Account__c=a.Id, cs_EDIId__c='980089', cs_EDIName__c='Test EDI');
        insert c;
    }
    
     @isTest
    public static void getEDIInfoTest(){
        case c = [Select id from case where cs_EDIId__c='980089'];
        string ca= cs_getEDIDetails.getEDIInfo(c.Id);
    }
    
     @isTest
    public static void updateEDIInfoTest(){
        case c = [Select id from case where cs_EDIId__c='980089'];
        boolean a=cs_getEDIDetails.updateEDIInfo(c.Id);
    }
}