trigger MaintenanceRequest on Case (after update) {
    if(Trigger.isAfter && Trigger.isUpdate)
        MaintenanceRequestHelper.updateWorkOrders((Map<Id,Case>)Trigger.oldMap, (List<Case>)Trigger.new);

}