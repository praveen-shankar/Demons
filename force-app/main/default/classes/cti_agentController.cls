/**
 *  This class is a ApexPages controller used by cti_CaseService to reset flags CTI uses to control which Cases to fetch.
 *  The controller also ensures the Case is transferred to the current user and it's status is set to "Under behandling".
 *  Finally redirecting the current user to the actual Case.
 */

public class cti_agentController {
    private Case c;

    public cti_agentController(ApexPages.StandardController stdController) {
        this.c = (Case)stdController.getRecord();
    }
    
    /**
     * Resets CTI flags, changes owner to current user and sets status to "Under behandling"
     * @return the URL to the actual Case
     */
    public PageReference prepareCaseForAgent() {
        //c.flag = false
        c.Assigned_to_CTI__c = false;
        c.Assigned_to_CTI_Agent__c = false;
        c.ownerId = UserInfo.getUserId();
        c.unread_action__c = false;
        c.case_new_Comment__c = false;
        c.Status = 'Under behandling';// api name
        //Csphase 2 Supriya 26122016
        //c.Status = 'Prosessing';
        
       
        upsert c;
        
        PageReference casePage = new ApexPages.StandardController(c).view();
        casePage.setRedirect(true);

        return casePage;

        
       // return null;
    }

}