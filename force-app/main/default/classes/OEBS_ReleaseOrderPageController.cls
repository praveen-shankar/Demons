public with sharing class OEBS_ReleaseOrderPageController {
        public String orderReleaseReason { get; set; }
        public Case caseToBeReleased { get; set; }
        public boolean hasReleaseFailed { get{ return ((caseToBeReleased != null) && (caseToBeReleased.OEBS_Order_Status__c == 'Release failed')); } }
        public Boolean hasCaseComments { get; set; }
        
        public OEBS_ReleaseOrderPageController(ApexPages.StandardController controller) {
                try {
                        caseToBeReleased = [SELECT Id,
                                                                        CaseNumber,
                                                                        Description,
                                                                        Origin,
                                                                        Code_Event__c,
                                                                        Service_Product__c,
                                                                        Owner.Username,
                                                                        OEBS_order_number__c,
                                                                        OEBS_order_URL__c,
                                                                        OEBS_order_line_id__c,
                                                                        OEBS_top_article__c,
                                                                        OEBS_contract_name__c,
                                                                        OEBS_contract_number__c,
                                                                        OEBS_producer__c,
                                                                        Submission_place__c,
                                                                        OEBS_Order_Status__c,
                                                                        OEBS_order_release_reason__c,
                                                                        (Select Id, ParentId, CommentBody, CreatedById, CreatedBy.Name, CreatedDate, LastModifiedDate, IsDeleted From CaseComments Where IsDeleted = false Order by CreatedDate DESC)
                                                                FROM Case
                                                                WHERE Origin = 'OEBS'
                                                                        AND recordTypeId = :KATSutilities.getRecordType('deviation_case')
                                                                        AND (NOT OEBS_Order_Status__c = 'Released')
                                                                        AND Id = :ApexPages.currentPage().getParameters().get('id')];
                        hasCaseComments = (caseToBeReleased.CaseComments.size() == 0 ? false : true );
                } catch(QueryException qe) {
                        //<!--CSphase2, Akash, 20122016-->
                        //ExceptionController.handleException(true, true, qe, 'Det ligger en feil i forbindelse med spørringen som gjøres i kontrolleren til OEBS_ReleaseOrderPageController', 'Kan ikke finne sak eller saken passer ikke kriteriene for å frigis.');
                        ExceptionController.handleException(true, true, qe, System.Label.cs_releaseOrderMsg5, System.Label.cs_releaseOrderMsg6);
                }
                
                if(caseToBeReleased != null && String.isNotBlank(caseToBeReleased.OEBS_order_release_reason__c)) {
                        orderReleaseReason = caseToBeReleased.OEBS_order_release_reason__c;
                }
        }
        
        public PageReference releaseOrderGoToCase() {
                return releaseOrder('/' + caseToBeReleased.id);
        }
        
        public PageReference releaseOrderCloseCase()
        {
                //This will check if the Case has the Henvenselsestype section updated before closing the case.
                //if(caseToBeReleased.Code_Event__c == null || caseToBeReleased.ProductId == null) 
                if(caseToBeReleased.Code_Event__c == null || caseToBeReleased.Service_Product__c == null)  /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
                {
                        //<!--CSphase2, Akash, 20122016-->
                        //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Saken kan ikke lukkes uten at det er valgt Henvendelsestype og produktfamilie/produkt og årsak 1. Vennligste oppdater de markerte feltene under henvendelsestype.'));
                        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_releaseOrderMsg2));
                        return null;
                }
                return releaseOrder('/' + caseToBeReleased.id + '/s?retURL=%2F' + caseToBeReleased.id);
        }
        
        public PageReference releaseOrder(String returnURL) {
                if(String.isBlank(this.orderReleaseReason)) {
                        //<!--CSphase2, Akash, 20122016-->
                        //caseToBeReleased.OEBS_order_release_reason__c.addError('Ordre frigivelsesgrunn mangler');
                        caseToBeReleased.OEBS_order_release_reason__c.addError(System.Label.cs_releaseOrderMsg4);
                        return null;
                }
                if(this.orderReleaseReason.length()>255) {
                //<!--CSphase2, Akash, 20122016-->
                        //caseToBeReleased.OEBS_order_release_reason__c.addError('Ordre frigivelsesgrunn kan ikke overskride 255 tegn');
                        caseToBeReleased.OEBS_order_release_reason__c.addError(System.Label.cs_releaseOrderMsg3);
                        return null;
                }
                
                caseToBeReleased.OEBS_order_release_reason__c = orderReleaseReason;
                
                //OEBS_OrderController.releaseOrder is tested elsewhere,
                //therefore the order status is set to "Released". The bottom two lines is therefore not tested
                if(test.isRunningTest()) {
                        caseToBeReleased.OEBS_Order_Status__c = 'Released';
                } else {
                        caseToBeReleased = OEBS_OrderController.releaseOrder(caseToBeReleased);
                }
                
                update caseToBeReleased;
                
                if(caseToBeReleased.OEBS_Order_Status__c.equals('Released')) {
                        return new PageReference(returnURL);
                }
                //<!--CSphase2, Akash, 20122016-->
                //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ordren ble ikke frigitt. Systemet vil forsøke å frigi ordren automatisk innen 10 minutter, du kan også forsøke å frigi manuelt på nytt.'));
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_releaseOrderMsg1));
                
                return null;
        }
        
        public PageReference abort() {
                if(caseToBeReleased == null) {
                        return new PageReference('/home/home.jsp');
                }
                
                return new PageReference('/'+caseToBeReleased.id);
        }
        
        public PageReference saveAndGoToCase() {
                update caseToBeReleased;
                
                if(caseToBeReleased == null) {
                        return new PageReference('/home/home.jsp');
                }
                
                return new PageReference('/'+caseToBeReleased.id);
        }
}