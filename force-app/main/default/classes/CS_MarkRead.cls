public with sharing class CS_MarkRead {
    
    private ApexPages.StandardSetController stdController;
     public Case c {get; set;}
    public  List<Case> selectedCases {get;set;}
    
    public CS_MarkRead (ApexPages.StandardSetController controller) {
     this.stdController= controller;
                this.c = (Case) stdController.getRecord();
    }    
      
      public pageReference getselectedCases()
    {       
           selectedCases = (List<Case>) stdController.getSelected();
           System.debug('##'+ selectedCases.size() );
        if(selectedCases.size()!=0)
        {
          for (Case updateRec :selectedCases){     updateRec.unread_action__c = false;       updateRec.case_new_Comment__c = false;    updateRec.hidden_preview_email__c = null;
        }
                update  selectedCases;
          return stdController.save();
        }
        else
        {
            system.debug('inside else');
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 
          System.Label.cs_Case_Mark_cases_as_read1)); 
              return null;  
        }
        
              //  return stdController.save(); 

      
            
    }

}