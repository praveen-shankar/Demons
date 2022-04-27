public class adHoc_viewCaseController {

    public Case myCase{ set; get { return getMyCase(); } }
    public String error { set; get; }
    public String xmlInfo { set; get{ return '<?xml version="1.0" encoding="UTF-8"?>';} }
    public String caseDescription { set; get{ return getCaseDescription(); } }
    
    public Case getMyCase() {
        String key = ApexPages.currentPage().getParameters().get('key');
        if(key != null) {
            try {
                return myCase = [SELECT CaseNumber, Shipment_number__c, Status, RecordType.Name, CreatedDate, LastModifiedDate, Origin, Subject, processing_deadline__c FROM Case WHERE hashed_URL__c = :key LIMIT 1];
            } catch(Exception e) {
                myCase = null;
            }
        }
        //<!--CSphase2, Akash, 19122016-->
        //setError('Kunne ikke finne den aktuelle saken. Vennligst kontakt kundeservice');
        setError(System.Label.cs_ViewCaseError);
        return null;
    }
    
    public void setError(String error) {
        this.error = error;
    }
    
    public String getError() {
        return error;
    }
    
    public String getCaseDescription() {
        if(myCase != null && myCase.Status != null) {
          if(myCase.Status.equals('Ny')) { return 'Ny'; }
          
            
          //CSphase2 22122016 supriya , Translated the value to English
            /*if(myCase.Status.equals('Planlagt')) { return 'Planlagt'; }
            if(myCase.Status.equals('Under behandling')) { return 'behandling'; }
            if(myCase.Status.equals('Avventer kunde')) { return 'kunde'; }
            if(myCase.Status.equals('Avventer 3dje part')) { return 'Avventer'; }
            if(myCase.Status.equals('Avventer annen enhet')) { return 'Avventer'; }
            if(myCase.Status.equals('Avsluttet')) { return 'Avsluttet'; }
            if(myCase.Status.equals('Avsluttet - dublett')) { return 'Avsluttet'; }
            if(myCase.Status.equals('Avsluttet - avbestilt')) { return 'Avsluttet'; }
            if(myCase.Status.equals('Avsluttet - feilregistrering')) { return 'Avsluttet'; }
            if(myCase.Status.equals('Avsluttet - avventer avsendende enhet')) { return 'Avsluttet'; }
            if(myCase.Status.equals('Avsluttet godkjent')) { return 'Avsluttet'; }
            if(myCase.Status.equals('Til anvisning')) { return 'anvisning'; }
            if(myCase.Status.equals('Avsluttet avvist')) { return 'avvist'; }
            if(myCase.Status.equals('Avventer 3die part')) { return 'Avventer'; }
            if(myCase.Status.equals('Lukket')) { return 'Lukket'; }
            if(myCase.Status.equals('Utsatt')) { return 'Utsatt'; }*/
        }
        return '';
    }

}