import { api, LightningElement, track } from 'lwc';

export default class SF_II_Services extends LightningElement {
  @api recordId;
    // @api  columns =[
    //     { fieldName: 'Id', type:'text', wrapText: true, hideDefaultActions: true },
    //     { fieldName: 'Name', type:'text', wrapText: true, hideDefaultActions: true }
    //     // { label: 'Last Name', fieldName: 'LastName',type:'text' },
    //     // { label: 'Email', fieldName: 'Email', type:'Email'}       
    // ];
// @api actualServiceName;
 @api serviceName;
 @api actualServiceId;
 @api activeSectionName;
 @api activeSectionSurcharge;
 @api makeArrayEmpty;
//  @track currentactiveSectionName=this.activeSectionName;
// @track progressValue=[];




// console.log(this.makeid(18));



@api handleMaximizeCounter() {
  this.template.querySelector("c-additional-services").makeArrayEmptyMethod();
  this.template.querySelector("c-configure-service").testActualServiceId();
}

@api handleActualServiceValue(){
 this.template.querySelector("c-configure-service").testActualServiceId();
}
  handleArray(){
    this.handleMaximizeCounter();
    this.handleActualServiceValue();
  }
 


  hanldeProgressValueChange(event) {
    // this.progressValue = event.detail;
    this.serviceName=event.detail;
    // JSON.stringify(this.progressValue);
  }

  handleserviceidchange(event){
this.actualServiceId=event.detail;
  }

  handleactivesection(event){
this.activeSectionName=event.detail;
  }
  handleactiveSectionSurcharge(event){
    this.activeSectionSurcharge=event.detail;
  }

   handleMakeArrayEmpty(event){
    const objChild = this.template.querySelector('c-additional-services');
    objChild.makeArrayEmptymethod();

    this.template.querySelector('c-configure-service').testActualServiceId();
  }
  
  // handleMakeArrayEmpty(event){
  //   this.addContact(this.event.detail);
  //   // this.template.querySelector('c-additional-services').makeArrayEmptymethod();
  //   // this.makeArrayEmpty=event.detail;
   
  // }

  // strContactName = '';
    
  // To call the child component method to add the Contact into the list.
  // addContact(event){
  //     const objChild = this.template.querySelector('c-additional-services');
  //     objChild.makeArrayEmptymethod();
  // }
// functiontest(){
// // console.log('actualserviceName from main component' +actualserviceName);
// console.log('actualserviceName from main component' +progressValue);
// }
// functiontest;
// showRecordId(){

//   console.log("recordId : "+ this.recordId);
// }


}