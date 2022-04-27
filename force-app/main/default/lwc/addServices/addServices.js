import { LightningElement, wire,api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//Experimental for Scroll
// import wireCall from '@salesforce/apex/addServices.wireCall';
//Experimental for scroll
// import fetchProduct2Record from '@salesforce/apex/addServices.fetchProduct2Record';
import fetchProduct2Record from '@salesforce/apex/addServices.fetchProduct2Record';
// import imperativeCall from '@salesforce/apex/addServices.imperativeCall';
// import deleteMultipleProduct2Record from '@salesforce/apex/addServices.deleteMultipleProduct2Record';
import { refreshApex } from '@salesforce/apex';
import IsExtIndicatorVisible from '@salesforce/schema/User.IsExtIndicatorVisible';
import Name from '@salesforce/schema/Account.Name';
import { getPicklistValues, getPicklistValuesByRecordType, getObjectInfo } from 'lightning/uiObjectInfoApi';
import PRODUCT_OBJECT from '@salesforce/schema/Product2';
import SF_II_ServiceType__c from '@salesforce/schema/Product2.SF_II_ServiceType__c';
import getPickListValuesIntoListJs from '@salesforce/apex/addServices.getPickListValuesIntoList';
// import PRODUCT_SOURCE from '@salesforce/schema/Account.Product2';
// import {ShowToastEvent} from 'lightning/platformShowToastEvent';


const  columns =[
    {label:'Name', fieldName: 'Name', type:'text', wrapText: true, hideDefaultActions: true },
    {label:'Service Group',  fieldName: 'crm_global_Service_Group__c',type:'text', wrapText: true, hideDefaultActions: true}
    // { label: 'Last Name', fieldName: 'LastName',type:'text' },
    // { label: 'Email', fieldName: 'Email', type:'Email'}       
];

var numberOfRecordsnew=10;
export default class AddServices extends LightningElement {

//Column Details will be stored in the below columns array
     

        @track errorMsg;
        @track tabselected='';
        // loadMoreStatus;
        // @wire(fetchProduct2Record,{tabselectedinjs: '$tabselectedapi'}) wireProduct2;
        // @api progressValue =[];
        @api selectedProduct2IdList=[];
        @api tabselectedapi;
        
        @api serviceName;
        @api actualserviceId;
        @api activeSectioName;
        @api activeSectioNSurcharge;
        @api makeArrayEmpty;
        @api grouplineItemId;
@api searchKey;
        // @wire(fetchProduct2Record,{tabselectedapi:'$tabselectedapi'}) wireProduct2;

//For Data Table Search Functionality starts
@api AllProducts;
@wire(fetchProduct2Record,{tabselectedapi:'$tabselectedapi',searchKey:'$searchKey'}) wireProduct2(wireResult) {
       
    const { data, error } = wireResult;
    // this._wiredMarketData = wireResult;
    this._wiredProduct2Data=wireResult;
       
        if (data) {
    // fetchProductConfig({recordId:this.recordId,actualServiceId:this.actualServiceIdmain}).then(result=>{


        this.AllProducts=data;
        // Console.log('this.AddServData'+JSON.stringify(this.AddServData));
        // this.ActualServiceId=this.ActualServiceData[0].Id;
        // this.ActualServiceDataName=this.ActualServiceData[0].Name;
    
        console.log('Inside Combined Service---->>>>'+' this.AllProducts)--> '+JSON.stringify(this.AllProducts));
    }else if (error) {
            // handle error
            console.error('830549 ERROR => '+ error);
            window.alert('No Configuration Service avaiable for selected Actual Service Please contact your system admin if you have already added: ' + JSON.stringify(this.error));
 
        }
    };
//For Data Table Search functionality ends







@track picklistData=[];
@track picklistDatamodified=[];

        @wire(getPickListValuesIntoListJs) getPickListValuesIntoListJs({data, error}){
                if(data){
                    console.log('Picklist Values'+JSON.stringify(data));
                    this.picklistData=JSON.parse(JSON.stringify(data));
                    if(data!=undefined){
                    // var temparr= this.picklistData; 
                    // var temparr= JSON.parse(JSON.stringify(this.picklistData));  
                    // temparr.splice(0,0,"All");
                    this.picklistData.splice(0,0,"All");
                    console.log(' this.picklistData'+ this.picklistData+'-normal -'+JSON.stringify( this.picklistData));
                    // console.log('temparr.join()'+temparr.join()+'temparr'+JSON.stringify(temparr)+' '+temparr);
                }
                    // colors.splice(index, 0, "white"); 
                    // console.log('picklistData'+JSON.stringify(this.picklistData)+' '+this.picklistData);
                    // console.log(' Picklist Values ', data.picklistFieldValues.SF_II_ServiceType__c.values);
                    // this.pickListvaluesByRecordType = data.picklistFieldValues.SF_II_ServiceType__c.values;
                    // this.accountsource = data.picklistFieldValues.AccountSource.values;
                    
                    var j=1;
                    for(var i=0;i<this.picklistData.length;i++){   
                        const picklistval=new Object();                      
                        picklistval.Id=j;
                        picklistval.Tab=this.picklistData[i];

                        this.picklistDatamodified.push(picklistval);
                        j++;
                    }
                    console.log('this.picklistDatamodified '+this.picklistDatamodified);
                    console.log('this.picklistDatamodified JSON '+JSON.stringify(this.picklistDatamodified));
                }
                if(error){
                    console.log('error picklist value'+JSON.stringify(error));
                
                }
            };


//Experimental starts

    // maxRows=1000;
    // tableElement;
    // @track dataRow; 
    // @track totalRecords;
    columns = columns;

    //Code for dynamic fetching
    @track pickListvalues;
    @track error;
    @track values;
    @track pickListvaluesByRecordType;
    @track accountsource;

    // @wire(getPicklistValuesByRecordType, {
    //     recordTypeId : '0127a000001CAxDAAW',
    //     objectApiName : SF_II_ServiceType__c
    // })
    // wiredRecordtypeValues({data, error}){
    //     if(data){
    //         // console.log('Picklist Values'+data.picklistFieldValues);
    //         console.log(' Picklist Values ', data.picklistFieldValues.SF_II_ServiceType__c.values);
    //         this.pickListvaluesByRecordType = data.picklistFieldValues.SF_II_ServiceType__c.values;
    //         // this.accountsource = data.picklistFieldValues.AccountSource.values;
    //     }
    //     if(error){
    //         console.log('error picklist value'+JSON.stringify(error));
        
    //     }

        
    // }
    // @wire(getObjectInfo,{
    //     objectApiName : PRODUCT_OBJECT
    // })
    //     wiredObject({data, error}){
    //         if(data){
    //             console.log(' Object iformation ', data);
    //             console.table(data);
    //         }
    //         if(error){
    //             console.log(error);
    //         }
    //     }
    //Code for dynamic fetching
    // @api numberOfRecords=10;
    
    //Imperative Call starts
    // connectedCallback() {
    //     imperativeCall( {tabselectedapi:this.tabselectedapi,recToReturn :this.numberOfRecords} )
    //     .then((data) => {
    //         this.dataRow = data;
    //         this.totalRecords = data.length;
    //         console.log('Server call made'); 
    //     }
    // );
    // }

    // loadMoreData(event) {
    //     console.log('Load more JS made');
    //     //Display a spinner to signal that data is being loaded
    //     if(event.target){
    //         event.target.isLoading = true;
    //     }
    //     this.tableElement = event.target;
    //     //Display "Loading" when more data is being loaded
    //     this.loadMoreStatus = 'Loading';
    //     this.numberOfRecords=this.numberOfRecords+10;
    //     imperativeCall( {tabselectedapi:this.tabselectedapi,recToReturn:this.numberOfRecords} )
    //         .then((data) => {
    //             console.log('Load more Call made');  
    //                 const currentData = this.dataRow;
    //                 //Appends new data to the end of the table
    //                 this.dataRow = this.dataRow.concat(data); 
    //                 this.loadMoreStatus = '';
    //                 this.totalRecords = this.dataRow.length; 
    //                 if (this.dataRow.length  >= this.maxRows) {
    //                     this.tableElement.enableInfiniteLoading = false;
    //                     this.loadMoreStatus = 'No more data to load';
    //                 }

    //             if(this.tableElement){
    //                 this.tableElement.isLoading = false;
    //             } 
    //         }
    //     );
    // }
    //Imperative Call ends

// @wire( wireCall, {tabselectedapi: '$tabselectedapi', recToReturn : '$numberOfRecords'} )
// wireMethodCallback({error,data}){
//     console.log('Callout JS');
//     console.log(data);
//     if(data){
//         this.dataRow = data;  
//         this.totalRecords = data.length;
//         console.log(data );
//         console.log(this.dataRow );
//     }
//     else if(error){
//         console.log('error'+error);
//     }
// }

// loadMoreData(event) {
//     console.log('Load more JS made');
//     //Display a spinner to signal that data is being loaded
//     if(event.target){
//         event.target.isLoading = true;
//     }
//     this.tableElement = event.target;
//     //Display "Loading" when more data is being loaded
//     this.loadMoreStatus = 'Loading';
//     this.numberOfRecords=this.numberOfRecords+10;
//     wireCall( {tabselectedapi: '$tabselectedapi',recToReturn : this.numberOfRecords} )
//         .then((data) => {
//             console.log('Load more Call made');  
//                 const currentData = this.dataRow;
//                 //Appends new data to the end of the table
//                 this.dataRow = this.dataRow.concat(data); 
//                 console.log('this.dataRow'+JSON.stringify(this.dataRow));
//                 this.loadMoreStatus = '';
//                 this.totalRecords = this.dataRow.length; 
//                 console.log('this.dataRow.length '+this.dataRow.length+' '+'this.maxRows '+this.maxRows);
//                 if (this.dataRow.length  >= this.maxRows) {
//                     this.tableElement.enableInfiniteLoading = false;
//                     this.loadMoreStatus = 'No more data to load';
//                 }

//             if(this.tableElement){
//                 this.tableElement.isLoading = false;
//             } 
//         }
//     );
// }

//Experimental ends
    
//handleTabData - this method wil be used to pass the values using event from Selected Tab and its content
handleTabData(event){

const tab = event.target;
     this.tabselected = `${event.target.value}`;
     this.tabselectedapi=JSON.stringify(this.tabselected);
    // if(this.tabselected=='All'){
    //     console.log(this.tabselected);
    //     console.log('Apex class value of tabselectedapi' +  JSON.stringify(this.tabselectedapi));
    //     // @wire (fetchProduct2Record) wireProduct2;
    //     // this.wireProduct2({tabselected:this.tabselected});
    //  }
    // if(this.tabselected=='B2B'){
    //     console.log(this.tabselected);
    //     console.log('Apex class value of tabselectedapi' +  JSON.stringify(this.tabselectedapi));
    //     // this.wireProduct2({tabselected:this.tabselected});
    // }
    // if(this.tabselected=='B2C'){
    //     console.log(this.tabselected);
    //     console.log('Apex class value of tabselectedapi' + JSON.stringify(this.tabselectedapi));
    //     // this.wireProduct2({tabselected:this.tabselected});
    // }
    // if(this.tabselected=='Product'){
    //     console.log(this.tabselected);
    //     console.log('Apex class value of tabselectedapi' + JSON.stringify(this.tabselectedapi));
    //     // this.wireProduct2({tabselected:this.tabselected});     
    // }

}

 @api handleArray() {
    this.dispatchEvent(new CustomEvent('arrayhandle'));
  }

//handleRowSelection - This will be used to get details of selected actual service row
handleRowSelection(event) {
//   var currentRows;
  var  selectedRows=event.detail.selectedRows;
  this.handleArray();


    // handleArray(){

    // }



  //Below "if" condition is used to check whether selectedRows contains any data or not and based on that we will pass the events to store the value in progressValue change variable
if(selectedRows.length>0){
    console.log('selectedRows-:'+ JSON.stringify(selectedRows));
    console.log('Service Name'+JSON.stringify(selectedRows[0].Name));
    // actualserviceName=JSON.stringify(selectedRows[0].Name);
     // Creates the event with the data.
     this.handleArray();
     this.serviceName=JSON.stringify(selectedRows[0].Name);
     this.actualserviceId=JSON.stringify(selectedRows[0].Id);

     function makeid(length) {
        var result           = '';
        var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        var charactersLength = characters.length;
        for ( var i = 0; i < length; i++ ) {
          result += characters.charAt(Math.floor(Math.random() *  charactersLength));
       }
       return result;
    }
    
    console.log(makeid(18));

         
     this.grouplineItemId=(makeid(5));
     this.activeSectioName=(makeid(5));
     this.activeSectioNSurcharge=(makeid(5));
     this.makeArrayEmpty=0;
    const selectedEvent = new CustomEvent("progressvaluechange", {
        // detail: this.progressValue,
        detail: this.serviceName
      });
  
      // Dispatches the event.
    this.dispatchEvent(selectedEvent);

    const selectedserviceEvent =new CustomEvent("serviceidchange",{
        detail: this.actualserviceId
    });
    this.dispatchEvent(selectedserviceEvent);
    
    const activesectionEvent =new CustomEvent("activesectionhandle",{
        detail: this.activeSectioName
    });
    this.dispatchEvent(activesectionEvent);

    const activesectionSurcharge=new CustomEvent("activesectionsurcharge",{
        detail: this.activeSectioNSurcharge
    });
    this.dispatchEvent(activesectionSurcharge);

    const makeArrayEmpty=new CustomEvent("makeArrayEmpty",{
        // details: this.makeArrayEmpty
    });
    this.dispatchEvent(makeArrayEmpty);

    
    
}
} 
}
//   this.progressValue=[selectedRows[0]];

//   if(this.progressValue.length>0){
//   console.log('progressValue'+JSON.stringify(this.progressValue[0].Name));
// }
// var selectedRows =this.template.querySelector('lightning-datatable').getSelectedRows();
//   var id;
//    if(selectedRows.length>1)
//     {
//         // id = this.template.querySelector('lightning-datatable').getSelectedRows();
//         var el = this.template.querySelector('lightning-datatable');
//         selectedRows=el.selectedRows=el.selectedRows.slice(1);
//         // this.showNotification();
        // event.preventDefault();
//         // var id = this.template.querySelector('id');
//     }

// showNotification() {
//     const event = new ShowToastEvent({
//         title: 'Error',
//         message: 'Only one service can be selected',
//         variant: 'warning',
//         mode: 'pester'
//     });
//     this.dispatchEvent(event);
// }





// _selectedRowId='';

// handleRowSelection = event => {
// var selectedRows=event.detail.selectedRows;
// var el = this.template.querySelector('lightning-datatable');
// if(selectedRows.length>1)
// {
// selectedRows=el.selectedRows=el.selectedRows.slice(1);
// this._selectedRowId=selectedRows;
// event.preventDefault();
// return;
// }else if(selectedRows.length==0)
// {
// selectedRows=el.selectedRows=this._selectedRowId;
// event.preventDefault();
// return;
// }
// window.console.log('selectedRows# ' + JSON.stringify(selectedRows));
// }


    // var rowdetails=JSON.stringify(selectedRows);
    // console.log('rowdetails-:'+rowdetails);
    
    // console.log('name of service-:'+rowdetails.product2.Name);

    //  currentRows =selectedRows['Id'];
    // console.log('id1-:'+JSON.stringify(id));
    // console.log('id2-:'+id);
    // console.log('Id-:'+currentRows)

    // currentRows =JSON.stringify(selectedRows);
    // console.log('currentRow-:'+ JSON.stringify(currentRows));
   

    // window.console.log('selectedRows# before condition' + JSON.stringify(selectedRows));
    //  if (selectedRows.length<2) {
       
    //  } 
    // else {
    //     window.console.log('selectedRows# before condition' + JSON.stringify(selectedRows[1]));
    // }
    // window.console.log('selectedRows# before condition' + JSON.stringify(selectedRows[0]));
    // 
     
    // return;
    
    // }
   
 


    //  window.console.log('selectedRows# before condition' + JSON.stringify(selectedRows[0]));
   
    // window.console.log('selectedRows# after condition' + JSON.stringify(selectedRows));
    // window.console.log('selectedRows# ' + JSON.stringify(selectedRows));


// }


// loadMoreData(event) {
//     //Display a spinner to signal that data is being loaded
//     event.target.isLoading = true;
//     //Display "Loading" when more data is being loaded
//     this.loadMoreStatus = 'Loading';
//     fetchData(50).then((data) => {
//         if (data.length >= this.totalNumberOfRows) {
//             event.target.enableInfiniteLoading = false;
//             this.loadMoreStatus = 'No more data to load';
//         } else {
//             const currentData = this.data;
//             //Appends new data to the end of the table
//             const newData = currentData.concat(data);
//             this.data = newData;
//             this.loadMoreStatus = '';
//         }
//         event.target.isLoading = false;
//     });
// }
        // getSelectedIdAction(event){
        //     var selectedRows=event.detail.selectedRows;
        // if(selectedRows.length>1)
        // {
        //     var el = this.template.querySelector('lightning-datatable');
        //     selectedRows=el.selectedRows=el.selectedRows.slice(1);
        //     this.showNotification();
        //     event.preventDefault();
        //     return;
        // }
       
            // const selectedProduct2Rows = event.detail.selectedRows;
        //     var selectedProduct2Rows = event.detail.selectedRows;
        //     // var selectedRows=event.detail.selectedRows;
        //     if(selectedProduct2Rows.length>1)
        // {
        //     var el = this.template.querySelector('lightning-datatable');
        //     selectedProduct2Rows=el.selectedRows=el.selectedRows.slice(1);
        //     this.showNotification();
        //     event.preventDefault();
        //     return;
        // }
        //     window.console.log('selectedProduct2Rows# ' + JSON.stringify(selectedProduct2Rows));
        //     this.selectedProduct2Rows=[];
            
            // for (let i = 0; i<selectedProduct2Rows.length; i++){
            //     this.selectedProduct2IdList.push(selectedProduct2Rows[i].Id);
            // }
    
           // window.console.log('selectedProduct2Rows1 ' + this.selectedProduct2Rows + selectedProduct2Rows.length );
       
    
      
       
        // deleteProduct2RowAction(){
        //     deleteMultipleProduct2Record({conObj:this.selectedProduct2IdList})
        //     .then(()=>{
        //         this.template.querySelector('lightning-datatable').selectedProduct2Rows=[];
    
        //         const toastEvent = new ShowToastEvent({
        //             title:'Success!',
        //             message:'Record deleted successfully',
        //             variant:'success'
        //           });
        //           this.dispatchEvent(toastEvent);
    
        //         return refreshApex(this.wireProduct2);
        //     })
        //     .catch(error =>{
        //         this.errorMsg =error;
        //         window.console.log('unable to delete the record due to ' + JSON.stringify(this.errorMsg));
        //     });
        // }
    
    
 
        // displayToastError() {
        //     const toastEvt = new ShowToastEvent({
        //         title: 'Error',
        //         message: 'Some Error Occurred',
        //         variant: 'error',
        //         mode: 'dismissable'
        //     });
        //     this.dispatchEvent(toastEvt);
        // }
        // displayToastSuccess() {
        //     const toastEvt = new ShowToastEvent({
        //         title: 'Success',
        //         message: 'Submitted Successfully ',
        //         variant: 'success',
        //         mode: 'dismissable'
        //     });
        //     this.dispatchEvent(toastEvt);
        // }
        // displayToastWarning() {
        //     const toastEvt = new ShowToastEvent({
        //         title: 'Toast Warning',
        //         message: 'Some Problem Occurred',
        //         variant: 'warning',
        //         mode: 'dismissable'
        //     });
        //     this.dispatchEvent(toastEvt);
        // }
        // displayToastInfo() {
        //     const toastEvt = new ShowToastEvent({
        //         title: 'Toast Info',
        //         message: 'Data running in background',
        //         variant: 'info',
        //         mode: 'dismissable'
        //     });
        //     this.dispatchEvent(toastEvt);
        // }