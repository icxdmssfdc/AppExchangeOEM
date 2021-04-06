public with sharing class TargetController {

   Public Static String userType = '';

   //Retrieving list of Target Owners from the salesforce
   @AuraEnabled(cacheable=true)
    public static List<icxdmsv1__Target_Owner__c> getTargetOwnersList() {
         userType = UserInfo.getUserType();
         Integer year = Date.Today().Year();
         Integer month = Date.Today().Month();
         String targetMonth ='';
         String targetYear = String.valueOf(year);
         Date todayDate = system.today();
        
        targetMonth = GetStringMonthName.getMonthName(month);
        List<icxdmsv1__Target__c> iTargets = new List<icxdmsv1__Target__c>();
        List < icxdmsv1__Target_Owner__c > targetOwnerData = new List < icxdmsv1__Target_Owner__c > ();
        List < Id > targetIds = new List < Id > ();
        Id userId = UserInfo.getUserId();
        Id dealerAccntId =[select account.id from user where Id = :userId].account.id;
        
        // Getting Target data
        iTargets=[select Id,icxdmsv1__Target_Month__c,icxdmsv1__Type__c,icxdmsv1__Revenue_Target__c,icxdmsv1__Quantity_Target__c,icxdmsv1__Target_Product__c 
               from icxdmsv1__Target__c where (icxdmsv1__Target_Year__c =:targetYear and icxdmsv1__Target_Month__c = :targetMonth)
                                                  or(icxdmsv1__Start_Date__c <=:todayDate AND icxdmsv1__End_Date__c >=:todayDate)];  
     	
         //Storing Target date in Map
         for(icxdmsv1__Target__c tardata : iTargets){
             targetIds.add(tardata.id);
         }
        
         // Getting Target Owner data with respective to order details 
          if (icxdmsv1__Target_Owner__c.sObjectType.getDescribe().isAccessible() && userType == 'Standard') {
            targetOwnerData = [select Id,Name, icxdmsv1__Current_Revenue_Reached__c, icxdmsv1__Current_Quantity_Reached__c, icxdmsv1__Target__r.Name,icxdmsv1__Target_Quantity__c,icxdmsv1__Target_Revenue__c,icxdmsv1__Target_Product__c 
                from icxdmsv1__Target_Owner__c where icxdmsv1__Target_Achieved__c =false and icxdmsv1__Target__c in: targetIds and icxdmsv1__Salesrep__c =: userId];
          }else {
            if (icxdmsv1__Target_Owner__c.sObjectType.getDescribe().isAccessible()){
            targetOwnerData = [select Id,Name, icxdmsv1__Current_Revenue_Reached__c, icxdmsv1__Current_Quantity_Reached__c, icxdmsv1__Target__r.Name,icxdmsv1__Target_Quantity__c,icxdmsv1__Target_Revenue__c,icxdmsv1__Target_Product__c
                from icxdmsv1__Target_Owner__c where icxdmsv1__Target_Achieved__c =false and  icxdmsv1__Target__c in: targetIds and icxdmsv1__Dealer__c =: dealerAccntId
                              ];}
        }
        
        system.debug(targetOwnerData);
        
        return targetOwnerData;
    }
    
    //Retrieving list of Target Owners from the salesforce
   @AuraEnabled(cacheable=true)
    public static List<icxdmsv1__Target_Incentive_Junction__c> getIncentiveList() {
         userType = UserInfo.getUserType();
         Integer year = Date.Today().Year();
         Integer month = Date.Today().Month();
         String targetMonth ='';
         String targetYear = String.valueOf(year);
         Date todayDate = system.today();
        
        targetMonth = GetStringMonthName.getMonthName(month);
        List<icxdmsv1__Target__c> iTargets = new List<icxdmsv1__Target__c>();
        List <icxdmsv1__Target_Owner__c> targetOwnerData = new List <icxdmsv1__Target_Owner__c> ();
        List<icxdmsv1__Target_Incentive_Junction__c> iIncentives = new List<icxdmsv1__Target_Incentive_Junction__c>();
        List <Id> targetIds = new List <Id>();
        Set <Id> newTargetIds = new Set <Id>();        
        List <Id> newTargetOwnertIds = new List <Id>();
        //Set<icxdmsv1__Target__c> newTargets = new Set<icxdmsv1__Target__c>();
        Id userId = UserInfo.getUserId();
        Id dealerAccntId =[select account.id from user where Id = :userId].account.id;
        
        // Getting Target data
        iTargets=[select Id,icxdmsv1__Target_Month__c,icxdmsv1__Type__c,icxdmsv1__Revenue_Target__c,icxdmsv1__Quantity_Target__c,icxdmsv1__Target_Product__c 
               from icxdmsv1__Target__c where (icxdmsv1__Target_Year__c =:targetYear and icxdmsv1__Target_Month__c = :targetMonth)
                                                  or(icxdmsv1__Start_Date__c <=:todayDate AND icxdmsv1__End_Date__c >=:todayDate)];  
     	
         //Storing Target date in Map
         for(icxdmsv1__Target__c tardata : iTargets){
             targetIds.add(tardata.id);
         }
        
         // Getting Target Owner data with respective to order details 
          if (icxdmsv1__Target_Owner__c.sObjectType.getDescribe().isAccessible() && userType == 'Standard') {
            targetOwnerData = [select Id,Name,icxdmsv1__Target__c,icxdmsv1__Target_Achieved__c,icxdmsv1__Incentive_Availed__c
                from icxdmsv1__Target_Owner__c where icxdmsv1__Target_Achieved__c =true and icxdmsv1__Incentive_Availed__c=false and icxdmsv1__Target__c in: targetIds and icxdmsv1__Salesrep__c =: userId];
          }else {
            if (icxdmsv1__Target_Owner__c.sObjectType.getDescribe().isAccessible()){
            targetOwnerData = [select Id,Name,icxdmsv1__Target__c,icxdmsv1__Target_Achieved__c,icxdmsv1__Incentive_Availed__c
                from icxdmsv1__Target_Owner__c where icxdmsv1__Target_Achieved__c =true and icxdmsv1__Incentive_Availed__c=false and  icxdmsv1__Target__c in: targetIds and icxdmsv1__Dealer__c =: dealerAccntId
                              ];}
        }
        
        if(targetOwnerData.size()>0){
            for(icxdmsv1__Target_Owner__c tar : targetOwnerData){
            newTargetOwnertIds.add(tar.id); 
            newTargetIds.add(tar.icxdmsv1__Target__c);
        }
        }
        
        if(newTargetIds.size()>0 && icxdmsv1__Target_Incentive_Junction__c.sObjectType.getDescribe().isAccessible()){
        //Getting Incetive data from junction object mapping
        iIncentives = [select id,icxdmsv1__Target__r.Name,icxdmsv1__Incentive__r.Name,Name from icxdmsv1__Target_Incentive_Junction__c
                      where icxdmsv1__Target__c in :newTargetIds];
        }
        system.debug('These are the newTargets Idss..... '+ newTargetIds);
        system.debug('These are the relative Incentives of the Target achieved..... '+ iIncentives);
        
        return iIncentives;
    }
    
   //Submitting target owner for approval and Updating Incentive
   @AuraEnabled
    public static void updateIncentive(Id juctionId) {
         userType = UserInfo.getUserType();
         Integer year = Date.Today().Year();
         Integer month = Date.Today().Month();
         String targetMonth ='';
         String targetYear = String.valueOf(year);
         Date todayDate = system.today();
         Id userId = UserInfo.getUserId();
        Id dealerAccntId =[select account.id from user where Id = :userId].account.id;
        targetMonth = GetStringMonthName.getMonthName(month);
        
        system.debug('Junction Id is.......'+juctionId);
        
        List<icxdmsv1__Target__c> iTargets = new List<icxdmsv1__Target__c>();
        List <icxdmsv1__Target_Owner__c> targetOwnerData = new List <icxdmsv1__Target_Owner__c>();
        List <icxdmsv1__Target_Owner__c> newTargetOwnerData = new List <icxdmsv1__Target_Owner__c>();
        List<icxdmsv1__Target_Incentive_Junction__c> ijuction = new List<icxdmsv1__Target_Incentive_Junction__c>();
        
        if (icxdmsv1__Target_Incentive_Junction__c.sObjectType.getDescribe().isAccessible()){
        ijuction = [select id,icxdmsv1__Target__c,icxdmsv1__Incentive__c from icxdmsv1__Target_Incentive_Junction__c where id = :juctionId];
        }
        
        Id targetId = ijuction[0].icxdmsv1__Target__c;
        Id inctvId = ijuction[0].icxdmsv1__Incentive__c;
        
        if (icxdmsv1__Target_Owner__c.sObjectType.getDescribe().isAccessible() && userType == 'Standard'){
            targetOwnerData =[select id,icxdmsv1__Target__c,icxdmsv1__Target_Achieved__c,icxdmsv1__Incentive__c,icxdmsv1__Incentive_Availed__c
                             from icxdmsv1__Target_Owner__c where icxdmsv1__Target__c = :targetId and icxdmsv1__Target_Achieved__c =true
                             and icxdmsv1__Salesrep__c =: userId and icxdmsv1__Status__c = 'Draft'];
        }
        else{            
             if (icxdmsv1__Target_Owner__c.sObjectType.getDescribe().isAccessible()){
            targetOwnerData =[select id,icxdmsv1__Target__c,icxdmsv1__Target_Achieved__c,icxdmsv1__Incentive__c,icxdmsv1__Incentive_Availed__c
                             from icxdmsv1__Target_Owner__c where icxdmsv1__Target__c = :targetId and icxdmsv1__Target_Achieved__c =true
                             and icxdmsv1__Dealer__c = :dealerAccntId and icxdmsv1__Status__c = 'Draft'];
        }
        }
        
        if(targetOwnerData.size()>0){
            for(icxdmsv1__Target_Owner__c tar : targetOwnerData){
                
                tar.icxdmsv1__Incentive__c = inctvId;
                tar.icxdmsv1__Incentive_Availed__c = true;
                newTargetOwnerData.add(tar);
            }
            
            //Updating Target Owner data
            if (icxdmsv1__Target_Owner__c.sObjectType.getDescribe().isUpdateable()) {
                update newTargetOwnerData;
            }
            
            for(icxdmsv1__Target_Owner__c tar : targetOwnerData){
                // Create an approval request for  Opportunity        
        		Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();          
       			req.setComments('Submitting approval request using Trigger');        
        		req.setObjectId(tar.id);
                // Submit on behalf of a specific submitter
                req.setSubmitterId(userId);
        		// Submit the approval request for the Opportunity        
        		Approval.ProcessResult result = Approval.process(req); 
            }            
        }//End of if
                            
    }
}