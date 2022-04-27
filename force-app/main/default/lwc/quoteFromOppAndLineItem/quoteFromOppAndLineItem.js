import { LightningElement , wire , track , api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { NavigationMixin } from 'lightning/navigation';
import checkOpportunityQuote from '@salesforce/apex/opportunityToQuotesCreate.getOpprtunityCheck' ;
import createQuoteAndLineitem from '@salesforce/apex/opportunityToQuotesCreate.createQuoteAndLineitem' ;
import {CloseActionScreenEvent} from 'lightning/actions' ;

export default class QuoteFromOppAndLineItem extends NavigationMixin(LightningElement) {
@api quoteFound ;
@api recordId; 

@api a ;
@api b ;
@api c ;

connectedCallback(){
    window.clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
            this.CWLI() ;
        }, 0);
    
}

// this.createQouteAndLineIten();
cancelScreen(){
    this.dispatchEvent(new CloseActionScreenEvent());
}
fireToast(){
    if(this.a == true){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Quote has been created',
                variant: 'success',
            }),
        );
       } 
       if(this.b == false ){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Quote And Quote Line item Allready exist - Please clone quote then edit and SYNC',
                variant: 'success',
            }),
        );
       }
       if(this.c == true){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Quote Line item has been created',
                variant: 'success',
            }),
        );
       }
}
CWLI(){
    console.log('in cwli 11' + this.recordId) ;
    checkOpportunityQuote({ oppid : this.recordId }).then((result) => {
        this.a = result.qut ;
        this.b = result.qutcheck ;
        this.c = result.qutline ;
    this.fireToast() ;

    this.cancelScreen();
    }).catch((error) => {

    });
    }

}