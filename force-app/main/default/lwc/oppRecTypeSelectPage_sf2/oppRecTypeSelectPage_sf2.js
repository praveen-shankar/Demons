import { LightningElement , wire , track , api } from 'lwc';
import getOpportunityRecordTypes from '@salesforce/apex/crm_customRecordTypePageOpportunity.getOpportunityRecordTypes_NewBusiness' ;
import { CloseActionScreenEvent  } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

export default class OppRecTypeSelectPage_sf2 extends NavigationMixin(LightningElement) {
    @api recordId;
    selectedValue;
    opp = [] ;
    //accid = '0017a00001a7tegAAA' ; //this.recordId ;//
    recordTypeId ;
    preselect ;
    @wire(getOpportunityRecordTypes , { accid: '$recordId' } )
    opptui({ error, data }) {
        if (data) {
            this.opp = data;
        } else if (error) {

        }
    }

    handleChange(event){
      var changeValue = event.target.value;
      this.recordTypeId = changeValue ;
 
    }
    cancel(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    next(){
        const defaultValues = encodeDefaultFieldValues(
            {AccountId: this.recordId }) ;
        let temp = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Opportunity',
                actionName: 'new'                  
            },
            state: {
                nooverride: '1',
                defaultFieldValues: defaultValues,
                recordTypeId: this.recordTypeId     
            }
        };
        this[NavigationMixin.Navigate](temp);  
    }
}