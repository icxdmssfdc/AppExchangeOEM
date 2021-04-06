trigger OrderItemTrigger on icxdmsv1__OrderItem__c (before insert,before update) {

    if(Trigger.isBefore){        
       //ApplyOrderLineOffers ordOff=new ApplyOrderLineOffers();
       //ordOff.applyOffers(Trigger.new);
    }
    
}