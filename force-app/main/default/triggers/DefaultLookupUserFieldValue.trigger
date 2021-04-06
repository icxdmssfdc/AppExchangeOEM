trigger DefaultLookupUserFieldValue on icxdmsv1__Attendance_Capture__c (before insert,before update) {
User CurrentUserid=[Select id from User where id=:userinfo.getUserId()];
    for(icxdmsv1__Attendance_Capture__c Att:Trigger.New){
        Att.icxdmsv1__User__c=CurrentUserid.id;
    }
}