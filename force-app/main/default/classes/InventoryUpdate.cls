//InventoryUpdate
/*
* Author:- Somesh M
* Created:- 26-03-2021
* Last Updated:-  Updated
* Last Updated By:- 
* Description:- Created for Inventory Updation depending on Order type
*/
public with Sharing class InventoryUpdate {

    public void updateInventory(List <icxdmsv1__Order__c> orderdata) {
        String sOrderAccId = '';
        String sDistributorId = '';
        List <Id> orderIds = new List <Id> ();
        List <Id> accIds = new List <Id> ();
        List <Id> invIds = new List < Id > ();
        List <icxdmsv1__OrderItem__c> orderItems = new List <icxdmsv1__OrderItem__c>();
        List <icxdmsv1__Inventory__c> invItems = new List <icxdmsv1__Inventory__c>();
        Map <Id, icxdmsv1__Inventory__c> invMapdetails = new Map <Id, icxdmsv1__Inventory__c>();
        Map<Id,icxdmsv1__OrderItem__c> ordItmMapDetails = new Map<Id,icxdmsv1__OrderItem__c>();
        List <icxdmsv1__Inventory__c> newInvItems = new List <icxdmsv1__Inventory__c>();
      
        try {
        //Adding Acount and Order Id's to Set Collection
        for (icxdmsv1__Order__c order: orderdata) {
            accIds.add(order.icxdmsv1__AccountId__c);
            orderIds.add(order.Id);
        }
    	
        //Fetching Order Items data related to Orders
        if(icxdmsv1__OrderItem__c.sObjectType.getDescribe().isAccessible()){
            orderItems=[select id,icxdmsv1__Quantity__c,icxdmsv1__Product2Id__c,icxdmsv1__OrderId__c,icxdmsv1__Batch_Number__c 
                        from icxdmsv1__OrderItem__c where icxdmsv1__OrderId__c in : orderIds];            
        }
        
        if(orderItems.size()>0){
        for(icxdmsv1__OrderItem__c ordItm : orderItems){            
            invIds.add(ordItm.icxdmsv1__Batch_Number__c);
            ordItmMapDetails.put(ordItm.icxdmsv1__Batch_Number__c,ordItm);
        }
        }
        
        //Fetching Inventory data related to Orders
        if(icxdmsv1__Inventory__c.sObjectType.getDescribe().isAccessible()){
            invItems= [select Id,icxdmsv1__Product__c,icxdmsv1__Batch_Number__c,icxdmsv1__Receivable_Qty__c,
                               icxdmsv1__Shipment_Quantity__c,icxdmsv1__OnHand_Qty__c from icxdmsv1__Inventory__c where Id in : invIds];            
        }
        
        if(invItems.size()>0){
            for(icxdmsv1__Inventory__c inv : invItems){
                invMapdetails.put(inv.Id,inv);                
            }            
        }
        
        
        for (icxdmsv1__Order__c ord: orderdata) {
            // Processing Dealer Orders for updating Inventory
            if (ord.icxdmsv1__Type__c == 'Dealer') {
                
                for(icxdmsv1__Inventory__c inv : invItems){
                    if (ord.icxdmsv1__STATUS__c == 'Confirmed') {
                        Decimal qty = ordItmMapDetails.get(inv.Id).icxdmsv1__Quantity__c;                                     
                        inv.icxdmsv1__Receivable_Qty__c += qty;
                    }  
                    else if (ord.icxdmsv1__STATUS__c == 'Delivered') {
                        Decimal qty = ordItmMapDetails.get(inv.Id).icxdmsv1__Quantity__c;
                        inv.icxdmsv1__Receivable_Qty__c -= qty;
                        inv.icxdmsv1__OnHand_Qty__c += qty;
                    }                     
                    else {
                        continue;
                    }
                    
                    newInvItems.add(inv);
                    
                }// End of For Loop Inventory
            }// End of dealer type
            
            
            // Processing Retailer Orders for updating Inventory
            if (ord.icxdmsv1__Type__c == 'Retailer') {
                
                for(icxdmsv1__Inventory__c inv : invItems){
                    if (ord.icxdmsv1__STATUS__c == 'Booked') {
                        Decimal qty = ordItmMapDetails.get(inv.Id).icxdmsv1__Quantity__c;                                     
                        inv.icxdmsv1__Shipment_Quantity__c += qty;
                    }  
                    else if (ord.icxdmsv1__STATUS__c == 'Out For Delivery') {
                        Decimal qty = ordItmMapDetails.get(inv.Id).icxdmsv1__Quantity__c;
                        inv.icxdmsv1__Shipment_Quantity__c -= qty;
                        inv.icxdmsv1__OnHand_Qty__c -= qty;
                    }                     
                    else {
                        continue;
                    }
                    
                    newInvItems.add(inv);
                    
                }// End of For Loop Inventory
            }// End of Retailer type
            
            
        }// End Of for loop for Order
                        
        
        //Updating Inventory
        if(newInvItems.size()>0 && Schema.sObjectType.icxdmsv1__Inventory__c.fields.icxdmsv1__OnHand_Qty__c.isUpdateable() &&
                        Schema.sObjectType.icxdmsv1__Inventory__c.fields.icxdmsv1__Receivable_Qty__c.isUpdateable() &&
           Schema.sObjectType.icxdmsv1__Inventory__c.fields.icxdmsv1__Shipment_Quantity__c.isUpdateable()){
               
               update newInvItems;
           }
        }//End of Try
        
        catch(Exception e) {
   				 	System.debug('An exception occurred: ' + e.getMessage());
            
		}//End of Catch
        
    }//End Of Method   
    
}//End Of Class