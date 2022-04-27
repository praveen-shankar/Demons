//Controller used for the AutoComplete Enhancement

public with sharing class PostalUnit_AutoCompleteController{

    //Constructors
    
    public PostalUnit_AutoCompleteController() {system.debug('CONSTRUCTOR');}
    
    //public PostalUnit_AutoCompleteController(ApexPages.StandardController controller) {system.debug('CONSTRUCTOR WITH STANDARD CONTROLLER');}

    //Attributes
    
    private List<String> resultsname = new List<String>();
    private Boolean hasparams = false;
    private Boolean hasnoresults = false;
        
    //Getters and Setters
    
    public Boolean getHasparams(){
        system.debug('HAS PARAMETERS -> ' + hasparams);
        return hasparams;
        
    }
    
    public void clearValues(){
        
        hasparams = false;
        
    }
    
    public Boolean getHasnoresults(){
        system.debug('HAS NO RESULT -> ' + hasnoresults);
        return hasnoresults;    
    }

    public void avoidRefresh(){
        system.debug('AVOID REFRESH');
    }
    
     public PageReference searchSuggestions() {
        system.debug('START SEARCH');
        //Initalize variables, hasparams just indicates that a search has started
        resultsname.clear();   
        hasparams = true;
        hasnoresults = false;

        //Obtain current parameters
        //String sobjectname = System.currentPageReference().getParameters().get('objectname');
        String stext = '%'+String.escapeSingleQuotes(System.currentPageReference().getParameters().get('aname').trim())+'%';
        
        //Limit Suggestions to 10 Results
        Integer iLimit = 10;
        
     //Validate if there's an input and get results
     
     if(stext.length() > 2){

        try{
            List<String> names = new List<String>();
            List<Distribution_Types_Lightuser__c> listOfTypes = [SELECT value__c FROM Distribution_Types_Lightuser__c WHERE Available_Lightuser__c = true];
            
            if(!listOfTypes.isEmpty()) {
                for(Distribution_Types_Lightuser__c dist : listOfTypes) {
                    names.add(dist.value__c);
                }
            }
            
              String sql = 'select name from PostalUnit__c where name like \''+stext+'\'limit '+ iLimit;
                    system.debug('QUERY -> ' + sql);
                    for(sobject x : Database.query(sql)){
                        
                        String s  = String.escapeSingleQuotes(((String)(x.get('name'))));
                        resultsname.add(s); 
                    }
        system.debug('RESULTS -> ' + resultsname);
            
        }catch(Exception e){
            
            resultsname.add('En feil oppsto, prøv igjen');  
        }


     }
       return null;
  }
  
      
      
     public List<String> getResultsname(){
          //Make sure to clear past values
          clearValues();
          if(resultsname.isEmpty()){
            system.debug('RESULTS -> EMPTY');
            hasnoresults = true;
            resultsname.add('Ingen resultat');
          }
          system.debug('RESULTS -> CONTAINS VALUES');
          return resultsname;
      }
 


}