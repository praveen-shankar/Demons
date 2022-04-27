public class CS_duplicateShipmetParcel {

    private ApexPages.StandardController stdController;
    public Case c {get; set;}
    public Case caseobj {get;set;} 
    public  List<Case> selectedCases {get;set;}
    public boolean shipmentduplicate {get;set;}
    public boolean parcelduplicate {get;set;}
    
    public CS_duplicateShipmetParcel(ApexPages.StandardController controller) {
    this.stdController= controller;
    this.c = (Case) stdController.getRecord();
       caseobj =[Select Id,Shipment_number__c,Shipment_identification__c,casenumber From Case Where id =:c.Id];
        shipmentduplicate=false;
        parcelduplicate=false;
      
    }
    public pageReference validate()
    {
       String dupshipmentno= '';
       String dupshipmentidentno= '';
       
       if (caseobj.Shipment_number__c!=null) {
         selectedCases = [Select Id,Shipment_number__c,casenumber From Case where Shipment_number__c = : caseobj.Shipment_number__c and  id!=:caseobj.id and isclosed= false order by createddate desc limit 5];
          if (selectedCases !=null  && selectedCases.size()>0) {
            
             //duplicate cases found
             for (Case c:selectedCases ){               dupshipmentno = dupshipmentno + c.casenumber + ', ' ;             }
             if(dupshipmentno.length()>0)             dupshipmentno =   dupshipmentno.Substring(0,dupshipmentno.length()-2);
        }    
       }
       
       if(caseobj.Shipment_identification__c !=null) {
        selectedCases = [Select Id,Shipment_number__c,Shipment_identification__c,casenumber From Case where Shipment_identification__c = : caseobj.Shipment_identification__c and  id!=:caseobj.id  and isclosed= false order by createddate desc limit 5];
          if (selectedCases !=null  && selectedCases.size()>0) {
          for (Case c:selectedCases ){                dupshipmentidentno = dupshipmentidentno + c.casenumber + ', ' ;           }
             if(dupshipmentidentno.length()>0)          dupshipmentidentno =  dupshipmentidentno.Substring(0,dupshipmentidentno.length()-2);
          }
       
       }
       
         if(dupshipmentno.length()>0 && dupshipmentidentno.length()>0)
        {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.warning, System.Label.cs_Duplicate_parcelshipment_No + ' ' +  dupshipmentno +' <br/> ' 
             + System.label.cs_Duplicate_parcelshipment_No+  ' ' + dupshipmentidentno ));             return null;
            
        }
   
        if(dupshipmentno.length()>0)
        {
            system.debug('inside check 1');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.warning, System.Label.cs_Duplicate_shipment_no  + ' ' +  dupshipmentno ));             return null;
        }
        if(dupshipmentidentno.length()>0)
        {
            system.debug('inside check 2');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.warning, System.Label.cs_Duplicate_parcelshipment_No +  ' '  + dupshipmentidentno));                 return null; 
        }
        else
        {
             
        ApexPages.addmessage(new Apexpages.Message(ApexPages.Severity.Info, System.Label.cs_NoDuplicates));
       
        return null;      }
    }
    
  @AuraEnabled
 public static String checkDuplicatenumbers(String caseId) {
   List<Case> selectedCases = new List<Case>();
   
   
   Case caseobj= [Select Id,Shipment_number__c,Shipment_identification__c , casenumber From Case where id=:CaseId];
  
   String dupshipmentno= '', dupshipmentnofinal='';
       String dupshipmentidentno= '', dupshipmentidentnofinal='';
       
       if (caseobj.Shipment_number__c !=null) {
         selectedCases = [Select Id,Shipment_number__c,casenumber From Case where Shipment_number__c = :caseobj.Shipment_number__c  and  id!=:caseId and isclosed= false order by createddate desc limit 5];
          if (selectedCases !=null  && selectedCases.size()>0) {
            
             //duplicate cases found
             for (Case c:selectedCases ){                dupshipmentno = dupshipmentno + c.casenumber + ', ' ;
             }
             if(dupshipmentno.length()>0)              dupshipmentnofinal =  dupshipmentno.Substring(0,dupshipmentno.length()-2);
              System.debug('dupshipmentidentno' + dupshipmentidentno);
               System.debug('dupshipmentnofinal' + dupshipmentnofinal);
        }    
       }
       
       if(caseobj.Shipment_identification__c !=null) {
        selectedCases = [Select Id,Shipment_number__c,Shipment_identification__c,casenumber From Case where Shipment_identification__c = : caseobj.Shipment_identification__c and  id!=:caseId and isclosed= false order by createddate desc limit 5];
          if (selectedCases !=null  && selectedCases.size()>0) {
          for (Case c:selectedCases ){                dupshipmentidentno = dupshipmentidentno + c.casenumber + ', ' ;           }
             if(dupshipmentidentno.length()>0)             dupshipmentidentnofinal =  dupshipmentidentno.Substring(0,dupshipmentidentno.length()-2);
              
          }
       
       }
       
       String error= '';
   
        if(dupshipmentnofinal.length()>0 && dupshipmentidentnofinal.length()>0)       {       error= System.Label.cs_Duplicate_shipment_no + ' ' + dupshipmentnofinal;         error += '<br/>  ' + System.Label.cs_Duplicate_parcelshipment_No+' ' + dupshipmentidentnofinal ;
            
        }
        else if(dupshipmentnofinal.length()>0)      {        error= System.Label.cs_Duplicate_parcelshipment_No+ ' ' + dupshipmentnofinal;
        }
        else if(dupshipmentidentnofinal.length()>0)      {        error= System.Label.cs_Duplicate_parcelshipment_No +' ' + dupshipmentidentnofinal;       }
        else {
        error=System.Label.cs_NoDuplicates;
        
        }
        system.debug('##' + error);
        
         return error;
   } 
    
}