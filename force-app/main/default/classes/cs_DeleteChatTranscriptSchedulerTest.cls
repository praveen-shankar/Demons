@isTest
public class cs_DeleteChatTranscriptSchedulerTest {
    
    @isTest
    public static void testBatchSchedule(){
        
        Test.startTest();
            cs_DeleteChatTranscriptEventScheduler schedulable = new cs_DeleteChatTranscriptEventScheduler();
    
            String cronExp = '0 0 13 ? * 1'; 
            system.schedule('Delete Live Chat Transcripts', cronExp, schedulable);
        
        Test.stopTest();
    }
}