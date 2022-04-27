import { LightningElement,wire,api, track } from 'lwc';
import fetchOppLineRecord from '@salesforce/apex/viewServices.fetchOppLineRecord';
import fetchProductConfig from '@salesforce/apex/viewServices.fetchProductConfig';
// import { getRecord, getRecordNotifyChange } from 'lightning/uiRecordApi';
import { getRecord } from 'lightning/uiRecordApi';
import { updateRecord } from 'lightning/uiRecordApi';
import fetchOppLineRecordAdditionalService from '@salesforce/apex/viewServices.fetchOppLineRecordAdditionalService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import deleteActualService from '@salesforce/apex/viewServices.deleteActualService';
import cloneActualService from '@salesforce/apex/viewServices.cloneActualService';
import fetchDynamicFieldsConditions from '@salesforce/apex/viewServices.fetchDynamicFieldsConditions'
//For Cloning flow launch
import crm_Min_Weight__c_FIELD from '@salesforce/schema/OpportunityLineItem.crm_Min_Weight__c';
import crm_Max_Weight__c_FIELD from '@salesforce/schema/OpportunityLineItem.crm_Minimum_Price__c';

import UnitPrice_FIELD from '@salesforce/schema/OpportunityLineItem.crm_Max_Weight__c';
import crm_Discount__c from '@salesforce/schema/OpportunityLineItem.crm_Min_Weight__c';
import updateActualServiceMethod from '@salesforce/apex/viewServices.updateActualService';
// import { getRecordNotifyChange } from 'lightning/uiRecordApi';
// crm_Free_Pickup__c
// crm_Passive_Return__c
// crm_Min_Weight__c
// crm_Max_Weight__c
// crm_Local__c
// crm_Conversion_Factor__c
// IsPayerReceiverorSender__c
// crm_Terminals__c
// crm_Direction__c

import {
    FlowAttributeChangeEvent,
    FlowNavigationNextEvent,
} from 'lightning/flowSupport';
// Ends

// import {
//     EXAMPLES_COLUMNS_DEFINITION_BASIC,
//     EXAMPLES_DATA_BASIC,
// } from './sampleData';



// const actions = [
//     { label: 'Clone', name: 'clone' },
//     // { label: 'Edit', name: 'edit' },
//     { label: 'Delete', name: 'delete' }
//  ];


 //define datatable columns with row actions
 const columns = [
    {label:'Actual Service Name',fieldName: 'crm_Product_Name__c', type:'text', wrapText: true, hideDefaultActions: true},

    // { label: 'Name', fieldName: 'Name' },
    // { label: 'AccountNumber', fieldName: 'AccountNumber' },
    // { label: 'Type', fieldName: 'Type' },
    // { label: 'Phone', fieldName: 'Phone', type: 'Phone' },
    // {
    //     type: 'action',
    //     typeAttributes: {
    //         rowActions: actions,
    //         menuAlignment: 'right'
    //     }
    // }
 ];


export default class ViewServices extends LightningElement {
    @api recordId;
    @track valuevar=1;
    @api realCase;
    @track accountName;
    @track contactName;
    // @wire(fetchOppLineRecord,{recordId:'$recordId'})
    @track error;

    // @api recordId; //current caseId
    @api wiredCase;
    @api actualserviceId;
    @api serviceName;

    @api AddServData;
    @api AddServId;
    @api AddServName;
    @api grplineItemId;

    // definition of columns for the tree grid
    // gridColumns = EXAMPLES_COLUMNS_DEFINITION_BASIC;

    // data provided to the tree grid
    // gridData = EXAMPLES_DATA_BASIC;

    // data=data;
    // columns2=columns2;
 @api newdata=[];


//Cloning Code starts here

@track _testhello = [];
@api _text='testHelloActualService';
@api
get testhello() {
    return this._testhello;
}

set testhello(testhello = []) {
    this._testhello = [...testhello];
}
cloningActualService(){
    this._testhello.push(this._text);
    // notify the flow of the new todo list
    const attributeChangeEvent = new FlowAttributeChangeEvent(
        'testhello',
        this._testhello
    );
    this.dispatchEvent(attributeChangeEvent);


}

//Deletion code starts here

@track data;
    @track columns = columns;
    @track showLoadingSpinner = false;
    recordId;    
    refreshTable;
    error;
    subscription = {};
    CHANNEL_NAME = '/event/RefreshDataTable__e';



    handleEvent = event => {
        const refreshRecordEvent = event.data.payload;
        if (refreshRecordEvent.RecordId__c === this.recordId) {
            this.recordId='';
            return refreshApex(this.refreshTable);
        }
    }



    disconnectedCallback() {
        unsubscribe(this.subscription, () => {
            console.log('Successfully unsubscribed');
        });
    }

@track rowId;

//     handleRowActions(event) {
//         const actionName = event.detail.action.name;
//         const row = event.detail.row;
//         this.rowId=row.Id;
//         this.recordId = row.Id;
//         this.cloneProductsAndServices(this.rowId);
//         // this.recordId = row.Id;
//         switch (actionName) {
//             case 'clone':
//                 this[NavigationMixin.Navigate]({
//                     type: 'standard__recordPage',
//                     attributes: {
//                         recordId: row.Id,
//                         actionName: 'clone'
//                     }
//                 });
//                 break;

//                 case 'delete':
//                     this.delActualSer(row);
//                     break;
//             case 'edit':
//                 this[NavigationMixin.Navigate]({
//                     type: 'standard__recordPage',
//                     attributes: {
//                         recordId: row.Id,
//                         objectApiName: 'Account',
//                         actionName: 'edit'
//                     }
//                 });
//                 break;
           
//        }
//    }

  
    delActualSer(currentRow) {
        this.showLoadingSpinner = true;
        console.log('rowId'+this.rowId+'recordId:this.recordId'+this.recordId);
        // deleteActualService({ rowId: this.rowId,recordId:this.recordId }).then(result => {
            deleteActualService({ rowId: this.actualserviceId,recordId:this.recordId }).then(result => {
            
            window.console.log('result^^' + result);
            this.showLoadingSpinner = false;
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success!!',
                message: currentRow.Name + ' actual Service deleted.',
                variant: 'success'
            }));
            refreshApex(this._wiredOppConfigData);
            refreshApex(this.wiredOppLineResult);
            refreshApex(this.fetchOppLineRecordAdditionalService);
            return refreshApex(this.wiredOppLine);
        }).catch(error => {
            window.console.log('Error ====> ' + error);
            this.showLoadingSpinner = false;
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error!!',
                message: JSON.stringify(error),
                variant: 'error'
            }));
        });
    }


    // Testing on deletion starts
    // deleteProductsAndServices(){

    // //     deleteActualService({ actualserviceID:this.actualserviceID,grplineItemId: this.grplineItemId,recordId:this.recordId }).then(result => {
    // //         // window.console.log('result^^' + result);
       
    // //         // refreshApex(this.fetchOppLineRecordAdditionalService);
    // //         // refreshApex(this.wiredOppConfig);
    // //         refreshApex(this._wiredOppConfigData);
    // //         refreshApex(this.wiredOppLineResult);
    // //         // refreshApex(this.wiredOppLine);
    // //         // refreshApex(this.fetchOppLineRecordAdditionalService);
    // //         // refreshApex(this.fetchProductConfig);      
    // //         // refreshApex(this.fetchOppLineRecord);
    // //         this.showLoadingSpinner = false;
    // //         this.dispatchEvent(new ShowToastEvent({
    // //             title: 'Success!!',
    // //             message: ' actual Service deleted.',
    // //             variant: 'success'
    // //         }));
    // //     }).catch(error => {
    // //         window.console.log('Error ====> ' + JSON.stringify(error));
    // //         this.showLoadingSpinner = false;
    // //         this.dispatchEvent(new ShowToastEvent({
    // //             title: 'Error!!',
    // //             message: JSON.stringify(error),
    // //             variant: 'error'
    // //         }));
    // //     });
    
    
    // // }

    //Testing on deletion ends



//Deletion code ends here

//Cloning code starts here

cloneProductsAndServices(){

    cloneActualService({ actualserviceID:this.actualserviceID,grplineItemId: this.grplineItemId,recordId:this.recordId }).then(result => {
        // window.console.log('result^^' + result);
   
        // refreshApex(this.fetchOppLineRecordAdditionalService);
        // refreshApex(this.wiredOppConfig);
        refreshApex(this._wiredOppConfigData);
        refreshApex(this.wiredOppLineResult);
        // refreshApex(this.wiredOppLine);
        // refreshApex(this.fetchOppLineRecordAdditionalService);
        // refreshApex(this.fetchProductConfig);      
        // refreshApex(this.fetchOppLineRecord);
        this.showLoadingSpinner = false;
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success!!',
            message: ' actual Service cloned.',
            variant: 'success'
        }));
    }).catch(error => {
        window.console.log('Error ====> ' + JSON.stringify(error));
        this.showLoadingSpinner = false;
        this.dispatchEvent(new ShowToastEvent({
            title: 'Error!!',
            message: JSON.stringify(error),
            variant: 'error'
        }));
    });


}


//Cloning code ends here








//  @api columns2=[];

//      columns2 = [
//         { label: 'Opportunity name', fieldName: 'opportunityName', type: 'text' },
//         {
//             label: 'Confidence',
//             fieldName: 'confidence',
//             type: 'percent',
//             cellAttributes: {
//                 iconName: { fieldName: 'trendIcon' },
//                 iconPosition: 'right',
//             },
//         },
//         {
//             label: 'Amount',
//             fieldName: 'amount',
//             type: 'currency',
//             typeAttributes: { currencyCode: 'EUR', step: '0.001' },
//         },
//         { label: 'Contact Email', fieldName: 'contact', type: 'email' },
//         { label: 'Contact Phone', fieldName: 'phone', type: 'phone' },
//     ];
    
//     newdata = [
//         {
//             id: 'a',
//             opportunityName: 'Cloudhub',
//             confidence: 0.2,
//             amount: 25000,
//             contact: 'jrogers@cloudhub.com',
//             phone: '2352235235',
//             trendIcon: 'utility:down',
//         },
//         {
//             id: 'b',
//             opportunityName: 'Quip',
//             confidence: 0.78,
//             amount: 740000,
//             contact: 'quipy@quip.com',
//             phone: '2352235235',
//             trendIcon: 'utility:up',
//         },
//     ];
    // Console.log('data'+data);
 

    getSelectedName(event) {
        const selectedRows = event.detail.selectedRows;
        // Display that fieldName of the selected rows
        for (let i = 0; i < selectedRows.length; i++) {
            alert('You selected: ' + selectedRows[i].opportunityName);
        }
    }
@track ProductDataupdated;
    // @wire(fetchOppLineRecord,{recordId:'$recordId'})wiredOppLine;
    @wire(fetchOppLineRecord,{recordId:'$recordId'}) wiredOppLine(result) {
        this.wiredOppLineResult = result;
        if (result.data) {
            console.log('830549data'+result.data);
            this.ProductDataupdated = result.data;
            // this.ProductDataupdated = { ...data };
            console.log("830549this.ProductDataupdated"+JSON.stringify( this.ProductDataupdated));
            // this.accountName = this.realCase.Account.Name;
            // this.accountName = this.realCase.Name; //tried this but it isn't working
            // return this.data;
        } else if (result.error) {
            // handle error
            console.error('830549 ERROR => ', JSON.stringify(result.error));
        }
    };
    isCssLoaded = false

    @wire(fetchProductConfig,{recordId:'$recordId',actualServiceId:'$actualServiceIdmain'}) wiredOppConfig(wireResult) {
       
    const { data, error } = wireResult;
    // this._wiredMarketData = wireResult;
    this._wiredOppConfigData=wireResult;
       
        if (data) {
    // fetchProductConfig({recordId:this.recordId,actualServiceId:this.actualServiceIdmain}).then(result=>{


        this.ActualServiceData=data.map(item=>{
           var ServiceCreatedDate= item.CreatedDate;

           var modifiedServiceDate = new Date(ServiceCreatedDate);
 
           // date of the month from above Date Object is
           // being extracted using getDate()
       
        //    var modifiedServiceDate=getDate(ServiceCreatedDate);
           var currentdate=new Date();

        //    var modifiedCurrentDate=currentdate.getUTCDate();
    //   var today = Date.now();
    //     var currentdate=today;

        //    var currentdate =(dateFormat(new Date(), "DD/MM/YYYY"));
        //    var diff = Math.abs(date1 - date2);
        var diff = Math.abs( currentdate- modifiedServiceDate);
        var diffInMinutes =diff/(1000 * 60);
            console.log('diff--> '+diffInMinutes+' '+'ServiceCreatedDate -->'+modifiedServiceDate+' currentdate -->'+currentdate);
            // var diff = Math.abs( currentdate- new Date(ServiceCreatedDate.replace(/-/g,'/')));
           

            // let amountColor = diffInMinutes <1 ? "slds-text-color_error":"slds-text-color_success";
            let amountColor = diffInMinutes <1 ? "slds-text-color_error":"abcd";
            // let iconName = diffInMinutes <50 ? "utility:down":"utility:up";
            // let iconName = diffInMinutes <5 ? " ":"abcd";
            return {...item, 
                "amountColor":amountColor,
                // "iconName":iconName,
                "industryColor":"slds-icon-custom-custom12 slds-text-color_default",
                "accountColor":"datatable-orange"
            }
        })
        console.log(this.ActualServiceData)
    
    if(error){
        console.error(error)
    }
        // Console.log('this.AddServData'+JSON.stringify(this.AddServData));
        this.ActualServiceId=this.ActualServiceData[0].Id;
        this.ActualServiceDataName=this.ActualServiceData[0].Name;
    
        console.log('Inside View Service---->>>>'+' this.AddServId '+ this.ActualServiceId+'this.AddServName'+this.ActualServiceDataName);
    }else if (error) {
            // handle error
            console.error('830549 ERROR => '+ error);
            window.alert('No Configuration Service avaiable for selected Actual Service Please contact your system admin if you have already added: ' + JSON.stringify(this.error));
 
        }
    };
        // window.alert('No Configuration Service avaiable for selected Actual Service Please contact your system admin if you have already added: ' + JSON.stringify(this.error));
    // }); 




    // }
 //define row actions




    // @api  columns =[
       
    //     {label:'Actual Service Name',fieldName: 'Name', type:'text', wrapText: true, hideDefaultActions: true},
    //     {
    //         label: 'Clone',
    //         type: 'button-icon',
    //         initialWidth: 75,
    //         typeAttributes: {
    //             iconName: 'action:clone',
    //             title: 'Clone',
    //             variant: 'border-filled',
    //             alternativeText: 'Clone'
    //         }
    //       },
    //       {
    //         label: 'Delete',
    //         type: 'button-icon',
    //         initialWidth: 75,
    //         typeAttributes: {
    //             iconName: 'action:delete',
    //             title: 'Delete',
    //             variant: 'border-filled',
    //             alternativeText: 'Delete'
    //         }
    //       },
        // {label: 'Type', fieldName: 'crm_Opp_Prod_Type__c',type:'text', editable: true }, 
        // {label: 'Weight from', fieldName: 'crm_Min_Weight__c', type: 'number', editable: true},
        // {label: 'Weight to', fieldName: 'crm_Max_Weight__c', type: 'number', editable: true},
              
        // {label: 'Actual Service Name', fieldName: 'actualServiceName', type:'text'}       
//    ];

   @api  columns1 =[
    // {label:'Actual Service Name',fieldName: 'Name', type:'text', wrapText: true, hideDefaultActions: true},
    // {label: 'Type', fieldName: 'crm_Opp_Prod_Type__c',type:'text', editable: true }, 
    {label: 'Weight from', fieldName: 'crm_Min_Weight__c', type: 'number', editable: true,hideCheckboxColumn:true},
    {label: 'Weight to', fieldName: 'crm_Max_Weight__c', type: 'number', editable: true},
          
    // {label: 'Actual Service Name', fieldName: 'actualServiceName', type:'text'}       
];

   @api column2=[
       {label:'Additional Service Name',fieldName:'crm_Product_Name__c',type:'text',wrapText:true,hideDefaultActions:true,hideCheckboxColumn:true},
       {label:'Type',fieldName:'crm_Opp_Prod_Type__c',type:'text',editable:true},
       {label:'Discount',fieldName:'crm_Discount__c',type:'text',editable:true},
       {label:'Unit',fieldName:'UnitPrice',type:'text',editable:true},
       
   ];

//    @wire(fetchOppLineRecordAdditionalService, { recordId:'$recordId',grplineItemId:'$grplineItemId'})
//    wiredInfo(value) {
//        this.wiredApexData = value;
//        if (value.data) {
//            this.apexData = value.data;
//            this.error = undefined;
//        } else if (value.error) {
//        }
//     }
//     opps;  

@api actualServiceIdmain;

@track ActualServiceData;

@track ActualServiceId;
@track ActualServiceDataName;

handleRowSelectionforAdd(event){

    var  selectedRows=event.detail.selectedRows;

    if(selectedRows.length>0){
        console.log('selectedRows-:'+ JSON.stringify(selectedRows));
        console.log('Service Name'+JSON.stringify(selectedRows[0].Name));
        // actualserviceName=JSON.stringify(selectedRows[0].Name);
         // Creates the event with the data.
        //  this.handleArray();
         this.serviceName=JSON.stringify(selectedRows[0].Name);
         this.actualserviceId=JSON.stringify(selectedRows[0].Id);
         this.grplineItemId=JSON.stringify(selectedRows[0].crm_lineItemsGroupId__c);
         this.actualServiceIdmain=JSON.stringify(selectedRows[0].crm_Actual_Service__c);
    console.log('Inside View Service: --> :grplineItemId '+this.grplineItemId+'recordId: '+this.recordId+' this.actualserviceId: '+ this.actualserviceId +' serviceName '+this.serviceName);
   

    fetchOppLineRecordAdditionalService({recordId:this.recordId,grplineItemId:this.grplineItemId}).then(result => {
        

        // Console.log('result'+JSON.stringify(result));
        this.AddServData=result;
        // Console.log('this.AddServData'+JSON.stringify(this.AddServData));
        this.AddServId=this.AddServData[0].Id;
        this.AddServName=this.AddServData[0].Name;

        console.log('Inside View Service---->>>>'+' this.AddServId '+ this.AddServId+'this.AddServName'+this.AddServName);
    }).catch(error => {
        this.error = error;
        // this.PricebookEntryvalue = undefined;
        window.alert('No Additional Service avaiable for selected Actual Service Please contact your system admin if you have already added: ' + JSON.stringify(this.error));
    }); 
}

}


@api DynamicConditionData;
// @track DynamicArray=[];
// @api finalString;
@track updatedArray=[];

async firstmethod(result){
    console.log('8305499228-->1');
    // this.DynamicArray.concat([4]);
    await this.checkDynamiccondition();
    console.log('8305499228-->4');
    refreshApex(this._wiredOppConfigData);
    refreshApex(this.ActualServiceData);
    refreshApex(this.wiredOppLineResult);
    console.log('8305499228(2)->>'+JSON.stringify(this.DynamicConditionData+'-->>+this.DynamicConditionData[0].Minimum_Price_check__c -->'+this.DynamicConditionData[0].Minimum_Price_check__c)); 
    // let label='label'
    console.log('  this.DynamicConditionData[0].Free_PickUp_Check__c -->'+this.DynamicConditionData[0].Free_PickUp_Check__c);
    // if(this.DynamicConditionData[0].Annual_Service_Value_Check__c==true){
    //   this.updatedArray=[{label: "Annual Service Value", fieldName: "UnitPrice", type: "'string'", editable: true,hideCheckboxColumn:true,cellAttributes:{
    //     class:{fieldName:'amountColor'},
    //     iconName:{fieldName:'iconName'}, iconPosition:'right'
    // }}];
    //    } 

       if(this.DynamicConditionData[0].Annual_Service_Value_Check__c==true){
        this.updatedArray=[{label: "Annual Service Value", fieldName: "UnitPrice", type: "'string'", editable: true,hideCheckboxColumn:true,cellAttributes:{
          class:{fieldName:'amountColor'}
      }}];
         } 





    // this.updatedArray = this.DynamicArray.concat(...[5]);
    // console.log('8305499228(5)->> '+JSON.stringify(this.DynamicArray));
    // // this.updatedArray.push({label: "'Minimum Price'",fieldName:"'crm_Minimum_Price__c'",type: "'string'", editable:true,hideCheckboxColumn:true});
    if( this.DynamicConditionData[0].Minimum_Price_check__c==true){
        this.updatedArray.push({label: "Minimum Price",fieldName:"crm_Minimum_Price__c",type: "'string'", editable:true,hideCheckboxColumn:true});
        }
        if(this.DynamicConditionData[0].Free_PickUp_Check__c==true){
            this.updatedArray.push({ label: "Free Pickup",fieldName:"crm_Free_Pickup__c", type: "'string'",editable:true,hideCheckboxColumn:true});
        }
        if(this.DynamicConditionData[0].Passive_Return_Check__c==true){
            this.updatedArray.push({label: "'Passive_Return", fieldName:"crm_Passive_Return__c",type: "'string'",editable:true,hideCheckboxColumn:true});
         }
        if(this.DynamicConditionData[0].Weight_Interval_From_Check__c==true){
        this.updatedArray.push({label:"Weight Interval From",fieldName:"crm_Min_Weight__c",type:"'string'",editable:true,hideCheckboxColumn:true,cellAttributes:{
            class:{fieldName:'amountColor'}
          
        }});
         }
        if(this.DynamicConditionData[0].Weight_Interval_To_Check__c==true){
            this.updatedArray.push({label:"Weight Interval To", fieldName:"crm_Max_Weight__c",type:"'string'",editable:true,hideCheckboxColumn:true,cellAttributes:{
                class:{fieldName:'amountColor'}
                
            }});
         }            
            if(this.DynamicConditionData[0].Local_Domestic_Check__c==true){
                this.updatedArray.push({label: "Local", fieldName: "crm_Local__c", type: "'string'", editable: true,hideCheckboxColumn:true});
               } if(this.DynamicConditionData[0].Conversion_Factor_Check__c==true){
                this.updatedArray.push({label: "Conversion Factor", fieldName: "crm_Conversion_Factor__c", type: "'string'", editable: true,hideCheckboxColumn:true});
               } if(this.DynamicConditionData[0].Is_Payer_Receiver_or_Sender_Check__c==true){
                this.updatedArray.push({label: "IsPayerReceiverorSender", fieldName: "IsPayerReceiverorSender__c", type: "'string'", editable: true,hideCheckboxColumn:true});
               }if(this.DynamicConditionData[0].Terminals_Check__c==true){
                this.updatedArray.push({label: "Terminals", fieldName: "crm_Terminals__c", type: "'string'", editable: true,hideCheckboxColumn:true});
               } if(this.DynamicConditionData[0].Direction_Terminals_Check__c==true){
                this.updatedArray.push({label: "Direction", fieldName: "crm_Direction__c", type: "'string'", editable: true,hideCheckboxColumn:true});
               }
             
               if(this.DynamicConditionData[0].Discount_Check__c==true){
                this.updatedArray.push({label: "Discount", fieldName: "crm_Discount__c", type: "'string'", editable: true,hideCheckboxColumn:true});
               }

            //    this.updatedArray.concat.prototype(this.DynamicArray);
           console.log('8305499228-->this.DynamicArray-->'+JSON.stringify(this.DynamicArray));
           console.log('8305499228-->this.updatedArray-->'+JSON.stringify(this.updatedArray));
        //    var string = JSON.stringify(this.DynamicArray);
        //    string.replace(/"/g, ""); //"[apple,orange,pear]"
        //    console.log('8305499228-->String-->'+string);
        // for(var i=0;i<this.DynamicArray.length;i++){

        //     let dummyString = JSON.stringify(this.DynamicArray[i]);
        //    let updatedString=dummyString.split('"').join('');
          
          

        //     this.updatedArray.push(updatedString);

        // }
        //     this.finalString = string.split('"').join('')
        //    console.log('8305499228-->finalString-->'+this.finalString);
        //   this.updatedArray=[{label: "'Local'", fieldName: "'crm_Local__c'", type: "'string'", editable: true,hideCheckboxColumn:true}];
        //    this.updatedArray.push(this.finalString);
        //    console.log('8305499228-->updatedArray after update-->'+ JSON.stringify(this.updatedArray));
}

draftValues = [];
// handleSave(event){
//     // Id
//     // crm_Minimum_Price__c
//     // crm_Free_Pickup__c
//     // crm_Passive_Return__c
//     // crm_Min_Weight__c
//     // crm_Max_Weight__c
//     // crm_Local__c
//     // crm_Conversion_Factor__c
//     // IsPayerReceiverorSender__c
//     // crm_Terminals__c
//     // crm_Direction__c
//     // UnitPrice
//     // crm_Discount__c


//     const fields = {}; 
//     // fields[ID_FIELD.fieldApiName] = event.detail.draftValues[0].Id;
//     // fields[crm_Minimum_Price__c_FIELD.fieldApiName] = event.detail.draftValues[0].crm_Minimum_Price__c;
//     // fields[crm_Free_Pickup__c_FIELD.fieldApiName] = event.detail.draftValues[0].crm_Free_Pickup__c;
//     // fields[crm_Passive_Return__c_FIELD.fieldApiName] = event.detail.draftValues[0].crm_Passive_Return__c;
//     fields[crm_Min_Weight__c_FIELD.fieldApiName] = event.detail.draftValues[0].crm_Min_Weight__c;
//     fields[crm_Max_Weight__c_FIELD.fieldApiName] = event.detail.draftValues[0].crm_Max_Weight__c;
//     // fields[crm_Local__c_FIELD.fieldApiName] = event.detail.draftValues[0].crm_Local__c;
//     // fields[crm_Conversion_Factor__c_FIELD.fieldApiName] = event.detail.draftValues[0].crm_Conversion_Factor__c;
//     // fields[IsPayerReceiverorSender__c_FIELD.fieldApiName] = event.detail.draftValues[0].IsPayerReceiverorSender__c;
//     // fields[crm_Terminals__c_FIELD.fieldApiName] = event.detail.draftValues[0].crm_Terminals__c;
//     // fields[crm_Direction__c_FIELD.fieldApiName] = event.detail.draftValues[0].crm_Direction__c;
//     fields[UnitPrice_FIELD.fieldApiName] = event.detail.draftValues[0].UnitPrice;
//     // fields[crm_Discount__c_FIELD.fieldApiName] = event.detail.draftValues[0].crm_Discount__c;
//     const recordInput = {fields};

//     updateRecord(recordInput)
//     .then(() => {
//         this.dispatchEvent(
//             new ShowToastEvent({
//                 title: 'Success',
//                 message: 'Contact updated',
//                 variant: 'success'
//             })
//         );
//         // Display fresh data in the datatable
//         return refreshApex(this._wiredOppConfigData).then(() => {

//             // Clear all draft values in the datatable
//             this.draftValues = [];

//         });
//     }).catch(error => {
//         this.dispatchEvent(
//             new ShowToastEvent({
//                 title: 'Error updating or reloading record',
//                 message: error.body.message,
//                 variant: 'error'
//             })
//         );
//     });

// }

// navigateToViewOpportunityPage() { 
//     this[NavigationMixin.Navigate]({ 
//     type: 'standard__recordPage', 
//     attributes: { recordId: this.recordId, objectApiName: 'Opportunity', actionName: 
//     'view' }, 
//     }); 
//  }
//Update Lightning Data table using Apex
async handleSave(event) {
    const updatedFields = event.detail.draftValues;
    
    // Prepare the record IDs for getRecordNotifyChange()
    const notifyChangeIds = updatedFields.map(row => { return { "recordId": row.Id } });

    try {
        // Pass edited fields to the updateContacts Apex controller
        const result = await updateActualServiceMethod({data: updatedFields});
        console.log(JSON.stringify("Apex update result: "+ result));
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Actual Service updated',
                variant: 'success'
            })
        );
        // this.navigateToViewOpportunityPage;
        // Refresh LDS cache and wires
        // getRecordNotifyChange(this.recordId);
        // getRecordNotifyChange([{recordId: this.recordId}]);
        // Display fresh data in the datatable
        refreshApex(this._wiredOppConfigData).then(() => {
            // Clear all draft values in the datatable
            this.draftValues = [];
        });
        // this.navigateToViewOpportunityPage;
   } catch(error) {
           this.dispatchEvent(
               new ShowToastEvent({
                   title: 'Error updating or refreshing records',
                   message: error.body.message,
                   variant: 'error'
               })
         );
    };
}





//Update Lightning Data table using Apex


async checkDynamiccondition(){

    return new Promise(async (resolve, reject) =>{
        console.log('8305499228-->2');
        // var result = await fetchDynamicFieldsConditions();
        var result = await fetchDynamicFieldsConditions({ActualServiceIdMain:this.actualServiceIdmain}).then(result => {
              
                this.DynamicConditionData=Object.values(result);  
            }).catch(error => {
                this.error = error;
                    console.log(JSON.stringify(this.DynamicArray));
                    window.alert('No Dynamic Condition found: ' + JSON.stringify(this.error));
                });  
                 ;
        console.log('8305499228-->3');
        resolve(result);
    });
    // await this.secondmethod();

    // this.DynamicConditionData;
    // 
    
    }

    //  secondmethod(){
        // fetchDynamicFieldsConditions({ActualServiceIdMain:this.actualServiceIdmain}).then(result => {
              
        //     this.DynamicConditionData=Object.values(result);  
        //     // this.DynamicConditionData=[{"Id":"01t2X000006UknoQAC","Name":"Pakke til bedrift","Minimum_Price_check__c":false,"Free_PickUp_Check__c":false,"Passive_Return_Check__c":true,"Weight_Interval_From_Check__c":true,"Weight_Interval_To_Check__c":true,"Local_Domestic_Check__c":false,"Conversion_Factor_Check__c":true,"Is_Payer_Receiver_or_Sender_Check__c":false,"Terminals_Check__c":false,"Direction_Terminals_Check__c":false,"Annual_Service_Value_Check__c":true,"Discount_Check__c":true}]  
        //     // var dynamicarrayupdated = Object.entries(this.DynamicConditionData);
            
        //     // let dynamicarrayupdated =JSON.stringify(this.DynamicConditionData);
            
        // //   console.log(JSON.stringify(this.DynamicConditionData));
        //   console.log('8305499228(1)->>'+JSON.stringify(this.DynamicConditionData)); 
        // //   console.log('8305499228(1.1)->>'+this.DynamicConditionData[0].Minimum_Price_check__c)
        // //   console.log('8305499228(1.2)->>'+JSON.stringify(dynamicarrayupdated));
        // //   var delayInMilliseconds = 5000; //3 second
    
        // //   setTimeout(function() {
        //     // console.log(JSON.stringify(this.DynamicConditionData));
        //     //your code to be executed after 3 second
        //     // console.log('8305499228(2)->>'+JSON.stringify(this.DynamicConditionData)); 
        //     // if(this.DynamicConditionData){
        //         // console.log('8305499228(3)->>'+JSON.stringify(this.DynamicConditionData)); 
         
        //     //   }
        // //   }, delayInMilliseconds);    
    
        // //   console.log(this.DynamicArray);
        // }).catch(error => {
        //     this.error = error;
        //     console.log(JSON.stringify(this.DynamicArray));
        //     window.alert('No Dynamic Condition found: ' + JSON.stringify(this.error));
        // }); 
    
    // }


   handleRowSelection(event) {
    //   var currentRows;
      var  selectedRows=event.detail.selectedRows;

      //Below "if" condition is used to check whether selectedRows contains any data or not and based on that we will pass the events to store the value in progressValue change variable
    if(selectedRows.length>0){
        console.log('selectedRows-:'+ JSON.stringify(selectedRows));
    //     console.log('Service Name'+JSON.stringify(selectedRows[0].Name));
    //     // actualserviceName=JSON.stringify(selectedRows[0].Name);
    //      // Creates the event with the data.
    //     //  this.handleArray();
    //      this.serviceName=JSON.stringify(selectedRows[0].Name);
         this.actualserviceID=JSON.stringify(selectedRows[0].Id);
    //      this.grplineItemId=JSON.stringify(selectedRows[0].crm_lineItemsGroupId__c);
         this.actualServiceIdmain=JSON.stringify(selectedRows[0].crm_Actual_Service__c);


//Code for dynamic columns starts

// this.checkDynamiccondition();
this.firstmethod();
refreshApex(this._wiredOppConfigData);
refreshApex(this.ActualServiceData);
// refreshApex(this._wiredOppConfigData);
refreshApex(this.wiredOppLineResult);

//Code for dynamic columns ends





    // console.log('Inside View Service: --> :grplineItemId '+this.grplineItemId+'recordId: '+this.recordId+' this.actualserviceId: '+ this.actualserviceId +' serviceName '+this.serviceName);
        
    // @wire(fetchOppLineRecordAdditionalService,{recordId:'$recordId',grplineItemId:'$grplineItemId'})fetchAdditionalService;
   

    // this.wiredInfo;
   
//    this.fetchOppLineRecordAdditionalService(this.recordId,this.grplineItemId);
// fetchProductConfig({recordId:this.recordId,actualServiceId:this.actualServiceIdmain}).then(result=>{


//     this.ActualServiceData=result;
//     // Console.log('this.AddServData'+JSON.stringify(this.AddServData));
//     this.ActualServiceId=this.ActualServiceData[0].Id;
//     this.ActualServiceDataName=this.ActualServiceData[0].Name;

//     console.log('Inside View Service---->>>>'+' this.AddServId '+ this.ActualServiceId+'this.AddServName'+this.ActualServiceDataName);
// }).catch(error => {
//     // this.error = error;
//     // this.PricebookEntryvalue = undefined;
//     window.alert('No Configuration Service avaiable for selected Actual Service Please contact your system admin if you have already added: ' + JSON.stringify(this.error));
// }); 
   
}
   
    // fetchOppLineRecordAdditionalService({recordId:this.recordId,grplineItemId:this.grplineItemId}).then(result => {
        

    //     // Console.log('result'+JSON.stringify(result));
    //     this.AddServData=result;
    //     // Console.log('this.AddServData'+JSON.stringify(this.AddServData));
    //     this.AddServId=this.AddServData[0].Id;
    //     this.AddServName=this.AddServData[0].Name;

    //     console.log('Inside View Service---->>>>'+' this.AddServId '+ this.AddServId+'this.AddServName'+this.AddServName);
    // }).catch(error => {
    //     this.error = error;
    //     // this.PricebookEntryvalue = undefined;
    //     window.alert('No Additional Service avaiable for selected Actual Service Please contact your system admin if you have already added: ' + JSON.stringify(this.error));
    // }); 
    
    
        //  function makeid(length) {
        //     var result           = '';
        //     var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        //     var charactersLength = characters.length;
        //     for ( var i = 0; i < length; i++ ) {
        //       result += characters.charAt(Math.floor(Math.random() *  charactersLength));
        //    }
        //    return result;
        // }
        
        // console.log(makeid(18));
    
             
        //  this.grouplineItemId=(makeid(5));
        //  this.activeSectioName=(makeid(5));
        //  this.activeSectioNSurcharge=(makeid(5));
        //  this.makeArrayEmpty=0;
        // const selectedEvent = new CustomEvent("progressvaluechange", {
        //     // detail: this.progressValue,
        //     detail: this.serviceName
        //   });
      
          // Dispatches the event.
        // this.dispatchEvent(selectedEvent);
    
        // const selectedserviceEvent =new CustomEvent("serviceidchange",{
        //     detail: this.actualserviceId
        // });
        // this.dispatchEvent(selectedserviceEvent);
        
        // const activesectionEvent =new CustomEvent("activesectionhandle",{
        //     detail: this.activeSectioName
        // });
        // this.dispatchEvent(activesectionEvent);
    
        // const activesectionSurcharge=new CustomEvent("activesectionsurcharge",{
        //     detail: this.activeSectioNSurcharge
        // });
        // this.dispatchEvent(activesectionSurcharge);
    
        // const makeArrayEmpty=new CustomEvent("makeArrayEmpty",{
        //     // details: this.makeArrayEmpty
        // });
        // this.dispatchEvent(makeArrayEmpty);
    
        
        
    // }
    } 

//    @api colums2 = [
//     { fieldName: 'Name', type:'text', wrapText: true, hideDefaultActions: true}
   
//    ];

//    @api columns3 = [
//     {label: 'Type', fieldName: 'crm_Opp_Prod_Type__c',type:'text', editable: true }
//    ];

//    @api columns4 = [
//     {label: 'Weight from', fieldName: 'crm_Min_Weight__c', type: 'number', editable: true},
//     {label: 'Weight to', fieldName: 'crm_Max_Weight__c', type: 'number', editable: true}
//    ];

    // getCaseDetails(resp) {
    //     this.wiredCase = resp;
    //     this.realCase = { ... this.wiredCase.data };
    //     this.accountName = this.realCase.Account.Name; //tried this but it isn't working
    //     this.contactName = this.realCase.Contact.Name; //tried this but it isn't working
    // }





    // wiredOppLine({data,error}){
    //     if (data) {
    //         this.data = data.map(row=>{
    //             // console.log({...row,Name:row.Name,crm_Opp_Prod_Type__c:row.crm_Opp_Prod_Type__c, actualServiceName: row.crm_Actual_Service__r.Name});
    //             // return{...row, Name: row.Name, crm_Opp_Prod_Type__c: row.crm_Opp_Prod_Type__c, actualServiceName: row.crm_Actual_Service__r.Name}
    //             return{...row, Name: row.Name, crm_Opp_Prod_Type__c: row.crm_Opp_Prod_Type__c}

                
               
    //         })
    //         this.error = undefined;
   
    //     } else if (error) {
    //         this.error = error;
    //         console.log("error"+error);
    //         this.data = undefined;
    //     }
    //     // console.log({...row,Name:row.Name,crm_Opp_Prod_Type__c:row.crm_Opp_Prod_Type__c});
    // }

    // wiredOppLine(result){
    //     if (result.data) {
    //         this.data = result.data.map(row=>{
    //             console.log({...row, actualServiceName: row.crm_Actual_Service__c.Name});
    //             return{...row, actualServiceName: row.crm_Actual_Service__c.Name}

    //         })
    //         this.error = undefined;
   
    //     } else if (result.error) {
    //         this.error = result.error;
    //         this.data = undefined;
    //     }
    // }

   
    // @api OpportunityId='0067a00000LRRXXAA5';
    // @api OpportunityId='0067a00000KoO7YAAV'
    // @wire(fetchOppLineRecord,{recordId:'$recordId'}) wiredOppLine;
   

    // @wire(getPriceBookEntry, {idProduct:'$recordId' })
    // myPriceBooks(result) {
    //     if (result.data) {
    //         this.data = result.data.map(row=>{
    //             return{...row, productName: row.Product2.Name}
    //         })
    //         this.error = undefined;
   
    //     } else if (result.error) {
    //         this.error = result.error;
    //         this.data = undefined;
    //     }
    // }

   


// checkrecordId(){
//     console.log("this.recordId"+this.recordId);
// }
// showrecordId(){
//     this.checkrecordId();
// }
// if(this.valuevar==1){
// this.checkrecordId();
// }
}