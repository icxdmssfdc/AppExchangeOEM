import { LightningElement,track,wire,api } from 'lwc';
/*import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import Current_User_Id from '@salesforce/user/Id';//fetches current user Id
import User_Name from '@salesforce/schema/User.Name';//fetches current user details here..name..based on user id
import User_logindate from '@salesforce/schema/User.LastLoginDate';
import getRecords from '@salesforce/apex/CheckPunchInUser.findUserLogin';
import {getRecord,getFieldValue} from 'lightning/uiRecordApi';
import ATTENDANCE_OBJECT from '@salesforce/schema/Attendance_Capture__c';
import Attendance_Date from '@salesforce/schema/Attendance_Capture__c.Logout_Date__c';
import User_Field from '@salesforce/schema/Attendance_Capture__c.User__c';
import Status_Field from '@salesforce/schema/Attendance_Capture__c.Status__c';
import Odometer_Field from '@salesforce/schema/Attendance_Capture__c.Odometer_Reading__c';
import Vehicletype_Field from '@salesforce/schema/Attendance_Capture__c.Vehicle_Type__c';
import AttendanceInfo from '@salesforce/apex/CheckPunchInUser.ApproachAttendanceDetails';
import AttId from '@salesforce/apex/CheckPunchInUser.getAttendance';
import PunchoutAttRecords from '@salesforce/apex/CheckPunchInUser.punchOutProcess';
const columns=[
     { label: 'UserName', fieldName: 'icxdmsv1__User__c', type: 'text', editable: false },
     { label: 'Last Login Info', fieldName: 'icxdmsv1__Login_Date__c', type: 'datetime', editable: false },
     { label: 'Status', fieldName: 'icxdmsv1__Status__c', type: 'text', editable: false }
 ];*/
//import PunchInTemplate from './punchInV2.html';
//import LastPunchInTemplate from 'G:/iDMS VS Project Innovacx/iDMS_Project/force-app/main/default/lwc/punchInPage/punchInPage.html';
export default class PunchInV2 extends LightningElement {
    
  /*  @track removetitle=true;
    @track addtitle=false;
    @track addtitlepo=false;
    @track LoginInfoTemp=true;
    @track PunchInTemp=true;
    @track attRecordId=AttId;
    @track CurrentUser;
    @track poField;
@track poForm=false;
@track PunchOutButt=true;
@api recordId;
//@track values;
data = [];
columns = columns;
@track attendanceId;
handleSuccess(event) {
    this.attendanceId = event.detail.id;
    if(this.attendanceId){
        this.attRecordId=this.attendanceId;
        this.LoginInfoTemp=true;
        this.addtitle=true;
        this.PunchInTemp=false;
        if(this.Attendance_Date==system.now()){
            this.PunchOutButt=false;
        }
    }
    else{
    this.LoginInfoTemp=false;
    this.PunchInTemp=true;
    }
}
@wire(AttendanceInfo)
wiredRecordsMethod({ error, data }) {
    if (data) {
        console.log(data[0]);
        if(data.length>0){
            this.attRecordId=data[0].Id;
            this.LoginInfoTemp=true;
            this.PunchInTemp=false;
        }
        else{
            this.PunchInTemp=true;
            this.LoginInfoTemp=false;
        }
        
         
    }else if(error){
        this.LoginInfoTemp=false;
        this.PunchInTemp=true;
    }else {
        this.PunchInTemp=true;
        this.LoginInfoTemp=false;
    }
}
@wire(getRecord,{ recordId:Current_User_Id,fields:[User_Name,User_logindate]})
wireuser({
    error,data
})
{
    if(data){    
    this.CurrentUser=data.fields.Name.value;
    }
    else if(error){
    this.error=error;
    }
}
handleClick(event){
    this.selected = event.target.label
}

@track poField;
@track poForm=false;
disabled=true;
punchOutMsg(){
    this.addtitlepo=true;
    this.PunchOutButt=false;
    this.addtitle=false;
    //this.poField=system.now();
    //this.poField=event.po.Attendance_Date;
    console.log(poField);
   // this.poForm=true;
    this.dispatchEvent(
        new ShowToastEvent({
            title: 'Success',
            message: 'You have been punched out and you may properly logout now',
            variant: 'success'
        })
    );
}*/
    
}