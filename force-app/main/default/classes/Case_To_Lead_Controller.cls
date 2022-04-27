public with sharing class Case_To_Lead_Controller{ 

    public CaseDetails caseDetail { get; set; }
    public String test { get; set; }
    
       public Case_To_Lead_Controller(ApexPages.StandardController controller) {
        String id = ApexPages.currentPage().getParameters().get('id');
        test = id;
                if(id!=null && id!=''){
       /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        Case c = [SELECT 
                        Service_Product__r.Name,
                        Code_Event__r.name,
                        Code_Reason1__r.name,
                        Code_Reason2__r.name,
                        description,
                        Account.Name,
                        Account.party_number__c,
                        Account.crm_Organization_number__c,
                        Account.crm_Party_level_Account__c,
                        Contact.Name,
                        SuppliedPhone,
                        SuppliedEmail
                        FROM Case
                    WHERE id = :id LIMIT 1];
        caseDetail = new CaseDetails(c);
    }
}
    
    public class CaseDetails {
        public Case myCase { get; set; }
        public String description {get; set;}
        public String produkt { get; set; }
        public String category { get; set; }
        public String reason { get; set; }
        public String reason2 {get; set;}        
        public String accountName { get; set; }
        public String accountPartyNumber { get; set; }
        public String contactName { get; set; }
        public String contactPhone{ get; set; }
        public String contactEmail{ get; set; }
        public String suppliedPhone{ get; set; }
        public String suppliedEmail{ get; set; }
        public String partyLevelAccount {get; set;}
        public String orgNumber{get; set;}
        


        public CaseDetails(Case c) {
            myCase = c;
            

            if(!KATSutilities.isEmpty(c.Code_Event__r.name))        {this.category = c.Code_Event__r.name; }
            if(!KATSutilities.isEmpty(c.Code_Reason1__r.name))      {this.reason = c.Code_Reason1__r.name; }
            if(c.Code_Reason2__c != null)                           {this.reason2 = c.Code_Reason2__r.name; }
            if(!KATSutilities.isEmpty(c.Service_Product__r.Name))   {this.produkt = c.Service_Product__r.Name; }/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
            if(!KATSutilities.isEmpty(c.description))               {this.description = c.description; }
            if(!KATSutilities.isEmpty(c.Account.party_number__c))   {this.accountPartyNumber = c.Account.party_number__c; }
            if(!KATSutilities.isEmpty(c.Account.Name))              {this.accountName = c.Account.Name; }
            if(!KATSutilities.isEmpty(c.Contact.Name))              {this.contactName = c.Contact.Name; }
            if(!KATSutilities.isEmpty(c.suppliedPhone))             {this.suppliedPhone = c.suppliedPhone; }
            if(!KATSutilities.isEmpty(c.suppliedEmail))             {this.suppliedEmail= c.suppliedEmail; } 
            if(!KATSutilities.isEmpty(c.Account.crm_Party_level_Account__c))         {this.partyLevelAccount= c.Account.crm_Party_level_Account__c; }
            if(!KATSutilities.isEmpty(c.Account.crm_Organization_number__c))                 {this.orgNumber= c.Account.crm_Organization_number__c; }          
            
            
            
                        }
                }
        }