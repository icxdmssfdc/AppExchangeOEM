import { LightningElement, track, wire, api } from 'lwc';
import { getRecord, getFieldValue, updateRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

import getItemsList from '@salesforce/apex/getOrderITems.getItemsList';
import getOrderAccountId from '@salesforce/apex/OrderLWCHandler.getOrderAccountId';
import getOrderLineItems from '@salesforce/apex/OrderLWCHandler.getOrderLineItems';
        
import ACCOUNT_ID from '@salesforce/schema/Order__c.AccountId__c';
const  accref_fields = [ACCOUNT_ID];

const actions = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' }
];
const columns = [
    { label: 'SKU', fieldName: 'icxdmsv1__Product_SKU__c', type: 'text', editable: false },
    { label: 'Product', fieldName: 'icxdmsv1__Product_Name__c', type: 'text', editable: false },
    { label: 'Batch', fieldName: 'icxdmsv1__Batch_Number__c', type: 'text', editable: false },
    { label: 'Quantity', fieldName: 'icxdmsv1__Quantity__c', type: 'number', editable: true },
    { label: 'List Price', fieldName: 'icxdmsv1__List_Price__c', type: 'currency', editable: false },
    { label: 'Unit Price', fieldName: 'icxdmsv1__UnitPrice__c', type: 'currency', editable: true },
    { label: 'Total', fieldName: 'icxdmsv1__Total_Price__c', type: 'currency', editable: false },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    }, 
];

export default class OrderTemplate extends NavigationMixin( LightningElement ) {

    @api OrderFields;
    @api recordId;
    @api editRecord;
    @track orderFieldsArray;
    @track accountFieldsArray = ['Name', 'AccountNumber', 'icxdmsv1__Record_Type__c', 'icxdmsv1__Active__c'];
    @track billingFieldsArray = ['icxdmsv1__TOTAL_AMOUNT__c','icxdmsv1__APPLIED_OFFER__c','icxdmsv1__DISCOUNT_AMOUNT__c','icxdmsv1__GRAND_TOTAL_AMOUNT__c']
    @track orderLineItems;
    columns = columns;
    saveDraftValues = [];
    defaultValues = encodeDefaultFieldValues({
        icxdmsv1__OrderId__c: this.recordId
    });

    @wire(getRecord, { recordId: '$recordId', accref_fields })
    account;
    @wire(getOrderAccountId, {orderId: '$recordId'})
    accountId;
    @wire(getOrderLineItems, {orderId: '$recordId'})
    orderItems({ error, data }) {
        if (data) {
            this.orderLineItems = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.orderLineItems = undefined;
        }
    }

    get accountId() {
        return getFieldValue(this.account.data, ACCOUNT_ID);
    }

    connectedCallback(){
        this.orderFieldsArray = this.OrderFields.split(',');
        console.log(this.orderFieldsArray.length);
        getItemsList({}).then(result => {
            this.users = result;
        }).catch(error => {
            this.error = error;
        });
    }

    renderedCallback(){
        console.log('Account Id:'+this.accountId);
    }

    handelEdit(){
        this.editRecord = true;
    }

    handleSave(event) {
        this.saveDraftValues = event.detail.draftValues;
        const recordInputs = this.saveDraftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });

        // Updateing the records using the UiRecordAPi
        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        Promise.all(promises).then(res => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Records Updated Successfully!!',
                    variant: 'success'
                })
            );
            this.saveDraftValues = [];
            return this.refresh();
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'An Error Occured!!',
                    variant: 'error'
                })
            );
        }).finally(() => {
            this.saveDraftValues = [];
        });
    }

    // This function is used to refresh the table once data updated
    async refresh() {
        await refreshApex(this.orderLineItems);
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'delete':
                this.deleteRow(row);
                break;
            case 'edit':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.Id,
                        objectApiName: 'icxdmsv1__OrderItem__c',
                        actionName: 'edit'
                    }
                });
                break;
            default:
        }
    }

    handelLineItemNew(event){
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'icxdmsv1__OrderItem__c',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: this.defaultValues
            }
        });
    }
}