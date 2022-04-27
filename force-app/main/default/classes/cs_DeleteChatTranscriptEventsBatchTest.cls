@isTest
public class cs_DeleteChatTranscriptEventsBatchTest {
    
    @TestSetup
    public static void setupTestData(){
        List<Case> caseList = New List<Case>();
        List<LiveChatTranscript> chatTranscriptList = New  List<LiveChatTranscript>();
        List<LiveChatTranscriptEvent> chatTranscriptEventList = New  List<LiveChatTranscriptEvent>();
        
        Account a = New Account(Name='Test Account');
        insert a;
        
        for(integer i = 0; i<10; i++){
            Case c = New Case(Subject='Test Case'+i, AccountId=a.Id);
            caseList.add(c);
        }
        insert caseList;
        
        LiveChatVisitor chatVisitor = New LiveChatVisitor();
        insert chatVisitor;
        
        for(integer i = 0; i<10; i++){
            LiveChatTranscript lct = New LiveChatTranscript();
            lct.caseId = caseList[i].Id;
            lct.AccountId = a.Id;
            lct.LiveChatVisitorId = chatVisitor.Id;
            lct.requestTime = system.now();
            lct.EndTime = system.now().addMinutes(2);
            lct.Body = 'Test chat transcript';
            if(i==2 || i==5){
                lct.CreatedDate = system.now();
            }
            lct.CreatedDate = system.now().addDays(-35);
            chatTranscriptList.add(lct);
        }
        insert chatTranscriptList;
        
        for(LiveChatTranscript lct : chatTranscriptList){
            for(integer i=0; i<5; i++){
                LiveChatTranscriptEvent event = new LiveChatTranscriptEvent();
                event.LiveChatTranscriptId = lct.Id;
                event.Type = 'Other';
                event.Time = system.now().addDays(-35-i).addMinutes(i);
                event.CreatedDate = system.now().addDays(-35-i);
                chatTranscriptEventList.add(event);
            }
        }
        insert chatTranscriptEventList;

        
    }
    
    @isTest
    public static void testBatch(){
        Test.startTest();
            cs_DeleteChatTranscriptEventsBatch myBatchObject = new cs_DeleteChatTranscriptEventsBatch();
            Id batchId = Database.executeBatch(myBatchObject);
        Test.stopTest();
    }
}