import { LightningElement, wire,api, track} from 'lwc';
import OPPORTUNITYLINEITEM_OBJECT from '@salesforce/schema/OpportunityLineItem';
// import Pricebook2IdList from '@salesforce/apex/ConfigureService.fetchPricebook2Id';
import Pricebook2IdList from '@salesforce/apex/AdditionalServiceslwc.fetchPricebook2Id';
import fetchPriceBookEntryId from '@salesforce/apex/ConfigureService.fetchPriceBookEntryId';
//import DISCOUNT_FIELD from '@salesforce/schema/OpportunityLineItem.crm_Discount__c';
//import MINIMUM_FIELD from '@salesforce/schema/OpportunityLineItem.crm_Minimum_Price__c';
//import ANNUALSERVICEVALUE_FIELD from '@salesforce/schema/OpportunityLineItem.UnitPrice';
import { getRecord } from 'lightning/uiRecordApi';
import { createRecord } from 'lightning/uiRecordApi';
// import Name from '@salesforce/schema/Opportunity.Name';
export default class ConfigureService extends LightningElement {
    
    // @api record='0067a00000KoO4tAAF';
    // @api record='0067a00000KoO7YAAV';
    @api recordId;
    // @api actaulService='01t7a000009xYHLAA2';
  @api actualServiceId;
//   @api actualServiceId;
    // @track actualServiceIdModified;
    @api actualServiceIdModified;
   
    // @api actualServiceIdModified=this.actualServiceId.replace(/"/g,"'");
    // @api PricebookEntryId='01uw000000wdcQQAAY';
    @api pricebook2IDdata=[];
    @api Pricebook2Idvalue;
    // @api Pricebook2Idvalue='01s7a000001umk1AAA';
    @api CurrencyIsoCodevalue;
    // @api CurrencyIsoCodevalue='DKK';
    @api PricebookEntrydata;
    @api PricebookEntryvalue;
    @api error;



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


    // @wire(fetchPriceBookEntryId,{actualServiceIdModified:'$actualServiceIdModified',Pricebook2Idvalue:'$Pricebook2Idvalue',CurrencyIsoCodevalue:'$CurrencyIsoCodevalue'})wiredfetchPriceBookEntryId({data,error}){
    //     if (data) {
    //         this.PricebookEntrydata=data;
    //         console.log("this.PricebookEntrydata"+this.PricebookEntrydata);

    //     } else if (error) {

    //         console.log(JSON.stringify(error));

    //     } else {
    //       console.log('No data available');
                   
    //     }
    // }
    
   @api testActualServiceId(){
       console.log("inside - @api testActualServiceId() ");

       this.strDiscount="";
       this.strAnnualServiceValue="";
      this.strMinimumPrice="";
    this.strcrm_Min_Weight__c="";
     this.strcrm_Max_Weight__c="";
     this.PricebookEntrydata=[];

    //   this.recordId,
    // this.actualServiceIdModified,                          
    //  this.PricebookEntryvalue
    //     if(this.actualServiceId!=undefined){
        // console.log("this.actualServiceId"+this.actualServiceId);
        // let str;
        // str=this.actualServiceId;
        // let modifiedstr;
        // // modifiedstr=str.replace(/"/g,"");
        // modifiedstr=str.replace(/^"|"$/g, '');

     
        // this.actualServiceIdModified=modifiedstr;
        // console.log("testActualServiceId:"+this.actualServiceIdModified);
    // }
    }
//Will add code later to fetch value dynamicaaly after demo
    // @wire(Pricebook2IdList,{recordId:'$recordId'})Pricebook2IdList({data,error}){
    //     if (data) {
    //         this.pricebook2IDdata=data;
    //         console.log("Inside Configure Service");
    //         console.log("data Pricebook2IdList :" +JSON.stringify(this.pricebook2IDdata))
    //         this.Pricebook2Idvalue=this.pricebook2IDdata[0].Pricebook2Id;
    //         this.CurrencyIsoCodevalue=this.pricebook2IDdata[0].CurrencyIsoCode;
    //         console.log("Pricebook2Id: "+this.Pricebook2Idvalue);
    //         console.log("this.CurrencyIsoCodevalue: "+this.CurrencyIsoCodevalue);
    //         console.log("currentactualServiceId"+this.currentactualServiceId);
    //         console.log("OppId"+this.recordId);
    
    //     } else if (error) {
        
    //         this.errorEmptyService=error;
    //         console.log(this.errorEmptyService);
    //     console.log(JSON.stringify(error));
    //     }else{
    //         console.log('No data available');
           
    //     }
    // }


    // connectedCallback() { 
    //     this.testActualServiceId();
    // }

    // testActualServiceId;

    // value = 'norway';
    // get options() {
    //     return [
    //         { label: 'Norway', value: 'norway' },
    //         { label: 'Sweden', value: 'sweden' },
    //         { label: 'Other', value: 'other' },
    //     ];
    // }

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
                {label: 'Local', value2: 'local'},
                {label: 'Domestic', value2: 'domestic'}
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
            this.value2 = event.detail.value2;
        }
          
        strDiscount;
        strAnnualServiceValue;
        strMinimumPrice;
        strcrm_Min_Weight__c;
        strcrm_Max_Weight__c

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

        addServices(){
            console.log("inside Add Service =this.actualServiceId"+this.actualServiceId);
            let str;
            str=this.actualServiceId;
            let modifiedstr;
            // modifiedstr=str.replace(/"/g,"");
            modifiedstr=str.replace(/^"|"$/g, '');
    
         
            this.actualServiceIdModified=modifiedstr;
            console.log("inside Add Service =this.actualServiceIdModified: "+this.actualServiceIdModified);
///PriceBook Entry Code

console.log("--fetchPriceBookEntryId Starts--"+
            "this.actualServiceIdModified:"+this.actualServiceIdModified+
            "this.Pricebook2Idvalue"+this.Pricebook2Idvalue+
            "this.CurrencyIsoCodevalue"+this.CurrencyIsoCodevalue);
    fetchPriceBookEntryId({productId:this.actualServiceIdModified,Pricebook2Id:this.Pricebook2Idvalue,CurrencyIsoCode:this.CurrencyIsoCodevalue}).then(result => {
        // console.log("actualServiceIdModified:this.actualServiceIdModified,Pricebook2Idvalue:this.Pricebook2Idvalue,CurrencyIsoCodevalue:this.CurrencyIsoCodevalue"+this.actualServiceIdModified,this.Pricebook2Idvalue,this.CurrencyIsoCodevalue);

        // let PricebookEntryTemp;
        this.PricebookEntrydata=result;
        this.PricebookEntryvalue=this.PricebookEntrydata[0].Id;

        
        console.log("this.PricebookEntrydata: "+this.PricebookEntrydata);
        console.log("JSON.stringify(this.PricebookEntrydata: "+JSON.stringify(this.PricebookEntrydata));
        // this.PricebookEntryvalue=this.PricebookEntrydata[0].Id;
        console.log("this.PricebookEntryvalue: "+this.PricebookEntryvalue);
        // this.error = undefined;
        var fields = {'crm_Discount__c' : this.strDiscount,
                         'UnitPrice' : this.strAnnualServiceValue,
                          'crm_Minimum_Price__c' : this.strMinimumPrice,
                          'crm_Min_Weight__c' : this.strcrm_Min_Weight__c,
                          'crm_Max_Weight__c' : this.strcrm_Max_Weight__c,
                           'OpportunityId':this.recordId,
                            'crm_Actual_Service__c':this.actualServiceIdModified,                          
                                'PricebookEntryId':this.PricebookEntryvalue
                                // 'PricebookEntryId':'01u7a00000G47RtAAJ'

                        };
            var objRecordInput = {'apiName' : 'OpportunityLineItem', fields};
            createRecord(objRecordInput).then(response => {
                alert('Account created with Id: ' +response.id);
            }).catch(error => {
                alert('Error: ' +JSON.stringify(error));
                console.log('Error: ' +JSON.stringify(error));
            });
       
    }).catch(error => {
        this.error = error;
        // this.PricebookEntryvalue = undefined;
        window.alert('Please contact system admin: ' + JSON.stringify(this.error));
    });
 
    
console.log("After fetchPriceBookEntryId method");
console.log(" this.PricebookEntrydata:"+ this.PricebookEntrydata);
console.log("this.PricebookEntryvalue:"+this.PricebookEntryvalue);
// this.showSuccessToastonSave();
        


//PriceBook Entry Code end

            // console.log("this.actualServiceIdModified"+this.actualServiceIdModified);
            // var fields = {'crm_Discount__c' : this.strDiscount,
            //              'UnitPrice' : this.strAnnualServiceValue,
            //               'crm_Minimum_Price__c' : this.strMinimumPrice,
            //               'crm_Min_Weight__c' : this.strcrm_Min_Weight__c,
            //               'crm_Max_Weight__c' : this.strcrm_Max_Weight__c,
            //                'OpportunityId':this.recordId,
            //                 'crm_Actual_Service__c':this.actualServiceIdModified,                          
            //                     'PricebookEntryId':this.PricebookEntryvalue
            //                     // 'PricebookEntryId':'01u7a00000G47RtAAJ'

            //             };
            // var objRecordInput = {'apiName' : 'OpportunityLineItem', fields};
            // createRecord(objRecordInput).then(response => {
            //     alert('Account created with Id: ' +response.id);
            // }).catch(error => {
            //     alert('Error: ' +JSON.stringify(error));
            //     console.log('Error: ' +JSON.stringify(error));
            // });
        }
        

    
    
   
   
    @api  columns =[
        // { fieldName: 'Id', type:'text', wrapText: true, hideDefaultActions: true },
        { fieldName: 'Name', type:'text', wrapText: true, hideDefaultActions: true }
        // { label: 'Last Name', fieldName: 'LastName',type:'text' },
        // { label: 'Email', fieldName: 'Email', type:'Email'}       
    ];
// @api actualServiceName;
@api progressValue;
// @track serviceName;

@api serviceName;
// if(thValue.length>0){
//     console.log('progressValue'+JSON.stringify(this.progressValue[0].Name));
//   }

// itemToForm ()  {
//     console.log('No values inside progressValue Variable') 
//     if(this.progressValue === undefined)
//      {
//         console.log('No values inside progressValue Variable') 
//         return
    
//     }else{
//     servicename=JSON.stringify(this.progressValue[0].Name);
    
//     console.log('servicename'+servicename);
// }
//     // The rest of the code
//   }
//   itemToForm;

  
//  servicename=JSON.stringify(this.progressValue['Name'].[0]);

//   hanldeProgressValueChange(event) {
//     this.progressValue = event.detail;
//     // JSON.stringify(this.progressValue);
//   }



//opportunityLineItemObject=OPPORTUNITYLINEITEM_OBJECT;
    //fields=[DISCOUNT_FIELD,ANNUALSERVICEVALUE_FIELD];
   // record='0067a00000KoO4tAAF';
   // @api record; 
    //@wire(getRecord,{record:'$recordId', fields: [DISCOUNT_FIELD, ANNUALSERVICEVALUE_FIELD]})
    
    //handleServiceConfigured(){
       /* var fields= {
            'crm_Discount__c':this.strDiscount,
            'UnitPrice':this.strAnnualServiceValue,
            'OpportunityId':this.record,
            'crm_Actual_Service__c':this.actaulService
            

        }
        var objRecordInput = {'apiName' : 'OpportunityLineItem', fields};
            createRecord(objRecordInput).then(response => {
                alert('Account created with Id: ' +response.id);
            }).catch(error => {
                alert('Error: ' +JSON.stringify(error));
                console.log('Error: ' +JSON.stringify(error));
            });*/
        
   // }

}



// insertContactData({contactDataString: JSON.stringify(storeMultipleDetailsList)}).then(result =>
// this.actualServiceIdModified='01t7a000009xYHLAA2';
// var a=this.actualServiceIdModified;
// var b=this.Pricebook2Idvalue;
// var c=this.CurrencyIsoCodevalue;
// console.log("a"+a+"b"+b+"c"+c);


   // fetchPriceBookEntryId({actualServiceIdModified:this.actualServiceIdModified,Pricebook2Idvalue:this.Pricebook2Idvalue,CurrencyIsoCodevalue:this.CurrencyIsoCodevalue}).then({data=>{

    // },error}){
    //     if (data) {
    //         this.PricebookEntrydata=data;
    //         console.log("this.PricebookEntrydata"+this.PricebookEntrydata);

    //     } else if (error) {

    //         console.log(JSON.stringify(error));

    //     } else {
    //       console.log('No data available');
                   
    //     }
    
    // }
    //             let newContactList = this.contactDataWrp;
    // for(let i = 0; i < result.length; i++){
    //     if(result[i] !== undefined){
    //         let contactRecord = {'sobjectType' : 'OpportunityLineItem'};
    //         contactRecord.Id = result[i].Id;
    //         contactRecord.FirstName = result[i].FirstName;
    //         contactRecord.LastName = result[i].LastName;
    //         contactRecord.AccountId = this.selectedAccount;
    //         newContactList.push(contactRecord);
    //     }
    // }
    // this.contactDataWrp = newContactList;
    // console.log('Saved data :' + this.contactDataWrp);
    // this.blankRow = []; 
    // this.index = newContactList.length;