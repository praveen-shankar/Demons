import { LightningElement,wire,api,track } from 'lwc';
import fetchProduct2Record from '@salesforce/apex/addServices.fetchProduct2Record';
export default class FinalCombinedAddService extends LightningElement {

     //<--Add Service Component Variable starts-->

     @api tabselectedapi;
     @track tabselected='';
     @wire(fetchProduct2Record,{tabselectedapi:'$tabselectedapi'}) wireProduct2;
 
     //<--Add Service component Variable Ends-->
 
 
 
     //<--Add Service Methods starts-->
 
     //handleTabData - this method wil be used to pass the values using event from Selected Tab and its content
 handleTabData(event){
 
     const tab = event.target;
          this.tabselected = `${event.target.value}`;
          this.tabselectedapi=JSON.stringify(this.tabselected);    
     }
 
 //Column Details will be stored in the below columns array
 @api  columns =[
     {label:'Name', fieldName: 'Name', type:'text', wrapText: true, hideDefaultActions: true },
     {label:'Service Group',  fieldName: 'crm_global_Service_Group__c',type:'text', wrapText: true, hideDefaultActions: true}
     // { label: 'Last Name', fieldName: 'LastName',type:'text' },
     // { label: 'Email', fieldName: 'Email', type:'Email'}       
 ];
 
 //<--Add Service Methods Ends-->
}