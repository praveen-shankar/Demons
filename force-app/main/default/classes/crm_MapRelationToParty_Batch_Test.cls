/* Created By: Bhavani Prasad 
Test class: Test class for crm_MapRelationToParty_Batch
*/
@isTest
public class crm_MapRelationToParty_Batch_Test {

    
    public static recordtype relationRecordType = NULL;
    public static recordtype partyRecordType = NULL;
    public static Account relation = NULL;
    public static Account party = NULL;
    
    static testMethod void mapRelationToParty() {
    crm_TestDataFactory.CreateCustomSetting();
        relationRecordType = [select id from recordtype where developerName = 'business_account' limit 1];
        partyRecordType = [select id from recordtype where developerName = 'crm_Party_level_Customer' limit 1];
        string organization_number = System.hashCode(System.now())+'';
        relation = new Account();
        relation.name = 'test'+System.Now();
        relation.RecordTypeId =  relationRecordType.Id;
        relation.Orga__c = organization_number;
        
        insert relation;
        
        system.debug ('RELATION: '+ relation.id);

        party = new Account();
        party.name = 'test party '+System.Now();
        party.RecordTypeId =  partyRecordType.Id;
        party.Orga__c = organization_number;
        party.crm_upsertKey__c = organization_number+'PARTY';
        
        insert party;
        
        system.debug('PARTY:  ' + party.id);
        System.Test.StartTest();
        Database.executeBatch(new crm_MapRelationToParty_Batch('test',relationRecordType.Id));        
        System.Test.StopTest();
        
        ID relationId = relation.Id;
        relation = [select id,parentid from account where id=:relationId];
        system.debug('Relation ID after batch: ---' + relation.id);
        system.debug('Relation ParentId after batch: ---' + relation.ParentId);
        System.assertEquals(relation.ParentId, party.Id);
        
    }

}