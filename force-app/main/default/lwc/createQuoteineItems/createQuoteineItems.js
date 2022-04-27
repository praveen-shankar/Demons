import { LightningElement, wire,api, track } from 'lwc';
//Add Service starts
import fetchProduct2Record from '@salesforce/apex/createQuoteLineItems.fetchProduct2Record';
import getPickListValuesIntoListJs from '@salesforce/apex/createQuoteLineItems.getPickListValuesIntoList';
import { CloseActionScreenEvent  } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
//Add Service ends

//Configure Service starts
import { createRecord } from 'lightning/uiRecordApi';
import fetchPriceBookEntryId from '@salesforce/apex/createQuoteLineItems.fetchPriceBookEntryId';
import Pricebook2IdList from '@salesforce/apex/createQuoteLineItems.fetchPricebook2Id';
//Configure service ends

//additionalServices import Starts here

import fetchAdditionalServices from '@salesforce/apex/createQuoteLineItems.AdditionalServices';
import fetchSurcharges from '@salesforce/apex/createQuoteLineItems.AdditionalServicesSurcharge';
import createOliRecords from '@salesforce/apex/createQuoteLineItems.createOliRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//additionalServices import Ends here


//View Services Starts
import fetchOppLineRecord from '@salesforce/apex/viewServices.fetchOppLineRecord';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
//View Services Ends

export default class CreateQuoteineItems extends NavigationMixin(LightningElement) {

    //<--Add Service Component Variable starts-->
    @track actualserviceId;
    @api serviceName;
    @api tabselectedapi;
    @track tabselected='';
    @api searchKeyMain="";
    @api ActualProductsData;
    // @wire(fetchProduct2Record,{tabselectedapi:'$tabselectedapi',searchKey:'$searchKeyMain'}) wireProduct2;

//Code for Search Functionality in Add Service Lightning Data Table Starts
@wire(fetchProduct2Record,{tabselectedapi:'$tabselectedapi',searchKey:'$searchKeyMain'}) wireProduct2(wireResult) {
       
    const { data, error } = wireResult;
    // this._wiredMarketData = wireResult;
    this._wiredProduct2Data=wireResult;
    this.ActualProductsData=data;
       
        if (data) {
            this.ActualProductsData=data;
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


    timerId;
    handleKeywordChange(event){
        this.searchKeyMain=event.target.value;
    }
startSearchTimer(event) {
  this.searchKeyMain=event.target.value;
  clearTimeout(this.timerId);
  this.timerId = setTimeout(this.doSearch.bind(this),500);
}
doSearch() {

    console.log('this.searchKeyMain'+this.searchKeyMain);
    refreshApex(this._wiredOppConfigData);
//   fetchAccounts({userId:this.userId,searchKey:this.searchKey})
//   .then(data => {
//     this.Acc = data;
//     this.error = null;
//   })
//   .catch(error => {
//     this.Acc = null;
//     this.error = error;
//   });
}
//code for Search functionality in Add Service Lightning Data Table Ends



    // ({data, error}){
    //     if(data){
    //         console.log('wireProduct2 data values'+JSON.stringify(data));
    //     }
    //     if(error){
    //         console.log('Error wireProduct2 '+error);
    //     }
    // };

    //<--Add Service component Variable Ends-->

    //Configure Service variable starts
    @api recordId;
    @api actualServiceIdModified;
    @api pricebook2IDdata=[];
    @api Pricebook2Idvalue;
    @api CurrencyIsoCodevalue;
    @api PricebookEntrydata;
    @api PricebookEntryvalue;
    @api error;

    //Configure Service Variable ends

    //Additional Service variable starts

    // @api serviceName;
    // @api actualserviceId;
    @api activeSectionName;
    @api activeSectionSurcharge;
    // @api recordId;
    // @api PricebookEntryId='01uw000000wdcQQAAY';
    @api PricebookEntryId;
    // @api Pricebook2Idvalue;
  
    // @api CurrencyIsoCodevalue;
    // @api PricebookEntrydata;
    // @api PricebookEntryvalue;
    @api storeMultipleValueTempArray;
    @api storeMultipleValueTempArraySurcharge;

    @api additionalServiceList=[];
    @api additionalServiceSurchage=[];
    errorEmptyService='No Service available';

    @api currentactualServiceId;
    @api makeArrayEmpty;
    @track SelectedValues=[];
    @track SelectedSurchargeValues=[];
    @track discountDataList = [];
    @track DiscountValueVAS='';
    @track UnitValueVAS;

    @track pricebook2IDdata=[];
  @api createOliRecordsResponse=[];

   @track contactDataWrp;

    //Additional Service variable ends

    //View Services starts

    @track valuevar=1;
    @api realCase;
    @track accountName;
    @track contactName;
    @track error;

    // @api recordId; //current caseId
    @api wiredCase;

    @api tableData;
    
    //View Services ends

//Common for all variables
@track grouplineItemId;
//Common for all variable
   
    //<--Add Service Methods starts-->

    //handleTabData - this method wil be used to pass the values using event from Selected Tab and its content

//Get picklist values dynamically starts

@track picklistData=[];
@track picklistDatamodified=[];

        @wire(getPickListValuesIntoListJs) getPickListValuesIntoListJs({data, error}){
                if(data){
                    console.log('Picklist Values'+JSON.stringify(data));
                    this.picklistData=JSON.parse(JSON.stringify(data));
                    if(data!=undefined){
                  
                    this.picklistData.splice(0,0,"All");
                    console.log(' this.picklistData'+ this.picklistData+'-normal -'+JSON.stringify( this.picklistData));
                    }
                
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

//Get picklist values dynamically ends


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

makeid(length) {
    var result           = '';
    var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var charactersLength = characters.length;
    for ( var i = 0; i < length; i++ ) {
      result += characters.charAt(Math.floor(Math.random() *  charactersLength));
   }
   result = this.actualserviceId+result;

   let str;
   str=result;
   let modifiedstr;
   // modifiedstr=str.replace(/"/g,"");
//    modifiedstr=str.replace(/^"|"$/g, '');
// modifiedstr=str.toString().replace('"', '\\"');
// modifiedstr=str.replace(/"/g, '\\"');
if(str!=undefined){
modifiedstr=str.replaceAll('"', '');
}
   this.grouplineItemId=modifiedstr;

//    this.grouplineItemId= result;
   console.log('this.grouplineItemId'+this.grouplineItemId);
   return result;
}

//handleRowSelection starts- This will be used to get details of selected actual service row

//Handle Dynamic fields on Congfigure starts
@track Minimum_Price_check=true;
@track Free_PickUp_Check=true;
@track Passive_Return_Check=true;
@track Weight_Interval_From_Check=true;
@track Weight_Interval_To_Check=true;
@track Local_Domestic_Check=true;
@track Conversion_Factor_Check=true;
@track Is_Payer_Receiver_or_Sender_Check=true;
@track Terminals_Check=true;
@track Direction_Terminals_Check=true;
@track Annual_Service_Value_Check=true;
@track Discount_Check=true;
//Handle dynamic fields on Congfigure ends



handleRowSelection(event) {

      var  selectedRows=event.detail.selectedRows;
    //   this.handleArray();

//Below "if" condition is used to check whether selectedRows contains any data or not and based on that we will pass the events to store the value in progressValue change variable
if(selectedRows.length>0){
    console.log('selectedRows-:'+ JSON.stringify(selectedRows));
    console.log('Service Name'+JSON.stringify(selectedRows[0].Name));
    //  this.handleArray();
     this.serviceName=JSON.stringify(selectedRows[0].Name);
     this.actualserviceId=JSON.stringify(selectedRows[0].Id);
     
    //  this.tableData=this.serviceName;

    //To handle dynamic fields on Configure starts
    console.log('9303633this.Minimum_Price_check=JSON.stringify(selectedRows[0].Minimum_Price_check__c)'+JSON.stringify(selectedRows[0].Minimum_Price_check__c));
    this.Minimum_Price_check=selectedRows[0].Minimum_Price_check__c;
    this.Free_PickUp_Check=selectedRows[0].Free_PickUp_Check__c;
    this.Passive_Return_Check=selectedRows[0].Passive_Return_Check__C;
    this.Weight_Interval_From_Check=selectedRows[0].Weight_Interval_From_Check__c;
    this.Weight_Interval_To_Check=selectedRows[0].Weight_Interval_To_Check__c;
    this.Local_Domestic_Check=selectedRows[0].Local_Domestic_Check__c;
    this.Conversion_Factor_Check=selectedRows[0].Conversion_Factor_Check__c;
    this.Is_Payer_Receiver_or_Sender_Check=selectedRows[0].Is_Payer_Receiver_or_Sender_Check__c;
    this.Terminals_Check=selectedRows[0].Terminals_Check__c;
    this.Direction_Terminals_Check=selectedRows[0].Direction_Terminals_Check__c;
    this.Annual_Service_Value_Check=selectedRows[0].Annual_Service_Value_Check__c;
    this.Discount_Check=selectedRows[0].Discount_Check__c;

    //To handle dynamic fields on Configure ends

    // this.storeMultipleValueTempArray=[];
    this.storeMultipleValueTempArray=[];
    this.storeMultipleValueTempArraySurcharge=[];

    this.tableData= [
        {
            Id: this.actualserviceId,
            Name: this.serviceName,
          
        },
        
     
    ];
    // this.data=this.tableData;
     console.log('this.actualserviceId inside selectedRows '+this.actualserviceId);

  
    this.makeid(24);
    // console.log('function makeid' + makeid(24));

    
        
    //  this.grouplineItemId=(makeid(5));
    //  this.activeSectioName=(makeid(5));
    //  this.activeSectioNSurcharge=(makeid(5));
    //  this.makeArrayEmpty=0;
    const selectedEvent = new CustomEvent("progressvaluechange", {
        // detail: this.progressValue,
        detail: this.serviceName
      });
  
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

    
    
}
}
//handleRowSelection ends




//<--Add Service Methods Ends-->


 //Configure Service Methods starts
 @wire(Pricebook2IdList,{recordId:'$recordId'})Pricebook2IdList({data,error}){
    if (data) {
        this.pricebook2IDdata=data;
        console.log("data Pricebook2IdList :" +JSON.stringify(this.pricebook2IDdata))
        this.Pricebook2Idvalue=this.pricebook2IDdata[0].Opportunity.Pricebook2Id;
        this.CurrencyIsoCodevalue=this.pricebook2IDdata[0].Opportunity.CurrencyIsoCode;
        console.log("Pricebook2Id: "+this.Pricebook2Idvalue);
        console.log("this.CurrencyIsoCodevalue: "+this.CurrencyIsoCodevalue);
        console.log("currentactualServiceId"+this.currentactualServiceId);
        console.log("OppId"+this.recordId);

    } else if (error) {
    
        this.errorEmptyService=error;
        console.log("Pricebook2IdList Error:"+this.errorEmptyService);
    console.log(JSON.stringify(error));
    }else{
        console.log('No data available');
       
    }
}

strDiscount;
strAnnualServiceValue;
strMinimumPrice;
strcrm_Min_Weight__c;
strcrm_Max_Weight__c;
strcrm_Local__c;
strcrm_Conversion_Factor__c;
strIsPayerReceiverorSender__c;
strcrm_Free_Pickup__c;
strcrm_Passive_Return__c;
strcrm_Terminals__c;
strcrm_Direction__c;

value = 'All';
get options(){
    return [
        {label:'All', value:'All'},
        {label:'Alta', value:'Alta'},
        {label:'Drammen', value:'Drammen'},
        {label:'Fauske', value:'Fauske'},
        {label:'Gol', value:'Gol'},
        {label:'Hamar', value:'Hamar'},
        {label:'Harstad', value:'Harstad'},
        {label:'Haugesun', value:'Haugesun'},
        
    ];
}

value2 = 'local';
get options2(){
    return[
        {label: 'Local', value: 'Local'},
        {label: 'Domestic', value: 'Domestic'}
    ];
}

value4 = 'Standard';
get options4(){
    return[
        {label: 'Standard', value: 'Standard'},
        {label: '3', value: '3'},
        {label: '4', value: '4'},
        {label: '5', value: '5'},
        {label: '6', value: '6'},
        {label: '7', value: '7'},
        {label: 'Actual Weight', value: 'Actual Weight'}
    ];
}

value5 = 'Both';
get options5(){
    return[
        {label: 'Both', value: 'Both'},
        {label: 'Inbound', value: 'Inbound'},
        {label: 'Outbound', value: 'Outbound'}
    ];
}

value6 = 'Both';
get options6(){
    return[
        
        {label: 'Payer', value: 'Payer'},
        {label: 'Reciever', value: 'Reciever'},
        {label: 'Both', value: 'Both'}
    ];
}

value8 = 'Ordinary Service';
get options8(){
    return[
        {label: 'Both', value: 'Both'},
        {label: 'Ordinary Service', value: 'Ordinary Service'},
        {label: 'Passive Return', value: 'Passive Return'}
    ];
}

isNorwaySelected = false;
isSwedenSelected = false;
isOtherSelected = false;

handleNorway(event){
    this.isNorwaySelected = event.target.checked;
}
handleSweden(event){
    this.isSwedenSelected = event.target.checked;
}
handleOther(event){
    this.isOtherSelected = event.target.checked;
}

handleChange(event) {
    this.value = event.detail.value;
}

handleChange2(event) {
    this.value2 = event.detail.value;
    this.strcrm_Local__c=this.value2;
}

handleChange4(event) {
   this.value4 = event.detail.value;
    this.strcrm_Conversion_Factor__c= this.value4;
}

handleChange5(event) {
    this.value5 = event.detail.value5;
}

handleChange6(event) {
    this.value6 = event.detail.value6;
}
value7;
strFree_PickUp__c;
handleChange7(event){
this.value7=event.detail.value6;
this.strcrm_Free_Pickup__c=this.value7;
}

handleChange8(event) {
    this.value8 = event.detail.value8;
}

  
// strDiscount;
// strAnnualServiceValue;
// strMinimumPrice;
// strcrm_Min_Weight__c;
// strcrm_Max_Weight__c;
// strcrm_Local__c;
// strcrm_Conversion_Factor__c;

discountChangedHandler(event){
    this.strDiscount=event.target.value;
}

asvChangedHandler(event){
    this.strAnnualServiceValue=event.target.value;
}

priceChangeHandler(event){
    this.strMinimumPrice=event.target.value;
}

minWeightChangedHandler(event){
    this.strcrm_Min_Weight__c=event.target.value;
}

maxWeightChangedHandler(event){
    this.strcrm_Max_Weight__c=event.target.value;
}

// @track checkIfActuaServiceAdded;


resetFormAction(event) {
    const lwcInputFields =[...this.template.querySelectorAll('lightning-input')];
    if (lwcInputFields) {
        lwcInputFields.forEach(field => {
            field.reset();
        });
    }
 }

 navigateToViewOpportunityPage() { 
    this[NavigationMixin.Navigate]({ 
    type: 'standard__recordPage', 
    attributes: { recordId: this.recordId, objectApiName: 'Opportunity', actionName: 
    'view' }, 
    }); 
 }

addServices(){
    if(this.actualserviceId!=undefined){
    console.log("inside Add Service =this.actualServiceId"+this.actualserviceId);
    let str;
    str=this.actualserviceId;
    let modifiedstr;
    // modifiedstr=str.replace(/"/g,"");
    if(str!=undefined){
    modifiedstr=str.replace(/^"|"$/g, '');
     }  
 
    this.actualServiceIdModified=modifiedstr;
    console.log("inside Add Service =this.actualServiceIdModified: "+this.actualServiceIdModified);
///PriceBook Entry Code

console.log("--fetchPriceBookEntryId Starts--"+
    "this.actualServiceIdModified:"+this.actualServiceIdModified+
    "this.Pricebook2Idvalue"+this.Pricebook2Idvalue+
    "this.CurrencyIsoCodevalue"+this.CurrencyIsoCodevalue);
    fetchPriceBookEntryId({productId:this.actualServiceIdModified,Pricebook2Id:this.Pricebook2Idvalue,CurrencyIsoCode:this.CurrencyIsoCodevalue}).then(result => {
    // fetchPriceBookEntryId
    
    // console.log("actualServiceIdModified:this.actualServiceIdModified,Pricebook2Idvalue:this.Pricebook2Idvalue,CurrencyIsoCodevalue:this.CurrencyIsoCodevalue"+this.actualServiceIdModified,this.Pricebook2Idvalue,this.CurrencyIsoCodevalue);

// let PricebookEntryTemp;
this.PricebookEntrydata=result;
this.PricebookEntryvalue=this.PricebookEntrydata[0].Id;


console.log("this.PricebookEntrydata: "+this.PricebookEntrydata);
console.log("JSON.stringify(this.PricebookEntrydata: "+JSON.stringify(this.PricebookEntrydata));
// this.PricebookEntryvalue=this.PricebookEntrydata[0].Id;
console.log("this.PricebookEntryvalue: "+this.PricebookEntryvalue);
// this.error = undefined;
var fields = {'Discount' : this.strDiscount,
                 'UnitPrice' : this.strAnnualServiceValue,
                  'crm_Minimum_Price__c' : this.strMinimumPrice,
                  'crm_Min_Weight__c' : this.strcrm_Min_Weight__c,
                  'crm_Max_Weight__c' : this.strcrm_Max_Weight__c,
                  'crm_Local__c' : this.strcrm_Local__c,
                  'crm_Conversion_Factor__c': this.strcrm_Conversion_Factor__c,
                   'QuoteId':this.recordId,
                    'Product2Id':this.actualServiceIdModified,                          
                        'PricebookEntryId':this.PricebookEntryvalue,
                        'Group_Line_Item_Id__c':this.grouplineItemId,
                        'crm_Free_PickUp__c':this.strcrm_Free_Pickup__c,
                        'Quantity':1,
                        // 'crm_Conversion_Factor__c':'Standard'
                        // 'PricebookEntryId':'01u7a00000G47RtAAJ'

                };
    var objRecordInput = {'apiName' : 'QuoteLineItem', fields};
    if(objRecordInput!=undefined){
         createRecord(objRecordInput).then( response => {
  
        alert('Actual Service created with Id: ' +response.id);
        refreshApex(this.wiredOppLine);
            this.saveAddServices();
           this.saveAddServicesSurcharge();
        //    this.resetFormAction();
        // this.checkIfActuaServiceAdded=true;
        this.navigateToViewOpportunityPage();
        
    }).catch(error => {
        this.checkIfActuaServiceAdded=false;

        alert('Error:Please check if all the mandatory fields have value or not');
        console.log('Error: ' +JSON.stringify(error));

        // console.log('Error: ' +JSON.stringify(error));
    });
}

}).catch(error => {
    this.checkIfActuaServiceAdded=false;
this.error = error;
// this.PricebookEntryvalue = undefined;
window.alert('Please contact system admin or check if any mandatory field is blank or not: ' + JSON.stringify(this.error));
});



console.log("After fetchPriceBookEntryId method");
console.log(" this.PricebookEntrydata:"+ this.PricebookEntrydata);
console.log("this.PricebookEntryvalue:"+this.PricebookEntryvalue);
}else{

    alert('Please select Actual Service before clicking on Save button');
}
}


//Configure Service Methods ends-----------------------

//Additional Services Code starts--------------

@wire(Pricebook2IdList,{recordId:'$recordId'})Pricebook2IdList({data,error}){
    if (data) {
        this.pricebook2IDdata=data;
        console.log("data Pricebook2IdList :" +JSON.stringify(this.pricebook2IDdata))
        this.Pricebook2Idvalue=this.pricebook2IDdata[0].Pricebook2Id;
        this.CurrencyIsoCodevalue=this.pricebook2IDdata[0].CurrencyIsoCode;
        console.log("Pricebook2Id: "+this.Pricebook2Idvalue);
        console.log("this.CurrencyIsoCodevalue: "+this.CurrencyIsoCodevalue);
        console.log("currentactualServiceId"+this.currentactualServiceId);
        console.log("OppId"+this.recordId);

    } else if (error) {
    
        this.errorEmptyService=error;
        console.log("Pricebook2IdList Error:"+this.errorEmptyService);
    console.log(JSON.stringify(error));
    }else{
        console.log('No data available');
       
    }
}




@wire(fetchAdditionalServices,{currentactualServiceId:'$actualserviceId'}) wiredProduct_Relation__c({data,error}){
    if (data) {
        this.additionalServiceList=data;

    } else if (error) {
    
        this.errorEmptyService=error;
        console.log(this.errorEmptyService);
    console.log(JSON.stringify("fetchAdditionalServices error: "+error));
    }else{
        console.log('No data available');
       
    }
}

@wire(fetchSurcharges,{currentactualServiceId:'$actualserviceId'})wiredProduct_Relation__cSurcharges({data,error}){
   if (data) {
       this.additionalServiceSurchage=data;
       JSON.stringify('this.additionalServiceSurchage'+this.additionalServiceSurchage);
    
   } else if (error) {
    this.errorEmptyService=error;
    console.log("fetchSurcharges error: "+this.errorEmptyService);
    console.log(JSON.stringify(error));
   } else {
    console.log('No data available');
   
}


}


checkvalueblankRow(){

    console.log("inside checkvalueblankRow");

}

@api makeArrayEmptyMethod(){
    console.log("inside - @api makeArrayEmptyMethod(){");
  
    console.log("makeArrayEmptyMethod");
    console.log("Inside Additonal service :this.actualServiceId"+this.actualserviceId);
   
        this.SelectedSurchargeValues=[];

    console.log("this.SelectedSurchargeValues"+this.SelectedSurchargeValues);
    this.SelectedValues=[];
  
    console.log("this.SelectedValues"+this.SelectedValues);


}

@track index;
@track strCheckBoxValue;


handleCheckboxChange(event){
    this.strCheckBoxValue=event.target.value;
    console.log("this.strCheckBoxValue"+this.strCheckBoxValue)
    if (event.target.checked) {
        this.SelectedValues.push( this.strCheckBoxValue);
        
    } else {
        try {
            this.index = this.SelectedValues.indexOf( this.strCheckBoxValue);
            this.SelectedValues.splice(this.index, 1);
        } catch (err) {
            //error message
            str ="Error Selecting Services";
            console.log("Error Selecting Services: "+str)
        }
    }
    console.log('selected vas checkbox are : '+JSON.stringify(this.SelectedValues));
    // alert('selected checkbox are : '+JSON.stringify(this.SelectedValues));
}

@track index;
@track strCheckBoxSurchargeValue;


handleCheckboxChangeSurcharge(event){
    this.strCheckBoxSurchargeValue=event.target.value;
    console.log("this.strCheckBoxSurchargeValue"+this.strCheckBoxSurchargeValue)
    if (event.target.checked) {
        this.SelectedSurchargeValues.push( this.strCheckBoxSurchargeValue);
    } else {
        try {
            this.index = this.SelectedSurchargeValues.indexOf( this.strCheckBoxSurchargeValue);
            this.SelectedSurchargeValues.splice(this.index, 1);
        } catch (err) {
            //error message
            str ="Error Selecting Services";
            console.log("Error Selecting Services: "+str)
        }
    }
    console.log('selected surcharge checkbox are : '+JSON.stringify(this.SelectedSurchargeValues));



}

handleactivesection(event){
    this.activeSectionName=event.detail;
      }


  handlactiveSectionSurcharge(event){
    this.activeSectionSurcharge=event.detail;
  } 


  toggleSectionHandleVAS(event){

    var activesectionlengthcheck=[];
    activesectionlengthcheck=this.activeSectionName;

    if(activesectionlengthcheck){
    if(activesectionlengthcheck.length == 0){
        this.activeSectionName =''
    }
    else{
        this.activeSectionName ='VAS'
    }
    }
    // // this.currentactualservicetype="Vas";
    this.currentactualServiceId=this.actualserviceId;
    
    console.log("additionalServiceList: "+ this.additionalServiceList);
    console.log("additionalServiceList JSon: "+ JSON.stringify(this.additionalServiceList));

}


toggleSectionHandleSurcharge(event) {
    // var openSectionsvar = event.detail.openSections;
    // this.sectionselectedapi=this.openSections;
    // console.log('Surcharge section:'+event.detail.openSections);
    // this.actualservicetype="Surcharge";
    // this.currentactualservicetype="Surcharge";
    var activesectionlengthSurchargecheck=[];
    activesectionlengthSurchargecheck=this.activeSectionName;
    if(activesectionlengthSurchargecheck){
    if(activesectionlengthSurchargecheck.length == 0){
        this.activeSectionSurcharge =''
    }
    else{
        this.activeSectionSurcharge ='Surcharge'
    }
 }
    // if(this.activeSectionSurcharge.length === 0){
    //     this.activeSectionSurcharge =''
    // }
    this.currentactualServiceId=this.actualserviceId;

    console.log("additionalServiceSurchage: "+ this.additionalServiceSurchage);
    console.log("additionalServiceSurchage JSon: "+ JSON.stringify(this.additionalServiceSurchage));
}

handleDiscountChange(event){

    // var DiscountArray=[];
       let named;
       named = event.detail.name;
       let dataidd;
       dataidd=event.target.dataset.vasId;
       let valueDiscount;
       valueDiscount=event.detail.value;

       let discountData = new Object();

       discountData.name=named;
       discountData.dataid=dataidd;
       discountData.discountValue=valueDiscount;
       this.discountDataList.push(discountData);       

       console.log("this.discountDataList"+JSON.stringify(this.discountDataList));

    }


//Enable and Disable field on Additional Service section starts
// @track DisableDiscountVAS=false;
// @track DisableUnitVAS=false;
    Handlefieldvisibility(){

        // if(this.additionalServiceList.length>=1){

          let addid;
          
            // if(this.SelectedValues.length>=1){
   
             for(let i=0;i<this.additionalServiceList.length;i++)
             {
                addid=this.additionalServiceList[i].Additional_Service__r.Id;
                var discountTemp = this.template.querySelector('[data-id="'+addid+'"]').value;

                var unitTemp= this.template.querySelector('[data-unit-id="'+addid+'"]').value;
                

              if (discountTemp!=='' && discountTemp!==undefined){

                    // this.DisableDiscountVAS=false;
                    this.template.querySelector('[data-id="'+addid+'"]').disabled=false;
                    // this.DisableUnitVAS=true;
                    this.template.querySelector('[data-unit-id="'+addid+'"]').disabled=true;

                 }else if(unitTemp!=='' && unitTemp!==undefined){
                    // this.DisableDiscountVAS=true;
                    this.template.querySelector('[data-id="'+addid+'"]').disabled=true;
                    // this.DisableUnitVAS=false;
                    this.template.querySelector('[data-unit-id="'+addid+'"]').disabled=false;
                 } else if((discountTemp==='' || discountTemp===undefined) && (unitTemp==='' || unitTemp===undefined)){
                    //  this.DisableDiscountVAS=false;
                    //  discountTemp.disabled=false;
                    this.template.querySelector('[data-id="'+addid+'"]').disabled=false;
                    //  this.DisableUnitVAS=false;
                    this.template.querySelector('[data-unit-id="'+addid+'"]').disabled=false;
                 }

            //     crm_Actual_Service__c=addid;
            //     OpportunityId=this.recordId;
            //    //  addSerData.crm_Opp_Prod_Type__c='VAS';
            //     if(discountTemp!==undefined){
            //        crm_Discount__c=discountTemp;
            //     }
            //  //    var boolean=true;
            //     if(unitTemp!==undefined){
            //         UnitPrice =unitTemp;
                    
            //     }

            }
        }
                //  console.log("inside main loop"+i);
                //  for(let j=0;j<this.SelectedValues.length;j++){
                    //  console.log("inside inner loop"+j);
                    //  console.log("this.additionalServiceList[i].Additional_Service__r.Id"+this.additionalServiceList[i].Additional_Service__r.Id);
                    //  console.log("this.SelectedValues[j]"+this.SelectedValues[j])
   
   
                    //  if(this.additionalServiceList[i].Additional_Service__r.Id==this.SelectedValues[j]){      
                
                      // let addSerData = new Object();
   
                      // addSerData.crm_Actual_Service__c=addid;
                      // addSerData.OpportunityId=this.recordId;
              
   
                      // if(this.PricebookEntryvalue!=undefined){
                       //    console.log("this.PricebookEntryvalue is not equal to undefined : value: "+this.PricebookEntryvalue)
                    
                      
   
                    //   console.log(
                    //   "this.actualServiceIdModified:"+this.actualServiceIdModified+
                    //   "this.crm_Actual_Service__c"+crm_Actual_Service__c+
                    //   "this.Pricebook2Idvalue"+this.Pricebook2Idvalue+
                    //   "this.CurrencyIsoCodevalue"+this.CurrencyIsoCodevalue);
   
                //       fields = {
                //        'crmDiscountC': crm_Discount__c,
                //        'UnitPrice': UnitPrice,
                //        //   'crm_Minimum_Price__c' : this.strMinimumPrice,
                //        //   'crm_Min_Weight__c' : this.strcrm_Min_Weight__c,
                //        //   'crm_Max_Weight__c' : this.strcrm_Max_Weight__c,
                //        'OpportunityId': OpportunityId,
                //        'crmActualServiceC': crm_Actual_Service__c,
                //        'Pricebook2Id' : this.Pricebook2Idvalue,
                //        'CurrencyIsoCode':this.CurrencyIsoCodevalue
                //     //    'PricebookEntryId': PricebookEntryIdinsave
                //    //  'PricebookEntryId':'01uw000000wdcQQAAY' 
                //    };
                //    console.log("fields" + JSON.stringify(fields));
                   // objRecordInput = { 'apiName': 'OpportunityLineItem', fields };
                //    console.log(" createRecord(objRecordInput).then(response => {");
   
                  
           //  console.log('objRecordInput'+JSON.stringify(objRecordInput));
            // console.log("pushing the data addSerData.PricebookEntryId=this.PricebookEntryvalue------storeMultipleDetailsList.push(addSerData)");
            // console.log("this.PricebookEntryvalue before data push"+this.PricebookEntryvalue);
   
   
   
            // console.log('ValueDiscountVAS inside loop : -'+JSON.stringify(storeMultipleDetailsList));
                     
            // else{
            //     return;
            // }
            // storeMultipleDetailsList.push(fields);
        //  }
       
   
    //  }
    // console.log("Outside first loop");
   //  storeMultipleDetailsList.push(objRecordInput);
   // storeMultipleDetailsList.push(fields);
//    this.storeMultipleValueTempArray=JSON.stringify(storeMultipleDetailsList);
//     console.log("storeMultipleDetailsList outside first loop: "+storeMultipleDetailsList);
//     console.log('storeMultipleDetailsList outside first loop : -'+JSON.stringify(storeMultipleDetailsList));
   
//    }
   // ({ productId: crm_Actual_Service__c, Pricebook2Id: this.Pricebook2Idvalue, CurrencyIsoCode: this.CurrencyIsoCodevalue })
   
  
   
   
//    }
           
   
//    console.log('storeMultipleDetailsList outside second loop inside save method : -'+JSON.stringify(storeMultipleDetailsList));
   
// }


    // }


//Enable and Disable field on Additional Service section ends 


showSuccessToastonSave() {
        const evt = new ShowToastEvent({
            title: 'Success',
            message: 'You have successfully saved the additional services!!',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }


//Passing Data to apex method and Save he data starts
    
    saveAddServices(){
        let crm_Discount__c;
        let UnitPrice;
        // let PricebookEntryIdinsave;
        let addid;
        let crm_Actual_Service__c;
        let OpportunityId;
        let storeMultipleDetailsList=[];
        // let objRecordInput;
        let fields;

       if(this.additionalServiceList.length>=1){


          
         if(this.SelectedValues.length>=1){

          for(let i=0;i<this.additionalServiceList.length;i++)
          {

              console.log("inside main loop"+i);
              for(let j=0;j<this.SelectedValues.length;j++){
                  console.log("inside inner loop"+j);
                  console.log("this.additionalServiceList[i].Additional_Service__r.Id"+this.additionalServiceList[i].Additional_Service__r.Id);
                  console.log("this.SelectedValues[j]"+this.SelectedValues[j])


                  if(this.additionalServiceList[i].Additional_Service__r.Id==this.SelectedValues[j]){      
                   addid=this.additionalServiceList[i].Additional_Service__r.Id;
                   var discountTemp = this.template.querySelector('[data-id="'+addid+'"]').value;

                   var unitTemp= this.template.querySelector('[data-unit-id="'+addid+'"]').value;

                   // let addSerData = new Object();

                   // addSerData.crm_Actual_Service__c=addid;
                   // addSerData.OpportunityId=this.recordId;
                   crm_Actual_Service__c=addid;
                   OpportunityId=this.recordId;
                  //  addSerData.crm_Opp_Prod_Type__c='VAS';
                   if(discountTemp!==undefined){
                      crm_Discount__c=discountTemp;
                   }
                //    var boolean=true;
                   if(unitTemp!==undefined){
                       UnitPrice =unitTemp;
                       
                   }

                   // if(this.PricebookEntryvalue!=undefined){
                    //    console.log("this.PricebookEntryvalue is not equal to undefined : value: "+this.PricebookEntryvalue)
                 
                   

                   console.log(
                   "this.actualServiceIdModified:"+this.actualServiceIdModified+
                   "this.crm_Actual_Service__c"+crm_Actual_Service__c+
                   "this.Pricebook2Idvalue"+this.Pricebook2Idvalue+
                   "this.CurrencyIsoCodevalue"+this.CurrencyIsoCodevalue);

                   fields = {
                    'crmDiscountC': crm_Discount__c,
                    'UnitPrice': UnitPrice,
                    //   'crm_Minimum_Price__c' : this.strMinimumPrice,
                    //   'crm_Min_Weight__c' : this.strcrm_Min_Weight__c,
                    //   'crm_Max_Weight__c' : this.strcrm_Max_Weight__c,
                    'OpportunityId': OpportunityId,
                    'crmActualServiceC': crm_Actual_Service__c,
                    'Pricebook2Id' : this.Pricebook2Idvalue,
                    'CurrencyIsoCode':this.CurrencyIsoCodevalue
                 //    'PricebookEntryId': PricebookEntryIdinsave
                //  'PricebookEntryId':'01uw000000wdcQQAAY' 
                };
                console.log("fields" + JSON.stringify(fields));
                // objRecordInput = { 'apiName': 'OpportunityLineItem', fields };
             //    console.log(" createRecord(objRecordInput).then(response => {");

               
        //  console.log('objRecordInput'+JSON.stringify(objRecordInput));
         console.log("pushing the data addSerData.PricebookEntryId=this.PricebookEntryvalue------storeMultipleDetailsList.push(addSerData)");
         console.log("this.PricebookEntryvalue before data push"+this.PricebookEntryvalue);



         console.log('ValueDiscountVAS inside loop : -'+JSON.stringify(storeMultipleDetailsList));
                  
         // else{
         //     return;
         // }
         storeMultipleDetailsList.push(fields);
     }
    

 }
 console.log("Outside first loop");
//  storeMultipleDetailsList.push(objRecordInput);
// storeMultipleDetailsList.push(fields);
this.storeMultipleValueTempArray=JSON.stringify(storeMultipleDetailsList);
 console.log("storeMultipleDetailsList outside first loop: "+storeMultipleDetailsList);
 console.log('storeMultipleDetailsList outside first loop : -'+JSON.stringify(storeMultipleDetailsList));

}
// ({ productId: crm_Actual_Service__c, Pricebook2Id: this.Pricebook2Idvalue, CurrencyIsoCode: this.CurrencyIsoCodevalue })

createOliRecords({ addSerData: this.storeMultipleValueTempArray,currentactualServiceId: this.currentactualServiceId,lineItemsGroupId:this.grouplineItemId }).then( response =>{
    if(response){
        console.log('response:->>'+response);
        console.log('response:->>'+JSON.stringify(response));
        if(response==true){
            refreshApex(this.wiredOppLine);
            this.showSuccessToastonSave();
        alert('Additional Services Added successfully');
        
        }
    }
    
        console.log("storeMultipleDetailsListafter :"+storeMultipleDetailsList);
        console.log("this.storeMultipleValueTempArray :"+this.storeMultipleValueTempArray);
    
        // console.log('result'+result);
        // this.createOliRecordsResponse 
        // let result =response.data;
        //     //    JSON.parse(result);
        //     //    console.log("response createOliRecords: "+result);
        //        console.log("response createOliRecords: "+JSON.stringify(result));
    
            //    alert('OLI created with Id: ' +result.id+'OpportunityId:'+result.OpportunityId);
           }).catch(error => {
               alert('Error: ' +JSON.stringify(error));
               console.log('Error: ' +JSON.stringify(error));
           }); 


}
        

console.log('storeMultipleDetailsList outside second loop inside save method : -'+JSON.stringify(storeMultipleDetailsList));

}
console.log("storeMultipleDetailsList before"+storeMultipleDetailsList);
//  this.storeMultipleValueTempArray= JSON.parse(JSON.stringify(storeMultipleDetailsList));
this.storeMultipleValueTempArray=JSON.stringify(storeMultipleDetailsList);

// var TemarrayString=JSON.stringify(this.storeMultipleValueTempArray);
// var otherContactsString=JSON.stringify(this.storeMultipleValueTempArray);
console.log("this.storeMultipleValueTempArray"+this.storeMultipleValueTempArray);
// console.log("otherContactsString: "+otherContactsString);

// fetchPriceBookEntryId({ productId: crm_Actual_Service__c, Pricebook2Id: this.Pricebook2Idvalue, CurrencyIsoCode: this.CurrencyIsoCodevalue }).

   
// testMethodjs({ abc: 'TemarrayString' });
// 
   



} 


 HandlefieldvisibilitySurcharge(){

      let addid;
      
         for(let i=0;i<this.additionalServiceSurchage.length;i++)
         {
            addid=this.additionalServiceSurchage[i].Additional_Service__r.Id;

            var discountTemp = this.template.querySelector('[data-surchargediscount-id="'+addid+'"]').value;

            var unitTemp= this.template.querySelector('[data-surchargeunit-id="'+addid+'"]').value;
            
          if (discountTemp!=='' && discountTemp!==undefined){

                // this.DisableDiscountVAS=false;
                this.template.querySelector('[data-surchargediscount-id="'+addid+'"]').disabled=false;
                // this.DisableUnitVAS=true;
                this.template.querySelector('[data-surchargeunit-id="'+addid+'"]').disabled=true;

             }else if(unitTemp!=='' && unitTemp!==undefined){
         
                this.template.querySelector('[data-surchargediscount-id="'+addid+'"]').disabled=true;
           
                this.template.querySelector('[data-surchargeunit-id="'+addid+'"]').disabled=false;
             } else if((discountTemp==='' || discountTemp===undefined) && (unitTemp==='' || unitTemp===undefined)){
      
                this.template.querySelector('[data-surchargediscount-id="'+addid+'"]').disabled=false;
              
                this.template.querySelector('[data-surchargeunit-id="'+addid+'"]').disabled=false;
             }


        }
    }


saveAddServicesSurcharge(){
    let crm_Discount__c;
    let UnitPrice;
    // let PricebookEntryIdinsave;
    let addid;
    let crm_Actual_Service__c;
    let OpportunityId;
    let storeMultipleDetailsList=[];
    // let objRecordInput;
    let fields;

   if(this.additionalServiceSurchage.length>=1){

    
      
     if(this.SelectedSurchargeValues.length>=1){

      for(let i=0;i<this.additionalServiceSurchage.length;i++)
      {

          console.log("inside main loop"+i);
          for(let j=0;j<this.SelectedSurchargeValues.length;j++){
              console.log("inside inner loop"+j);
              console.log("this.additionalServiceSurchage[i].Additional_Service__r.Id"+this.additionalServiceSurchage[i].Additional_Service__r.Id);
              console.log("this.SelectedSurchargeValues[j]"+this.SelectedSurchargeValues[j])


              if(this.additionalServiceSurchage[i].Additional_Service__r.Id==this.SelectedSurchargeValues[j]){      
               addid=this.additionalServiceSurchage[i].Additional_Service__r.Id;
               var discountTemp = this.template.querySelector('[data-surchargediscount-id="'+addid+'"]').value;

               var unitTemp= this.template.querySelector('[data-surchargeunit-id="'+addid+'"]').value;

               // let addSerData = new Object();
console.log('discountTemp inside Surcharge:'+discountTemp);
console.log('unitTemp inside Surcharge:'+unitTemp)
               // addSerData.crm_Actual_Service__c=addid;
               // addSerData.OpportunityId=this.recordId;
               crm_Actual_Service__c=addid;
               OpportunityId=this.recordId;
              //  addSerData.crm_Opp_Prod_Type__c='VAS';
               if(discountTemp!==undefined){
                  crm_Discount__c=discountTemp;
               }
            //    var boolean=true;
               if(unitTemp!==undefined){
                   UnitPrice =unitTemp;
                   
               }

               // if(this.PricebookEntryvalue!=undefined){
                //    console.log("this.PricebookEntryvalue is not equal to undefined : value: "+this.PricebookEntryvalue)
             
               

               console.log(
               "this.actualServiceIdModified:"+this.actualServiceIdModified+
               "this.crm_Actual_Service__c"+crm_Actual_Service__c+
               "this.Pricebook2Idvalue"+this.Pricebook2Idvalue+
               "this.CurrencyIsoCodevalue"+this.CurrencyIsoCodevalue);

               fields = {
                'crmDiscountC': crm_Discount__c,
                'UnitPrice': UnitPrice,
                //   'crm_Minimum_Price__c' : this.strMinimumPrice,
                //   'crm_Min_Weight__c' : this.strcrm_Min_Weight__c,
                //   'crm_Max_Weight__c' : this.strcrm_Max_Weight__c,
                'OpportunityId': OpportunityId,
                'crmActualServiceC': crm_Actual_Service__c,
                'Pricebook2Id' : this.Pricebook2Idvalue,
                'CurrencyIsoCode':this.CurrencyIsoCodevalue
             //    'PricebookEntryId': PricebookEntryIdinsave
            //  'PricebookEntryId':'01uw000000wdcQQAAY' 
            };
            console.log("fields" + JSON.stringify(fields));
            // objRecordInput = { 'apiName': 'OpportunityLineItem', fields };
         //    console.log(" createRecord(objRecordInput).then(response => {");

           
    //  console.log('objRecordInput'+JSON.stringify(objRecordInput));
     console.log("pushing the data addSerData.PricebookEntryId=this.PricebookEntryvalue------storeMultipleDetailsList.push(addSerData)");
     console.log("this.PricebookEntryvalue before data push"+this.PricebookEntryvalue);



     console.log('ValueDiscountVAS inside loop : -'+JSON.stringify(storeMultipleDetailsList));
              
     // else{
     //     return;
     // }
     storeMultipleDetailsList.push(fields);
 }


}
console.log("Outside first loop");
//  storeMultipleDetailsList.push(objRecordInput);

this.storeMultipleValueTempArraySurcharge=JSON.stringify(storeMultipleDetailsList);
console.log("storeMultipleDetailsList outside first loop: "+storeMultipleDetailsList);
console.log('storeMultipleDetailsList outside first loop : -'+JSON.stringify(storeMultipleDetailsList));

}
// ({ productId: crm_Actual_Service__c, Pricebook2Id: this.Pricebook2Idvalue, CurrencyIsoCode: this.CurrencyIsoCodevalue })

createOliRecords({ addSerData: this.storeMultipleValueTempArraySurcharge,currentactualServiceId: this.currentactualServiceId,lineItemsGroupId:this.grouplineItemId }).then( response =>{
    if(response){
    console.log('response:->>'+response);
    console.log('response:->>'+JSON.stringify(response));
    if(response==true){
        // refreshApex(this.createOliRecords);
        refreshApex(this.wiredOppLine);
    alert('Additional Services Added successfully');
    }
    }
    
    console.log("storeMultipleDetailsListafter :"+storeMultipleDetailsList);
    console.log("this.storeMultipleValueTempArray :"+this.storeMultipleValueTempArraySurcharge);
    
    // console.log('result'+result);
    // this.createOliRecordsResponse 
    // let result =response.data;
    //     //    JSON.parse(result);
    //     //    console.log("response createOliRecords: "+result);
    //        console.log("response createOliRecords: "+JSON.stringify(result));
    
        //    alert('OLI created with Id: ' +result.id+'OpportunityId:'+result.OpportunityId);
       }).catch(error => {
           alert('Error: ' +JSON.stringify(error));
           console.log('Error: ' +JSON.stringify(error));
       });    
    




}
    

console.log('storeMultipleDetailsList outside second loop inside save method : -'+JSON.stringify(storeMultipleDetailsList));

}
console.log("storeMultipleDetailsList before"+storeMultipleDetailsList);
//  this.storeMultipleValueTempArray= JSON.parse(JSON.stringify(storeMultipleDetailsList));
// this.storeMultipleValueTempArraySurcharge=JSON.stringify(storeMultipleDetailsList);

// var TemarrayString=JSON.stringify(this.storeMultipleValueTempArray);
// var otherContactsString=JSON.stringify(this.storeMultipleValueTempArray);
console.log("this.storeMultipleValueTempArray"+this.storeMultipleValueTempArray);
// console.log("otherContactsString: "+otherContactsString);

// fetchPriceBookEntryId({ productId: crm_Actual_Service__c, Pricebook2Id: this.Pricebook2Idvalue, CurrencyIsoCode: this.CurrencyIsoCodevalue }).

// testMethodjs({ abc: 'TemarrayString' });
// 




}  
//Save Surcharge additional Services method Code ends here

//Additional Services Code ends


//View Service method starts
@wire(fetchOppLineRecord,{recordId:'$recordId'})wiredOppLine;

@api  columns1 =[
    { fieldName: 'Name', type:'text', wrapText: true, hideDefaultActions: true},
    {label: 'Type', fieldName: 'crm_Opp_Prod_Type__c',type:'text', editable: true }, 
    {label: 'Weight from', fieldName: 'crm_Min_Weight__c', type: 'number', editable: true},
    {label: 'Weight to', fieldName: 'crm_Max_Weight__c', type: 'number', editable: true},
          
    // {label: 'Actual Service Name', fieldName: 'actualServiceName', type:'text'}       
];

@api colums2 = [
{ label:'Name', fieldName: 'Name', type:'text', wrapText: true, hideDefaultActions: true}

];

@api columns3 = [
{label: 'Type', fieldName: 'crm_Opp_Prod_Type__c',type:'text', editable: true }
];

@api columns4 = [
{label: 'Weight from', fieldName: 'crm_Min_Weight__c', type: 'number', editable: true},
{label: 'Weight to', fieldName: 'crm_Max_Weight__c', type: 'number', editable: true}
];
//View Services ends ends



//Common Code for All starts

// saveAllServices(){

//     // this.addServices();

//     // this.saveAddServices();
//     // this.saveAddServicesSurcharge();

// }

// connectedCallback() {
//     console.log('connectedCallback starts 1');
//     this.saveAllServices();
//     console.log('connectedCallback end 2');
// }

// async saveAllServices() {
//     // try {
//         console.log('89598 try started');
//       await this.addServices();
//     //    .then(()=>{

//         console.log('89598 Method1: result:addServices() ' + 'result1'
//         +'--:checkIfActuaServiceAdded:'+this.checkIfActuaServiceAdded);

//         if(this.checkIfActuaServiceAdded===true){
//             console.log('89598 Method2: this.saveAddServices() this.saveAddServicesSurcharge() ');
//             this.saveAddServices();
//             this.saveAddServicesSurcharge();
//         }

    //    });
      
        // const result2 = await getTextMethod2({
        //     message1: result1
        // });
        // console.log('Method2 result: ' + result2);
        // const result3 = await getTextMethod3({
        //     message2: result2
        // });
        // console.log('Method3 result: ' + result3);
    // } catch(error) {
    //     console.log(error);
    // } finally {
    //     console.log('89598 Finally Block');
    // }
// }



//Common Code for All Ends






}