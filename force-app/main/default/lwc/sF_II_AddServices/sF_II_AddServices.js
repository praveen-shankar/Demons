import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SF_II_AddServices extends LightningElement {
 
        displayToastError() {
            const toastEvt = new ShowToastEvent({
                title: 'Error',
                message: 'Some Error Occurred',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(toastEvt);
        }
        displayToastSuccess() {
            const toastEvt = new ShowToastEvent({
                title: 'Success',
                message: 'Submitted Successfully ',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(toastEvt);
        }
        displayToastWarning() {
            const toastEvt = new ShowToastEvent({
                title: 'Toast Warning',
                message: 'Some Problem Occurred',
                variant: 'warning',
                mode: 'dismissable'
            });
            this.dispatchEvent(toastEvt);
        }
        displayToastInfo() {
            const toastEvt = new ShowToastEvent({
                title: 'Toast Info',
                message: 'Data running in background',
                variant: 'info',
                mode: 'dismissable'
            });
            this.dispatchEvent(toastEvt);
        }
    }