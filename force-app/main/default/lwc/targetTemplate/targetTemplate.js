import { LightningElement, track, wire, api } from 'lwc';
import userList from '@salesforce/apex/TargetController.getUsersList';


export default class TargetTemplate extends LightningElement {

    @wire (userList) wiredUsers;
    @track users;
    @track uList=[];
    selectedMonth;
    selectedYear;
    selected = [];
    @track options;
    @track vdata=true;
    @track value = [""];
    @track MktUsers = [];
    @track error;


    @wire(userList)
    myWiredMktUsers({ error, data }) {
      if (data) {
        this.MktUsers = data;
        this.error = undefined;
      } else if (error) {
        this.error = error;
        this.MktUsers = undefined;
      }
    }

  get comms() {
    let alist = [];
    this.MktUsers.forEach(function(element) {
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

}