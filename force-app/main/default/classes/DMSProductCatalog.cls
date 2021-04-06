public with sharing class DMSProductCatalog {

    @AuraEnabled
    public static List<icxdmsv1__Products__c> getProducts() {
      // LETS GO!
        return [SELECT Id, Name, icxdmsv1__Family__c, icxdmsv1__Default_Price__c, icxdmsv1__Description__c, icxdmsv1__VF_Image__c, icxdmsv1__Catalog_Image__c, icxdmsv1__Image_Document_ID__c
            FROM icxdmsv1__Products__c
            WHERE icxdmsv1__Family__c != null
            ORDER BY icxdmsv1__Family__c ASC, Name ASC NULLS FIRST];
    }

    @AuraEnabled
    public static icxdmsv1__Order__c getOrder(list<Account> accounts){
        String accountId = accounts[0].Id;
        String ordId = '';
        icxdmsv1__Order__c order = [Select Id,icxdmsv1__AccountId__c,icxdmsv1__TOTAL_AMOUNT__c,icxdmsv1__Discount_Amount__c,icxdmsv1__GRAND_TOTAL_AMOUNT__c,icxdmsv1__APPLIED_OFFER__c from icxdmsv1__Order__c where icxdmsv1__STATUS__c = 'Draft' AND icxdmsv1__AccountId__c =:accountId order by Id DESC Limit 1];
        icxdmsv1__Order__c orders = new icxdmsv1__Order__c();
        RecordType dt = [SELECT Id FROM RecordType WHERE sObjectType = 'Order' AND Name = 'PartnerDealer'];//for partnerdealer recordtype id
        orders.icxdmsv1__AccountId__c = accountId;
        orders.icxdmsv1__EFFECTIVEDATE__c =  system.today();
        orders.icxdmsv1__STATUS__c = 'Draft';
        orders.RecordTypeId = dt.Id;//'0122v000002RJ3vAAG';
        insert orders;
            ordId = order.Id;
            return order;
        
           
           }
    
    @AuraEnabled
    public static list<icxdmsv1__OrderItem__c> getOrderItems(Order order){
        String ordId = order.Id;
        return [SELECT Id, icxdmsv1__OrderId__c, icxdmsv1__Quantity__c, icxdmsv1__UnitPrice__c, icxdmsv1__List_Price__c, icxdmsv1__Total_Price__c, icxdmsv1__Description__c, icxdmsv1__Applied_Scheme__c, icxdmsv1__Discount_Amount__c, icxdmsv1__Offered_Quantity__c from icxdmsv1__OrderItem__c WHERE icxdmsv1__OrderId__c =: ordId];
    }

    @AuraEnabled
    public static list<icxdmsv1__OrderItem__c> addOrderItem(String accountId, Order order, String product, Integer quantity){
        String orderId = order.Id;
        String product2Id = product;
        //List<icxdmsv1__Order__c> accountId = [Select icxdmsv1__AccountId__c from icxdmsv1__Order__c where Id =:orderId];

        //Id newid = accountId.icxdmsv1__AccountId__c;
        if(icxdmsv1__Inventory__c.sObjectType.getDescribe().isAccessible()){
        icxdmsv1__Inventory__c price = [Select Id,icxdmsv1__Dealer_Price__c from icxdmsv1__Inventory__c where icxdmsv1__Dealer__c =: accountId AND icxdmsv1__Product__c =:product2Id];
        if(OrderItem.sObjectType.getDescribe().isAccessible()){
            icxdmsv1__OrderItem__c ordItm = [Select Id from icxdmsv1__OrderItem__c where icxdmsv1__OrderId__c =:orderId];
            icxdmsv1__OrderItem__c ordItem = new icxdmsv1__OrderItem__c();
			ordItem.icxdmsv1__OrderId__c = orderId;
			ordItem.icxdmsv1__Product2Id__c = product2Id;
			ordItem.icxdmsv1__UnitPrice__c = price.icxdmsv1__Dealer_Price__c;
			ordItem.icxdmsv1__Quantity__c = quantity;
			insert ordItem;
			}
          }
        return [SELECT Id, icxdmsv1__OrderId__c,icxdmsv1__Product2Id__c, icxdmsv1__Quantity__c, icxdmsv1__UnitPrice__c, icxdmsv1__List_Price__c, icxdmsv1__Total_Price__c, icxdmsv1__Description__c, icxdmsv1__Applied_Scheme__c, icxdmsv1__Discount_Amount__c, icxdmsv1__Offered_Quantity__c from icxdmsv1__OrderItem__c WHERE icxdmsv1__OrderId__c =: orderId];
    }

    @AuraEnabled
    public static list<icxdmsv1__OrderItem__c> removeOrderItem(Order order, String product){
        String orderId = order.Id;
        String product2Id = product;
       list<icxdmsv1__OrderItem__c> ordItems = [Select Id from icxdmsv1__OrderItem__c where icxdmsv1__OrderId__c =:orderId and icxdmsv1__Product2Id__c =: product2Id];
        if (OrderItem.sObjectType.getDescribe().isDeletable()){
            delete ordItems;
        }
        return [SELECT Id, icxdmsv1__OrderId__c,icxdmsv1__Product2Id__c, icxdmsv1__Quantity__c, icxdmsv1__UnitPrice__c, icxdmsv1__List_Price__c, icxdmsv1__Total_Price__c, icxdmsv1__Description__c, icxdmsv1__Applied_Scheme__c, icxdmsv1__Discount_Amount__c, icxdmsv1__Offered_Quantity__c from icxdmsv1__OrderItem__c WHERE icxdmsv1__OrderId__c =: orderId];
    }
    
    @AuraEnabled
    public static string createCatalogOrder(String accountId, List<icxdmsv1__OrderItem__c> items) {
        // Check if we can view fields on Orders
        // LETS GO!
        icxdmsv1__Order__c newOrder = new icxdmsv1__Order__c();
        newOrder.icxdmsv1__AccountId__c = accountId;
        newOrder.icxdmsv1__STATUS__c = 'Submitted';
		 if (icxdmsv1__Order__c.sObjectType.getDescribe().isCreateable()){
        insert newOrder;
        List<icxdmsv1__OrderItem__c> lineItems = new List<icxdmsv1__OrderItem__c>();
        for (icxdmsv1__OrderItem__c lineItem : items) {
            lineitem.icxdmsv1__OrderId__c = newOrder.Id;
            
            lineItems.add(lineItem);
        }
        if (icxdmsv1__OrderItem__c.sObjectType.getDescribe().isCreateable()){
        insert lineItems;
        }
        }
        return [SELECT Name FROM icxdmsv1__Order__c WHERE Id =: newOrder.Id].Name;
    }


    @AuraEnabled
    public static string createCartOrder(Order order) {
        String orderId = order.Id;
        order.status = 'Confirmed';
        update order;
       return [SELECT Name FROM icxdmsv1__Order__c WHERE Id =:orderId].Name;
    }
    
    @AuraEnabled
    public static List<Account> getAccounts() {
        // Check if we can view fields on Account
    return [SELECT Id, Name from Account where icxdmsv1__Record_Type__c = 'Dealer'];
    }
    

    @AuraEnabled
    public static List<icxdmsv1__Order__c> addOrderDetails(Order order) {
        // Check if we can view fields on Account
        String ordId = order.Id;
    return [Select Id,icxdmsv1__TOTAL_AMOUNT__c,icxdmsv1__DISCOUNT_AMOUNT__c,icxdmsv1__GRAND_TOTAL_AMOUNT__c,icxdmsv1__APPLIED_OFFER__c from icxdmsv1__Order__c where Id =: ordId];
    }

    @AuraEnabled
    public static List<icxdmsv1__Scheme__c> getOffers(){
        return [Select Name from icxdmsv1__Scheme__c where icxdmsv1__Active__c = True];
    }
}