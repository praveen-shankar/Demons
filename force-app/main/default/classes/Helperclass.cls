public class Helperclass {
    @future(callout=true)
    public static void updateEmailToCase(List<id> newCasesList){
    list<Case> updatecases = new list<Case>();   
        list<Case> cases = [SELECT id,
                     Email__c,
                     PostNumber__c
                  FROM Case 
                 WHERE id in :newCasesList] ;
        
        for( case c : cases){
        System.debug('~~Postal Number::'+c.PostNumber__c);
            String result = '';
            result = Callout.getEmail(c.PostNumber__c);
            if(String.isNotBlank(result)){
                c.EnhetsNumber__c = result.split(',')[0];
                c.Unit_Name__c =  result.split(',')[1];   
                c.Email__c = result.split(',')[2];
                c.flag__c = true;
                System.debug('~~~EnhetsNumber__c'+c.EnhetsNumber__c );
                System.debug('~~~Navn__c'+c.Unit_Name__c );
                System.debug('~~~email'+c.Email__c );
                System.debug('~~~flag__c'+c.flag__c);
                updatecases.add(c);
            }
            else{                
                System.debug('Exception - Postal Number is blank');
            }
        }
        if(updatecases.size()>0){
        update updatecases;
        }    
    }

}