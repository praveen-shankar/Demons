/*
Created by :Supriya Goel
Date: 1st Aug 2018
updateresponsible seller 

*/

global class crm_responsiblesellerController {
    public Segment_Change_Request__c reqObj {
        get;
        set;
    }

    public crm_responsiblesellerController(ApexPages.StandardController stdController) {
        this.reqObj = (Segment_Change_Request__c) stdController.getRecord();
    }


    public Pagereference updateobjects() {

        Segment_Change_Request__c req = [Select id, Customer__c, Start_Date__c, Status__c, Service_Group__c, Current_Sales_Responsible__c, Proposed_Sales_Responsible__c, Proposed_Sales_Responsible__r.lastname, Proposed_Sales_Responsible__r.firstname from Segment_Change_Request__c where id =: reqObj.Id];

        if (req.Status__c == 'Approved') {
            OrgWideEmailAddress owa = [Select id, DisplayName, Address from OrgWideEmailAddress limit 1];
            List < Messaging.SingleEmailMessage > allmsg = new List < Messaging.SingleEmailMessage > ();

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List < string > toAddress = new List < string > ();
            mail.setToAddresses(new String[] {
                UserInfo.getUserEmail()
            });
            //mail.setTargetObjectId(opps.crm_Primary_Opportunity_Contact__c);
            mail.setSaveAsActivity(false);
            mail.setUseSignature(false);
            mail.setSubject('Your request has been initiated');
            String reason = '';

            string body = 'Hello ' + UserInfo.getName() + ',';
            body = body + '<br/> <br/> Your request has been initiated';
            body = body + '<br/> You will be notified when the request is done';
            body = body + '<br/> <br/> Thanks, <br/> Salesforce Support';
            mail.setHtmlBody(body);

            allmsg.add(mail);
            try {
                Messaging.sendEmail(allmsg, false);
            } catch (Exception e) {
                System.debug(e.getMessage());
            }
            Set < String > reqids = new Set < String > ();
            reqids.add(req.id);
            crm_updateresponsibleseller_Batch bcn = new crm_updateresponsibleseller_Batch(reqids);
            ID batchprocessid = Database.executeBatch(bcn, 1); //Changed the batch size for incident E2-IM018407963 (too many rows error was coming)

            return new Pagereference('/' + reqObj.Id); //+ '/e?retURL=%2F'+opp.Id
        } else {
            return new Pagereference('/apex/Cannotprocesssegmentreq?reqobjid=' + reqObj.Id);

        }
    }

}