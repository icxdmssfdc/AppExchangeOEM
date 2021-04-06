({
    doInit : function(component, event, helper) {
        var urlString = window.location.href;
		var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        component.set("v.cbaseURL", baseURL);
        
        var action = component.get("c.getAccounts");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.accounts", response.getReturnValue());
                var action = component.get('c.getcartOrder');
                $A.enqueueAction(action);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    getcartOrder: function(component, event, helper) {
        var action = component.get("c.getOrder");
        //action.setParams({ accounts : component.get("v.accounts")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.cartorder", response.getReturnValue());
                var action = component.get('c.getCartItems');
                $A.enqueueAction(action);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    getCartItems : function(component, event, helper) {
        var action = component.get("c.getOrderItems");
        action.setParams({ order : component.get("v.cartorder")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.cartitems", response.getReturnValue());
               var exitems = component.get("v.itemsInCart");
                var exitemsinCart=response.getReturnValue();
                for (var i = 0; i < exitemsinCart.length; ++i) {
            		var newItem1 = {
            			product: exitemsinCart[i].Product2Id,
            			quantity: exitemsinCart[i].Quantity
                	};
                    exitems.push(newItem1);
                }
                if(exitemsinCart.length<=1)
       			component.set("v.itemsInCart",exitems);

            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
	addToCart : function(component, event, helper) {
		var product = event.getParam("Product");	
		var quantity = event.getParam("Quantity");
        // TODO: add product and quantity to local
        var newItem = {
            product: product,
            quantity: quantity
        };
        helper.addNewItem(component, newItem);
        helper.getCartDetails(component);
        helper.updateTotal(component);
    },
    onQtyChange:function(component, event, helper) {
        var quantity=  event.getSource().get("v.value");
        var productId = event.getSource().get("v.class");
        productId = productId.split(" ")[0];
        var newItem = {
            product: productId,
            quantity: quantity
        };
        helper.updateQtyItem(component, newItem);
        //helper.getCartDetails(component);
        //helper.updateTotal(component);
    },
	showModal : function(component, event, helper) {
        var modal = component.find("modal");
        $A.util.addClass(modal, "slds-fade-in-open");
        var modal = component.find("backdrop");
        $A.util.addClass(modal, "slds-backdrop--open");
	},
    hideModal : function(component, event, helper) {
        var modal = component.find("modal");
        $A.util.removeClass(modal, "slds-fade-in-open");
        var modal = component.find("backdrop");
        $A.util.removeClass(modal, "slds-backdrop--open");
        var eventname = event.getSource().get("v.name");
        if(eventname == "Close"){
            var orderId = component.get("v.orderId");
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
            "recordId": orderId,
            "slideDevName": "related"
            });
            navEvt.fire();
        }
    },
    onAccountChange : function(component, event, helper) {
        var accountId = component.find("account").get("v.value");
        //var ids=new Array();
        component.set("v.selectedAccount",accountId);
        //ids.push(accountId);
        //component.set("v.accounts",ids);
        //action.setParams({"accounts":$A.util.json.encode(component.get("v.selectedAccount"))});
    },
   	createOrder : function(component, event, helper) {
        var action = component.get("c.createCartOrder");
        var order = component.get("v.cartorder");
        component.set('v.orderId', order.Id);
        action.setParams({ accounts : component.find("account").get("v.value")});
        action.setParams({ order : order});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var orderNumber = response.getReturnValue();
                component.set("v.orderNumber",orderNumber);
                helper.updateTotal(component);
                var action = component.get('c.getcartOrder');
                $A.enqueueAction(action);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " +
                                 errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    removeItem : function(component, event, helper) {
    	// TODO remove Product record from itemsInCart
        var productId = event.getSource().get("v.class");
        helper.removeItem(component,productId);
        helper.getCartDetails(component);
        helper.updateTotal(component);
    }
})