import { LightningElement, track } from 'lwc';

export default class AttendanceLwc extends LightningElement {
    @track openModal=false;
    @track openModalP=false;
    @track punchInModal=true;
    createModal(){
        this.openModal=true;
    }
    closeCreateModal(){
        this.openModal=false;
        this.openModalP=true;
        this.punchInModal=false;

    }
    punchOutModal(){
        this.openModalP=true;
    }
    
    closePunchOutModal(){
        this.openModalP=false;
    }
    PI(){
        this.punchInModal=true;
    }
}