({
    doInit: function(component, event, helper) {
		console.log('ProductCatalogItems: doInit');
		var urlString = window.location.href;
		var baseURL = urlString.substring(0, urlString.indexOf("/s"));
		component.set("v.cbaseURL", baseURL);
    },
	filterByCategory: function(component, event, helper) {
		var category = event.getParam("Category");
		var familyList = event.getParam("FamilyList");
		var itemSelected = event.getParam("ItemSelected");
        // TODO: filter based on category
        component.set("catalogItems",familyList);
        //console.log("filterByCategory");
	},
})