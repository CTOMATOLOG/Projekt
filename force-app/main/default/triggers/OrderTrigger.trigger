trigger OrderTrigger on Order (before insert, before update, after delete) {
    OrderTriggerHandler orderTriggerHandler = new OrderTriggerHandler();
    orderTriggerHandler.run();
}