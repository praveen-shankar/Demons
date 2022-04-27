/*
Created by :Supriya Goel
Date: 16th nov 2016
delete opportunity if no agreement is linked

*/

global class crm_deleteOpportunity
{
    public Opportunity opp{get;set;}
    
    public crm_deleteOpportunity(ApexPages.StandardController stdController){
        this.opp= (Opportunity)stdController.getRecord();
    }
  
    
    public Pagereference deleteOpportunity() // you can pass parameters
    { 
        Opportunity opptodelete =[Select id, name,accountid, crm_Agreement__c  from Opportunity  where id =:opp.id];
        if(opptodelete.crm_Agreement__c !=null)
        {
         return new Pagereference('/apex/crm_Opp_Cannot_be_Deleted?opp='+opp.Id);
        
        }
        else {
        Id Accountid= opptodelete.Accountid;
        try{
               Database.delete(opp);
            
                    } catch(Exception e) { crm_Exception_handler.createExceptionRecords(e);}   
                    
                       return new Pagereference('/'+Accountid );
        }
    
    }
    
  }