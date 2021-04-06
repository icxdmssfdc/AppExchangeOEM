import { LightningElement,track,wire,api } from 'lwc';
import getTargetOwners from '@salesforce/apex/TargetController.getTargetOwnersList';
import getTargetIncentive from '@salesforce/apex/TargetController.getIncentiveList';
import updateIncentive from '@salesforce/apex/TargetController.updateIncentive';
import {refreshApex} from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class TargetIncentiveLWC extends LightningElement {

   @track junctionId ='';
   @api errorMsg='';

    @wire(getTargetOwners) targetOwners;

    @wire(getTargetIncentive) incentives;


    handleGetIncentive(event){
        console.log(event.currentTarget.value);
        this.junctionId = event.target.value;
        updateIncentive({ juctionId:this.junctionId})
        .then(result =>{
            //this.contacts = result;           
            this.showSuccessToast();
            return refreshApex(this.incentives)
        })
        .catch(error =>{
            this.errorMsg = error;
            console.log(this.errorMsg);
            this.showErrorToast();
        })
    }

    showSuccessToast() {
        const evt = new ShowToastEvent({
            title: 'Successfully Submitted to Avail the Incentive',
            message: 'Opearion sucessful',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    showErrorToast() {
        const evt = new ShowToastEvent({
            title: 'Error',
            message: 'Some unexpected error',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }


}