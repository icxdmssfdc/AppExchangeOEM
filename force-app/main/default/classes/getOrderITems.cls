public inherited sharing class getOrderITems {
    @AuraEnabled(cacheable=true)
    public static List<icxdmsv1__OrderItem__c> getItemsList() {
        return [SELECT Name, icxdmsv1__Product2Id__c, icxdmsv1__Quantity__c, icxdmsv1__Total_Price__c  FROM icxdmsv1__OrderItem__c where icxdmsv1__OrderId__c='a004x000005R0YrAAK'];
    }
}