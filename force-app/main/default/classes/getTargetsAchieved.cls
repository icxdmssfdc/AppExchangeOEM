public with sharing class getTargetsAchieved {
    @AuraEnabled(cacheable=true)
    public static List<icxdmsv1__Target__c> getTargetsAchieved() {
        return [SELECT Id,icxdmsv1__Revenue_Target__c,icxdmsv1__Quantity_Target__c,icxdmsv1__Target_Achieved__c  FROM icxdmsv1__Target__c];
    }
}