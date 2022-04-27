@isTest
public class EmailSendController_Test {
static testmethod void testEmail()
{

//EmailSendController etest=new EmailSendController();
test.startTest();


crm_TestDataFactory.CreateCustomSetting();
Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
partyLevelacnt.crm_Count_of_Relation_level_Accounts__c=1;
insert  partyLevelacnt;
Contact con=new Contact();
con.lastname='testmaping';
con.email='Testmapping@cap.com';
con.AccountId=partyLevelacnt.id;
con.crm_Contact_Type__c='Sales';
insert con;

EmailSendController.sendMailMethod('a.b@test.com','this is subject','this is body',con.id);
List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

Messaging.sendEmail(mails);
    
EmailSendController.getContact(con.id);
//system.assert(UserInfo.getLanguage() == 'no');
EmailSendController.getBody(con.id);
EmailSendController.getsubject();

test.stopTest();
}
    

}