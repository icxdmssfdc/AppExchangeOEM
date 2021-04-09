import { LightningElement,track,wire,api } from 'lwc';
import BEAT_STARTDATE from '@salesforce/schema/Beat_User__c.Visit_Start_Date__c';
import BeatDay from '@salesforce/apex/CheckPunchInUser.returnDay';
import BeatUserInfo from '@salesforce/apex/CheckPunchInUser.returnBeatsList';
import BeatInfo from '@salesforce/apex/CheckPunchInUser.BeatsList';
import { getRecord } from 'lightning/uiRecordApi';
import CalculatedDay from '@salesforce/apex/calculateDayOfDate.calculateDayOfDateval';
import DisplayBeats from '@salesforce/apex/calculateDayOfDate.displayBeats';
import GetBeatRelatedAccounts from '@salesforce/apex/calculateDayOfDate.getBeatAccounts';
import getAccount from '@salesforce/apex/calculateDayOfDate.getAccount';
import CheckInCreation from '@salesforce/apex/calculateDayOfDate.checkInRecordCreation';
import GetBeatRelatedAccounts1 from '@salesforce/apex/calculateDayOfDate.getBeatAccounts1';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const weekday=["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
var d = new Date();
//let n;
var i;
export default class BeatUI extends LightningElement {
startDateVar;
endDateVar;
beatDay;
beatIdVal;
@track n;
@track BeatDayVar=BeatDay;
@track fetchedBeats = [];
@track VisibleBeats;
@track fetchedBeatAccounts = [];
@track AccountsOnMap = [];
@track day;
@track beatDayRecord;
@track CreateModal=false;
@track PostingDate;

@track accounts;
@track error;
@track showFooter = true ;
disabled=false;
@track checkinbutton=true;
@track checkoutbutton=false;
//@api n;
             
    
handleChangeSd(event){
    if(event.target.name==='startdate'){
        this.startDateVar=event.target.value;
    }    
    console.log('start date is'+this.startDateVar);
}

get beatStartDate(){
    if(this.startDateVar){
        return (this.startDateVar);
    }
    console.log('start date is'+this.startDateVar);
}


DayofBeat(){
this.weekday = new Array(7);
this.weekday[0] = "Sunday";
this.weekday[1] = "Monday";
this.weekday[2] = "Tuesday";
this.weekday[3] = "Wednesday";
this.weekday[4] = "Thursday";
this.weekday[5] = "Friday";
this.weekday[6] = "Saturday";
 this.n=this.weekday[d.getDay()];
 console.log('day value is'+this.n);
 return this.n;
}


handleChangeEd(event){
    if(event.target.name==='enddate'){
        this.endDateVar=event.target.value;
    }
    }    
get beatEndDate(){
    if(this.endDateVar){
        return (this.endDateVar);
    }
}
@track wiredEvents;
@track OModal=false;
   /* EditModalOpenCheckIn(){
        //this.OModal=true;
      //  if(this.label=='CheckIn'){
            CheckInCreation().then(result =>{
                this.wiredEvents = result;
            })
            .catch(error =>{
                this.errorMsg = error;
            })
      //  }
      handleCreateSuccessCheckIn();
    }*/
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
       // console.log('onsuccess event recordEditForm', event.detail.fields.Name);
       // this.OModal=false;
        //return refreshApex(this.VisibleBeats);

    }
    handlecreateSubmit(event){
        console.log('onsuccess event recordEditForm', event.detail.fields);
    }


UpdateRecordhandler(event){
    this.VisibleBeats=[...event.detail.records]
}
showCreateModal(){
    this.CreateModal=true;
}
closeCreateModal(){
    this.CreateModal=false;
    //window.location.reload();
}
PostingDateChange(event) {
    this.PostingDate = event.target.value;
    BeatDay({postingdate : this.PostingDate })
    }

@track dayvalue;
connectedCallback(){
//get getDayValue() {
    this.DayofBeat();
       DisplayBeats({day:this.n})
    .then(result=>{
        console.log('Day param success');
        this.fetchedBeats=result;
        console.log(this.fetchedBeats);
    })
    .catch(error=>{
        console.log('error came');
        console.log(error)
    });
}

//get beatAcc(){
//    this.fetchedBeats.icxdmsv1__Beat__c;
//}

//uncomment for previous code
/*@wire(GetBeatRelatedAccounts,{beatList:'$fetchedBeats'})
wireGetBeatsInfo({error,data}){
    if(data){
        
        this.fetchedBeatAccounts=data;
        }
    
    else if(error){
       console.log(error);
    }
    
}*/
/*@track fields;
@wire(GetBeatRelatedAccounts,{beatList:'$fetchedBeats'})
    wiredResult(result) { 
        if (result.data) {
            //mapData = [];
            var conts = result.data;
           // for(var key in conts){
            //    this.fetchedBeatAccounts.push({value:conts[key], key:key}); //Here we are creating the array to show on UI.
           // }
           this.fetchedBeatAccounts = Object.keys(conts).map(key=> ({ key: key, ...fetchedBeatAccounts[key] }));
           //return fields;
        }
    }*/
   @track wiredBeatId;
    handleToggleSection(event){
        this.beatIdVal=event.detail.openSections;//event.VisibleBeats.id;//event.getparam(opensections);
        console.log('beat id shown here is'+this.beatIdVal);//event.detail.openSections;
       // this.beatIdVal = event.target.name;
        GetBeatRelatedAccounts1({
            beatUserId:this.beatIdVal
        }).then(result =>{
            this.fetchedBeatAccounts = result;
        })
        .catch(error =>{
            this.errorMsg = error;
        })
       // this.beatIdVal=event.detail.openSections;
        console.log('BeatId we got is'+this.beatIdVal);
     
    }     
        @wire(GetBeatRelatedAccounts,{beatList:'$fetchedBeats'})
wireGetBeatsInfo({error,data}){
    if(data){
        
        this.AccountsOnMap=data;
        }
    
    else if(error){
       console.log(error);
    }
    
}
    @wire(getAccount,{relatedAccounts:'$AccountsOnMap'})  //'$fetchedBeatAccounts'})
    wiredAccountss({error,data}) {
        if (data) {
            this.accounts = data;
            console.log(data);
            console.log(JSON.stringify(data, null, '\t'));
        } else if (error) {
            console.log(error);
            this.error = error;
        }
    }
    @api accountEventId;
    @track accId;
    checkinbuttonId;
    @track CIButtontrue=false;
    @track COButtontrue=true;
    handleSuccessAccountCI(event) {
        //this.accountEventId = event.detail.id;       
        //let currentButtonId = event.
        this.accountEventId = event.target.value;
        this.checkinbuttonId=event.target.name;
        this.buttId=event.target.id;
        if(this.checkinbuttonId==this.accountEventId ){//&& this.accountEventId==this.buttId){
            
            console.log('checkin button name'+this.checkinbuttonname);        
        CheckInCreation({
            accountId:this.accountEventId
        }).then(result =>{
            this.wiredEvents = result;
        })
        .catch(error =>{
            this.errorMsg = error;
        })        
        this.showSuccessToast();
        this.CIButtontrue=true;
        this.CIButtontrue=false;
        //this.checkinbutton=false;
       // this.checkoutbutton=true;        
        }
    }          
    showSuccessToast() {
        const evt = new ShowToastEvent({
            title: 'Successfully CheckedIn',
            message: 'CheckIn Operation successful',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
        //this.disabled=true;
    }
    handleSuccessAccountCO(event){
        const evt = new ShowToastEvent({
            title: 'Successfully CheckedOut',
            message: 'CheckIn Operation successful',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
        this.CIButtontrue=false;
    }
    @wire(CheckInCreation,{accountId:'$accountEventId'})//'$accounts'})
    wireGetBeatsInfopp({error,data}){
        if(data){        
            this.accId=this.accountEventId;
            this.wiredEvents=data;
        }       
        else if(error){
           console.log(error);
        }
    }
/*@api recordId;
@wire(GetBeatRelatedAccounts1,{beatUserId:'$fetchedBeats.id'})
wireGetBeatsInfo({error,data}){
    if(data){        
        this.fetchedBeatAccounts=data;
        }
    
    else if(error){
       console.log(error);
    }
}*/
}