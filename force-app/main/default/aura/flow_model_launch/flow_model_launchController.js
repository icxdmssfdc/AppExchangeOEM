({
    doInit : function(component, event, helper) {
        component.set('v.isOpen', false);
    },
    
    closeFlowModal : function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    
    closeModalOnFinish : function(component, event, helper) {
        if(event.getParam('status') === "FINISHED") {
            component.set("v.isOpen", false);
        }
    },
    openSecOrderFlow: function(component, event, helper){
        component.set('v.isOpen', true);
        var flow = component.find('flow');
        flow.startFlow(component.get('v.flowName'));
    }
})