import { LightningElement, track, api } from 'lwc';
 
export default class LwcResetForm extends LightningElement {
    @api recordId;
    @api objectApiName="OpportunityLineItem"; 
    @api disabledButton;
    disabledButton=true;
   // recordId='00Nw0000008pu03';

 
   /* resetFormAction(event) {
        const lwcInputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (lwcInputFields) {
            lwcInputFields.forEach(field => {
                field.reset();
            });
        }
     }*/
}