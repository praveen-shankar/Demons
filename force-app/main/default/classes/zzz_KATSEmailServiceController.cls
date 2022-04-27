@isTest
private class zzz_KATSEmailServiceController {
    //TODO: IMRPOVE ME
    static testMethod void testFormCarryOnBusinessPallet() {
        recordType RecordTyp = [select id from recordType where developerName='crm_Party_level_Customer' and sobjectType = 'Account' limit 1];
        Account slaAccount = new Account(name = 'Posten SLA Placeholder Account',RecordTypeId = RecordTyp.id);
        insert slaAccount;
        
        Account letterAccount = new Account(parentId = slaAccount.id, Name = 'Ikke fordelt brev/faks');
        insert letterAccount;
        
        //Creating Envelope Object
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.toAddress = 'toTest@test.test';
        envelope.fromAddress = 'fromTest@test.test';
        
        //Create Email object
        String[] fields = new String[] {'Navn Navnesen', 'testBedrift', '000.00.0000', 'TestAdresse 01', '0000', 'Testestad', '12345678', 'fromTest@test.test', 'Epost', 'Sende en pakke'};
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.fromAddress = 'fromTest@test.test';
        email.toAddresses = new String[] {'toTest@test.test'};
        email.subject = 'CarryOn Business Pallet: Navn Navnesen';
        email.plainTextBody = 'Navn: ' + fields[0] + '\n'
                        +'Bedrift: ' + fields[1] + '\n'
                        +'Organisasjonsnummer: ' + fields[2] + '\n'
                        +'Adresse: ' + fields[3] + '\n'
                        +'Postnummer: ' + fields[4] + '\n'
                        +'Poststed: ' + fields[5] + '\n'
                        +'Telefonnummer: ' + fields[6] + '\n'
                        +'Epost: ' + fields[7] + '\n'
                        +'Hvordan ønsker du å bli kontaktet?: ' + fields[8] + '\n'
                        +'Hva er ditt behov, og hva ønsker du å vite?:\n'
                        + fields[9];
        
        //Test methods
        KATSEmailServiceController k = new  KATSEmailServiceController();
        k.handleInboundEmail(email, envelope);
    }
}