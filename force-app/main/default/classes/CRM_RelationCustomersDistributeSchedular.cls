/**********************************************************************
 Name: CRM_RelationCustomersDistributeSchedular 
======================================================
Req:

======================================================
Purpose:
This schedular of CRM_RelationCustomersDistributeBatch class 
======================================================
History
-------
VERSION  AUTHOR            DATE              DETAIL
   1.0 -  Vasudha Tandon    08/05/2020     Initial Development
***********************************************************************/
global class CRM_RelationCustomersDistributeSchedular implements Schedulable {

    global void execute(SchedulableContext sc) {
        
        
        CRM_RelationCustomersDistributeBatch  relationDistributeBatch = new CRM_RelationCustomersDistributeBatch (); 
        Database.executeBatch(relationDistributeBatch);
    }
   
}