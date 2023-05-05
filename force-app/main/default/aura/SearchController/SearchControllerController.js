({
    doInit: function(component) {
        var action = component.get("c.getObjectLabel");
        action.setParams({
            "pObjectName": component.get("v.sObjectName")
        })
        // Call back method
        action.setCallback(this, function(response) {

            var responseValue = response.getReturnValue();
            component.set("v.sObjectLabel",responseValue);
        });

        // Enqueue Action
        $A.enqueueAction(action);

        var action2 = component.get("c.getNameField");
        action2.setParams({
            "pObjectName": component.get("v.sObjectName")
        })
        // Call back method
        action2.setCallback(this, function(response) {

            var responseValue = response.getReturnValue();
            component.set("v.sObjectNameField",responseValue);
        });

        // Enqueue Action
        $A.enqueueAction(action2);
    },
    onTextChange : function(component){
        component.set("v.searchTerm", component.find('enter-search').get('v.value'))
    },
    handleClick : function (component){

        if(component.get('v.searchTerm').length < 3){
            if(component.get("v.displayStatus") != "display: flex"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": $A.get("$Label.c.Error_label"),
                    "message": $A.get("$Label.c.Your_request_must_contain_label"),
                    "type": "warning"
                });
                toastEvent.fire();
            }
            component.set("v.displayStatus","display:none")
        }
        else{
        var action = component.get("c.findInAllFields");
        action.setParams({
            "pSearchTerm": component.get('v.searchTerm'),
            "pObjectName": component.get("v.sObjectName"),
            "pNameField": component.get("v.sObjectNameField")
        })
        // Call back method
        action.setCallback(this, function(response) {
            var responseValue = []
            try {
                responseValue = response.getReturnValue();
                var nameField = component.get("v.sObjectNameField")
                if(nameField!="Name"){
                    for (var item_i of responseValue) {
                        item_i.Name=item_i[nameField]
                    }
            }
            } catch (error) {
                console.log(error)
            }
            component.set("v.countOfRecords", responseValue.length)
            component.set("v.predictions",responseValue);
            if(responseValue.length != 0 && responseValue.length != null){
                component.set("v.displayStatus","display: flex")
                component.set("v.errorNothingFound","")
            }
            else
                component.set("v.errorNothingFound",$A.get("$Label.c.Nothing_was_found_label"))
        });

        // Enqueue Action
        $A.enqueueAction(action);
    }
    }
})

