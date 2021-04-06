//ApplyOrderOffers
/*
* Author:- Vamsi Alla
* Created:- 31-08-2020
* Last Updated:- 22-03-2021 
* Last Updated By:- Somesh M
* Description:- Created for Schemes applicable on Order
*/
public with sharing class ApplyOrderOffers {
    
    List<icxdmsv1__Scheme__c> offers = new List<icxdmsv1__Scheme__c>();
    List<icxdmsv1__Promotional_Scheme__c> issuedCoupons = new List<icxdmsv1__Promotional_Scheme__c>();
    Map<Id,icxdmsv1__Promotional_Scheme__c> issuedCouponsMap = new Map<Id,icxdmsv1__Promotional_Scheme__c>();

    String offerFields = '';
    public ApplyOrderOffers() {
        offerFields = GetAllFields.getAllObjectField('icxdmsv1__Scheme__c');
        String query = 'select ' + offerFields + ' from icxdmsv1__Scheme__c where icxdmsv1__ACTIVE__c = True AND icxdmsv1__START_DATE__c <= Today and (icxdmsv1__END_DATE__c = null OR icxdmsv1__END_DATE__c >= Today) and icxdmsv1__HEADER_DISCOUNT__c = True';
        offers = Database.query(query);
    }

    public void applyOffers(List<icxdmsv1__Order__c> orders){
        String appliedOffer = '';
        String appliedOfferId = '';
        Decimal discountAmount = 0;
        Decimal discount = 0;
        Boolean qualify = false;
        Boolean couponApplied = false;
        String couponId = '';
        icxdmsv1__Promotional_Scheme__c[] coupontoinsert = new icxdmsv1__Promotional_Scheme__c[]{};
        Set<Id> cuponRefIds = new Set<Id>();
            try{
        for(icxdmsv1__Order__c order : orders){
           if(order.icxdmsv1__Type__c == 'Retailer' && order.icxdmsv1__TOTAL_AMOUNT__c > 0){
                discountAmount = 0;
                qualify = false;
                for(icxdmsv1__Scheme__c offer : offers){
                    discount = 0;
                    
                    if(offer.icxdmsv1__SCHEME_TYPE__c == 'Specific'){
                        if(offer.icxdmsv1__STATE__c != null){
                            String[] states = offer.icxdmsv1__STATE__c.split(';');
                            for(String state : states){
                                if (state == order.icxdmsv1__SHIPPINGSTATE__c){
                                    qualify = true;
                                }
                            }
                        }
                        if(offer.icxdmsv1__ORDER_AMOUNT__c != null){
                            if(order.icxdmsv1__TOTAL_AMOUNT__c >= offer.icxdmsv1__ORDER_AMOUNT__c){
                                qualify = true;
                            }else{
                                qualify = false;
                            }
                        }
                    }else{
                        qualify = true;
                    }

                    if(offer.icxdmsv1__DISCOUNT_TYPE__c == 'Amount' && qualify && !couponApplied){
                        discount = offer.icxdmsv1__DISCOUNT_AMOUNT__c;
                        if(discount > discountAmount){
                            discountAmount = discount;
                            appliedOffer = offer.Name;
                            appliedOfferId = offer.Id;
                        }
                    }else if(offer.icxdmsv1__DISCOUNT_TYPE__c == 'Percentage' && qualify && !couponApplied){
                        discount = order.icxdmsv1__TOTAL_AMOUNT__c * (offer.icxdmsv1__DISCOUNT_PERCENTAGE__c/100);
                        if(discount > discountAmount){
                            discountAmount = discount;
                            appliedOffer = offer.Name;
                            appliedOfferId = offer.Id;
                        }
                    }else if(offer.icxdmsv1__DISCOUNT_TYPE__c == 'Coupon' && qualify && !couponApplied){
                        couponId = offer.icxdmsv1__Coupon__c;
                        appliedOffer = offer.Name;
                        appliedOfferId = offer.Id;
                        couponApplied = true;
                    }else {
                        //do nothing
                    }
                
                    if(couponId != ''){
                        if(order.icxdmsv1__Coupon_Id__c == null && order.Promotional_Scheme__c == null){
                            order.icxdmsv1__Coupon_Id__c = couponId;
                            Id accountId = order.icxdmsv1__AccountId__c;
                            icxdmsv1__Promotional_Scheme__c isscoupon = new icxdmsv1__Promotional_Scheme__c();
                            isscoupon.icxdmsv1__Account__c = accountId;
                            isscoupon.icxdmsv1__Coupon__c = couponId;
                            coupontoinsert.add(isscoupon);
                            /*if (Schema.sObjectType.Promotional_Offer__c.fields.Account__c.isCreateable()&&Schema.sObjectType.Promotional_Offer__c.fields.Coupon__c.isCreateable()) {
                            insert isscoupon;
                            }*/
                            
                            order.icxdmsv1__Promotional_Scheme__c = isscoupon.Id;
                        }
                        discountAmount = 0;
                    }else if(order.Promotional_Scheme__c != null){
                        order.icxdmsv1__Coupon_Id__c = null;

                        cuponRefIds.add(order.Promotional_Scheme__c);
                        order.icxdmsv1__Promotional_Scheme__c = null;
                    }else{
                        // do nothing
                    }
                    if(appliedOfferId != ''){
                        order.icxdmsv1__Applied_Scheme__c = appliedOfferId;
                    }else{
                        order.icxdmsv1__Applied_Scheme__c = null;
                    }
                    order.icxdmsv1__DISCOUNT_AMOUNT__c = discountAmount;
                    order.icxdmsv1__APPLIED_OFFER__c = appliedOffer;
                    if(appliedOffer != ''){
                        order.icxdmsv1__HEADER_DISCOUNT__c = true;
                    }else{
                        order.icxdmsv1__HEADER_DISCOUNT__c = false;
                    }
                }
            }
        }
        if(coupontoinsert.size() > 0)
        if(icxdmsv1__Promotional_Scheme__c.sObjectType.getDescribe().isCreateable()&&
        Coupon__c.sObjectType.getDescribe().isCreateable()&&
        Schema.sObjectType.icxdmsv1__Promotional_Scheme__c.fields.Account__c.isCreateable()&&
          Schema.sObjectType.icxdmsv1__Promotional_Scheme__c.fields.Coupon__c.isCreateable()
        ){
       	  insert coupontoinsert;
        }
        if(cuponRefIds.size() > 0)
        if(icxdmsv1__Promotional_Scheme__c.SObjectType.getDescribe().isAccessible() ){
            List<icxdmsv1__Promotional_Scheme__c> coupReff = new List<icxdmsv1__Promotional_Scheme__c>();
            coupReff = [Select Id from icxdmsv1__Promotional_Scheme__c where Id in :cuponRefIds];
            if (icxdmsv1__Promotional_Scheme__c.sObjectType.getDescribe().isDeletable()) {
               delete coupReff;
            }
        }

    }//End of try

	catch(Exception e) {
   				 	System.debug('An exception occurred: ' + e.getMessage());
            
	}//End of Catch
                
    }//End Of Method
} // End of Class