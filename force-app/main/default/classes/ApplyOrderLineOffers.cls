//ApplyOrderLineOffers
/*
* Author:- Vamsi Alla
* Created:- 31-08-2020
* Last Updated:- 22-03-2021 
* Last Updated By:- Somesh M
* Description:- Created for Schemes applicable on Order Line Items
*/
public with sharing class ApplyOrderLineOffers {
    
		List<icxdmsv1__Scheme__c> offers = new List<icxdmsv1__Scheme__c>();
        String offerFields = ''; 
    
        public ApplyOrderLineOffers() {
        offerFields = GetAllFields.getAllObjectField('icxdmsv1__Scheme__c');
        String query = 'select ' + offerFields + ' from icxdmsv1__Scheme__c where icxdmsv1__ACTIVE__c = True AND icxdmsv1__START_DATE__c <= Today AND (icxdmsv1__END_DATE__c = null OR icxdmsv1__END_DATE__c >= Today) and icxdmsv1__HEADER_DISCOUNT__c = False';
        offers = Database.query(query);
    }
    
    public void applyOffers(List<icxdmsv1__OrderItem__c> orderitems){
        
        String appliedOffer = '';
        String appliedOfferId = '';
        Decimal discountAmount = 0;
        Decimal discount = 0;
        Boolean qualify = false;
        Boolean qtyApplied = false;
        Decimal unitPrice = 0;
        Decimal freeQty = 0;
        Boolean qtyDiscApplied = false;
        List <icxdmsv1__OrderItem__c> orderitemtoinsert = new List <icxdmsv1__OrderItem__c>();
        List <icxdmsv1__OrderItem__c> orderitemtoupdate = new List <icxdmsv1__OrderItem__c>();
        Set<Id> dealerIds = new Set<Id>();
        Set<Id> orderIds = new Set<Id>();
        Set<Id> prodIds = new Set<Id>();
        Set<Date> invDates = new Set<Date>();
        
        List <icxdmsv1__Inventory__c> invData = new List <icxdmsv1__Inventory__c>();
        List<AggregateResult> invAggregateData = new List<AggregateResult>();
        Map <String,AggregateResult> invAggreMapData = new Map <String,AggregateResult>();
        Map <Id,icxdmsv1__Inventory__c> invMapData = new Map <Id,icxdmsv1__Inventory__c>();
        try{
         for(icxdmsv1__OrderItem__c orderlineitems :orderitems){
            orderIds.add(orderlineitems.icxdmsv1__OrderId__c);
            dealerIds.add(orderlineitems.icxdmsv1__Dealer__c);
            prodIds.add(orderlineitems.icxdmsv1__Product2Id__c);
        }
        
        if(icxdmsv1__Inventory__c.sObjectType.getDescribe().isAccessible()){
        invAggregateData = [select min(createddate),icxdmsv1__Dealer__c,icxdmsv1__Product__c
                     from icxdmsv1__Inventory__c where icxdmsv1__Dealer__c in :dealerIds and icxdmsv1__Product__c in :prodIds
                  and icxdmsv1__Current_OnHand_Qty__c>0 group by icxdmsv1__Product__c,icxdmsv1__Dealer__c];
        }
        
        //Creating Map of inventory and Account,Product as key
        if(invAggregateData.size()>0){
            for(AggregateResult ar : invAggregateData){
                String invKey =  String.valueOf(ar.get('icxdmsv1__Dealer__c'));
                invDates.add(Date.valueOf(ar.get('min(createddate)')));
                invAggreMapData.put(invKey,ar);
                
            }
            
            }
        //Fetching new data
        if(icxdmsv1__Inventory__c.sObjectType.getDescribe().isAccessible()){
           invData = [select Id,icxdmsv1__Dealer__c,icxdmsv1__Product__c,createddate
                     from icxdmsv1__Inventory__c where icxdmsv1__Dealer__c in :dealerIds and icxdmsv1__Product__c in :prodIds
                  and icxdmsv1__Current_OnHand_Qty__c>0 and createddate in :invDates];                       
        }
        
        for(icxdmsv1__Inventory__c invd : invData){
            invMapData.put(invd.icxdmsv1__Dealer__c,invd);            
        }
        
		for(icxdmsv1__OrderItem__c orderitem:orderitems){
			
		 if(orderitem != null && orderitem.icxdmsv1__Order_Record_Type__c == 'Retailer'){
			 
			 discountAmount = 0;
			 
			 for(icxdmsv1__Scheme__c offer : offers){
				 discount = 0;
				      if(offer.icxdmsv1__SCHEME_TYPE__c == 'Specific'){
                        if(offer.icxdmsv1__STATE__c != null){
                            String[] states = offer.icxdmsv1__STATE__c.split(';');
                            for(String state : states){
                                if (state == orderitem.Shipping__c){
                                    qualify = true;
                                }
                            }
                        }
                        if(offer.icxdmsv1__ORDER_AMOUNT__c != null){
                            if(orderitem.icxdmsv1__Total_Price__c >= offer.icxdmsv1__ORDER_AMOUNT__c){
                                qualify = true;
                            }else{
                                qualify = false;
                            }
                        }
                        if(offer.icxdmsv1__Product__c != null){
                            if(orderitem.icxdmsv1__Product2Id__c == offer.icxdmsv1__Product__c){
                                qualify = true;
                            }else{
                                qualify = false;
                            }
                        }
                    }else{
                        qualify = true;
                    }
					
					
					// Logic for Quantity Offer
					if(offer.icxdmsv1__DISCOUNT_TYPE__c == 'Quantity' && qualify){
                        if(orderitem.icxdmsv1__Quantity__c >= offer.icxdmsv1__BUY__c){
                            discount = offer.icxdmsv1__GET__c * orderitem.icxdmsv1__UnitPrice__c;
                            
                            if(discount > discountAmount){   
                                Decimal totalunits = orderitem.icxdmsv1__Quantity__c + offer.icxdmsv1__GET__c;
                                if(orderitem.icxdmsv1__List_Price__c != null){
                                    unitPrice = (orderitem.icxdmsv1__List_Price__c * orderitem.icxdmsv1__Quantity__c) / totalunits;
                                }else{
                                    unitPrice = (orderitem.icxdmsv1__UnitPrice__c * orderitem.icxdmsv1__Quantity__c) / totalunits;
                                }
                                orderitem.icxdmsv1__Quantity__c = totalunits;
                                discountAmount = discount;
                                appliedOffer = offer.Name;
                                appliedOfferId = offer.Id;
                                qtyDiscApplied = true;
                                freeQty = offer.icxdmsv1__GET__c;
                            }
                        }
                    }
					else if(offer.icxdmsv1__DISCOUNT_TYPE__c == 'Cross Product Offer' && qualify){
                        if(orderitem.icxdmsv1__Quantity__c >= offer.icxdmsv1__BUY__c){
							
                                List<Order> order = new List<Order>();
                                Decimal qty = offer.icxdmsv1__GET__c;
                                String product2Id = offer.icxdmsv1__Get_Product__c;
                                Id dealerId = orderitem.icxdmsv1__Dealer__c;
                                
                                //String orderId = orderitem.OrderId;

                                //if(pricebookExists){                                  	
                                    if(orderitemtoupdate.size()<=0){
                                        icxdmsv1__OrderItem__c ordItemins = new icxdmsv1__OrderItem__c();
                                        ordItemins.icxdmsv1__OrderId__c = orderitem.icxdmsv1__OrderId__c;
                                        ordItemins.icxdmsv1__Product2Id__c = product2Id;
                                        ordItemins.icxdmsv1__UnitPrice__c = 0.00;
                                        ordItemins.icxdmsv1__Quantity__c = qty;
                                        ordItemins.icxdmsv1__Cross_Discount_Product_Id__c=orderitem.Id;
										ordItemins.icxdmsv1__Batch_Number__c = invMapData.get(dealerId).Id;
                                        orderitemtoinsert.add(ordItemins);
                                       
                                    }
                                    appliedOffer = offer.Name;
                                    appliedOfferId = offer.Id;
                             
                              //}

                        }
						
                    }else {
                        //do nothing
                    }
				 
				 
				 

				 
			 } // End of Scheme for loop			 
			 
		 
				if(qtyDiscApplied == true){
                    orderitem.icxdmsv1__Offered_Quantity__c = freeQty;
                }else{
                    orderitem.icxdmsv1__Offered_Quantity__c = 0;
                }
                if(unitPrice > 0){
                    orderitem.icxdmsv1__UnitPrice__c = unitPrice;
                }
                if(appliedOfferId != ''){
                    orderitem.icxdmsv1__Applied_Scheme__c = appliedOfferId;
                }else{
                    orderitem.icxdmsv1__Applied_Scheme__c = null;
                }
		 
		 }
		
		} // End of Order Item for loop	
		
		
		if(orderitemtoinsert.size() > 0 && Orderitem.sObjectType.getDescribe().isCreateable()){
						
			insert orderitemtoinsert;
						
		}
		        
            
        } //End of try   
        
     catch(Exception e) {
   				 	System.debug('An exception occurred: ' + e.getMessage());
            
	}//End of Catch
        
    } // End of applyOffers Method
        
} // End of Class