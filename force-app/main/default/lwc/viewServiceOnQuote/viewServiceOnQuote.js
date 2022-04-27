import { LightningElement,wire,api,track } from 'lwc';
import fetchOppLineRecord from '@salesforce/apex/viewServiceOnQuote.fetchOppLineRecord';
import fetchProductConfig from '@salesforce/apex/viewServiceOnQuote.fetchProductConfig';
import { getRecord } from 'lightning/uiRecordApi';
import { updateRecord } from 'lightning/uiRecordApi';
import fetchOppLineRecordAdditionalService from '@salesforce/apex/viewServiceOnQuote.fetchOppLineRecordAdditionalService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
// import deleteActualService from '@salesforce/apex/viewServices.deleteActualService';
import cloneActualService from '@salesforce/apex/viewServiceOnQuote.cloneActualService';
import fetchDynamicFieldsConditions from '@salesforce/apex/viewServices.fetchDynamicFieldsConditions'
import { NavigationMixin } from 'lightning/navigation';
import fetchOpportunityRecordId from '@salesforce/apex/viewServiceOnQuote.fetchOpportunityRecordId';
import deleteActualService from '@salesforce/apex/viewServiceOnQuote.deleteActualService'
const actions = [
    { label: 'Clone', name: 'clone' },
    // { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' }
 ];


 //define datatable columns with row actions
 const columns = [
    {label:'Actual Service Name',fieldName: 'Product_Name__c', type:'text', wrapText: true, hideDefaultActions: true},

    // { label: 'Name', fieldName: 'Name' },
    // { label: 'AccountNumber', fieldName: 'AccountNumber' },
    // { label: 'Type', fieldName: 'Type' },
    // { label: 'Phone', fieldName: 'Phone', type: 'Phone' },
    {
        type: 'action',
        typeAttributes: {
            rowActions: actions,
            menuAlignment: 'right'
        }
    }
 ];

 export default class ViewServiceOnQuote extends NavigationMixin(LightningElement) {

    @api recordId;
    @track valuevar=1;
    @api realCase;
    @track accountName;
    @track contactName;
    @track updateUI;
 
    @track error;

  
    @api wiredCase;
    @api actualserviceId;
    @api serviceName;

    @api AddServData;
    @api AddServId;
    @api AddServName;
    @api grplineItemId;


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

//Model Popup code starts here

 //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
 @track isModalOpen = false;
 openModal() {
     // to open modal set isModalOpen tarck value as true
     this.isModalOpen = true;
 }
 closeModal() {
     // to close modal set isModalOpen tarck value as false
     this.isModalOpen = false;
 }
 submitDetails() {
     // to close modal set isModalOpen tarck value as false
     //Add your code to call apex method or do some processing
     this.isModalOpen = false;
 }

//Model popup code ends here




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
            this.updateUI=1;
            return refreshApex(this.refreshTable);
            
        }
    }



    disconnectedCallback() {
        unsubscribe(this.subscription, () => {
            console.log('Successfully unsubscribed');
        });
    }

@track rowId;

    handleRowActions(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        this.rowId=row.Id;
        switch (actionName) {


                case 'delete':
                    this.delActualSer(row);
                    break;
   
           
        }
    }

    delActualSer(currentRow) {
        this.showLoadingSpinner = true;
        console.log('rowId'+this.rowId+'recordId:this.recordId'+this.recordId);
        deleteActualService({ rowId: this.actualserviceId,recordId:this.recordId }).then(result => {
            window.console.log('result^^' + result);
            this.showLoadingSpinner = false;
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success!!',
                message: currentRow.Name + ' actual Service deleted.',
                variant: 'success'
            }));
            refreshApex(this.fetchOppLineRecordAdditionalService);
            this.updateUI=1;
            return refreshApex(this.wiredOppLine);
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

//Deletion code ends here

// // Navigation to Add Service LWC component
navigateToLightningComponent() {
    this[NavigationMixin.Navigate]({
        "type": "standard__component",
        "attributes": {
            //Here customLabelExampleAura is name of lightning aura component
            //This aura component should implement lightning:isUrlAddressable
            "componentName": "c__CombinedServiceRefresh"
        }
    });
}
//c/accountCreator

navigateToOpportunityRecord(){
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: this.OpportunityRecordId,
            objectApiName: 'Opportunity',
            actionName: 'view'
        },
    });
}
//Cloning code starts here

cloneProductsAndServices(){

    cloneActualService({ actualserviceID:this.actualserviceId,grplineItemId: this.grplineItemId,recordId:this.recordId }).then(result => {
   
        refreshApex(this._wiredOppConfigData);
        refreshApex(this.wiredOppLineResult);

        this.updateUI=1;
    
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
@api wiredfetchOpportunityRecordIdResult;
@api OpportunityRecordIdData;
@api OpportunityRecordId;

    @wire(fetchOpportunityRecordId,{recordId:'$recordId'}) fetchOpportunityRecordId(result){
        this.wiredfetchOpportunityRecordIdResult = result;
        if (result.data) {
            console.log('830549data'+result.data);
            // this.ProductDataupdated = result.data;
            this.OpportunityRecordIdData=result.data;
            // this.ProductDataupdated = { ...data };
            console.log("830549 this.OpportunityRecordIdData"+JSON.stringify(this.OpportunityRecordIdData));
            this.OpportunityRecordId = this.OpportunityRecordIdData[0].OpportunityId__c;
            // this.accountName = this.realCase.Account.Name;
            // this.accountName = this.realCase.Name; //tried this but it isn't working
            // return this.data;
        } else if (result.error) {
            // handle error
            console.error('830549 ERROR => ', JSON.stringify(result.error));
        }
    };

    @wire(fetchProductConfig,{recordId:'$recordId',actualServiceId:'$actualServiceIdmain'}) wiredOppConfig(wireResult) {
       
    const { data, error } = wireResult;
    // this._wiredMarketData = wireResult;
    this._wiredOppConfigData=wireResult;
    console.log('this.ActualServiceData'+JSON.stringify(this.ActualServiceData));
        if (data) {
    // fetchProductConfig({recordId:this.recordId,actualServiceId:this.actualServiceIdmain}).then(result=>{


        this.ActualServiceData=data;
        console.log('this.ActualServiceData'+JSON.stringify(this.ActualServiceData));
        // Console.log('this.AddServData'+JSON.stringify(this.AddServData));
        this.ActualServiceId=this.ActualServiceData[0].Product2Id;
        this.ActualServiceDataName=this.ActualServiceData[0].ProductNamefromOppLineItem__c;
    
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
       {label:'Additional Service Name',fieldName:'Product_Name__c',type:'text',wrapText:true,hideDefaultActions:true,hideCheckboxColumn:true},
       {label:'Type',fieldName:'Product_Type__c',type:'text',editable:true},
       {label:'Discount',fieldName:'Discount',type:'text',editable:true},
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
    // const row = event.detail.row;
    this.rowId=selectedRows.Id;
    if(selectedRows.length>0){
        console.log('selectedRows8305499228-:'+ JSON.stringify(selectedRows));
        console.log('Service Name'+JSON.stringify(selectedRows[0].ProductNamefromOppLineItem__c));
        // actualserviceName=JSON.stringify(selectedRows[0].Name);
         // Creates the event with the data.
        //  this.handleArray();
         this.serviceName=JSON.stringify(selectedRows[0].ProductNamefromOppLineItem__c);
         this.actualserviceId=JSON.stringify(selectedRows[0].Id);
         this.grplineItemId=JSON.stringify(selectedRows[0].Group_Line_Item_Id__c);
         this.actualServiceIdmain=JSON.stringify(selectedRows[0].Product2Id);
    console.log('Inside View Service: --> :grplineItemId '+this.grplineItemId+'recordId: '+this.recordId+' this.actualserviceId: '+ this.actualserviceId +' serviceName '+this.serviceName);
    console.log('this.actualServiceIdmain'+this.actualServiceIdmain);

    fetchOppLineRecordAdditionalService({recordId:this.recordId,grplineItemId:this.grplineItemId}).then(result => {
        

        // Console.log('result'+JSON.stringify(result));
        this.AddServData=result;
        // Console.log('this.AddServData'+JSON.stringify(this.AddServData));
        this.AddServId=this.AddServData[0].Id;
        this.AddServName=this.AddServData[0].Name;

        console.log('JSON.stringify(this.AddServData)-->'+JSON.stringify(this.AddServData));

        console.log('JSON.stringify(result.data)-->'+JSON.stringify(result.data));
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
    console.log('8305499228(2)->>'+JSON.stringify(this.DynamicConditionData+'-->>+this.DynamicConditionData[0].Minimum_Price_check__c -->'+this.DynamicConditionData[0].Minimum_Price_check__c)); 
    // let label='label'
    console.log('  this.DynamicConditionData[0].Free_PickUp_Check__c -->'+this.DynamicConditionData[0].Free_PickUp_Check__c);
    if(this.DynamicConditionData[0].Annual_Service_Value_Check__c==true){
      this.updatedArray=[{label: "Annual Service Value", fieldName: "UnitPrice", type: "'string'", editable: true,hideCheckboxColumn:true}];
       } 
    // this.updatedArray = this.DynamicArray.concat(...[5]);
    // console.log('8305499228(5)->> '+JSON.stringify(this.DynamicArray));
    // // this.updatedArray.push({label: "'Minimum Price'",fieldName:"'crm_Minimum_Price__c'",type: "'string'", editable:true,hideCheckboxColumn:true});
    if( this.DynamicConditionData[0].Minimum_Price_check__c==true){
        this.updatedArray.push({label: "Minimum Price",fieldName:"crm_Minimum_Price__c",type: "'string'", editable:true,hideCheckboxColumn:true});
        }
        if(this.DynamicConditionData[0].Free_PickUp_Check__c==true){
            this.updatedArray.push({ label: "Free Pickup",fieldName:"crm_Free_PickUp__c", type: "'string'",editable:true,hideCheckboxColumn:true});
        }
        if(this.DynamicConditionData[0].Passive_Return_Check__c==true){
            this.updatedArray.push({label: "'Passive_Return", fieldName:"Passive_Return__c",type: "'string'",editable:true,hideCheckboxColumn:true});
         }
        if(this.DynamicConditionData[0].Weight_Interval_From_Check__c==true){
        this.updatedArray.push({label:"Weight Interval From",fieldName:"crm_Min_Weight__c",type:"'string'",editable:true,hideCheckboxColumn:true});
         }
        if(this.DynamicConditionData[0].Weight_Interval_To_Check__c==true){
            this.updatedArray.push({label:"Weight Interval To", fieldName:"crm_Max_Weight__c",type:"'string'",editable:true,hideCheckboxColumn:true});
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
         this.actualserviceID=JSON.stringify(selectedRows[0].Product2Id);
    //      this.grplineItemId=JSON.stringify(selectedRows[0].crm_lineItemsGroupId__c);
         this.actualServiceIdmain=JSON.stringify(selectedRows[0].Product2Id);


//Code for dynamic columns starts

// this.checkDynamiccondition();
this.firstmethod();


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