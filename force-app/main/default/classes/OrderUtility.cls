public inherited sharing class OrderUtility {
    public OrderUtility() {

    }

    public static Order__c defaultOrderAddress(Account acc, Order__c ord){
        if(ord.AccountId__c != null){
            //Populating Default Order BIlling address with Account Billing Address
            Address billingAddr = (Address) acc.BillingAddress;
            ord.BillingStreet__c = billingAddr.getStreet();
            ord.BILLINGCITY__c = billingAddr.getCity();
            ord.BILLINGSTATE__c = billingAddr.getState();
            ord.BILLINGCOUNTRY__c = billingAddr.getCountry();
            ord.BILLINGPOSTALCODE__c = billingAddr.getPostalCode();
            
            //Populating Default Order Shipping address with Account Shipping Address.
            Address shippingAddr = (Address) acc.ShippingAddress;
            ord.SHIPPINGStreet__c = shippingAddr.getStreet();
            ord.SHIPPINGCITY__c = shippingAddr.getCity();
            ord.SHIPPINGSTATE__c = shippingAddr.getState();
            ord.SHIPPINGCOUNTRY__c = shippingAddr.getCountry();
            ord.SHIPPINGPOSTALCODE__c = shippingAddr.getPostalCode();
        }
        return ord;
    }
}