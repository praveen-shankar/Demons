import { LightningElement,api,wire,track } from 'lwc';
import {refreshApex} from '@salesforce/apex';
import fetchAdditionalServices from '@salesforce/apex/AdditionalServiceslwc.AdditionalServices';
import fetchPriceBookEntryId from '@salesforce/apex/ConfigureService.fetchPriceBookEntryId';
import createOliRecords from '@salesforce/apex/AdditionalServiceslwc.createOliRecord';
import fetchSurcharges from '@salesforce/apex/AdditionalServiceslwc.AdditionalServicesSurcharge';
// import insertContactData from '@salesforce/apex/AdditionalServiceslwc.saveContactData';
import Pricebook2IdList from '@salesforce/apex/AdditionalServiceslwc.fetchPricebook2Id';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
// import testMethodjs from '@salesforce/apex/additionalServiceslwc.testMethodjs';
export default class AdditionalServices extends LightningElement {

  @api serviceName;
  @api actualServiceId;
  @api activeSectionName;
  @api activeSectionSurcharge;
  @api recordId;
  @api PricebookEntryId='01uw000000wdcQQAAY';
  @api Pricebook2Idvalue;
//   @api Pricebook2Idvalue='01s7a000001umk1AAA';

  @api CurrencyIsoCodevalue;
//   @api CurrencyIsoCodevalue='NOK';
  @api PricebookEntrydata;
  @api PricebookEntryvalue;
  @api storeMultipleValueTempArray;
//   @track storeMultipleDetails=[];
//   @api currentActiveSectionName='';
//   @track presentactivesectionName=this.currentActiveSectionName;
//   presentactivesectionName;
//   @api actualservicetype;
  @api additionalServiceList=[];
  @api additionalServiceSurchage=[];
  errorEmptyService='No Service available';
//   @api currentactualServiceId;
//   currentactualServiceId=this.actualServiceId;
//   currentactualServiceId;
//   @api currentactualServiceId;
  @api currentactualServiceId;
  @api makeArrayEmpty;
  @track SelectedValues=[];
  @track SelectedSurchargeValues=[];
  @track discountDataList = [];
  @track DiscountValueVAS='';
  @track UnitValueVAS;
//   @api  Pricebook2Idvalue;
//   @api  CurrencyIsoCodevalue;
  @track pricebook2IDdata=[];
@api createOliRecordsResponse=[];
//   @api currentactualservicetype;
// @track boleanvalue=true;
//-------selected additional services code starts-------------//
 @track contactDataWrp;
// @api blankRow = [];
// @track disabledCheckbox = true;
// @track index = 0;

    // @track selectedAccount;
    // @track accountName;
// @api myMethod(PARAMETER){
//     this.currentactualServiceId = PARAMETER;
// }

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




@wire(fetchAdditionalServices,{currentactualServiceId:'$currentactualServiceId'}) wiredProduct_Relation__c({data,error}){
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

@wire(fetchSurcharges,{currentactualServiceId:'$currentactualServiceId'})wiredProduct_Relation__cSurcharges({data,error}){
   if (data) {
       this.additionalServiceSurchage=data;
    
   } else if (error) {
    this.errorEmptyService=error;
    console.log("fetchSurcharges error: "+this.errorEmptyService);
    console.log(JSON.stringify(error));
   } else {
    console.log('No data available');
   
}


}
// setFirstName(event){
//     const eventName = event.target.name;
//     let blankRow = this.additionalServiceList;
//     blankRow[eventName].FirstName = event.target.value;
//     this.additionalServiceList = blankRow;
// }

// setLastName(event){
//     const eventName = event.target.name;
//     let blankRow = this.blankRow;
//     blankRow[eventName].LastName = event.target.value;
//     this.blankRow = blankRow;
// }
// container={};
// addRow(event){
//     this.index++;
//     let i = this.index;
//     let newContact = new Object();
//     this.container = this.additionalServiceList;
//     newContact.Id = i;
//     newContact.isChecked = false;
//     this.additionalServiceList = Object.assign([], this.additionalServiceList);
//     this.additionalServiceList.push(newContact);
//     // this.additionalServiceList.push(newContact);
//     this.additionalServiceList.push(this.container); 

  
// }
 
// setCheckBox(event){
//     // let temObj=new Object();
//       this.container = this.additionalServiceList;
//     if(this.container[event.target.name].isChecked){
//         this.container[event.target.name].isChecked = false;
//     }else{
//         this.container[event.target.name].isChecked = true;
//     }

//     // this.additionalServiceList = blankrow;
//     // this.additionalServiceList = Object.assign([], this.additionalServiceList);
//     // this.additionalServiceList.push(...blankrow);
//     // this.container = this.additionalServiceList.concat(...blankrow);
//     this.additionalServiceList.push(this.container);
//     // this.container[event.target.name] = event.detail.value;
// }


checkvalueblankRow(){
    // if(this.blankRow.length<1){
    //     this.blankRow=[];
    // this.wiredProduct_Relation__c({data,error});
    // this.wiredProduct_Relation__cSurcharges({data,error});
    // }
    // this.addRow();
    // this.myMethod(this.currentactualServiceId);
    // let localList=this.additionalServiceList;
    // this.blankRow=localList;
    // this.toggleSectionHandleVAS();
    // this.activeSectionName='VAS'
    console.log("inside checkvalueblankRow");

}

// checkvalueblankRow();
// if(additionalServiceList){
//     // this.blankRow=this.additionalServiceList;
//     Array.prototype.push.apply(this.blankRow, this.additionalServiceList);
// console.log("blankRow"+this.blankRow);
// }
// if(additionalServiceList!=undefined){

// }
//  this.blankRow=this.additionalServiceList;



// setCheckBox(event){
//     let blankrow = this.blankRow;
//     if(blankrow[event.target.name].isChecked){
//         blankrow[event.target.name].isChecked = false;
//     }else{
//         blankrow[event.target.name].isChecked = true;
//     }
//     this.blankRow.push(blankrow);
//     // this.blankRow = blankrow;
// }

// setDiscount(event){
//     const eventName = event.target.name;
//     let blankRow = this.additionalServiceList;
//     this.additionalServiceList[eventName].Discount = event.target.value;
//     this.additionalServiceList = blankRow;
// }

// setUnit(event){
//     const eventName = event.target.name;
//     let blankRow = this.additionalServiceList;
//     this.additionalServiceList[eventName].Unit = event.target.value;
//     this.additionalServiceList = blankRow;
// }


// saveData(event){
//     let blankRow = this.blankRow;
//     let contactDataList = [];
//     for(let i = 0; i < blankRow.length; i++){
//         if(blankRow[i] !== undefined && blankRow[i].isChecked){
//             let conData = new Object();
//             conData.AccountId = this.selectedAccount;
//             conData.FirstName = blankRow[i].FirstName;
//             conData.LastName = blankRow[i].LastName;
//             contactDataList.push(conData);
//         }
//     }
//     if(contactDataList.length > 0){
//         insertContactData({contactDataString: JSON.stringify(contactDataList)}).then(result => {
//             let newContactList = this.contactDataWrp;
//             for(let i = 0; i < result.length; i++){
//                 if(result[i] !== undefined){
//                     let contactRecord = {'sobjectType' : 'Contact'};
//                     contactRecord.Id = result[i].Id;
//                     contactRecord.FirstName = result[i].FirstName;
//                     contactRecord.LastName = result[i].LastName;
//                     contactRecord.AccountId = this.selectedAccount;
//                     newContactList.push(contactRecord);
//                 }
//             }
//             this.contactDataWrp = newContactList;
//             this.blankRow = []; 
//             this.index = newContactList.length;
//         }).catch(error => {
//             window.alert('Please contact system admin: ' + JSON.stringify(error));
//         })
//     }else{
//         window.alert('Please select any row to insert data.');
//     }
// }
//-------selected additional services code ends-------------//

//   closeAccordian(){
// this.activeSectionName='';
// // this.boleanvalue=false;
// arr.splice(0, arr.length)------------------------
@api makeArrayEmptyMethod(){
    console.log("inside - @api makeArrayEmptyMethod(){");
    // this.checkvalueblankRow();
    // this.toggleSectionHandleVAS();
    console.log("makeArrayEmptyMethod");
    console.log("Inside Additonal service :this.actualServiceId"+this.actualServiceId);
    // this.additionalServiceList=[];
    // this.makeArrayEmpty=makeArrayEmpty;
    // if(this.makeArrayEmpty==0){
        this.SelectedSurchargeValues=[];
    // this.SelectedSurchargeValues.splice(0,this.SelectedSurchargeValues.length);
    console.log("this.SelectedSurchargeValues"+this.SelectedSurchargeValues);
    this.SelectedValues=[];
    // this.SelectedValues.splice(0,this.SelectedValues.length);
    console.log("this.SelectedValues"+this.SelectedValues);
// }
// this.activeSectionName='VAS'
// var activesectionlengthcheck=[];
// activesectionlengthcheck=this.activeSectionName;
// if(activesectionlengthcheck){
// if(activesectionlengthcheck.length == 0){
//     this.activeSectionName =''
// }
// else{
//     this.activeSectionName ='VAS'
// }
// }

}

// connectedCallback(){
//     if(this.makeArrayEmpty==0){
//     this.SelectedSurchargeValues.splice(0,this.SelectedSurchargeValues.length);
//     console.log(this.SelectedSurchargeValues);

//     this.SelectedValues.splice(0,this.SelectedValues.length);
//     console.log(this.SelectedValues);
// }
// }

//   }

// strDiscount;
@track index;
@track strCheckBoxValue;

// strMinimumPrice;

// discountChangedHandler(event){
//     this.strDiscount=event.target.value;
// }

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

// priceChangeHandler(event){
//     this.strMinimumPrice=event.target.value;
// }
// ShowAddServices(event){
//     this.strCheckBoxValue=event.target.value;
//     console.log("this.strCheckBoxValue"+this.strCheckBoxValue)

// }



  handleactivesection(event){
    this.activeSectionName=event.detail;
      }


  handlactiveSectionSurcharge(event){
    this.activeSectionSurcharge=event.detail;
  } 
//   currentactualservicetype=this.actualservicetype;
//   currentactualservicetype;
  



    //    checkvalue(){
    //     if (actualserviceId!=this.currentactualServiceId) {
    //         alert('Ids does not match : '+this.actualserviceId+' != '+this.currentactualServiceId);
    //         refreshApex(this.wiredProduct_Relation__c);
    //     }
    //   }
    //   checkvalue;
   toggleSectionHandleVAS(event){
        // console.log('toggleSectionHandleVAS -----VAS section:'+event.detail.openSections);
        // const accordion = this.template.querySelector('.VASAccordianSection');
        // console.log('sname: '+this.serviceName);
        // console.log('sid: '+this.actualServiceId);
        // console.log("blankRow"+this.blankRow);
        // if(this.blankRow.length<1){

        // let blankrow;
        // blankrow=this.blankRow.splice(0, this.blankRow.length);
        // this.blankRow=blankrow;

        // this.blankrow=JSON.stringify(this.additionalServiceList);
        // console.log("blankrow value in VAS toggele"+this.blankrow);
   
        // this.myMethod(this.currentactualServiceId);
        // const localList=this.additionalServiceList;
        // this.blankRow=localList;
        // console.log("this.blankRow"+this.blankRow);
        // this.activeSectionName ='VAS'
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
        this.currentactualServiceId=this.actualServiceId;
        
        console.log("additionalServiceList: "+ this.additionalServiceList);
        console.log("additionalServiceList JSon: "+ JSON.stringify(this.additionalServiceList));
          //   }
        //   if (this.blankRow.length>=this.additionalServiceList.length) {
            // this.blankRow=[];
            // let blankrow;
            //  blankrow=(this.blankRow).splice(0, (this.blankRow).length);
            //  this.blankRow=blankrow;
            //  this.blankRow=JSON.stringify(this.additionalServiceList);
        // }
        // if(this.blankRow.length<1){
    //   let localList=this.additionalServiceList;
    //     this.blankRow=localList;
    //    console.log("this.blankRow vas toggle: "+this.blankRow)
        //   }
        // if(this.additionalServiceList){
        //         // this.blankRow=this.additionalServiceList;
        //         // Array.prototype.push.apply(this.blankRow, this.additionalServiceList);
        //     // console.log("blankRow"+this.blankRow);
        //     console.log("this.blankRow Json"+JSON.stringify(this.blankRow));
        //     }
        // accordion.activeSectionName = 'VAS';
        // activeSectionName='VAS';
        // console.log(this.additionalServiceList);
        // console.log('with Stringify'+JSON.stringify(this.additionalServiceList));
        // // console.log('values printed separataly--'+' this.additionalServiceList[0].Id: '+this.additionalServiceList[0].Id+' this.additionalServiceList[0].Additional_Service__r.Name: '+this.additionalServiceList[0].Additional_Service__r.Name)
        // console.log(' console.log(this.actualServiceId);'+this.actualServiceId);
        // console.log('inside toggleSectionHandleVAS "currentactualServiceId": '+this.currentactualServiceId);
        // console.log('inside toggleSectionHandleVAS "currentactualservicetype": '+this.currentactualservicetype);

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
            this.currentactualServiceId=this.actualServiceId;

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
         }
        

     }
     console.log("Outside first loop");
    //  storeMultipleDetailsList.push(objRecordInput);
    storeMultipleDetailsList.push(fields);

     console.log("storeMultipleDetailsList outside first loop: "+storeMultipleDetailsList);
     console.log('storeMultipleDetailsList outside first loop : -'+JSON.stringify(storeMultipleDetailsList));
 
    }
    // ({ productId: crm_Actual_Service__c, Pricebook2Id: this.Pricebook2Idvalue, CurrencyIsoCode: this.CurrencyIsoCodevalue })
   
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

createOliRecords({ addSerData: this.storeMultipleValueTempArray,currentactualServiceId: this.currentactualServiceId }).then( response =>{
    console.log('createOliRecords'+'this.storeMultipleValueTempArray-->'+this.storeMultipleValueTempArray+'this.currentactualServiceId-->'+this.currentactualServiceId);

    
    if(response){
        console.log('response:->>'+response);
        console.log('response:->>'+JSON.stringify(response));
        if(response==true){
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
// testMethodjs({ abc: 'TemarrayString' });
// 
       



}   
}           

                                //  fetchPriceBookEntryId({ productId: crm_Actual_Service__c, Pricebook2Id: this.Pricebook2Idvalue, CurrencyIsoCode: this.CurrencyIsoCodevalue }).then( async  result => {
                                     
                                //    console.log("Entered fetchPriceBookEntryId");
                                //    // console.log("actualServiceIdModified:this.actualServiceIdModified,Pricebook2Idvalue:this.Pricebook2Idvalue,CurrencyIsoCodevalue:this.CurrencyIsoCodevalue"+this.actualServiceIdModified,this.Pricebook2Idvalue,this.CurrencyIsoCodevalue);
                                //       // let PricebookEntryTemp;
                                //       this.PricebookEntrydata =  await result;
                                //       console.log("after this.PricebookEntrydata = await result;");
                                //       this.PricebookEntryvalue = this.PricebookEntrydata[0].Id;


                                    //   console.log("this.PricebookEntrydata: " + this.PricebookEntrydata);
                                    //   console.log("JSON.stringify(this.PricebookEntrydata: " + JSON.stringify(this.PricebookEntrydata));
                                    //   // this.PricebookEntryvalue=this.PricebookEntrydata[0].Id;
                                    //   console.log("this.PricebookEntryvalue: " + this.PricebookEntryvalue);

                                    //   let str;
                                    //   str = this.PricebookEntryvalue;
                                    //   let modifiedstrPBEntryId;
                                    //   // modifiedstr=str.replace(/"/g,"");
                                    //   modifiedstrPBEntryId = str.replace(/^"|"$/g, '');
                                    //   console.log("modifiedstrPBEntryId" + modifiedstrPBEntryId);

                                    //   PricebookEntryIdinsave = this.modifiedstrPBEntryId;
                                      // this.error = undefined;
                                      //             'crm_Discount__c' : this.strDiscount,
                                      //  'UnitPrice' : this.strAnnualServiceValue,
                                      //   'crm_Minimum_Price__c' : this.strMinimumPrice,
                                      //   'crm_Min_Weight__c' : this.strcrm_Min_Weight__c,
                                      //   'crm_Max_Weight__c' : this.strcrm_Max_Weight__c,
                                      //    'OpportunityId':this.recordId,
                                      //     'crm_Actual_Service__c':this.actualServiceIdModified,                          
                                      //         'PricebookEntryId':this.PricebookEntryvalue
                                






                                //   }).catch(error => {
                                //       alert('Error: ' + JSON.stringify(error));
                                //       console.log('Error: ' + JSON.stringify(error));
                                //       // this.error = error;
                                //       // this.PricebookEntryvalue = undefined;
                                //       window.alert('Please contact system admin: ' + JSON.stringify(this.error));
                                //   });



                                //   createRecord(objRecordInput).then( response => {
                                //    //    response;
                                //        console.log("response createRecord: "+response)
   
                                //        alert('Account created with Id: ' +response.id);
                                //    }).catch(error => {
                                //        alert('Error: ' +JSON.stringify(error));
                                //        console.log('Error: ' +JSON.stringify(error));
                                //    });

                               // }

                              

                               //    this.createRecord(this.objRecordInput);
                               // createRecord(this.objRecordInput);

                           

                                   // await this.method1();
                                   // let ObjRecInput=objrecord;
                                   // this.method1();
                                        
                     
                     
                                    






                    
                       
                       // getPricebookEntryId =new getPricebookEntryId();
                       // getPricebookEntryId();
         
                      
              

           // } ).catch(error => {
           //     alert('Error: ' +JSON.stringify(error));
           //     console.log('Error: ' +JSON.stringify(error));
           // });
  //PricebookEntry Id Code starts---------------
   //                     if(boolean=true){
  
   //                      console.log("inside ----- if(boolean=true){");
   //                     fetchPriceBookEntryId({productId:addid,Pricebook2Id:this.Pricebook2Idvalue,CurrencyIsoCode:this.CurrencyIsoCodevalue}).then(result => {
   //                     // console.log("actualServiceIdModified:this.actualServiceIdModified,Pricebook2Idvalue:this.Pricebook2Idvalue,CurrencyIsoCodevalue:this.CurrencyIsoCodevalue"+this.actualServiceIdModified,this.Pricebook2Idvalue,this.CurrencyIsoCodevalue);
  
   //                      // let PricebookEntryTemp;
   //                     this.PricebookEntrydata=result;
   //                     this.PricebookEntryvalue=this.PricebookEntrydata[0].Id;
  
      
   //                        console.log("this.PricebookEntrydata: "+this.PricebookEntrydata);
   //                        console.log("JSON.stringify(this.PricebookEntrydata: "+JSON.stringify(this.PricebookEntrydata));
   //                        // this.PricebookEntryvalue=this.PricebookEntrydata[0].Id;
   //                        console.log("this.PricebookEntryvalue: "+this.PricebookEntryvalue);
  
   //                        }).catch(error => {
   //                         this.error = error;
   //    // this.PricebookEntryvalue = undefined;
   //                         window.alert('Please contact system admin: ' + JSON.stringify(this.error));
   //                        });
  
   //                        }
                        //   console.log("if(boolean=true){----- ends");
  
  // fetchPriceBookEntryId();
  //PriceBookEntry Id Code ends-----------------
  
                             
                           //    if(this.PricebookEntryvalue!=undefined){
                           //        console.log("this.PricebookEntryvalue is not equal to undefined : value: "+this.PricebookEntryvalue)
                           //    let str;
                           //    str=this.PricebookEntryvalue;
                           //    let modifiedstrPBEntryId;
                           //    // modifiedstr=str.replace(/"/g,"");
                           //    modifiedstrPBEntryId=str.replace(/^"|"$/g, '');
                           //    console.log("modifiedstrPBEntryId"+modifiedstrPBEntryId);
                              
                           //    addSerData.PricebookEntryId=this.modifiedstrPBEntryId;
                           //    }
                           //    console.log(JSON.stringify(addSerData));
                           //    storeMultipleDetailsList.push(addSerData);
  //             addSerData.crm_Actual_Service__c = this.selectedAccount;
  //             addSerData.FirstName = blankRow[i].FirstName;
  //             addSerData.LastName = blankRow[i].LastName;
  //             contactDataList.push(conData);
  
  
  
                    //    console.log("discountTemp: -"+discountTemp);
                      //  this.storeMultipleDetails.push(discountTemp);
  
                      //  if(discountTemp!==undefined){
                      //     // this.storeMultipleDetails.push(discountTemp);
                      //     storeMultipleDetailsList.push(discountTemp);
                          
                      // //  this.storeMultipleDetails=discountTemp;
                      // }
                      // if(unitTemp!==undefined){
                      //     // this.storeMultipleDetails.push(unitTemp);
                      //     storeMultipleDetailsList.push(unitTemp);
  
                      // }
  
  
                      //  storeMultipleDetails = this.template.querySelector('DiscountVAS[data-id='+addid+']').value;
                    //         if(storeMultipleDetailsList.length > 0){
   //             console.log("---------------Inserting the data ---------------------")
   //                    insertContactData({contactDataString: JSON.stringify(storeMultipleDetailsList)}).then(result => {
                      
   //            //             let newContactList = this.contactDataWrp;
   //            // for(let i = 0; i < result.length; i++){
   //            //     if(result[i] !== undefined){
   //            //         let contactRecord = {'sobjectType' : 'OpportunityLineItem'};
   //            //         contactRecord.Id = result[i].Id;
   //            //         contactRecord.FirstName = result[i].FirstName;
   //            //         contactRecord.LastName = result[i].LastName;
   //            //         contactRecord.AccountId = this.selectedAccount;
   //            //         newContactList.push(contactRecord);
   //            //     }
   //            // }
   //            // this.contactDataWrp = newContactList;
   //            // console.log('Saved data :' + this.contactDataWrp);
   //            // this.blankRow = []; 
   //            // this.index = newContactList.length;
              
   //        }).catch(error => {
   //            window.alert('Please contact system admin: ' + JSON.stringify(error));
   //        })
   //        this.showSuccessToastonSave();
   //    }else{
   //        window.alert('Please select any row to insert data.');
   //    }
       
   

//Passing Data to apex method and Save the data ends






//         //Testing Save Method starts--------------------------------------
//         saveAddServices(){
//              let crm_Discount__c;
//              let UnitPrice;
//              let PricebookEntryIdinsave;
//              let addid;
//              let crm_Actual_Service__c;
//              let OpportunityId;
//              let storeMultipleDetailsList=[];
//              var objRecordInput;
//              var fields;
   
//             if(this.additionalServiceList.length>=1){
   
   
               
//               if(this.SelectedValues.length>=1){
   
//                for(let i=0;i<this.additionalServiceList.length;i++)
//                {
   
//                    console.log("inside main loop"+i);
//                    for(let j=0;j<this.SelectedValues.length;j++){
//                        console.log("inside inner loop"+j);
//                        console.log("this.additionalServiceList[i].Additional_Service__r.Id"+this.additionalServiceList[i].Additional_Service__r.Id);
//                        console.log("this.SelectedValues[j]"+this.SelectedValues[j])
   
   
//                        if(this.additionalServiceList[i].Additional_Service__r.Id==this.SelectedValues[j]){      
//                         addid=this.additionalServiceList[i].Additional_Service__r.Id;
//                         var discountTemp = this.template.querySelector('[data-id="'+addid+'"]').value;
   
//                         var unitTemp= this.template.querySelector('[data-unit-id="'+addid+'"]').value;
   
//                         // let addSerData = new Object();
   
//                         // addSerData.crm_Actual_Service__c=addid;
//                         // addSerData.OpportunityId=this.recordId;
//                         crm_Actual_Service__c=addid;
//                         OpportunityId=this.recordId;
//                        //  addSerData.crm_Opp_Prod_Type__c='VAS';
//                         if(discountTemp!==undefined){
//                            crm_Discount__c=discountTemp;
//                         }
//                         var boolean=true;
//                         if(unitTemp!==undefined){
//                             UnitPrice =unitTemp;
                            
//                         }

//                         // if(this.PricebookEntryvalue!=undefined){
//                             console.log("this.PricebookEntryvalue is not equal to undefined : value: "+this.PricebookEntryvalue)
                      
                        

//                         console.log("--fetchPriceBookEntryId Starts--"+
//                         "this.actualServiceIdModified:"+this.actualServiceIdModified+
//                         "this.crm_Actual_Service__c"+crm_Actual_Service__c+
//                         "this.Pricebook2Idvalue"+this.Pricebook2Idvalue+
//                         "this.CurrencyIsoCodevalue"+this.CurrencyIsoCodevalue);

                   
                               

//                                   fetchPriceBookEntryId({ productId: crm_Actual_Service__c, Pricebook2Id: this.Pricebook2Idvalue, CurrencyIsoCode: this.CurrencyIsoCodevalue }).then( async  result => {
                                      
//                                     console.log("Entered fetchPriceBookEntryId");
//                                     // console.log("actualServiceIdModified:this.actualServiceIdModified,Pricebook2Idvalue:this.Pricebook2Idvalue,CurrencyIsoCodevalue:this.CurrencyIsoCodevalue"+this.actualServiceIdModified,this.Pricebook2Idvalue,this.CurrencyIsoCodevalue);
//                                        // let PricebookEntryTemp;
//                                        this.PricebookEntrydata =  await result;
//                                        console.log("after this.PricebookEntrydata = await result;");
//                                        this.PricebookEntryvalue = this.PricebookEntrydata[0].Id;


//                                        console.log("this.PricebookEntrydata: " + this.PricebookEntrydata);
//                                        console.log("JSON.stringify(this.PricebookEntrydata: " + JSON.stringify(this.PricebookEntrydata));
//                                        // this.PricebookEntryvalue=this.PricebookEntrydata[0].Id;
//                                        console.log("this.PricebookEntryvalue: " + this.PricebookEntryvalue);

//                                        let str;
//                                        str = this.PricebookEntryvalue;
//                                        let modifiedstrPBEntryId;
//                                        // modifiedstr=str.replace(/"/g,"");
//                                        modifiedstrPBEntryId = str.replace(/^"|"$/g, '');
//                                        console.log("modifiedstrPBEntryId" + modifiedstrPBEntryId);

//                                        PricebookEntryIdinsave = this.modifiedstrPBEntryId;
//                                        // this.error = undefined;
//                                        //             'crm_Discount__c' : this.strDiscount,
//                                        //  'UnitPrice' : this.strAnnualServiceValue,
//                                        //   'crm_Minimum_Price__c' : this.strMinimumPrice,
//                                        //   'crm_Min_Weight__c' : this.strcrm_Min_Weight__c,
//                                        //   'crm_Max_Weight__c' : this.strcrm_Max_Weight__c,
//                                        //    'OpportunityId':this.recordId,
//                                        //     'crm_Actual_Service__c':this.actualServiceIdModified,                          
//                                        //         'PricebookEntryId':this.PricebookEntryvalue
//                                      fields = {
//                                         'crm_Discount__c': crm_Discount__c,
//                                         'UnitPrice': UnitPrice,
//                                         //   'crm_Minimum_Price__c' : this.strMinimumPrice,
//                                         //   'crm_Min_Weight__c' : this.strcrm_Min_Weight__c,
//                                         //   'crm_Max_Weight__c' : this.strcrm_Max_Weight__c,
//                                         'OpportunityId': OpportunityId,
//                                         'crm_Actual_Service__c': crm_Actual_Service__c,
//                                         'PricebookEntryId': PricebookEntryIdinsave
//                                     //  'PricebookEntryId':'01uw000000wdcQQAAY'
    
//                                     };
//                                     console.log("fields" + JSON.stringify(fields));
//                                     objRecordInput = { 'apiName': 'OpportunityLineItem', fields };
//                                     console.log(" createRecord(objRecordInput).then(response => {");

                                   
                             






//                                    }).catch(error => {
//                                        alert('Error: ' + JSON.stringify(error));
//                                        console.log('Error: ' + JSON.stringify(error));
//                                        // this.error = error;
//                                        // this.PricebookEntryvalue = undefined;
//                                        window.alert('Please contact system admin: ' + JSON.stringify(this.error));
//                                    });



//                                    createRecord(objRecordInput).then( response => {
//                                     //    response;
//                                         console.log("response createRecord: "+response)
    
//                                         alert('Account created with Id: ' +response.id);
//                                     }).catch(error => {
//                                         alert('Error: ' +JSON.stringify(error));
//                                         console.log('Error: ' +JSON.stringify(error));
//                                     });

//                                 // }

                               

//                                 //    this.createRecord(this.objRecordInput);
//                                 // createRecord(this.objRecordInput);

                            

//                                     // await this.method1();
//                                     // let ObjRecInput=objrecord;
//                                     // this.method1();
                                         
                      
                      
                                     






                     
                        
//                         // getPricebookEntryId =new getPricebookEntryId();
//                         // getPricebookEntryId();
          
                       
               

//             // } ).catch(error => {
//             //     alert('Error: ' +JSON.stringify(error));
//             //     console.log('Error: ' +JSON.stringify(error));
//             // });
//    //PricebookEntry Id Code starts---------------
//     //                     if(boolean=true){
   
//     //                      console.log("inside ----- if(boolean=true){");
//     //                     fetchPriceBookEntryId({productId:addid,Pricebook2Id:this.Pricebook2Idvalue,CurrencyIsoCode:this.CurrencyIsoCodevalue}).then(result => {
//     //                     // console.log("actualServiceIdModified:this.actualServiceIdModified,Pricebook2Idvalue:this.Pricebook2Idvalue,CurrencyIsoCodevalue:this.CurrencyIsoCodevalue"+this.actualServiceIdModified,this.Pricebook2Idvalue,this.CurrencyIsoCodevalue);
   
//     //                      // let PricebookEntryTemp;
//     //                     this.PricebookEntrydata=result;
//     //                     this.PricebookEntryvalue=this.PricebookEntrydata[0].Id;
   
       
//     //                        console.log("this.PricebookEntrydata: "+this.PricebookEntrydata);
//     //                        console.log("JSON.stringify(this.PricebookEntrydata: "+JSON.stringify(this.PricebookEntrydata));
//     //                        // this.PricebookEntryvalue=this.PricebookEntrydata[0].Id;
//     //                        console.log("this.PricebookEntryvalue: "+this.PricebookEntryvalue);
   
//     //                        }).catch(error => {
//     //                         this.error = error;
//     //    // this.PricebookEntryvalue = undefined;
//     //                         window.alert('Please contact system admin: ' + JSON.stringify(this.error));
//     //                        });
   
//     //                        }
//                            console.log("if(boolean=true){----- ends");
   
//    // fetchPriceBookEntryId();
//    //PriceBookEntry Id Code ends-----------------
   
//                                console.log("pushing the data addSerData.PricebookEntryId=this.PricebookEntryvalue------storeMultipleDetailsList.push(addSerData)");
//                                console.log("this.PricebookEntryvalue before data push"+this.PricebookEntryvalue);
//                             //    if(this.PricebookEntryvalue!=undefined){
//                             //        console.log("this.PricebookEntryvalue is not equal to undefined : value: "+this.PricebookEntryvalue)
//                             //    let str;
//                             //    str=this.PricebookEntryvalue;
//                             //    let modifiedstrPBEntryId;
//                             //    // modifiedstr=str.replace(/"/g,"");
//                             //    modifiedstrPBEntryId=str.replace(/^"|"$/g, '');
//                             //    console.log("modifiedstrPBEntryId"+modifiedstrPBEntryId);
                               
//                             //    addSerData.PricebookEntryId=this.modifiedstrPBEntryId;
//                             //    }
//                             //    console.log(JSON.stringify(addSerData));
//                             //    storeMultipleDetailsList.push(addSerData);
//    //             addSerData.crm_Actual_Service__c = this.selectedAccount;
//    //             addSerData.FirstName = blankRow[i].FirstName;
//    //             addSerData.LastName = blankRow[i].LastName;
//    //             contactDataList.push(conData);
   
   
   
//                         console.log("discountTemp: -"+discountTemp);
//                        //  this.storeMultipleDetails.push(discountTemp);
   
//                        //  if(discountTemp!==undefined){
//                        //     // this.storeMultipleDetails.push(discountTemp);
//                        //     storeMultipleDetailsList.push(discountTemp);
                           
//                        // //  this.storeMultipleDetails=discountTemp;
//                        // }
//                        // if(unitTemp!==undefined){
//                        //     // this.storeMultipleDetails.push(unitTemp);
//                        //     storeMultipleDetailsList.push(unitTemp);
   
//                        // }
   
   
//                        //  storeMultipleDetails = this.template.querySelector('DiscountVAS[data-id='+addid+']').value;
//                             console.log('ValueDiscountVAS inside loop : -'+JSON.stringify(storeMultipleDetailsList));
                       
//                        // else{
//                        //     return;
//                        // }
//                    }
                  
   
//                }
//                console.log('ValueDiscountVAS outside loop : -'+JSON.stringify(storeMultipleDetailsList));
           
//               }
//             }
   
//             console.log('ValueDiscountVAS outside loop inside save method : -'+JSON.stringify(storeMultipleDetailsList));
//     //         if(storeMultipleDetailsList.length > 0){
//     //             console.log("---------------Inserting the data ---------------------")
//     //                    insertContactData({contactDataString: JSON.stringify(storeMultipleDetailsList)}).then(result => {
                       
//     //            //             let newContactList = this.contactDataWrp;
//     //            // for(let i = 0; i < result.length; i++){
//     //            //     if(result[i] !== undefined){
//     //            //         let contactRecord = {'sobjectType' : 'OpportunityLineItem'};
//     //            //         contactRecord.Id = result[i].Id;
//     //            //         contactRecord.FirstName = result[i].FirstName;
//     //            //         contactRecord.LastName = result[i].LastName;
//     //            //         contactRecord.AccountId = this.selectedAccount;
//     //            //         newContactList.push(contactRecord);
//     //            //     }
//     //            // }
//     //            // this.contactDataWrp = newContactList;
//     //            // console.log('Saved data :' + this.contactDataWrp);
//     //            // this.blankRow = []; 
//     //            // this.index = newContactList.length;
               
//     //        }).catch(error => {
//     //            window.alert('Please contact system admin: ' + JSON.stringify(error));
//     //        })
//     //        this.showSuccessToastonSave();
//     //    }else{
//     //        window.alert('Please select any row to insert data.');
//     //    }
        
//            }
//         //Testing Save Method ends----------------------------------------
        



//         }


   
        

//         saveAddServices(){
            
//          let   storeMultipleDetailsList=[];

//          if(this.additionalServiceList.length>=1){


            
//            if(this.SelectedValues.length>=1){

//             for(let i=0;i<this.additionalServiceList.length;i++)
//             {

//                 console.log("inside main loop"+i);
//                 for(let j=0;j<this.SelectedValues.length;j++){
//                     console.log("inside inner loop"+j);
//                     console.log("this.additionalServiceList[i].Additional_Service__r.Id"+this.additionalServiceList[i].Additional_Service__r.Id);
//                     console.log("this.SelectedValues[j]"+this.SelectedValues[j])


//                     if(this.additionalServiceList[i].Additional_Service__r.Id==this.SelectedValues[j]){      
//                      var addid=this.additionalServiceList[i].Additional_Service__r.Id;
//                      var discountTemp = this.template.querySelector('[data-id="'+addid+'"]').value;

//                      var unitTemp= this.template.querySelector('[data-unit-id="'+addid+'"]').value;

//                      let addSerData = new Object();

//                      addSerData.crm_Actual_Service__c=addid;
//                      addSerData.OpportunityId=this.recordId;
                    
//                     //  addSerData.crm_Opp_Prod_Type__c='VAS';
//                      if(discountTemp!==undefined){
//                         addSerData.crm_Discount__c=discountTemp;
//                      }
//                      var boolean=true;
//                      if(unitTemp!==undefined){
//                          addSerData.UnitPrice =unitTemp;
                         
//                      }
// //PricebookEntry Id Code starts---------------
//                      if(boolean=true){

//                       console.log("inside ----- if(boolean=true){");
//                      fetchPriceBookEntryId({productId:addid,Pricebook2Id:this.Pricebook2Idvalue,CurrencyIsoCode:this.CurrencyIsoCodevalue}).then(result => {
//                      // console.log("actualServiceIdModified:this.actualServiceIdModified,Pricebook2Idvalue:this.Pricebook2Idvalue,CurrencyIsoCodevalue:this.CurrencyIsoCodevalue"+this.actualServiceIdModified,this.Pricebook2Idvalue,this.CurrencyIsoCodevalue);

//                       // let PricebookEntryTemp;
//                      this.PricebookEntrydata=result;
//                      this.PricebookEntryvalue=this.PricebookEntrydata[0].Id;

    
//                         console.log("this.PricebookEntrydata: "+this.PricebookEntrydata);
//                         console.log("JSON.stringify(this.PricebookEntrydata: "+JSON.stringify(this.PricebookEntrydata));
//                         // this.PricebookEntryvalue=this.PricebookEntrydata[0].Id;
//                         console.log("this.PricebookEntryvalue: "+this.PricebookEntryvalue);

//                         }).catch(error => {
//                          this.error = error;
//     // this.PricebookEntryvalue = undefined;
//                          window.alert('Please contact system admin: ' + JSON.stringify(this.error));
//                         });

//                         }
//                         console.log("if(boolean=true){----- ends");

// // fetchPriceBookEntryId();
// //PriceBookEntry Id Code ends-----------------

//                             console.log("pushing the data addSerData.PricebookEntryId=this.PricebookEntryvalue------storeMultipleDetailsList.push(addSerData)");
//                             console.log("this.PricebookEntryvalue before data push"+this.PricebookEntryvalue);
//                             if(this.PricebookEntryvalue!=undefined){
//                                 console.log("this.PricebookEntryvalue is not equal to undefined : value: "+this.PricebookEntryvalue)
//                             let str;
//                             str=this.PricebookEntryvalue;
//                             let modifiedstrPBEntryId;
//                             // modifiedstr=str.replace(/"/g,"");
//                             modifiedstrPBEntryId=str.replace(/^"|"$/g, '');
//                             console.log("modifiedstrPBEntryId"+modifiedstrPBEntryId);
                            
//                             addSerData.PricebookEntryId=this.modifiedstrPBEntryId;
//                         }
//                             console.log(JSON.stringify(addSerData));
//                             storeMultipleDetailsList.push(addSerData);
// //             addSerData.crm_Actual_Service__c = this.selectedAccount;
// //             addSerData.FirstName = blankRow[i].FirstName;
// //             addSerData.LastName = blankRow[i].LastName;
// //             contactDataList.push(conData);



//                      console.log("discountTemp: -"+discountTemp);
//                     //  this.storeMultipleDetails.push(discountTemp);

//                     //  if(discountTemp!==undefined){
//                     //     // this.storeMultipleDetails.push(discountTemp);
//                     //     storeMultipleDetailsList.push(discountTemp);
                        
//                     // //  this.storeMultipleDetails=discountTemp;
//                     // }
//                     // if(unitTemp!==undefined){
//                     //     // this.storeMultipleDetails.push(unitTemp);
//                     //     storeMultipleDetailsList.push(unitTemp);

//                     // }


//                     //  storeMultipleDetails = this.template.querySelector('DiscountVAS[data-id='+addid+']').value;
//                          console.log('ValueDiscountVAS inside loop : -'+JSON.stringify(storeMultipleDetailsList));
//                     }
//                     // else{
//                     //     return;
//                     // }
//                 }
               

//             }
//             console.log('ValueDiscountVAS outside loop : -'+JSON.stringify(storeMultipleDetailsList));
        
//            }
//          }

//          console.log('ValueDiscountVAS outside loop inside save method : -'+JSON.stringify(storeMultipleDetailsList));
//          if(storeMultipleDetailsList.length > 0){
//              console.log("---------------Inserting the data ---------------------")
//                     insertContactData({contactDataString: JSON.stringify(storeMultipleDetailsList)}).then(result => {
                    
//             //             let newContactList = this.contactDataWrp;
//             // for(let i = 0; i < result.length; i++){
//             //     if(result[i] !== undefined){
//             //         let contactRecord = {'sobjectType' : 'OpportunityLineItem'};
//             //         contactRecord.Id = result[i].Id;
//             //         contactRecord.FirstName = result[i].FirstName;
//             //         contactRecord.LastName = result[i].LastName;
//             //         contactRecord.AccountId = this.selectedAccount;
//             //         newContactList.push(contactRecord);
//             //     }
//             // }
//             // this.contactDataWrp = newContactList;
//             // console.log('Saved data :' + this.contactDataWrp);
//             // this.blankRow = []; 
//             // this.index = newContactList.length;
            
//         }).catch(error => {
//             window.alert('Please contact system admin: ' + JSON.stringify(error));
//         })
//         this.showSuccessToastonSave();
//     }else{
//         window.alert('Please select any row to insert data.');
//     }
     
//         }

    

// saveData(event){
//     let blankRow = this.blankRow;
//     let contactDataList = [];
//     for(let i = 0; i < blankRow.length; i++){
//         if(blankRow[i] !== undefined && blankRow[i].isChecked){
//             let conData = new Object();
//             conData.AccountId = this.selectedAccount;
//             conData.FirstName = blankRow[i].FirstName;
//             conData.LastName = blankRow[i].LastName;
//             contactDataList.push(conData);
//         }
//     }
//     if(contactDataList.length > 0){
//         insertContactData({contactDataString: JSON.stringify(contactDataList)}).then(result => {
//             let newContactList = this.contactDataWrp;
//             for(let i = 0; i < result.length; i++){
//                 if(result[i] !== undefined){
//                     let contactRecord = {'sobjectType' : 'Contact'};
//                     contactRecord.Id = result[i].Id;
//                     contactRecord.FirstName = result[i].FirstName;
//                     contactRecord.LastName = result[i].LastName;
//                     contactRecord.AccountId = this.selectedAccount;
//                     newContactList.push(contactRecord);
//                 }
//             }
//             this.contactDataWrp = newContactList;
//             this.blankRow = []; 
//             this.index = newContactList.length;
//         }).catch(error => {
//             window.alert('Please contact system admin: ' + JSON.stringify(error));
//         })
//     }else{
//         window.alert('Please select any row to insert data.');
//     }
// }
   

            // if (openSections.length>0 && openSections.length<2) {
            //     // console.log('openSections :'+JSON.stringify(openSections));
            //     console.log('openSections[0] :'+JSON.stringify(openSections[0]));
            //     console.log('sectionselectedapi :'+JSON.stringify(this.sectionselectedapi));
            //     // console.log('openSections[0].name :'+JSON.stringify(openSections[0].name));
            //     // console.log('openSections[1] :'+JSON.stringify(openSections[1]));

            // } else if(openSections.length>1 && openSections.length<=2){
            //     // console.log('openSections :'+JSON.stringify(openSections));
            //     // console.log('openSections[0] :'+JSON.stringify(openSections[0]));
            //     // console.log('openSections[0].name :'+JSON.stringify(openSections[0].name));
            //     console.log('openSections[1] :'+JSON.stringify(openSections[1]));
            //     console.log('sectionselectedapi :'+this.sectionselectedapi);

            
            // }


            
            // if (openSections.length === 0) {
            //     this.activeSectionsMessage = 'All sections are closed';
            // } else {
            //     this.activeSectionsMessage=this.sectionselectedapi;
            //     // this.activeSectionsMessage ='Open sections: ' + openSections[0];
            //         // 'Open sections: ' + openSections.join(', ');
            //         // console.log('This is the active section'+this.activeSectionsMessage);
            //         console.log('This is current calue of selected section'+ this.sectionselectedapi)
            // }
    

        

//    @track activeSectionMessage = '';
//     // @api hellov='Keydown pressed';
//     handleToggleSection(event) {
//         this.activeSectionMessage =event.detail.openSections;
//         // var hellolocal='Hellonew';
//         //    this.hellolocal=this.hellov;
//            console.log('activeSectionMessageName : '+activeSectionMessage);
//     }
//     handleSetActiveSectionC() {
//         const accordion = this.template.querySelector('.allow-multiple-sections-open');

//         accordion.activeSectionName = 'SURCHARGE';
//     }
//     // Handelkeydown() {
//     //    var hellolocal='Hellonew';
//     // //    this.hellolocal=this.hellov;
//     //    console.log('hellolocal'+hellolocal);
//     // //   return hellolocal;
//     // }
  
//     // console.log('hellolocal'+hellolocal);
//     // console.log.('Hello' + this.hellolocal);
//     // Handelkeydown(hello);
// }