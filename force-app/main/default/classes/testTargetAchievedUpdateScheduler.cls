@isTest public class testTargetAchievedUpdateScheduler {
    @isTest public static void targ(){
        icxdmsv1__Target__c targ=new icxdmsv1__Target__c();
        Integer year = Date.Today().Year();
         Integer month = Date.Today().Month();
         String targetMonth ='';
         String targetYear = String.valueOf(year); 
          Date todayDate = system.today();
		targetMonth = GetStringMonthName.getMonthName(month);  
        targ.icxdmsv1__Target_Month__c=targetMonth;
             targ.icxdmsv1__Type__c='Revenue';
            targ.icxdmsv1__Revenue_Target__c=40;
             targ.icxdmsv1__Quantity_Target__c=50; 
        icxdmsv1__Products__c targprod=new icxdmsv1__Products__c();
            targprod.Name='prod1';
        	targprod.icxdmsv1__StockKeepingUnit__c='PROD';
        	targprod.icxdmsv1__Default_Price__c=90;
        	insert targprod;
             targ.icxdmsv1__Target_Product__c=targprod.id;
	               targ.icxdmsv1__Target_Year__c=targetYear;         
             targ.icxdmsv1__Start_Date__c =todayDate;
                 targ.icxdmsv1__End_Date__c =todayDate;
        insert targ;
    }
}