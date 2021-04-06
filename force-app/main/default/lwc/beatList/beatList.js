import { LightningElement,track,api,wire } from 'lwc';
import getBeatList from '@salesforce/apex/getZonesList.getBeatsList';//for fetching localities records from apex
import { deleteRecord } from 'lightning/uiRecordApi';//for delete records
import { updateRecord } from 'lightning/uiRecordApi';//for updating records
import accountsList from '@salesforce/apex/getZonesList.getAccountsList';
//import { refreshApex } from '@salesforce/apex';
//import { CurrentPageReference } from 'lightning/navigation';
//import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
   // import createBeatRecord from '@salesforce/apex/getZonesList.createBeatRecord';
    import BEAT_ZONE_NAME from '@salesforce/schema/Beat__c.iZone__c';
    import BEAT_NAME from '@salesforce/schema/Beat__c.Name';
    import { ShowToastEvent } from 'lightning/platformShowToastEvent';
    import BEAT_ID from '@salesforce/schema/Beat__c.Id';
    //var Zone = JSON.stringify(Zone);

   // const FIELDS = ['Beat__c.iZone__r.Name']; 
    //const ZoneName = BEAT_NAME;
    export default class BeatList extends LightningElement {
        @track fetchedBeats = [];//for storing localities list
        @track VisibleBeats;
        @api recordId;
        @track FormZone;
        @api fieldApiName;
        @track CreateModal=false;
        @track EditModal=false;
        @track dragdown=false;
       // @wire(CurrentPageReference) pageRef;
        //@track Zone;
        //wire serrvice for extracting data values
        //start wire service
        @wire(getBeatList)
         wireGetBeatsInfo({error,data}){
             if(data){
                 this.fetchedBeats=data;
             }
             else if(error){
                console.log(error);
             }
         }
         //end wire service
         
         //For Deleting locality record
         deleteBeatrecord(event){
             let deleteId=event.target.value;
             deleteRecord(deleteId)
          .then(() => {
           this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Record deleted successfully',
                    variant: 'success'
                })
            );
    
            // To delete the record from UI
            for(let beat in this.VisibleBeats){
                if(this.VisibleBeats[beat].Id == deleteId){
                    this.VisibleBeats.splice(beat, 1);
                    break;
                }
    
            }
            //return refreshApex(this.fetchedLocalities);
            //for refresh the window
           // eval("$A.get('e.force:refreshView').fire();");
            //window.location.reload();
           
        })
        .catch(error => {
            console.log(error);
        });
    }
    
    showCreateModal(){
        this.CreateModal=true;
    }
    EditModalOpen(event){
        
        let editId = event.target.value;
        
        for(let beat in this.VisibleBeats){
            if(this.VisibleBeats[beat].Id == editId){
                this.FormZone=this.VisibleBeats[beat];
                break;
            }
    
        }
        this.EditModal=true;
    }
    closeCreateModal(){
        this.CreateModal=false;
        //window.location.reload();
    }
    closeEditModal(){
        this.EditModal=false;
        //window.location.reload();
    }
    handleCreateSuccess(event){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Record Created',
                variant: 'success'
            })
        );
        console.log('onsuccess event recordEditForm', event.detail.fields.Name);
        this.CreateModal=false;
        return refreshApex(this.VisibleBeats);

    }
    handlecreateSubmit(event){
        console.log('onsuccess event recordEditForm', event.detail.fields);
    }
    
    UpdateRecordhandler(event){
        this.VisibleBeats=[...event.detail.records]
    }
    handleSubmit(event){
        console.log('onsuccess event recordEditForm', event.detail.fields);
    }
    handleSuccess(event){
   
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Record updated',
                variant: 'success'
            })
        );
        this.EditModal=false;
        //this. RefreshList();
    }
    @track OModal=false;
    EditModalOpenCheckIn(){
        this.OModal=true;
    }
    closeOModal(){
        this.OModal=false;
    }
    handleCreateSuccessCheckIn(event){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'CheckedIn Successful',
                variant: 'success'
            })
        );
        console.log('onsuccess event recordEditForm', event.detail.fields.Name);
        this.OModal=false;
        //return refreshApex(this.VisibleBeats);

    }
        //for updating values
  /*  UpdateBeat() {
        const allValid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputFields) => {
                inputFields.reportValidity();
                return validSoFar && inputFields.checkValidity();
            }, true);
    
        if (allValid) {
            // Create the recordInput object
            const fields = {};
            fields[BEAT_ID.fieldApiName] = this.FormZone.Id;
            fields[BEAT_NAME.fieldApiName] = this.template.querySelector("[data-field='Name']").value;
            
            const recordInput = { fields };
    
            updateRecord(recordInput)
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Record updated',
                            variant: 'success'
                        })
                    );
                    this.EditModal=false;
                    // Display fresh data in the form
                   // this.openModal1=false;
                    //eval("$A.get('e.force:refreshView').fire();");
                    //refreshApex(this.fetchedZones);
                   // refreshApex(this.fetchedLocalities);
                    return refreshApex(this.VisibleBeats);
                    //return true;
                    
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error creating record',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
            }
        else {
            // The form is not valid
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Something is wrong',
                    message: 'Check your input and try again.',
                    variant: 'error'
                })
             );
        }
    }*/
    //wire for fetching accounts
  /*  @track vdata=true;
    @track value = [""];
    @track Users = [];
    @track error;
    @wire(accountsList)
    myWiredUsers({ error, data }) {
        if (data) {
          this.Users = data;
          this.error = undefined;
        } else if (error) {
          this.error = error;
          this.Users = undefined;
        }
      }
      get comms() {
        let alist = [];
        this.Users.forEach(function(element) {
          alist.push({ label: element["Name"], value: element["Id"] });
        });
        return alist;
        }
    
      get selectedValues() {
        return this.value.join(",");
        }
      handleChange(e) {
        this.value = e.detail.value;
        }
        handleCheckBoxChange(event){
            this.checkBoxFieldValue = event.target.checked;
         }
    */
}