public with sharing class OrderProductController {
    
    static OrderService service = OrderService.instance;

    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getAvailableProducts(Id orderId) {
        return service.getAvailableProducts(orderId);
    }

    @AuraEnabled(cacheable=true)
    public static List<OrderItem> getOrderProducts(Id orderId) {
        return service.getOrderProducts(orderId);
    }

    
    @AuraEnabled()
    public static OrderItem addProduct(Map<string, object> item){
        //TODO: fix this, directly accept OrderItem
        OrderItem itemObject = (OrderItem)JSON.deserialize(JSON.serialize(item), OrderItem.class);

        return service.addProduct(itemObject);
    }

    @AuraEnabled(cacheable=true)
    public static void activate(Id orderId) {
        service.activate(orderId);
    }
}
