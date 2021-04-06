public with sharing class getZonesList {
   //fetch zones list
   @AuraEnabled(cacheable=true)
   public static List<icxdmsv1__Zone__c> getItemsList(){
       return [SELECT Id,Name FROM icxdmsv1__Zone__c];
   }   
   //fetch localities
   @AuraEnabled(cacheable=true)
   public static List<icxdmsv1__Locality__c> getLocalitiesList(){
       return [SELECT Id,Name,icxdmsv1__Zone__c,icxdmsv1__City__c,icxdmsv1__State__c,icxdmsv1__Country__c,icxdmsv1__Address__c FROM icxdmsv1__Locality__c];
   }
   @AuraEnabled(cacheable=true)
   public static icxdmsv1__Zone__c getSingleItem(){
       return [SELECT Id,Name FROM icxdmsv1__Zone__c LIMIT 1];
   }   
   @AuraEnabled(cacheable=true)
   public static icxdmsv1__Zone__c createZoneRecord(icxdmsv1__Zone__c newRecord) {
    //icxdmsv1__Zone__c zone=new icxdmsv1__Zone__c();
    
    insert newRecord;
    return newRecord;
}
    //for locality creation
    @AuraEnabled(cacheable=true)
   public static icxdmsv1__Locality__c createLocalityRecord(icxdmsv1__Locality__c newRecord) {
    //icxdmsv1__Zone__c zone=new icxdmsv1__Zone__c();
    
    insert newRecord;
    return newRecord;
}
 //fetch Beats
 @AuraEnabled(cacheable=true)
 public static List<icxdmsv1__Beat__c> getBeatsList(){
     return [SELECT Id,Name,icxdmsv1__Customer_Name__c,icxdmsv1__Locality__c,icxdmsv1__iZone__c FROM icxdmsv1__Beat__c];
 }
 /* @AuraEnabled(cacheable=true)
 public static icxdmsv1__Beat__c createBeatRecord(icxdmsv1__Beat__c newRecord) {
  //icxdmsv1__Zone__c zone=new icxdmsv1__Zone__c();
  
  insert newRecord;
  return newRecord;
}*/
//fetch Accounts list
@AuraEnabled(cacheable=true)
public static List<Account> getAccountsList(){
    return [SELECT Id,Name FROM Account];
}
/*Create Attendance Record
@AuraEnabled(cacheable=true)
 public static icxdmsv1__Attendance_Capture__c createAttendanceRecord(icxdmsv1__Attendance_Capture__c newRecord) {  
  insert newRecord;
  return newRecord;
}*/
}