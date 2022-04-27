public class Case_SubmitPlanMassUpdateController {

        private final Case c;
        public String caseId {get;set;}
        
        public List<PlannedShipment> plannedShipments { get; set; }

        //Constructor.
        public Case_SubmitPlanMassUpdateController(ApexPages.StandardController stdController) {
                c = (Case) stdController.getRecord();
                c.Priority = '';
                c.Status = '';
                c.Submission_place_TEXTONLY__c = null;
                c.Booking_date__c = null;
                
                caseId = ApexPages.currentPage().getParameters().get('caseId');
                Id record = KATSutilities.getRecordType('planned_distribution_case');
                
                plannedShipments = new List<PlannedShipment>();
                for(Case x : [SELECT Id, caseNumber, AccountId, ContactId, Submission_place_TEXTONLY__c, Vekt_pr_sending__c, Number_of_circulation__c, Booking_date__c, Subject, Status, Priority FROM Case WHERE parentId = :caseId AND RecordTypeId = :record AND Status = 'Planlagt']) {
                //CSPhase2 Supriya 23122016
                //for(Case x : [SELECT Id, caseNumber, AccountId, ContactId, Submission_place_TEXTONLY__c, Vekt_pr_sending__c, Number_of_circulation__c, Booking_date__c, Subject, Status, Priority FROM Case WHERE parentId = :caseId AND RecordTypeId = :record AND Status = 'Planned']) {
                        plannedShipments.add(new PlannedShipment(x));
                }
        }
        
        //Updates filed where a change has happened
        public PageReference updatePlannedShipments() {
                try {
                        List<Case> cases = new List<Case>();
                        for(PlannedShipment ps : plannedShipments) {
                                if(ps.isSelected) {
                                        if(c.Submission_place_TEXTONLY__c != null) { ps.shipment.Submission_place_TEXTONLY__c = c.Submission_place_TEXTONLY__c; }
                                        if(c.Booking_date__c != null){ ps.shipment.Booking_date__c = c.Booking_date__c; }
                                        if(c.Vekt_pr_sending__c > 0) { ps.shipment.Vekt_pr_sending__c = c.Vekt_pr_sending__c; }
                                        if(c.Number_of_circulation__c > 0) { ps.shipment.Number_of_circulation__c = c.Number_of_circulation__c; }
                                        if(c.AccountId != null) { ps.shipment.AccountId = c.AccountId; }
                                        if(c.ContactId != null) { ps.shipment.ContactId = c.ContactId; }
                                        if(c.Status != null) { ps.shipment.Status = c.Status; }
                                        if(c.Priority != null) { ps.shipment.Priority = c.Priority; }
                                        cases.add(ps.shipment);
                                        ps.isSelected = false;
                                }
                        }
                        
                        upsert(cases);
                } catch (Exception e) {
                       // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Noe gikk galt under oppdateringen - ' + e.getMessage() ));
                       //CSPhase2 23122016 Supriya 
                         KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_Something_went_wrong_during_the_update+  '- ' + e.getMessage() ));
                }
                return null;
        }
        
        /*
        * Helper
        */
        public class PlannedShipment {
                public boolean isSelected { get; set; }
                public Case shipment { get; set; }
                
                public PlannedShipment(Case shipment) {
                        this.shipment = shipment;
                        isSelected = false;
                }
        }

}