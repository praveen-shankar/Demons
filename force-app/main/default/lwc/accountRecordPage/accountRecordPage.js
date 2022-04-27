import { LightningElement, api, wire, track } from 'lwc';
import OPPORTUNITYLINEITEM_OBJECT from '@salesforce/schema/OpportunityLineItem';
import DISCOUNT_FIELD from '@salesforce/schema/OpportunityLineItem.crm_Discount__c';
import ANNUALSERVICEVALUE_FIELD from '@salesforce/schema/OpportunityLineItem.UnitPrice';
import { getRecord } from 'lightning/uiRecordApi';


export default class accountRecordPage extends LightningElement {
    value = 'norway';

    get options() {
        return [
            { label: 'Norway', value: 'norway' },
            { label: 'Sweden', value: 'sweden' },
            { label: 'Other', value: 'other' },
        ];
    }

    handleChange(event) {
        this.value = event.detail.value;
    }

    opportunityLineItemObject=OPPORTUNITYLINEITEM_OBJECT;
    fields=[DISCOUNT_FIELD,ANNUALSERVICEVALUE_FIELD];
    record='0067a00000KoO4tAAF';
    @api record; 
    @wire(getRecord,{record:'$recordId', fields: [DISCOUNT_FIELD, ANNUALSERVICEVALUE_FIELD]})
   
    
    

    handleOpportunityCreated(){
        // Run code when account is created.
    }
    
}