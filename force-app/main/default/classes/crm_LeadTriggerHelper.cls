public class crm_LeadTriggerHelper 
{
    public static void updatemarketingfields(List<Lead> leadList, Map<id, Lead> oldLeadMap)
    {
        for (Lead l: leadList) {
           Lead oldlead = oldLeadMap.get(l.id);
           
           if (l.crm_Has_declined_Marketing_activities__c!= oldlead.crm_Has_declined_Marketing_activities__c && l.crm_Has_declined_Marketing_activities__c){
               l.crm_Has_Agreed_to_Marketing_Activities__c= false;
               /*l.crm_Has_Agreed_to_Emai__c = false;
               l.crm_Has_Agreed_to_SMS__c=false;
               l.crm_Has_Agreed_to_MyBring__c=false;*/
               /*l.yes_to_insights_trends_and_analysis__c=false;
               l.yes_to_industry_and_service_development__c= false;*/
               
               l.Marketing_Activities_Agreed_To__c = null;
           
           }
           
            if (l.crm_Has_Agreed_to_Marketing_Activities__c!= oldlead.crm_Has_Agreed_to_Marketing_Activities__c&& l.crm_Has_Agreed_to_Marketing_Activities__c){
              l.crm_Has_declined_Marketing_activities__c= false;
            /*l.crm_Has_Agreed_to_Emai__c = true;   
              l.crm_Has_Agreed_to_SMS__c=true;
              l.crm_Has_Agreed_To_MyBring__c=true;  */
              /*l.yes_to_insights_trends_and_analysis__c=true; 
              l.yes_to_industry_and_service_development__c= true;*/
                
              l.Marketing_Activities_Agreed_To__c = 'Email;SMS;MyBring';
           
           }
         if((l.crm_Has_Agreed_to_Marketing_Activities__c) && (l.Marketing_Activities_Agreed_To__c == null)){
           /*l.crm_Has_Agreed_to_Emai__c = true; 
             l.crm_Has_Agreed_to_SMS__c=true;
             l.crm_Has_Agreed_To_MyBring__c=true; */
             /*l.yes_to_insights_trends_and_analysis__c=true; 
             l.yes_to_industry_and_service_development__c= true;*/
             
             l.Marketing_Activities_Agreed_To__c = 'Email;SMS;MyBring';
             
             } 
            
            if(!(oldlead.crm_Has_Agreed_to_Marketing_Activities__c)&&(l.crm_Has_Agreed_to_Marketing_Activities__c) && (l.Marketing_Activities_Agreed_To__c == null)){
           /*l.crm_Has_Agreed_to_Emai__c = true;  
             l.crm_Has_Agreed_to_SMS__c=true; 
             l.crm_Has_Agreed_To_MyBring__c = true; */
             /*l.yes_to_insights_trends_and_analysis__c=true; 
             l.yes_to_industry_and_service_development__c= true; */  
                
             l.Marketing_Activities_Agreed_To__c = 'Email;SMS;MyBring';
                
             }
            
            if((oldlead.crm_Has_Agreed_to_Marketing_Activities__c)&&(l.crm_Has_Agreed_to_Marketing_Activities__c) && (l.Marketing_Activities_Agreed_To__c == null))
              {
              //c.crm_Has_agreed_to_Marketing_actvities__c.addError('If agreed to Marketing activities,you must choose either Insight Trends & Analysis or Industry & service development');
                l.crm_Has_Agreed_to_Marketing_Activities__c= false;
                l.crm_Has_declined_Marketing_activities__c=true;
              }
                
          /*if((oldlead.crm_Has_Agreed_to_Marketing_Activities__c)&&(l.crm_Has_Agreed_to_Marketing_Activities__c) && ((l.yes_to_insights_trends_and_analysis__c ) || (l.yes_to_industry_and_service_development__c)) && l.Marketing_Activities_Agreed_To__c == null)
             {
               l.crm_Has_Agreed_to_Marketing_Activities__c.addError('If agreed to Marketing activities,you must choose atleast one of Email, SMS or MyBring');
             }*/
             
           if(l.crm_Has_declined_Marketing_activities__c) {
             /*l.crm_Has_Agreed_to_Emai__c = false; 
               l.crm_Has_Agreed_to_SMS__c=false; 
               l.crm_Has_Agreed_To_MyBring__c=false; */
               /*l.yes_to_insights_trends_and_analysis__c=false;
               l.yes_to_industry_and_service_development__c= false;*/
             
               l.Marketing_Activities_Agreed_To__c = null;
               
             }
                
        
        }
    
    }
    
      public static void updateWebsiteCountry(List<Lead> leadList)
    {
         System.debug('@@@' + leadList)   ; 
        for (Lead l: leadList) 
        {
            if(l.crm_website_country__c=='NO')
            { l.CurrencyIsoCode='NOK';
                l.preferred_Language__c='Norwegian';
               l.et4ae5__Mobile_Country_Code__c ='NO';
            } 
            System.debug('@@@' + l.crm_website_country__c)   ;
            if(l.crm_website_country__c=='SE')
            { l.CurrencyIsoCode='SEK';
               l.preferred_Language__c='Swedish';
                  l.et4ae5__Mobile_Country_Code__c ='SE';    
              }  
             if(l.crm_website_country__c=='DK')
            { l.CurrencyIsoCode='DKK';
               l.preferred_Language__c='Danish';
              l.et4ae5__Mobile_Country_Code__c ='DK';    
                }
                if(l.crm_website_country__c=='FI')
            { l.CurrencyIsoCode='EUR';
               l.preferred_Language__c='Finnish';
              l.et4ae5__Mobile_Country_Code__c ='FI';    
                } 
                 System.debug('@@@' + l)   ;  
                       
                }  
                
                 System.debug('@@@' + leadList)   ;  
    }
    
}