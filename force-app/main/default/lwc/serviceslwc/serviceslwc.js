import { LightningElement,track} from 'lwc';

export default class Serviceslwc extends LightningElement {

   // caseObject = CASE_OBJECT;
  //  subjectField = SUBJECT;
  //  productField = PRODUCT;
  //  descriptionField = DESCRIPTION;
  //  priorityField = PRIORITY;
  //  reasonField = REASON;
  //  categoryField = CASE_CATEGORY;

    @track clickedButtonLabel = 'Show Service Overview';  
    @track boolVisible = false;  
  
    handleClick(event) {  
        const label = event.target.label;  
  
        if ( label === 'Show Service Overview' ) {  
  
            this.clickedButtonLabel = 'Hide Service Overview';  
            this.boolVisible = true;  
  
        } else if  ( label === 'Hide Service Overview' ) {  
              
            this.clickedButtonLabel = 'Show Service Overview';  
            this.boolVisible = false;  
  
        }  
    }  
}