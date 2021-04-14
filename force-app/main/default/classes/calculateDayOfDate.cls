public with sharing class calculateDayOfDate {
  //  Private Date startDate = date.newInstance(0001, 1, 1);
   // Public Date selectedDate{get;set;}
  //  public String dayValue{get;set;}
  //  public icxdmsv1__Beat_User__c beatUser {get;set;}
  //from git
  public class Location{
    @AuraEnabled 
    public String icon{get;set;} 
    @AuraEnabled 
    public String title{get;set;} 
    @AuraEnabled
    public String description{get;set;} 
    @AuraEnabled 
    public GeoLocation location{get;set;} 
}
public class GeoLocation{
    @AuraEnabled 
    public String Street{get;set;}
    @AuraEnabled 
    public String PostalCode{get;set;}
    @AuraEnabled 
    public String City{get;set;}
    @AuraEnabled 
    public String State{get;set;}
    @AuraEnabled 
    public String Country{get;set;}
}
    @AuraEnabled(cacheable=true)
          public static String calculateDayOfDateval()//Date startDateVar
        {
            Date startDate = date.newInstance(0001, 1, 1);
   Date selectedDate=date.today();
    String dayValue;
     icxdmsv1__Beat_User__c beatUser =new icxdmsv1__Beat_User__c();
  List<String> listDay = new List<String>{'Saturday' , 'Sunday' , 'Monday' , 'Tuesday' , 'Wednesday' , 'Thursday' , 'Friday'};
           // Date selectedDate = startDateVar;//beatUser.icxdmsv1__Visit_Start_Date__c;
            Integer remainder = Math.mod(startDate.daysBetween(selectedDate) , 7);
            dayValue = listDay.get(remainder);
            displayBeats(dayValue);
            system.debug('day is'+dayValue);
            return dayValue;
        }
    
    @AuraEnabled(cacheable=true)
    public static List<icxdmsv1__Beat_User__c> displayBeats(String day){
      List<icxdmsv1__Beat_User__c> beatList=new List<icxdmsv1__Beat_User__c>();
        
        System.debug('Weekday value from js is'+day);
        
        ID currentUId=UserInfo.getUserId(); 
            Date todaysDate = system.today();
        if(icxdmsv1__Beat_User__c.sObjectType.getDescribe().isAccessible()){
        beatList=[SELECT id,icxdmsv1__Beat__r.Name,icxdmsv1__BeatName__c,icxdmsv1__BeatAccountName__c FROM icxdmsv1__Beat_User__c WHERE icxdmsv1__UserName__c=:currentUId AND icxdmsv1__Visit_Start_Date__c > = :todaysDate AND icxdmsv1__Visit_End_Date__c<= :todaysDate AND icxdmsv1__Day__c includes (:day) ];// AND icxdmsv1__Visit_End_Date__c<=:todaysDate];
        System.debug('This is the beat list from apex'+beatList);
      
        }
       getBeatAccounts(beatList);
        return beatList;    
}


@AuraEnabled(cacheable=true)
public static List<Account> getBeatAccounts(List<icxdmsv1__Beat_User__c> beatList){
  Set<Id> beatIds = new Set<Id>();
  List<Account> relatedAccounts=new List<Account>();
 
  //Map<icxdmsv1__Beat__c,Account> relatedAccounts=new Map<icxdmsv1__Beat__c,Account>();
  //  for(Integer i:beatlist.size()){
  //  for(Integer i:beatlist.size()){
  for (icxdmsv1__Beat_User__c beatuser :beatList)
  {
    beatIds.add(beatuser.icxdmsv1__Beat__c);
  }
   // }
   // ID beatId=beatList[0].icxdmsv1__Beat__c;
    if(Account.sObjectType.getDescribe().isAccessible()){
//
    relatedAccounts=[SELECT id,Name,Type, Industry, BillingAddress,BillingStreet,
    BillingCity, BillingCountry, BillingPostalCode,
    BillingState,Phone,icxdmsv1__Beat__c FROM Account WHERE BillingStreet!=NULL AND
    BillingCity!=NULL AND BillingCountry!=NULL AND  BillingPostalCode!=NULL AND
    BillingState!=NULL AND icxdmsv1__Beat__c in :beatIds];
    }
    getAccount(relatedAccounts);
    
    return relatedAccounts;
}

@AuraEnabled(cacheable=true)
public static List<Account> getBeatAccounts1(Id beatUserId){
  
 Set<Id> beatIds = new Set<Id>();
 icxdmsv1__Beat_User__c beatFetch=[SELECT icxdmsv1__Beat__c FROM icxdmsv1__Beat_User__c WHERE icxdmsv1__Beat__c=:beatUserId];
  List<Account> relatedAccounts=new List<Account>();
    //ID beatId=beatList[0].icxdmsv1__Beat__c;
    if(Account.sObjectType.getDescribe().isAccessible()){

    relatedAccounts=[SELECT id,Name,Type, Industry, BillingAddress,BillingStreet,
    BillingCity, BillingCountry, BillingPostalCode,
    BillingState,Phone,icxdmsv1__Beat__c FROM Account WHERE BillingStreet!=NULL AND
    BillingCity!=NULL AND BillingCountry!=NULL AND  BillingPostalCode!=NULL AND
    BillingState!=NULL AND icxdmsv1__Beat__c = :beatFetch.icxdmsv1__Beat__c];
    }
    getAccount(relatedAccounts);
    return relatedAccounts;
}

@AuraEnabled(cacheable=true)
    public static List<Location> getAccount(List<Account> relatedAccounts) {

       /* List< Account> accs =  [Select Id, Name,Type, Industry, BillingAddress,BillingStreet,
                                BillingCity, BillingCountry, BillingPostalCode,
                                BillingState,Phone,icxdmsv1__Beat__c from Account where BillingStreet!=NULL AND
                                BillingCity!=NULL AND BillingCountry!=NULL AND  BillingPostalCode!=NULL AND
                                BillingState!=NULL ] ;*/
        
        List<Location> loc = new List<Location>();
        for(Account acc :relatedAccounts){
            System.debug(acc);
            GeoLocation geoInfo = new GeoLocation();
            geoInfo.Street = acc.BillingStreet;
            geoInfo.PostalCode = acc.BillingPostalCode;
            geoInfo.City = acc.BillingCity;
            geoInfo.State = acc.BillingState;
            geoInfo.Country = acc.BillingCountry;
            Location locDetail = new Location();
            locDetail.icon = 'action:map'; 
            locDetail.title = acc.Name;
            locDetail.description = acc.Name;
            locDetail.location = geoInfo;
            
            loc.add(locDetail);
        }
        return loc ;
    }
    //List<Account> accountsForEvents=relatedAccounts;
    //checkInRecordCreation(accountsForEvents);
        

  @AuraEnabled
  public static Event checkInRecordCreation(ID accountId){//,ID accountId,Date endDate,List<Account> relatedAccountse)
    Event eventRecord = new Event(); 
    //for(Account acc:relatedAccountse){
      eventRecord.WhatId=accountId;//acc.Id;
      ID userId=UserInfo.getUserId();
      eventRecord.OwnerId = userId;
      eventRecord.StartDateTime = Datetime.now();
      eventRecord.ActivityDateTime = Datetime.now();
      
     eventRecord.EndDateTime = Datetime.now().addDays(1);
     // eventRecord.Subject='I am Event Subject';
      
  //  }
    if(Event.sObjectType.getDescribe().isCreateable()){
      insert eventRecord;
      }
    return eventRecord;  
  }


}
/*@AuraEnabled(cacheable=true)
public static Map<id,Account> getBeatAccounts(List<icxdmsv1__Beat_User__c> beatList){
  Set<Id> beatIds = new Set<Id>();
  List<Account> relatedAccounts1=new List<Account>();
  Map<id,Account> relatedAccounts=new Map<id,Account>();
  //  for(Integer i:beatlist.size()){
    for (icxdmsv1__Beat_User__c beatuser1 :beatList)
  {
    beatIds.add(beatuser1.icxdmsv1__Beat__c);
      system.debug('BeatIds are shown'+beatIds);
  }
    
List<Account> BeatAccounts=[SELECT Name,icxdmsv1__Beat__c FROM Account WHERE icxdmsv1__Beat__c in :beatIds];

  for (Account beatAccount :BeatAccounts)
  {
    relatedAccounts.put(beatAccount.icxdmsv1__Beat__c,beatAccount);
  }
  
 

   // }
   // ID beatId=beatList[0].icxdmsv1__Beat__c;
    if(Account.sObjectType.getDescribe().isAccessible()){
//
    relatedAccounts1=[SELECT id,Name,Type, Industry, BillingAddress,BillingStreet,
    BillingCity, BillingCountry, BillingPostalCode,
    BillingState,Phone,icxdmsv1__Beat__c FROM Account WHERE BillingStreet!=NULL AND
    BillingCity!=NULL AND BillingCountry!=NULL AND  BillingPostalCode!=NULL AND
    BillingState!=NULL AND icxdmsv1__Beat__c in :beatIds];
    }
    getAccount(relatedAccounts1);
    system.debug('Accounts are'+relatedAccounts);
    return relatedAccounts;
}*/