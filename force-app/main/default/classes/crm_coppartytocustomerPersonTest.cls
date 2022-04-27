@isTest
public class crm_coppartytocustomerPersonTest
{
         @testSetup static void setup() {
         Account personacc=new Account();
         personacc.Party_number__c='1234567';
         personacc.FirstName='Person Account';
         personacc.LastName='Person Account1';
         Id Recordtype=[Select id,developerName from RecordType where sobjectType='Account' and developerName='person_account' and isPersonType=true].id;
         personacc.recordtypeid=recordtype;
         insert personacc;
         
         }
         
         static testMethod void CreateNewPartylevel()
         {
         System.Test.startTest();
         crm_coppartytocustomerPerson_Batch batchObj=new crm_coppartytocustomerPerson_Batch();
         DataBase.executebatch(batchObj);
         System.Test.StopTest();
         }
}