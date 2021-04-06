public with sharing class CheckPunchInUser {
  //fetch user from soql if loggedIn today and show his last login details
  //if not logged In show the punchIn button on UI
    //for record creation in checkin
@AuraEnabled(cacheable=true)
public static List<icxdmsv1__Attendance_Capture__c> ApproachAttendanceDetails(){
       // String param= '%' + attendanceId + '%';
       // List<User> userInf= new List<User>();
Id uId=UserInfo.getUserId();
List<icxdmsv1__Attendance_Capture__c> details=new List<icxdmsv1__Attendance_Capture__c>();
if(icxdmsv1__Attendance_Capture__c.sObjectType.getDescribe().isAccessible()){
details = [SELECT Id,icxdmsv1__Login_Date__c,icxdmsv1__User__c,icxdmsv1__Status__c FROM icxdmsv1__Attendance_Capture__c WHERE icxdmsv1__User__c=:uId AND CreatedDate = TODAY];// AND Id=:attendanceId];
}
System.debug(details);
//insertAttendance();
return details;              
}

@AuraEnabled(cacheable=true)
public static List<User> findUserLogin(String recordId)
{
  String param= '%' + recordId + '%';
  List<User> userInf= new List<User>();
  if(User.sObjectType.getDescribe().isAccessible()){
  userInf = [Select id,Name,LastLoginDate,Status__c,ProfileImage__c FROM User Where Id=:param AND LastLoginDate=TODAY];//Where LastLoginDate >= :System.Now().addDays(-1)];
  }
  System.debug(userInf);
  return userInf;                
}

@AuraEnabled(cacheable=true)
public static icxdmsv1__Attendance_Capture__c getAttendance(){
  return [SELECT Id FROM icxdmsv1__Attendance_Capture__c WHERE CreatedDate = TODAY];//icxdmsv1__User__c =:UserInfo.getUserId() AND     
}

@AuraEnabled(cacheable=true)
public static icxdmsv1__Attendance_Capture__c punchOutProcess(String attRecordId){
    String param= '%' + attRecordId + '%';
    icxdmsv1__Attendance_Capture__c fetchAttRec=[SELECT id,icxdmsv1__Logout_Date__c FROM icxdmsv1__Attendance_Capture__c WHERE id=:param];
    fetchAttRec.icxdmsv1__Logout_Date__c=system.now();
    if(icxdmsv1__Attendance_Capture__c.sObjectType.getDescribe().isUpdateable()){
    update fetchAttRec;
    }
    System.debug('logout date is'+fetchAttRec.icxdmsv1__Logout_Date__c);
    return fetchAttRec;
  }
@AuraEnabled(cacheable=true)
public static String returnDay(Date postingdate){
  //for fetching todays day
  Date postingdatevalue = Date.valueOf(postingdate);
  system.debug(postingdatevalue);
  Datetime dt = DateTime.newInstance(postingdatevalue, Time.newInstance(0, 0, 0, 0));//date.today();
String dayOfWeek=dt.format('EEEE');
System.debug('Day : ' + dayOfWeek);
 return dayOfWeek;
}

@AuraEnabled(cacheable=true)
public static List<icxdmsv1__Beat_User__c> returnBeatsList(){
  List<icxdmsv1__Beat_User__c> beatInfo=new List<icxdmsv1__Beat_User__c>();
  if(icxdmsv1__Beat_User__c.sObjectType.getDescribe().isAccessible()){
     beatInfo=[SELECT Id,icxdmsv1__Beat__c,icxdmsv1__Day__c,icxdmsv1__UserName__c FROM icxdmsv1__Beat_User__c WHERE icxdmsv1__Visit_Start_Date__c=TODAY];
  }
    return beatInfo;
  }
  @AuraEnabled(cacheable=true)
  public static List<icxdmsv1__Beat__c> BeatsList(){
    List<icxdmsv1__Beat__c> beatInfo=new List<icxdmsv1__Beat__c>();
    if(icxdmsv1__Beat__c.sObjectType.getDescribe().isAccessible()){
       beatInfo=[SELECT Id,icxdmsv1__Customer_Name__c,icxdmsv1__Locality__c,icxdmsv1__iZone__c FROM icxdmsv1__Beat__c];//WHERE icxdmsv1__Beat_User__c.icxdmsv1__Visit_Start_Date__c=TODAY];
    }
      return beatInfo;
    }
}