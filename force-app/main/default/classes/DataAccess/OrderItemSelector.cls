public with sharing class OrderItemSelector {
    private OrderItemSelector(){}
    
    private static OrderItemSelector s_instance;
    public  static OrderItemSelector instance{get{return s_instance = (null==s_instance) ? new OrderItemSelector():s_instance;}}

    public List<OrderItem> selectByOrder(Id orderId){
        return [
            SELECT Id, Product2Id,ProductName__c, OrderId, PricebookEntryId, Quantity, UnitPrice, TotalPrice
            FROM OrderItem
            WHERE OrderId=:orderId
            LIMIT 200
        ];
    }
}
