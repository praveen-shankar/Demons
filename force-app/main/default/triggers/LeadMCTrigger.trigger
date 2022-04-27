trigger LeadMCTrigger on Lead (after insert,after update) {
    
      try{ et4ae5.triggerUtility.automate('Lead');}catch(Exception e){if(Test.isRunningTest()){ return;} else{throw e; }}}