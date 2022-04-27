@isTest
public class CS_CaseCommentsTest {

    static testMethod void CS_CloseCasetestmethod() {
       
       Account testAccount = new Account(Name = 'Test OEBS Account',
                                    crm_customer_number__c = '12345678');
        
        upsert testAccount;
       
    
   
        Case testCase = new Case(Origin = 'OEBS',Subject='test case',Description='Test description');
        insert testCase;
        
        CaseComment cc= new CaseComment();
        cc.CommentBody ='abc';
        cc.IsPublished = true;
        cc.ParentId=testCase.Id;
        insert cc;
        system.debug('cc id'+cc.Id);
        
        CS_CaseComments.getcaseComments(testCase.Id);
      
        CS_CaseComments.loadCasecommentDetails(cc.Id);
        CS_CaseComments.loadCaseDetails(testCase.Id);
           CS_CaseComments.insertcomment(testCase.Id, 'xyz', false);
        CS_CaseComments.updatecomment(cc.Id,'fttyf', false);
          CS_CaseComments.deleterecord(cc.Id);
     
        
    } 
}