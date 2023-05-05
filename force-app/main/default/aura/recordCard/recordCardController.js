({
    navigateToRecord:function(component){
        var record  = component.get("v.record");

        var urlEvent  = $A.get("e.force:navigateToSObject");
        urlEvent  .setParams({
          "recordId": record.Id  ,
          "slideDevName": "detail"
        });
        urlEvent .fire();
    }
})
