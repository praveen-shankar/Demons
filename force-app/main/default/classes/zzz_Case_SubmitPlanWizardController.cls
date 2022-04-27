@isTest
private class zzz_Case_SubmitPlanWizardController 
{
    

    static testMethod void coverageTestPRU() 
    {
        Case c = new Case();
        upsert c;
        
        c = [SELECT id, caseNumber FROM Case WHERE id = :c.Id LIMIT 1];
        
        String product='PRU';
        
         environment_settings__c  objCustomSetting = new environment_settings__c ();
        objCustomSetting.value__c='Import';
        objCustomSetting.Name = 'ImportSendeplanOrigin';
        insert objCustomSetting ;
       
         Code_Event__c ce1 = new Code_Event__c(Name=' Planlagt innlevering');
        ce1.CaseTypeMultiselect__c = 'Klage';
        //CSpahse2 Supriya 29122016
        //ce1.CaseTypeMultiselect__c = 'Complaint';
        ce1.IsActive__c = true;
        insert ce1;
        
        c.Code_Event__c =ce1.Id;
        upsert c;
        
        ApexPages.currentPage().getParameters().put('case', c.id);
        
        Case_SubmitPlanWizardController spwc = new Case_SubmitPlanWizardController();
        
        Attachment att = new Attachment();
        att.name = 'TestPlan';
        att.Body = Blob.valueOf('Navn på utsendelse;Innleveringsdato;Innleveringssted;Vekt;Bestillings dato;Sperrefrist;Bestemt Dato;Opplag\nTest;01.01.2011;stokke;10;10.02.2010;01.02.2010;03.02.2011;2500');
        att.ContentType = 'application/vnd.ms-excel';
        
        spwc.csvFile = att;
        spwc.product = 'PRU';
        spwc.getItems();
        
        spwc.step1();
        spwc.step2();
        system.debug(c.CaseNumber);
        spwc.step3();
        spwc.save();
        
    }


    static testMethod void coverageTestPOST_ABO() 
    {
        Case c = new Case();
        upsert c;
        
        c = [SELECT id, caseNumber FROM Case WHERE id = :c.Id LIMIT 1];
        
        ApexPages.currentPage().getParameters().put('case', c.id);
        
        Case_SubmitPlanWizardController spwc = new Case_SubmitPlanWizardController();
        
        Attachment att = new Attachment();
        att.name = 'TestPlan';
        att.Body = Blob.valueOf('Navn på utsendelse2;Innleveringsdato;Innleveringssted;Vekt;Full distribusjon dato;Innlevering;Mottaker gruppe;Antall;Område for distribusjon;01.01.2011;stokke;10;10.02.2010;01.02.2010;03.02.2011;2500');
        att.ContentType = 'application/vnd.ms-excel';
        
        spwc.csvFile = att;
        spwc.product = 'POST_ABO';
        spwc.getItems();
        
        spwc.step1();
        spwc.step2();
        system.debug(c.CaseNumber);
        spwc.step3();
        spwc.save();
        
    }


    static testMethod void coverageTestPOST_ABO_PL() 
    {
        Case c = new Case();
        upsert c;
        
        c = [SELECT id, caseNumber FROM Case WHERE id = :c.Id LIMIT 1];
        
        ApexPages.currentPage().getParameters().put('case', c.id);
        
        Case_SubmitPlanWizardController spwc = new Case_SubmitPlanWizardController();
        
        Attachment att = new Attachment();
        att.name = 'TestPlan';
        att.Body = Blob.valueOf('Navn på utsendelse;Innleveringsdato;Innleveringssted;Vekt;Full distribusjon dato;Innlevering;Mottaker gruppe;Antall;Område for distribusjon;01.01.2011;stokke;10;10.02.2010;01.02.2010;03.02.2011;2500');
        att.ContentType = 'application/vnd.ms-excel';
        
        spwc.csvFile = att;
        spwc.product = 'POST_ABO_PL';
        spwc.getItems();
        
        spwc.step1();
        spwc.step2();
        system.debug(c.CaseNumber);
        spwc.step3();
        spwc.save();
        
    }

    
    static testMethod void coverageTestStep2() {
        Case c = new Case();
        upsert c;
        
        c = [SELECT id, caseNumber FROM Case WHERE id = :c.Id LIMIT 1];
        
        ApexPages.currentPage().getParameters().put('case', c.id);
        
        Case_SubmitPlanWizardController spwc = new Case_SubmitPlanWizardController();
        
        Attachment att = new Attachment();
        att.name = 'TestPlan';
        att.Body = Blob.valueOf('Navn på utsendelse;Innleveringsdato;Innleveringssted;Vekt;Full distribusjon dato;Innlevering;Mottaker gruppe;Antall;Område for distribusjon;01.01.2011;stokke;10;10.02.2010;01.02.2010;03.02.2011;2500');
        att.ContentType = 'text/anytext';
        
        spwc.csvFile = att;
        spwc.product = 'POST_ABO_PL';
        
        spwc.step1();
        spwc.step2();
        spwc.step3();
    }
    
    static testMethod void coverageTestException() {
        Case c = new Case();
        upsert c;
        
        c = [SELECT id, caseNumber FROM Case WHERE id = :c.Id LIMIT 1];
        
        ApexPages.currentPage().getParameters().put('case', c.id);
        
        Case_SubmitPlanWizardController spwc = new Case_SubmitPlanWizardController();
        
        Attachment att = new Attachment();
        att.name = 'TestPlan';
        att.Body = Blob.valueOf('Navn på utsendelse;Innleveringsdato;Innleveringssted;Vekt;Full distribusjon dato;Innlevering;Mottaker gruppe;Antall;Område for distribusjon;01.01.2011;stokke;10;10.02.2010;01.02.2010;03.02.2011;2500');
        att.ContentType = 'text/anytext';
        
        spwc.csvFile = att;
        spwc.step1();
        spwc.step2();
        
        spwc.csvFile.ContentType='ErrorType';
        spwc.product = 'POST_ABO_PL';
        spwc.step1();
        spwc.step2();
    }
    
    static testMethod void coverageTestSave() {
        Case c = new Case();
        c.Submission_date__c = date.newInstance(2012,5,20);
        c.Submission_place_TEXTONLY__c ='Innleveringssted';
        c.Vekt_pr_sending__c=10;
        
        c.Booking_date__c=date.newInstance(2012,5,22);
        c.Release_deadline__c=date.newInstance(2012,7,20);
        c.Distribution_date__c=date.newInstance(2012,9,20);
        c.Number_of_circulation__c = 100;
        upsert c;
        
        c = [SELECT id, caseNumber FROM Case WHERE id = :c.Id LIMIT 1];
        
        ApexPages.currentPage().getParameters().put('case', c.id);
        
        Case_SubmitPlanWizardController spwc = new Case_SubmitPlanWizardController();
        
        Attachment att = new Attachment();
        att.name = 'TestPlan';
        att.Body = Blob.valueOf('Navn på utsendelse;Innleveringsdato;Innleveringssted;Vekt;Full distribusjon dato;Innlevering;Mottaker gruppe;Antall;Område for distribusjon;01.01.2011;stokke;10;10.02.2010;01.02.2010;03.02.2011;2500');
        att.ContentType = 'application/vnd.ms-excel';
        
        spwc.csvFile = att;
        spwc.save();
    }
}