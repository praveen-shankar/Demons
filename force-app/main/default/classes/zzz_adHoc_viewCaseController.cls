@isTest
private class zzz_adHoc_viewCaseController {
	
	static testMethod void coverageTest() {
		adHoc_viewCaseController adHoc = new adHoc_viewCaseController();
		adHoc.getMyCase();
		
		Case c = new Case(Hashed_URL__c = 'skdbcskdjcs');
		c.date_to_be_resumed__c = Date.today().addDays(3);
		upsert c;
		
		c = [SELECT id, status, Hashed_URL__c FROM Case WHERE id = :c.id LIMIT 1];
		
		ApexPages.currentPage().getParameters().put('key', c.Hashed_URL__c);
		adHoc_viewCaseController adHoc2 = new adHoc_viewCaseController();
		adHoc2.getMyCase();
		adHoc2.getError();
		adHoc2.getCaseDescription();
        adHoc.xmlInfo='XYZ';
        adHoc.caseDescription='XYZ';
		/*
		c.Status = 'Ny';
		adHoc2.myCase = c;
		adHoc2.getCaseDescription();
		
		c.Status = 'Under behandling';
		adHoc2.myCase = c;
		adHoc2.getCaseDescription();
		
		c.Status = 'Avventer kunde';
		adHoc2.myCase = c;
		adHoc2.getCaseDescription();
		
		c.Status = 'Avventer 3dje part';
		adHoc2.myCase = c;
		adHoc2.getCaseDescription();
		
		c.Status = 'Avsluttet';
		adHoc2.myCase = c;
		adHoc2.getCaseDescription();
		
		c.Status = 'Avventer annen enhet';
		adHoc2.myCase = c;
		adHoc2.getCaseDescription();
		
		c.Status = 'Avsluttet - dublett';
		adHoc2.myCase = c;
		adHoc2.getCaseDescription();
		
		c.Status = 'Avsluttet - avbestilt';
		adHoc2.myCase = c;
		adHoc2.getCaseDescription();
		
		c.Status = 'Avsluttet - feilregistrering';
		adHoc2.myCase = c;
		adHoc2.getCaseDescription();
		
		c.Status = 'Avsluttet - avventer avsendende enhet';
		adHoc2.myCase = c;
		adHoc2.getCaseDescription();
		
		c.Status = 'Avsluttet godkjent';
		adHoc2.myCase = c;
		adHoc2.getCaseDescription();
		
		c.Status = 'Til anvisning';
		adHoc2.myCase = c;
		adHoc2.getCaseDescription();
		
		c.Status = 'Avsluttet avvist';
		adHoc2.myCase = c;
		adHoc2.getCaseDescription();
		
		c.Status = 'Avventer 3die part';
		adHoc2.myCase = c;
		adHoc2.getCaseDescription();
		
		c.Status = 'Lukket';
		adHoc2.myCase = c;
		adHoc2.getCaseDescription();
		
		c.Status = 'Lukket';
		adHoc2.myCase = c;
		adHoc2.getCaseDescription();
		*/
		if(adHoc.myCase.Status == null) {
			system.debug('***************************************************************************NULL');
		}
		
	}
}