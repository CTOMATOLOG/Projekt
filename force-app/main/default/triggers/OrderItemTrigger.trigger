trigger OrderItemTrigger on OrderItem (before insert, before update, before delete) {
    OrderItemTriggerHandler orderItemTriggerHandler = new OrderItemTriggerHandler();
    orderItemTriggerHandler.run();
}