import { LightningElement, track, wire } from 'lwc';
import { createRecord, getRecord } from 'lightning/uiRecordApi';
const arrFields = ['Account.Id', 'Account.Name', 'Account.Phone', 'Account.AccountNumber'];
export default class LdsCreateRecord extends LightningElement {
    areDetailsVisible = false;
    areFieldsVisible = false;
    handleChange(event) {
        this.areDetailsVisible = event.target.checked;
    }
    handleIt(event) {
        this.areFieldsVisible = event.target.checked;
    }
    
    
    
    
    strName;
    strAccountNumber;
    strPhone;
    idAccount;
    @wire(getRecord, {recordId:'$idAccount', fields: arrFields})
    accountRecord;
    // Change Handlers.
    nameChangedHandler(event){
        this.strName = event.target.value;
    }
    numberChangedHandler(event){
        this.strAccountNumber = event.target.value;
    }
    phoneChangedHandler(event){
        this.strPhone = event.target.value;
    }
    // Insert record.
    createAccount(){
        // Creating mapping of fields of Account with values
        var fields = {'Name' : this.strName, 'AccountNumber' : this.strAccountNumber, 'Phone' : this.strPhone};
        // Record details to pass to create method with api name of Object.
        var objRecordInput = {'apiName' : 'Account', fields};
        // LDS method to create record.
        createRecord(objRecordInput).then(response => {
            this.idAccount = response.id;
        }).catch(error => {
            alert('Error: ' +JSON.stringify(error));
        });
    }
    //Getters
    get accountName(){
        if(this.accountRecord.data){
            return this.accountRecord.data.fields.Name.value;
        }
        return undefined;
    }
    get accountPhone(){
        if(this.accountRecord.data){
            return this.accountRecord.data.fields.Phone.value;
        }
        return undefined;
    }
    get accountNumber(){
        if(this.accountRecord.data){
            return this.accountRecord.data.fields.AccountNumber.value;
        }
        return undefined;
    }
    get accountId(){
        if(this.accountRecord.data){
            return this.accountRecord.data.fields.Id.value;
        }
        return undefined;
    }
}