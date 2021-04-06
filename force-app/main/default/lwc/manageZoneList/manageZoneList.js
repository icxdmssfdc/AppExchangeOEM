import { LightningElement, wire, track, api} from 'lwc';
import zoneList from '@salesforce/apex/getZonesList.getItemsList';
import getItemsUpdatedList from '@salesforce/apex/getZonesList.getItemsList';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

//const ZFields=[{label:'ZoneName',fieldName:'Name'}];
export default class ManageZoneList extends LightningElement {
disabled = false;
@track error;
@track records;
@track error;
@api recordId;
@track editMode=false;
//Fields=[ZNAME];
@track CreateModal=false;
@track EditModal=false;
@track columns = [
    { label: 'Zone Name', fieldName: 'Name' }
];
@track selected = ['Name'];
@track fetchedZones = [];
@api fieldApiName;
//@api recordId;
@track VisibleZones;
@track FormZone;
@wire(zoneList)
   wiregetzoneInfo({ error, data }) {
    if (data) {
        this.fetchedZones = data;
    } else if (error) {
        console.log(error);
    }
}
showCreateModal(){
    this.CreateModal=true;
}
EditModalOpen(event){
    
    let editId = event.target.value;
    
    for(let zone in this.VisibleZones){
        if(this.VisibleZones[zone].Id == editId){
            this.FormZone=this.VisibleZones[zone];
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

deleteZonerecord(event){
    let deleteId = event.target.value;
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
        for(let zone in this.VisibleZones){
            if(this.VisibleZones[zone].Id == deleteId){
                this.VisibleZones.splice(zone, 1);
                break;
            }

        }
       
    })
    .catch(error => {
        console.log(error);
    });
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
    //console.log('onsuccess1 event recordEditForm', event.detail.Name);
    this.EditModal=false;
    this. RefreshList();
    
    //refreshApex(this.fetchedZones);
   // UpdateRecordhandler(event);
    
    
    //this.dispatchEvent(event);
   // setTimeout(function() {
        
   // }, 10000);
   


}
RefreshList(){
    getItemsUpdatedList()
    .then(result => {
        this.fetchedZones = result;
        console.log("ffffff"+result);
        //this.template.querySelector('c-pagination').records(this.fetchedZones);
        this.template.querySelector('c-pagination').RefreshRecord(this.fetchedZones);
        //console.log(this.VisibleZones);
    })
    .catch(error => {
        this.error = error;
    });
   
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
    this. RefreshList();
    
}
handlecreateSubmit(event){
    console.log('onsuccess event recordEditForm', event.detail.fields);
}

UpdateRecordhandler(event){
    this.VisibleZones=[...event.detail.records]
}
}