/*
Created by :Supriya Goel
Date:cs phase 2
create case from lead

*/

global class cs_leadtocase{
public lead leadobj{get;set;}

    public List<SelectOption> records { get; set; }
    public List<SelectOption> ServiceGroup{ get; set; }
    public List<SelectOption> Queues{ get; set; }
    public String selectedrecord{ get; set; }
    public String selectedservicegroup{ get; set; }
     public String selectedqueue{ get; set; }
    
   
    public boolean error{get;set;}
    
    public String  Casenumber{ get; set; }
    public Boolean Casecreated{ get; set; }
    public Boolean Caseidnull{ get; set; }
    public Boolean cannotbeconverted{get;set;}
    
    public cs_leadtocase(ApexPages.StandardController stdController){
        this.leadobj= (lead)stdController.getRecord();
        Casecreated=false;
        Caseidnull=true;
        cannotbeconverted=false;
        error=false;
          
        Lead Leadobj=[Select id,AnnualRevenue,city,cs_case_Id__c, cs_Case_Detail__c,country,state, street,PostalCode, email, phone, name,fax, Industry, Leadsource,MobilePhone,Title, company,crm_Campaign__c, crm_organization_number__c,  status ,  rating,website, crm_website_country__c, crm_Customer_s_Website__c, description from lead where id =:this.leadobj.id];
        if(Leadobj.cs_case_Id__c!=null ) {
            Caseidnull=false;
            Case tempobj=[Select casenumber from case where id=:leadobj.cs_case_Id__c];
            casenumber=tempobj.casenumber;
        }
        
        if(Leadobj.cs_Case_Detail__c!=null){
        //this is a lead converted from case
         cannotbeconverted=true;
        }
        if(Caseidnull){
        
          this.records= new List<SelectOption>();
          records.add(new SelectOption('complaint',System.Label.cs_RecordTypeComplaints));
          records.add(new SelectOption('simple_inquiry',System.Label.cs_RecordtypeConsulting));
          
          this.ServiceGroup= new List<SelectOption>();
          
          ServiceGroup.add(new SelectOption('None','None'));
          /*
          ServiceGroup.add(new SelectOption('Post','Post'));
          ServiceGroup.add(new SelectOption('Warehousing','Warehousing'));
          ServiceGroup.add(new SelectOption('Cargo','Cargo'));
          ServiceGroup.add(new SelectOption('Citymail','Citymail'));
          ServiceGroup.add(new SelectOption('Dialog','Dialog'));
          ServiceGroup.add(new SelectOption('Express','Express'));
          ServiceGroup.add(new SelectOption('Frigo','Frigo'));
          ServiceGroup.add(new SelectOption('Mail Nordic','Mail Nordic'));
          ServiceGroup.add(new SelectOption('Parcels – Domestic Norway','Parcels – Domestic Norway'));
          ServiceGroup.add(new SelectOption('Parcels','Parcels'));
          ServiceGroup.add(new SelectOption('Home Delivery','Home Delivery'));
          
          */
          
          Schema.DescribeFieldResult fieldResult =  Opportunity.crm_Opp_Service_Group__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            //options.put(f.getLabel(), f.getValue());
            //new SelectOption(value, label, isDisabled);
            //ServiceGroup.add(new SelectOption(f.getLabel(), f.getValue())); 
            ServiceGroup.add(new SelectOption(f.getValue(),f.getLabel())); 
        }  
          
           this.queues= new List<SelectOption>();
             List<Lead_to_case_queue_details__c> queueNames = Lead_to_case_queue_details__c.getall().values(); 
              queueNames.sort(); 
          for (Lead_to_case_queue_details__c q:queueNames)
          {
            
          queues.add(new SelectOption(q.name,q.name));
          
           if(q.Default__c == true)
          selectedqueue = q.name;
          
          }
          
          
          /* queues.add(new SelectOption('Logistikk booking','Logistikk booking'));
           queues.add(new SelectOption('SMB Mybring','SMB Mybring'));
           queues.add(new SelectOption('SMB Kundeservice','SMB Kundeservice'));
           queues.add(new SelectOption('Privat Kundeservice','Privat Kundeservice'));*/
          
         
        }  
 
 }
    
    

public void saveCase() {


Lead Leadobj=[Select id,AnnualRevenue,city,cs_case_Id__c, cs_Lead_Converted__c, country,state, street,PostalCode, email, phone, name,fax, Industry, Leadsource,MobilePhone,Title, company,crm_Campaign__c, crm_organization_number__c, crm_Customer_Requirement__c, status ,  rating,website, crm_website_country__c, crm_Customer_s_Website__c, description from lead where id =:this.leadobj.id];
   
    String recordTypeId;
    Case caseobj= new Case();
    
    System.debug('@@@'+selectedrecord );
    if (selectedrecord =='complaint')
        caseobj.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.cs_RecordTypeComplaints).getRecordTypeId();
        else
        caseobj.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.cs_RecordtypeConsulting).getRecordTypeId();
        
    if(selectedservicegroup!='None')
     caseobj.Product_global_Service_Group__c=selectedservicegroup;
     
     
     caseobj.cs_queue__c=selectedqueue;
        
     caseobj.origin='Lead to Case';
     caseobj.status='New';
     
     
     if(leadobj.Email!=null)
         caseobj.SuppliedEmail=leadobj.email;
         
     if(leadobj.phone!=null)
         caseobj.SuppliedPhone=leadobj.phone;
         
     if(leadobj.name!=null)
         caseobj.SuppliedName=leadobj.name;
         
    caseobj.description='';     
         
    if(leadobj.AnnualRevenue!=null)
     caseobj.description='\n AnnualRevenue:'+ leadobj.AnnualRevenue;
     
     if(leadobj.city!=null)
     caseobj.description +='\n City:'+ leadobj.City;
     
     if(leadobj.country!=null)
     caseobj.description+='\n Country:'+ leadobj.country;
     
     if(leadobj.state!=null)
     caseobj.description+='\n State:'+ leadobj.state;
     
     if(leadobj.street!=null)
     caseobj.description+='\n Street:'+ leadobj.street;
     
     if(leadobj.PostalCode!=null)
     caseobj.description+='\n PostalCode:'+ leadobj.PostalCode;
     
     if(leadobj.fax!=null)
     caseobj.description+='\n Fax:'+ leadobj.fax;
     
    // if(leadobj.AnnualRevenue!=null)
   //  caseobj.description+=' AnnualRevenue:'+ leadobj.AnnualRevenue;
     
     if(leadobj.Industry!=null)
     caseobj.description+='\n Industry:'+ leadobj.Industry;
     
     if(leadobj.LeadSource!=null)
     caseobj.description+='\n LeadSource:'+ leadobj.LeadSource;
         
    if(leadobj.Company!=null)
     caseobj.description+='\n Company:'+ leadobj.Company;
     
     if(leadobj.MobilePhone!=null)
     {
     caseobj.description+='\n MobilePhone:'+ leadobj.MobilePhone;
     caseobj.SuppliedPhone = leadobj.MobilePhone;
     }
     
     if(leadobj.crm_organization_number__c!=null)
     caseobj.description+='\n Organization number:'+ leadobj.crm_organization_number__c;
     
     if(leadobj.crm_Campaign__c!=null)
     caseobj.description+='\n Campaign:'+ leadobj.crm_Campaign__c;
     
     if(leadobj.crm_Customer_Requirement__c!=null)
     caseobj.description+='\n Customer Requirement:'+ leadobj.crm_Customer_Requirement__c;
     
     if(leadobj.status!=null)
     caseobj.description+='\n Status:'+ leadobj.status;
     
     if(leadobj.Title!=null)
     caseobj.description+='\n Title:'+ leadobj.Title;
     
     //if(this.leadobj.category!=null)
    // caseobj.description+=' Category:'+ this.leadobj.category;
     
     if(leadobj.rating!=null)
     caseobj.description +='\n Rating:'+ leadobj.Rating;
     
      if(leadobj.Website!=null)
     caseobj.description+='\n Website:'+ leadobj.Website;
     
      if(leadobj.crm_website_country__c!=null)
     caseobj.description+='\n Website country:'+ leadobj.crm_website_country__c;
     
      if(leadobj.crm_Customer_s_Website__c!=null)
     caseobj.description+='\n Posten Website:'+ leadobj.crm_Customer_s_Website__c;
     
      if(leadobj.description!=null)
     caseobj.description+='\n Description:'+ leadobj.description;
     
     caseobj.cs_Lead_Detail__c=System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+leadobj.Id;
     Database.DMLOptions dmo = new Database.DMLOptions();
    dmo.assignmentRuleHeader.useDefaultRule= true;    
 
 

    try{
                    caseobj.setOptions(dmo);
                    
                    System.debug('###lead to case '+ caseObj);
                    insert caseobj;
                    Casecreated=true;
                   
                }catch(Exception e) {crm_Exception_handler.createExceptionRecords(e); }  
        System.debug('@@@'+caseobj);
        
        Case tempobj=[Select casenumber from case where id=:caseobj.id];
        leadobj.cs_case_Id__c= caseobj.id;
        leadobj.cs_Lead_Converted__c='Lead converted to Case';
        casenumber=tempobj.casenumber;
        
          try{
                    update leadobj;
             }catch(Exception e) {crm_Exception_handler.createExceptionRecords(e); }  
         
                
            
       
  
  }



}