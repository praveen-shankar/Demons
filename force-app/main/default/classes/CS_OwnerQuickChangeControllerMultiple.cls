public with sharing class CS_OwnerQuickChangeControllerMultiple{

 private ApexPages.StandardSetController stdController;
        public List<Group> queues {get; set;}
        public List<User> users {get; set;}
        public Case c {get; set;}
        public Map<string, string> UserMap {get;set;}
        public integer Mapsize  {get;set;}
        public  List<Case> selectedCases {get;set;}

    public CS_OwnerQuickChangeControllerMultiple(ApexPages.StandardSetController controller) {
     this.stdController= controller;
                this.c = (Case) stdController.getRecord();
                queues = [ select Id, Name , DeveloperName from Group where Type='Queue' and (not DeveloperName  LIKE 'crm_%') order by Name]; //added order by clause to resolve incident E2-IM018578696
                users = [select Id, Name from User where (profile.name like'%KATS%' or profile.name like 'CS%'or profile.name like'%Admin' or profile.name in('CS Admin','System Administrator','CRM System Administrator','Kvalitetsbruker')) and isActive = true order by Name ];
                //users = [select Id, Name from User order by Name];
                UserMap = new Map<String,String>();
                for (User u : users ){
                         UserMap.put(u.name,u.id);
                    } 
                Mapsize  = UserMap.size();    

    }

  
        public String newOwnerId { set; get; }
        public Id ownerId { get; set; }
        
        public PageReference changeOwner() { for (Case c :selectedCases)
          
                c.OwnerId = ownerId;    update  selectedCases;   return stdController.save();   
        }        
         public PageReference getselectedCases()   {      selectedCases = (List<Case>) stdController.getSelected();      return null;        
    }
}