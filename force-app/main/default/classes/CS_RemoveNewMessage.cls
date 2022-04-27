public with sharing class CS_RemoveNewMessage {
    
    private ApexPages.StandardSetController stdController;
     public Case c {get; set;}
    public  List<Case> selectedCases {get;set;}
    
    public CS_RemoveNewMessage(ApexPages.StandardSetController controller) {
     this.stdController= controller;
                this.c = (Case) stdController.getRecord();
    }    
      
      public pageReference getselectedCases()
    {       
           selectedCases = (List<Case>) stdController.getSelected();
           System.debug('##'+ selectedCases.size() );
        if(selectedCases.size()!=0)
        {
            for (Case c :selectedCases)
                          c.unread_action__c =false;             update  selectedCases;  return stdController.save();
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