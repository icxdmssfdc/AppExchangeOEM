import { LightningElement,track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
export default class Communityregform extends NavigationMixin(LightningElement) {
    @track openModal = false;

    handleSuccess(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Registration Successful.Thank you for your interest,Your will be updated with futher details to the given mailid.',
                variant: 'success',
            }),
            );
        }
        handleReset(event) {
            const inputFields = this.template.querySelectorAll(
                'lightning-input-field'
            );
            if (inputFields) {
                inputFields.forEach(field => {
                    field.reset();
                });
            }
         }
         showModal() {
             this.openModal = true;
         }
         closeModal() {
            //this.template.querySelector("c-child-web-component").handleValueChange();
            const inputFields = this.template.querySelectorAll(
                'lightning-input-field'
            );
            if (inputFields) {
                inputFields.forEach(field => {
                    field.reset();
                });
            }
            this.openModal = false;

         }
     

        }