public class AccountContactRelationTriggerHelper{
    
     public static void checkContactLevel(List< AccountContactRelation > triggerNewlist) {
     Set<Id> Accountids= new Set<Id>();
         
     for (AccountContactRelation obj :triggerNewlist)
        Accountids.add(obj.accountid);
        
          
       setprimarycontact (Accountids);

} 


    public static void setprimarycontact(Set<id> Accountids )
    {
      Map<id, Id> DecisionmakerMap= new Map<Id,Id>();
     Map<id, Id> InfluencerMap= new Map<Id,Id>();
     Map<id, Id> ContactUserMap= new Map<Id,Id>();
     Map<id, Id> ContactBlankMap= new Map<Id,Id>();
     Map<id, Id> ContactMap= new Map<Id,Id>();  
     
     System.debug('###Accountids  '+ Accountids ) ;
      crm_AccountRecordTypes__c rTParty= crm_AccountRecordTypes__c.getValues('Party level Customer');
      //  Id PartyLevelRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTParty.crm_Record_Type_Label__c).getRecordTypeId();
      RecordType PartyLevelRecordType= [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'crm_Party_level_Customer'];
     
     
     List<AccountContactRelation > AccountContactRelationlist =[Select id ,contactid, contact.status__c, account.name , contact.name , contact.crm_functional_decision_level__c  from AccountContactRelation where accountid in : Accountids and contact.status__c ='Aktiv' and contact.email!=null  and contact.crm_Contact_Type__c ='Sales' and account.recordtypeid=:PartyLevelRecordType.id order by createddate desc];
     
     
       System.debug('###AccountContactRelationlist '+ AccountContactRelationlist ) ;
      List<AccountcontactrelationCustom__c> listtodelete= [Select id, Accountid__c from  AccountcontactrelationCustom__c where Accountid__c in :Accountids];
      if(listtodelete.size()>0)
        delete listtodelete;
     
      List<AccountcontactrelationCustom__c> listtoadd = new List<AccountcontactrelationCustom__c>();
     
     for (AccountContactRelation  c:  AccountContactRelationlist ){
      AccountcontactrelationCustom__c obj= new AccountcontactrelationCustom__c();
      
       if(c.contact.crm_functional_decision_level__c == 'Decision maker'){
            if(!DecisionmakerMap.containskey(c.accountid)){
                 DecisionmakerMap.put(c.accountid, c.contactid);
                
                 for (Integer i = 0; i < listtoadd.size(); i++) {
                if (listtoadd.get(i).Accountid__c == c.accountid){
                    listtoadd.remove(i);
                    
                    }
               }
                }
               
                obj.Accountid__c=c.accountid;
                obj.Contactid__c= c.contactid;
                obj.Functional_Decision_level__c ='Descision Maker';
                listtoadd.add(obj);
            }
            
         
        if(c.contact.crm_functional_decision_level__c == 'Influencer'){
        
       
            if(!InfluencerMap.containskey(c.accountid) &&  !DecisionmakerMap.containskey(c.accountid)) {
                InfluencerMap.put(c.accountid, c.contactid);
                for (Integer i = 0; i < listtoadd.size(); i++) {
                if (listtoadd.get(i).Accountid__c == c.accountid){
                    listtoadd.remove(i);
                    
                    }
               }
                }
                if(!DecisionmakerMap.containskey(c.accountid)){
                obj.Accountid__c=c.accountid;
                obj.Contactid__c= c.contactid;
                obj.Functional_Decision_level__c ='Influencer';
                listtoadd.add(obj);
                 }
                
                
            
        }   
         
        if(c.contact.crm_functional_decision_level__c == 'User'){
            if(!ContactUserMap.containskey(c.accountid) && !InfluencerMap.containskey(c.accountid) && !DecisionmakerMap.containskey(c.accountid) ){
                ContactUserMap.put(c.accountid, c.contactid);
                }
                if(!InfluencerMap.containskey(c.accountid) && !DecisionmakerMap.containskey(c.accountid) ){
                obj.Accountid__c=c.accountid;
                obj.Contactid__c= c.contactid;
                obj.Functional_Decision_level__c ='User';
                listtoadd.add(obj);
            }
        }  
        
           if(c.contact.crm_functional_decision_level__c == '' || c.contact.crm_functional_decision_level__c == null){
            if(!ContactUserMap.containskey(c.accountid) && !InfluencerMap.containskey(c.accountid) && !DecisionmakerMap.containskey(c.accountid) && !ContactBlankMap.containskey(c.accountid)){
                ContactBlankMap.put(c.accountid, c.contactid);
                }
                if(!InfluencerMap.containskey(c.accountid) && !DecisionmakerMap.containskey(c.accountid) && !ContactUserMap.containskey(c.accountid)){
                obj.Accountid__c=c.accountid;
                obj.Contactid__c= c.contactid;
                obj.Functional_Decision_level__c ='';
                listtoadd.add(obj);
            }
        }    
        
        if(!ContactMap.containskey(c.accountid))
                ContactMap.put(c.accountid, c.contactid);
     
     }//end of for
     
     
     system.debug('## InfluencerMap '+  InfluencerMap );
     system.debug('## DecisionmakerMap ' + DecisionmakerMap);
     system.debug('## ContactUserMap' + ContactUserMap);
     system.debug('## ContactMap'+  ContactMap);
     
     //insert list
     
      if(listtoadd.size()>0)
            insert  listtoadd ;
            
            Map<Id, Integer> AggresultsMap = new Map<Id, Integer>();
            
      list<AggregateResult> AggregateResultList=[select Accountid__c,count(id)total  from AccountcontactrelationCustom__c    group by Accountid__c having count(id) >5]; 
    if(AggregateResultList!= null && AggregateResultList.size() > 0){ 
        for(AggregateResult agg:AggregateResultList){ 
           if(!AggresultsMap.containskey((id)agg.get('Accountid__c')))
               AggresultsMap.put((id)agg.get('Accountid__c'), (Integer)agg.get('total'));
        }  
    }      
     //aggregate a1, 6, a1 9 
     
   List<Account> acclist =[Select id,  Primary_contact__c, Warrants_Postage__c  from account where id in :ContactMap.keyset()];
     for (Account a : acclist){
         
          if(DecisionmakerMap.containskey(a.id)){
            a.Primary_contact__c= DecisionmakerMap.get(a.id);
            if(AggresultsMap.containskey(a.id))
                a.Warrants_Postage__c= true;
             else
                a.Warrants_Postage__c = false;
           
            }
        else if(InfluencerMap.containskey(a.id)){
            a.Primary_contact__c= InfluencerMap.get(a.id);
             if(AggresultsMap.containskey(a.id))
                a.Warrants_Postage__c= true;
             else
                a.Warrants_Postage__c = false;
           
            }
       
          
     else   if(ContactUserMap.containskey(a.id)){
            a.Primary_contact__c= ContactUserMap.get(a.id);
             if(AggresultsMap.containskey(a.id))
                a.Warrants_Postage__c= true;
             else
                a.Warrants_Postage__c = false;
            }
            
       else if(ContactBlankMap.containskey(a.id)){
            a.Primary_contact__c= ContactBlankMap.get(a.id);
           
             a.Warrants_Postage__c = true;
           if(AggresultsMap.containskey(a.id))
                a.Warrants_Postage__c= true;
             else
                a.Warrants_Postage__c = false;
          
            }        
            
     else   if(ContactMap.containskey(a.id)){
            a.Primary_contact__c= ContactMap.get(a.id);
             a.Warrants_Postage__c = true;
          
            }
       
     
     }
       update  acclist;
      
            
            //select count() 
            

}
}