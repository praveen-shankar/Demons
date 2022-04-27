import { LightningElement , wire , track , api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { NavigationMixin } from 'lightning/navigation';
import {CloseActionScreenEvent} from 'lightning/actions' ;
import checkOppQuoteAndLineItem from '@salesforce/apex/cloneQuoteAndQuoteLineItem.createQuoteAndLineItem' ;

export default class CloneQuoteAndQuoteLineItem extends NavigationMixin(LightningElement) {
    @api recordId;
 
    @api a ;
    @api b ;
    @api c ;

    connectedCallback(){
        window.clearTimeout(this.delayTimeout);
            this.delayTimeout = setTimeout(() => {
                this.callToCheckAndCreateQuoteAndLineItem() ;
            }, 0);
        
    }
callToCheckAndCreateQuoteAndLineItem(){
    checkOppQuoteAndLineItem({ quoted : this.recordId }).then((result) => {
        this.a = result.quote_cloned ;
        this.b = result.quoteLine_cloned ;
        this.c = result.quote_cannotBeCloned ;
        this.cancelScreen();
    }).catch((error) => {

    }) ;
}
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
}