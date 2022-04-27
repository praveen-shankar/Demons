@isTest
public class AddEdiDetails_Test{


static TestMethod void Test1(){
crm_TestDataFactory.CreateCustomSetting();
list<Account> acclist = new List<Account>();

    Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
    insert  partyLevelacnt; 
    
    //create relation level accounts  
    Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
    relationLevelacnt1.parentId=partyLevelacnt.id;
    insert  relationLevelacnt1;
    
    Account relationLevelacnt2= crm_TestDataFactory.createRelationlevelAccount();
    relationLevelacnt2.parentId=partyLevelacnt.id;
    insert  relationLevelacnt2;
    
    relationLevelacnt1.crm_customer_number__c ='12345';
    relationLevelacnt1.Orga__c ='243234';
    relationLevelacnt1.crm_Customer_Status_Role_3__c ='A';
    relationLevelacnt1.crm_EDI_Customer__c =true;
    update relationLevelacnt1;
    acclist.add(relationLevelacnt1);
    
    
    relationLevelacnt2.crm_customer_number__c ='123451';
    relationLevelacnt2.Orga__c ='243234';
    relationLevelacnt2.crm_Customer_Status_Role_3__c ='A';
    relationLevelacnt2.crm_EDI_Customer__c =true;
    update relationLevelacnt2;
    acclist.add(relationLevelacnt2);
       
    AddEdiDetails.accountListWrapper wrapper = new AddEdiDetails.accountListWrapper(true,relationLevelacnt1);
    wrapper.isChecked =true;
    wrapper.objAccount =  relationLevelacnt1;
    
    String str = JSON.serialize(acclist);

    Edi_Information__c edi = new Edi_Information__c();
    edi.Name ='test EDI';
    edi.crm_Account__c = relationLevelacnt1.id;
    edi.EDI_Identificator__c ='1233';
    edi.Kvalificator__c ='14';
    edi.status__c ='New';
    insert edi;
    
    environment_settings__c profilenames = new environment_settings__c ();
       profilenames.name = 'EDI_ReplicationTabVisibilty';
       profilenames.value__c = 'System Administrator';
       insert profilenames;

Test.startTest();
    AddEdiDetails.performAction(str,edi.id);
    AddEdiDetails.getCustomers(relationLevelacnt1.name,'relation',relationLevelacnt1.orga__c);
    AddEdiDetails.getprofilename();
Test.StopTest();    

}

}