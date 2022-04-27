@isTest
private class zzz_Case_SubmitPlanMassUpdateController {


    static testMethod void coverageTest() 
    {
        List<Case> case_Lst = new List<Case>();

        Account acct1 = new Account(Name = 'Test1');
        upsert acct1;
        Contact cont1 = new Contact(Lastname = 'Test1');
        upsert cont1;
        
        Account acct2 = new Account(Name = 'Test2');
        upsert acct2;
        Contact cont2 = new Contact(Lastname = 'Test2');
        upsert cont2;
        
        
        Case c1 = new Case();
        c1.RecordTypeId = KATSutilities.getRecordType('planned_distribution_case');
        c1.Priority = 'Medium';
        c1.Status = 'Planned';
        c1.Submission_place_TEXTONLY__c = 'Oslo';
        c1.Booking_date__c = date.today();
        c1.Vekt_pr_sending__c = 5;
        c1.Number_of_circulation__c = 100;
        c1.AccountId = acct1.Id;
        c1.ContactId = cont1.Id;
        case_Lst.add(c1);
        
        Case c2 = new Case();
        c2.RecordTypeId = KATSutilities.getRecordType('planned_distribution_case');
        c2.Priority = 'Planned';
        c2.Status = 'Closed';
        c2.Submission_place_TEXTONLY__c = 'Stokke';
        c2.Booking_date__c = date.today().addDays(10);
        c2.Vekt_pr_sending__c = 10;
        c2.Number_of_circulation__c = 200;
        c2.AccountId = acct2.Id;
        c2.ContactId = cont2.Id;
        c2.ParentId = c1.Id;
        case_Lst.add(c2);

        Test.startTest();

        PageReference pageRef = Page.Case_subminPlanMassUpdate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('caseId', c1.id);     

        Case_SubmitPlanMassUpdateController spmuc = new Case_SubmitPlanMassUpdateController(new ApexPages.StandardController(c1));

        spmuc.plannedShipments.add(new Case_SubmitPlanMassUpdateController.PlannedShipment(c2));
        for(Case_SubmitPlanMassUpdateController.PlannedShipment ps : spmuc.plannedShipments) 
        {
            ps.isSelected = true;
        }

        spmuc.updatePlannedShipments();

        Test.stopTest();
    }
}