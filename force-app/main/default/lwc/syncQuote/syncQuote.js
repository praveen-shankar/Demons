import { LightningElement , api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { NavigationMixin } from 'lightning/navigation';
import {CloseActionScreenEvent} from 'lightning/actions' ;
import syncquote from '@salesforce/apex/syncQuote.syncQuoteWithOpportunity' ;

export default class CloneQuoteAndQuoteLineItem extends NavigationMixin(LightningElement) {
    @api recordId;
    @api a ; b ; c ;
    connectedCallback(){
        window.clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
            this.syncQuoteAndLine() ;
        }, 0);
    }
    syncQuoteAndLine(){
        syncquote({ quoted : this.recordId }).then((result) => {
     this.a = result.quote_sync ; 
     console.log('hey' + this.a) ;
     this.b = result.quote_linesync ;
     console.log('hi' + this.b) ;
     this.c = result.oppLine_delete  ;
     console.log('hello' + this.c) ;
     this.cancelScreen();
        }).catch((error) => {
        }) ;
    }

    cancelScreen(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}