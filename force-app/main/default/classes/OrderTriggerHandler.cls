public inherited sharing class OrderTriggerHandler implements ITriggerHandler{
    
    // Allows unit tests (or other code) to disable this trigger for the transaction
    public static Boolean triggerDisabled = false;

    public OrderTriggerHandler() {

    }

    /*
        Checks to see if the trigger has been disabled either by custom setting or by running code
    */
    public Boolean isDisabled()
    {
        /*if (TriggerSettings__c.AccountTriggerDisabled__c = true){
            return true;
        }
        else{
            return TriggerDisabled;
        }*/

        return triggerDisabled;
    }
 
    public void beforeInsert(List<SObject> newItems) 
    {
        // Reject any Accounts which have the word "Test" in the name
        Set<Id> accIds = new Set<Id>();
        for (Order__c ord : (List<Order__c>)newItems)
        {
            accIds.add(ord.AccountId__c);
        }

        Map<Id,Account> accMap = new Map<Id,Account>([Select Id, Name, BillingAddress, BillingStreet, BillingCity, 
                                                      BillingState, BillingCountry,BillingPostalCode, ShippingAddress,
                                                      ShippingStreet, ShippingCity, ShippingState, ShippingCountry, 
                                                      ShippingPostalCode FROM Account WHERE Id in :accIds]);
        
        for (Order__c ord : (List<Order__c>)newItems)
        {
            ord = OrderUtility.defaultOrderAddress(accMap.get(ord.AccountId__c), ord);
            //system.debug(acc);
            //system.debug(ord);
        }
    }
 
    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}
 
    public void beforeDelete(Map<Id, SObject> oldItems) {}
 
    public void afterInsert(Map<Id, SObject> newItems) {}
 
    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}
 
    public void afterDelete(Map<Id, SObject> oldItems) {}
 
    public void afterUndelete(Map<Id, SObject> oldItems) {}
}