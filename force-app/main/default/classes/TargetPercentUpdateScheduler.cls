global without sharing class TargetPercentUpdateScheduler implements Schedulable {

     global void execute(SchedulableContext ctx) {
         Integer year = Date.Today().Year();
         Integer month = Date.Today().Month();
         String targetMonth ='';
         String targetYear = String.valueOf(year); 
         List<icxdmsv1__Target__c> iTargets = new List<icxdmsv1__Target__c>();
         Map<Id,icxdmsv1__Target__c> tarMapData = new Map<Id,icxdmsv1__Target__c>(); 
         List < icxdmsv1__Target_Owner__c > targetOwnerData = new List < icxdmsv1__Target_Owner__c > ();
         List < icxdmsv1__Target_Owner__c > newTargetOwnerData = new List < icxdmsv1__Target_Owner__c > ();
         List < Id > targetIds = new List < Id > ();
         Date todayDate = system.today();

		targetMonth = GetStringMonthName.getMonthName(month);   
         try{
        // Getting Target data with respective to order details 
        iTargets=[select Id,icxdmsv1__Target_Month__c,icxdmsv1__Type__c,icxdmsv1__Revenue_Target__c,icxdmsv1__Quantity_Target__c,icxdmsv1__Target_Product__c 
               from icxdmsv1__Target__c where (icxdmsv1__Target_Year__c =:targetYear and icxdmsv1__Target_Month__c = :targetMonth)
                                                  or(icxdmsv1__Start_Date__c <=:todayDate AND icxdmsv1__End_Date__c >=:todayDate)];  
     	
         //Storing Target date in Map
         if(iTargets.size()>0){
         for(icxdmsv1__Target__c tardata : iTargets){
             targetIds.add(tardata.id);
         	tarMapData.put(tardata.id,tardata);
         }
         
          // Getting Target Owner data with respective to order details 
          if (icxdmsv1__Target_Owner__c.sObjectType.getDescribe().isAccessible()) {
            targetOwnerData = [select Id, icxdmsv1__Current_Revenue_Reached__c, icxdmsv1__Current_Quantity_Reached__c, icxdmsv1__Target__c, icxdmsv1__Apply_For_Dealer__c
                from icxdmsv1__Target_Owner__c where icxdmsv1__Target__c in: targetIds];
          }
         }
         
      
         if(targetOwnerData.size()>0){
         // Updating Percent Of target achieved
         for(icxdmsv1__Target_Owner__c tars : targetOwnerData){
             tars.icxdmsv1__Percent_Of_Target_Achieved__c = (tars.icxdmsv1__Current_Revenue_Reached__c/tarMapData.get(tars.icxdmsv1__Target__c).icxdmsv1__Revenue_Target__c)*100;
             newTargetOwnerData.add(tars);
         }
         
         //Updating Target
         if(icxdmsv1__Target__c.sObjectType.getDescribe().isUpdateable() && newTargetOwnerData.size()>0) {
         update newTargetOwnerData;
         }
         } 
         
    }// End of try
         
         catch(Exception e) {
   				 	System.debug('An exception occurred: ' + e.getMessage());
            
		}//End of Catch
         
     }
    
}