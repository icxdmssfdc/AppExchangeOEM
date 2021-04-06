import { LightningElement, wire,track,api } from 'lwc';
import localitiesList from '@salesforce/apex/getZonesList.getLocalitiesList';//for fetching localities records from apex
import { deleteRecord } from 'lightning/uiRecordApi';//for delete records
import { updateRecord } from 'lightning/uiRecordApi';//for updating records
import { refreshApex } from '@salesforce/apex';
//import CreateLocaleRecord from '@salesforce/apex/getZonesList.createLocalityRecord';
import LOCALE_NAME from '@salesforce/schema/Locality__c.Name';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LOCALE_ID from '@salesforce/schema/Locality__c.Id';

export default class LocalitiesList extends LightningElement {
    @track fetchedLocalities = [];//for storing localities list
    @track VisibleLocales;
    @api recordId;
    @track FormZone;
    @api fieldApiName;
    @track CreateModal=false;
    @track EditModal=false;
    @track dragdown=false;
    //wire serrvice for extracting data values
    //start wire service
    @wire(localitiesList)
     wireGetLocalitiesInfo({error,data}){
         if(data){
             this.fetchedLocalities=data;
         }
         else if(error){
            console.log(error);
         }
     }
     //end wire service
     
     //For Deleting locality record
     deleteLocalerecord(event){
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
        for(let locale in this.VisibleLocales){
            if(this.VisibleLocales[locale].Id == deleteId){
                this.VisibleLocales.splice(zone, 1);
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
    
    for(let locale in this.VisibleLocales){
        if(this.VisibleLocales[locale].Id == editId){
            this.FormZone=this.VisibleLocales[locale];
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
}
handlecreateSubmit(event){
    console.log('onsuccess event recordEditForm', event.detail.fields);
}

UpdateRecordhandler(event){
    this.VisibleLocales=[...event.detail.records]
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
}
}