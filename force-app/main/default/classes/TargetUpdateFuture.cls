public with sharing class TargetUpdateFuture {

    @future public static void updateTargetFuture(Id ownerId, Date bookedDate, Double ordAmount, Integer ordQuantity,
        Id dealerAccntId, String userTyp, String targetMonth, String targetYear) {

        List < icxdmsv1__Target__c > targData = new List < icxdmsv1__Target__c > ();
        List < icxdmsv1__Target__c > dealertargData = new List < icxdmsv1__Target__c > ();
        List < Id > targetIds = new List < Id > ();
        List < Id > dealertargIds = new List < Id > ();

        List < icxdmsv1__Target_Owner__c > targetOwnerData = new List < icxdmsv1__Target_Owner__c > ();
        List < icxdmsv1__Target_Owner__c > allTargetOwnerData = new List < icxdmsv1__Target_Owner__c > ();
        List < icxdmsv1__Target_Owner__c > newTargetOwnerData = new List < icxdmsv1__Target_Owner__c > ();
        Map < Id, icxdmsv1__Target__c > tarMapData = new Map < Id, icxdmsv1__Target__c > ();
        List < icxdmsv1__Target_Owner__c > dealertargetData = new List < icxdmsv1__Target_Owner__c > ();


        // Getting Target data with respective to order details   
        if (icxdmsv1__Target__c.sObjectType.getDescribe().isAccessible()) {

            targData = [select Id, icxdmsv1__Target_Month__c, icxdmsv1__Type__c
                from icxdmsv1__Target__c where(icxdmsv1__Target_Year__c =: targetYear and icxdmsv1__Target_Month__c =: targetMonth)
                or(icxdmsv1__Start_Date__c <=: bookedDate AND icxdmsv1__End_Date__c >=: bookedDate)
            ];

        }
        if (targData.size() > 0) {
            for (icxdmsv1__Target__c iTarget: targData) {
                targetIds.add(iTarget.Id);
                tarMapData.put(iTarget.Id, iTarget);
            }
        }

        // Getting Target Owner data with respective to order details    
        if (icxdmsv1__Target_Owner__c.sObjectType.getDescribe().isAccessible() && userTyp == 'Standard') {
            targetOwnerData = [select Id, icxdmsv1__Current_Revenue_Reached__c, icxdmsv1__Current_Quantity_Reached__c, icxdmsv1__Target__c, icxdmsv1__Apply_For_Dealer__c
                from icxdmsv1__Target_Owner__c where icxdmsv1__Target__c in: targetIds and icxdmsv1__Salesrep__c =: ownerId
            ];
        } else {
            if (icxdmsv1__Target_Owner__c.sObjectType.getDescribe().isAccessible()){
            targetOwnerData = [select Id, icxdmsv1__Current_Revenue_Reached__c, icxdmsv1__Current_Quantity_Reached__c, icxdmsv1__Target__c, icxdmsv1__Apply_For_Dealer__c
                from icxdmsv1__Target_Owner__c where icxdmsv1__Target__c in: targetIds and icxdmsv1__Dealer__c =: dealerAccntId
                              ];}
        }

        // Adding logic to update dealer targets if owner is Salesrep and Apply for dealer is true                              
        if (userTyp == 'Standard') {
            for (icxdmsv1__Target_Owner__c tar: targetOwnerData) {
                if (tar.icxdmsv1__Apply_For_Dealer__c == true) {
                    dealertargIds.add(tar.icxdmsv1__Target__c);
                }
            }

            if (icxdmsv1__Target_Owner__c.sObjectType.getDescribe().isAccessible()) {
                dealertargetData = [select Id, icxdmsv1__Current_Revenue_Reached__c, icxdmsv1__Current_Quantity_Reached__c, icxdmsv1__Target__c, icxdmsv1__Apply_For_Dealer__c
                    from icxdmsv1__Target_Owner__c where icxdmsv1__Target__c in: dealertargIds and icxdmsv1__Dealer__c =: dealerAccntId
                ];
            }
        }
        //Adding both targets together
        allTargetOwnerData.addall(targetOwnerData);
        if (dealertargetData.size() > 0) {
            allTargetOwnerData.addall(dealertargetData);
        }

        //Checking for targData is not empty
        if (allTargetOwnerData.size() > 0) {
            for (icxdmsv1__Target_Owner__c tar: allTargetOwnerData) {
                if (tarMapData.get(tar.icxdmsv1__Target__c).icxdmsv1__Type__c == 'Revenue') {
                    tar.icxdmsv1__Current_Revenue_Reached__c = tar.icxdmsv1__Current_Revenue_Reached__c + ordAmount;
                    newTargetOwnerData.add(tar);
                }
                if (tarMapData.get(tar.icxdmsv1__Target__c).icxdmsv1__Type__c == 'Quantity') {
                    tar.icxdmsv1__Current_Quantity_Reached__c = tar.icxdmsv1__Current_Quantity_Reached__c + ordQuantity;
                    newTargetOwnerData.add(tar);
                }
            }

        } //End of if                                  

        //Updating Target Owner data
        if (icxdmsv1__Target_Owner__c.sObjectType.getDescribe().isUpdateable()) {
            update newTargetOwnerData;
        }

    } //End of method

    @future public static void updateSKUWithQtyFuture(Id ownerId, Date bookedDate, ID ordProductId, Double ordProdAmount, Integer ordProdQuantity,
        Id dealerAccntId, String userTyp, String targetMonth, String targetYear) {

        List < icxdmsv1__Target__c > targData = new List < icxdmsv1__Target__c > ();
        List < icxdmsv1__Target__c > dealertargData = new List < icxdmsv1__Target__c > ();
        List < Id > targetIds = new List < Id > ();
        List < Id > dealertargIds = new List < Id > ();

        List < icxdmsv1__Target_Owner__c > targetOwnerData = new List < icxdmsv1__Target_Owner__c > ();
        List < icxdmsv1__Target_Owner__c > allTargetOwnerData = new List < icxdmsv1__Target_Owner__c > ();
        List < icxdmsv1__Target_Owner__c > newTargetOwnerData = new List < icxdmsv1__Target_Owner__c > ();
        Map < Id, icxdmsv1__Target__c > tarMapData = new Map < Id, icxdmsv1__Target__c > ();
        List < icxdmsv1__Target_Owner__c > dealertargetData = new List < icxdmsv1__Target_Owner__c > ();


        // Getting Target data with respective to order details   
        if (icxdmsv1__Target__c.sObjectType.getDescribe().isAccessible()) {

            targData = [select Id, icxdmsv1__Target_Month__c, icxdmsv1__Type__c
                from icxdmsv1__Target__c where(icxdmsv1__Target_Year__c =: targetYear and icxdmsv1__Target_Month__c =: targetMonth)
                or(icxdmsv1__Start_Date__c <=: bookedDate AND icxdmsv1__End_Date__c >=: bookedDate)
            ];

        }
        if (targData.size() > 0) {
            for (icxdmsv1__Target__c iTarget: targData) {
                targetIds.add(iTarget.Id);
                tarMapData.put(iTarget.Id, iTarget);
            }
        }

        // Getting Target Owner data with respective to order details    
        if (icxdmsv1__Target_Owner__c.sObjectType.getDescribe().isAccessible() && userTyp == 'Standard') {
            targetOwnerData = [select Id, icxdmsv1__Current_Revenue_Reached__c, icxdmsv1__Current_Quantity_Reached__c, icxdmsv1__Target__c, icxdmsv1__Apply_For_Dealer__c
                from icxdmsv1__Target_Owner__c where icxdmsv1__Target__c in: targetIds and icxdmsv1__Salesrep__c =: ownerId
            ];
        } else {
            targetOwnerData = [select Id, icxdmsv1__Current_Revenue_Reached__c, icxdmsv1__Current_Quantity_Reached__c, icxdmsv1__Target__c, icxdmsv1__Apply_For_Dealer__c
                from icxdmsv1__Target_Owner__c where icxdmsv1__Target__c in: targetIds and icxdmsv1__Dealer__c =: dealerAccntId
            ];
        }

        // Adding logic to update dealer targets if owner is Salesrep and Apply for dealer is true                              
        if (userTyp == 'Standard') {
            for (icxdmsv1__Target_Owner__c tar: targetOwnerData) {
                if (tar.icxdmsv1__Apply_For_Dealer__c == true) {
                    dealertargIds.add(tar.icxdmsv1__Target__c);
                }
            }

            if (icxdmsv1__Target_Owner__c.sObjectType.getDescribe().isAccessible()) {
                dealertargetData = [select Id, icxdmsv1__Current_Revenue_Reached__c, icxdmsv1__Current_Quantity_Reached__c, icxdmsv1__Target__c, icxdmsv1__Apply_For_Dealer__c
                    from icxdmsv1__Target_Owner__c where icxdmsv1__Target__c in: dealertargIds and icxdmsv1__Dealer__c =: dealerAccntId
                ];
            }
        }

        //Adding both targets together if Order is by SalesRep
        allTargetOwnerData.addall(targetOwnerData);
        if (dealertargetData.size() > 0) {
            allTargetOwnerData.addall(dealertargetData);
        }


        if (allTargetOwnerData.size() > 0) {
            for (icxdmsv1__Target_Owner__c tar: allTargetOwnerData) {
                if (tarMapData.get(tar.icxdmsv1__Target__c).icxdmsv1__Type__c == 'SKU With Quantity') {
                    tar.icxdmsv1__Current_Quantity_Reached__c = tar.icxdmsv1__Current_Quantity_Reached__c + ordProdQuantity;
                    newTargetOwnerData.add(tar);
                }
                if (tarMapData.get(tar.icxdmsv1__Target__c).icxdmsv1__Type__c == 'SKU With Revenue') {
                    tar.icxdmsv1__Current_Revenue_Reached__c = tar.icxdmsv1__Current_Revenue_Reached__c + ordProdAmount;
                    newTargetOwnerData.add(tar);
                }
            }
            //Updating Target Owner data
            if (icxdmsv1__Target_Owner__c.sObjectType.getDescribe().isUpdateable()) {
                update newTargetOwnerData;
            }
        }

    }

} //End of class