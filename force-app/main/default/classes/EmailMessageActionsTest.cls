@isTest
public class EmailMessageActionsTest {
    
    @isTest
    static void testEmailMessages(){
        String recTypeId = [Select Id from recordType where sobjectType = 'Case' and developername like '%consulting_case'].Id;
        
        Case c = New Case(Origin='Email', Status='New', Subject='Test Case');
        insert c;
        
        List<EmailMessage> emsgList = New List<EmailMessage>();
        for(integer i=0; i<3; i++){
            EmailMessage emsg = New EmailMessage(ParentId=c.Id, Subject='Test Email '+i, HtmlBody='Test Email 1'+i);
            emsgList.add(emsg);
        }
        
        insert emsgList;
        
       Test.StartTest();
       ApexPages.StandardController sc = new ApexPages.StandardController(emsgList[1]);
       EmailMessageActions  emsgAction = new EmailMessageActions(sc);
       PageReference nextEmail = emsgAction.nextMsg();
       PageReference prevEmail = emsgAction.previousMsg();
        
       ApexPages.StandardController sc1 = new ApexPages.StandardController(emsgList[2]);
       EmailMessageActions  emsgAction1 = new EmailMessageActions(sc1);
       PageReference nextEmail1 = emsgAction1.nextMsg();
        
       ApexPages.StandardController sc2 = new ApexPages.StandardController(emsgList[0]);
       EmailMessageActions  emsgAction2 = new EmailMessageActions(sc);
       PageReference prevEmail2 = emsgAction2.previousMsg();
       Test.StopTest();
    }
    
    @isTest
    static void testMethodWithNoNext(){
        String recTypeId = [Select Id from recordType where sobjectType = 'Case' and developername like '%consulting_case'].Id;
        
        Case c = New Case(Origin='Email', Status='New', Subject='Test Case');
        insert c;
        
        EmailMessage emsg = New EmailMessage(ParentId=c.Id, Subject='Test Email 1', HtmlBody='Test Email 1');
        insert emsg;
                
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(emsg);
        EmailMessageActions  emsgAction = new EmailMessageActions(sc);
        PageReference nextEmail = emsgAction.nextMsg();
        Test.stopTest();
        
    }
    
    @isTest
    static void testMethodWithNoPrevious(){
        String recTypeId = [Select Id from recordType where sobjectType = 'Case' and developername like '%consulting_case'].Id;
        
        Case c = New Case(Origin='Email', Status='New', Subject='Test Case');
        insert c;
        
        EmailMessage emsg = New EmailMessage(ParentId=c.Id, Subject='Test Email 2', HtmlBody='Test Email 2');
        insert emsg;
        
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(emsg);
        EmailMessageActions  emsgAction = new EmailMessageActions(sc);
        PageReference nextEmail = emsgAction.PreviousMsg();
        Test.stopTest();
        
    }
    
    

}