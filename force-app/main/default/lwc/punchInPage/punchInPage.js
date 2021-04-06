import { LightningElement,track,wire,api } from 'lwc';
/*import Current_User_Id from '@salesforce/user/Id';//fetches current user Id
import User_Name from '@salesforce/schema/User.Name';//fetches current user details here..name..based on user id
import User_logindate from '@salesforce/schema/User.LastLoginDate';
import User_Status from '@salesforce/schema/User.Status__c';
import User_ProfileImage from '@salesforce/schema/User.ProfileImage__c';
import {getRecord,getFieldValue} from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';//for displaying toast messages
import getRecords from '@salesforce/apex/CheckPunchInUser.findUserLogin';
import attendanceDetails from '@salesforce/apex/CheckPunchInUser.getAttendance';
import Attendance_Date from '@salesforce/schema/Attendance_Capture__c.Login_Date__c';
import checkUser from '@salesforce/schema/Attendance_Capture__c.checkuser1__c';
import User_Field from '@salesforce/schema/Attendance_Capture__c.User__c';
import Status_Field from '@salesforce/schema/Attendance_Capture__c.Status__c';

const fields=[Attendance_Date,checkUser,User_Status,User_Field];
const columns=[
    { label: 'Last Login Info', fieldName: 'icxdmsv1__Login_Date__c', type: 'datetime', editable: false }
];*/
export default class PunchInPage extends LightningElement {
/*@track CurrentUser;
@track UserLogindate;
@track UserStatus;
@track UserProfile;
@track disabledCondition=false;
@track attendancedate;//from attendance object
@api Login_Date__c;
@track removetitle=true;
@track addtitle=false;
@track addtitlepo=false;
@track attends;
@track error;
@track values;
data = [];
columns = columns;
@api recordId;
@wire(getRecord,{ recordId:Current_User_Id,fields:[User_Name,User_logindate,User_Status,User_ProfileImage]})
wireUser({
    error,data
}){
    if(data){
        this.CurrentUser=data.fields.Name.value;
        this.UserLogindate=data.fields.LastLoginDate.value;
        this.UserStatus=data.fields.Status__c.value;
        this.UserProfile=data.fields.ProfileImage__c.value;
        console.log('loginstatusis is'+UserStatus);
    }
    else if(error){
        this.error=error;
    }
}


@track openPI=false;
@track hbutton=true;//for button hiding
openPunchIn(){
    this.hbutton=false;
    this.openPI=true;
    this.disabledCondition = false;
}//Current_User_Id
@wire(getRecord,{ recordId:Current_User_Id,fields})
atrecord;
get atDate(){
    return getFieldValue(this.atrecord.data,Attendance_Date);
}
get atUser(){
    return getFieldValue(this.atrecord.data,User_Field);
}
get atStatus(){
    return getFieldValue(this.atrecord.data,Status_Field);
}

closetemp(){
    this.openPI=false;
    this.removetitle=false;
    this.addtitle=true;
   this.disabledCondition=true;
   attendanceDetails()
    .then(result =>{
        this.attends = result;
    })
    .catch(error =>{
        this.error = error;
    })
    this.dispatchEvent(
        new ShowToastEvent({
            title: 'Success',
            message: 'You are On-duty now',
            variant: 'success'
        })
    );
//



}
punchoutmsg(){
    this.addtitlepo=true;
    this.addtitle=false;
    this.dispatchEvent(
        new ShowToastEvent({
            title: 'Success',
            message: 'You have been punched out and you may properly logout now',
            variant: 'success'
        })
    );
}
@wire(getRecords,{recordId:Current_User_Id})
    wiredRecordsMethod({ error, data }) {
        if (data) {
            this.data  = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data  = undefined;
        }
      
    }*/

    
}