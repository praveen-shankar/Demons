public class CaseAttachmentPresentHelper {
    public static void updateCaseWhichHasAttach(Set < ID > caseIds) {
        List < Case > finalCaseList = new List < Case > ();
        List < Case > finalCaseList1 = new List < Case > ();
        list < Case > caseList = [select id, has_Attachment__c, Receive_case_update_for_Mybring_cases__c, origin from Case where id in: caseIds];

        if (caseList != null && caseList.size() > 0) {
            for (Case case1: caseList) {
                //Need to update only those Cases whose has_Attachment__c field value is not true    
                if (case1.has_Attachment__c != true) {
                    case1.has_Attachment__c = true;
                    if (case1.Receive_case_update_for_Mybring_cases__c == true && case1.origin == 'Mybring') {
                        case1.send_email_of_case_update_myBring__c = true;
                    }

                    finalCaseList.add(case1);
                } else if (case1.Receive_case_update_for_Mybring_cases__c == true && case1.origin == 'Mybring') {
                    case1.send_email_of_case_update_myBring__c = true;
                    finalCaseList.add(case1);
                }
            }
        }

        if (caseList != null && caseList.size() > 0) {
            for (Case case1: caseList) {
                //Need to update only those Cases whose has_Attachment__c field value is not true    
                if (case1.has_Attachment__c != true) {
                    case1.has_Attachment__c = true;
                    finalCaseList1.add(case1);
                }
            }
        }


        Try {
            update finalCaseList;

        }

        Catch(Exception e) {
            ExceptionController.handleException(false, true, e, 'An error occured while updating the Case field has_Attachment__c in the method ==> updateCaseWhichHasAttach', '');
        }
    }


    public static void updateCaseWhichdoNothaveAttach(Set < ID > caseIds) {
        List < Case > finalCaseList = new List < Case > ();
        list < Case > caseList = [select id, has_Attachment__c, (select id from attachments) from Case where id in: caseIds];

        if (caseList != null && caseList.size() > 0) {
            for (Case case1: caseList) {
                //Need to update only those Cases who after deletion of the attachment do not have any attachment associated with it. 
                if (case1.attachments.isEmpty() && case1.has_Attachment__c == true) {
                    case1.has_Attachment__c = false;
                    finalCaseList.add(case1);
                }
            }
        }

        Try {
            update finalCaseList;
        }

        Catch(Exception e) {
            ExceptionController.handleException(false, true, e, 'An error occured while updating the Case field has_Attachment__c in the method ==> updateCaseWhichdoNothaveAttach', '');
        }

    }
    
    //Adding method to update the attachment description
    public static void addAttachmentDescription(List<Id> attId){
        List<Attachment> updateAttachment = New List<Attachment>();
        For(Attachment att : [Select id, parentId, description, createdbyId from Attachment where id IN :attId]){
            if(att.ParentId.getSobjectType() == Case.SobjectType && att.createdbyId != '005w000000724XW'){
                att.Description = 'Internal';
                updateAttachment.add(att);
            }
        }
        update updateAttachment;
        
    }

}