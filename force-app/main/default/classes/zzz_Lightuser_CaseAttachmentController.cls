@isTest
private class zzz_Lightuser_CaseAttachmentController {
    /* TODO: Write proper testing when logic is landed. This test has sole focus on line coverage */
    
    
    static testMethod void coverageTest()
    {
        Code_Event__c ce1 = new Code_Event__c();
        ce1.Name = 'CodeEvent1';
        ce1.IsActive__c = true;
        database.insert(ce1);
        
        //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        Service_Product__c prod1 = new Service_Product__c();
        prod1.Name = 'Prod1';
        //prod1.Eier__c = 'Post';
        //Cspahse2 Supriya 29122016
         prod1.Eier__c = 'MAIL';
        prod1.IsActive__c = true;
        database.insert(prod1);

        Code_Reason1__c cr1 = new Code_Reason1__c();
        cr1.Name = 'Arsak1';
        database.insert(cr1);

        Case c = new Case(status='Avsluttet');
        //Cspahse2 Supriya 29122016
          //Case c = new Case(status='Closed');
        c.Code_Event__c = ce1.Id;
        //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        c.Service_Product__c = prod1.Id;
        c.Code_Reason1__c = cr1.Id;
        c.Category__c = 'CodeEvent1';
        c.Produkt__c = 'Prod1';
        c.reason__c = cr1.Name;
        upsert c;

        
        ApexPages.currentPage().getParameters().put('id', c.id);
        Lightuser_CaseAttachmentController lc = new Lightuser_CaseAttachmentController();
        
        lc.newAttachment();
        List<Attachment> attachments = lc.attachments;
        
        lc.caseId=c.id;
        
        c=[select id, status from case where id=:c.id];
        System.assert(lc.getIsCaseClosed());
        
       // c.status='Ny';
       //Csphase2 supriya 29122016
        c.status='New';
        upsert c;
        c=[select id, status from case where id=:c.id];
        System.assert(lc.getIsCaseOpen());
        
        PageReference ref= lc.newAttachment();
        
    }
    
}