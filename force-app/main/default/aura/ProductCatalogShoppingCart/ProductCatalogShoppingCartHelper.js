({
	updateTotal : function(cmp) {
        var items = cmp.get("v.itemsInCart");
        var total = 0;
        items.forEach(function(item){
            total += item.product.icx__Default_Price__c * item.quantity;            
        });
        cmp.set("v.total", total);
	},
    addNewItem : function (cmp, newItem) {
        var items = cmp.get("v.itemsInCart");
        var itemExist = false;
        for (var i = 0; i < items.length; ++i) {
            if (items[i].product.Id === newItem.product.Id) {
                itemExist = true;
                items[i].quantity = newItem.quantity;
            }
        }
        if (!itemExist) {
            items.push(newItem);
        }
        cmp.set("v.itemsInCart", items);
        
        var productId = newItem.product.Id;
        var quantity = newItem.quantity;
        //var orderID = cmp.get("v.cartorder");
        var action = cmp.get("c.addOrderItem");
        action.setParams({ order : cmp.get("v.cartorder"),
                           product: productId,
                           quantity : quantity
                        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.cartitems", response.getReturnValue());

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
    updateQtyItem : function (cmp, newItem) {
        var items = cmp.get("v.itemsInCart");
        var itemExist = false;
        for (var i = 0; i < items.length; ++i) {
            if (items[i].product.Id === newItem.product) {
                itemExist = true;
                items[i].quantity = newItem.quantity;
            }
        }
        if (!itemExist) {
            items.push(newItem);
        }
        cmp.set("v.itemsInCart", items);
        
        var productId = newItem.product;
        var quantity = newItem.quantity;
        var action = cmp.get("c.addOrderItem");
        action.setParams({ order : cmp.get("v.cartorder"),
                           product: productId,
                           quantity : quantity
                        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.cartitems", response.getReturnValue());
                this.getCartDetails(cmp);
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
    removeItem : function (component, productId) {
        var items = component.get("v.itemsInCart");
        var index;
        productId = productId.split(" ")[0];
        for (var i = 0; i < items.length; ++i) {
            if (items[i].product.Id === productId) {
                index = i;
            }
        }
        items.splice(index,1);
        component.set("v.itemsInCart",items);

        var productId = productId;
        var action = component.get("c.removeOrderItem");
        action.setParams({ order : component.get("v.cartorder"),
                           product: productId,
                        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.cartitems", response.getReturnValue());
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
    removeAllItems : function (component) {
        var array = [];
        component.set("v.itemsInCart", array);
    },
    getCartDetails : function(component){
        var action = component.get("c.addOrderDetails");
        action.setParams({ order : component.get("v.cartorder")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.cartorder", response.getReturnValue());
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
    }
})