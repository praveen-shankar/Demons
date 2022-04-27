public class CS_DeleteSelected {
 
    private ApexPages.StandardSetController stdController;
     public Case c {get; set;}
    public  List<Case> selectedCases {get;set;}
    
    public CS_DeleteSelected(ApexPages.StandardSetController controller) {
     this.stdController= controller;
                this.c = (Case) stdController.getRecord();
    }    
      
      public pageReference getselectedCases()
    {       
           selectedCases = (List<Case>) stdController.getSelected();
           System.debug('##'+ selectedCases.size() );
        Profile p = [select id,Name from Profile where id=:Userinfo.getProfileid()];
        system.debug('Profile name'+p.name);
        if(selectedCases.size()!=0)
        {
            if(p.Name=='System Administrator' || p.Name=='Systemadministrator' || p.Name == 'KATS System Administrator' || p.Name=='CS Admin')
            {
               delete  selectedCases;  return stdController.save();
            }
            else
            {
               system.debug('inside profile else');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.cs_Case_Delete_marked_cases1));   return null;    
            }
        }
        else
        {
           
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.cs_Case_Mark_cases_as_read1));  return null;  
        }
        
              //  return stdController.save(); 

      
            
    }

}