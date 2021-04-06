trigger OrderTrigger on Order__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    TriggerDispatcher.run(new OrderTriggerHandler());
    
    if(Trigger.isBefore && Trigger.isUpdate){      
            ApplyOrderOffers applyoffers = new ApplyOrderOffers();
            applyoffers.applyOffers(Trigger.New);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){        
        InventoryUpdate invUpdate = new InventoryUpdate();
        invUpdate.updateInventory(Trigger.New);
    }
}