public inherited sharing class OrderLWCHandler {
    public OrderLWCHandler() {

    }

    @AuraEnabled(cacheable=true)
    public static String getOrderAccountId(String orderId){
        try {
            Order__c ord = [Select Id, AccountId__c from Order__c where Id =:orderId];
            return ord.AccountId__c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static list<icxdmsv1__OrderItem__c> getOrderLineItems(String orderId){
        try {
            String SobjectApiName = 'icxdmsv1__OrderItem__c';
            String fieldsName = Utility.getAllFields(SobjectApiName);
            String query = 'select ' + fieldsName + ' from ' + SobjectApiName + ' where icxdmsv1__OrderId__c = \'' +orderId+ '\'';
            list<icxdmsv1__OrderItem__c> orderItms =  Database.query(query);
            return orderItms;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}