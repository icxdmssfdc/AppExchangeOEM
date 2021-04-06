import { LightningElement, wire, track, api} from 'lwc';
import zoneList from '@salesforce/apex/getZonesList.getItemsList';
import createZoneRecord from '@salesforce/apex/getZonesList.createZoneRecord';
//const ZFields=[{label:'ZoneName',fieldName:'Name'}];
export default class ZoneList_CreationLwc extends LightningElement {
@track records;
@track isEditable=false;
//Fields=[ZNAME];
@track openModal=false;
@track columns = [
    //{ label: 'Id', fieldName: 'Id'},
    { label: 'Zone Name', fieldName: 'Name' , editable: true}
];
@track selected = ['Name'];
@track fetchedZones = [];
VisibleZones
//@api recordId;

@wire(zoneList)
   wiregetzoneInfo({ error, data }) {
    if (data) {
        this.fetchedZones = data;
    } else if (error) {
        console.log(error);
    }
}
showModal(){
    this.openModal=true;
}
closeModal(){
    this.openModal=false;
    window.location.reload();

}
UpdateRecordhandler(event){
    console.log("zone"+event.detail.records);
    this.VisibleZones=[...event.detail.records]
}
@wire(zoneList) zonesList;  
   createRecord(){  
     var selectedRecords =  
      this.template.querySelector("lightning-datatable").getSelectedRows();  
      createZoneRecord({zonesList: selectedRecords})  
     .then(result=>{  
       return refreshApex(this.zonesList);  
     })  
     .catch(error=>{  
       alert('Could not Create'+JSON.stringify(error));  
     })  
   }  
  
/*renderedCallback() {
    console.log("Zones:::", this.zL);
    //console.log("Accounts:::", JSON.stringify(this.Accounts));
}
closeModal(){
    this.open='false';
}
handleClick(event) {
    console.log("In HandleClick");
    const recId = event.target.name;
    this.rec2Id = event.currentTarget.name;
    console.log("Selected Zone Id:::", recId);
    console.log("Selected ZOne Id rec2Id :::", this.rec2Id);
    this.open = true;
}*/
 

}