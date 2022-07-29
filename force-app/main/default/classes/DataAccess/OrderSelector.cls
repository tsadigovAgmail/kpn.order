public with sharing class OrderSelector {
    private OrderSelector(){}

    private static OrderSelector s_instance;
    public  static OrderSelector instance{get{return s_instance = (null==s_instance) ? new OrderSelector():s_instance;}}

    public Order getById(Id orderId){
        return [
            SELECT
                accountId,
                orderNumber,
                type,
                status,
                (
                    SELECT 
                        Id,
                        ProductName__c,
                        OrderItemNumber,
                        unitPrice,
                        quantity
                    FROM 
                        OrderItems
                )
            FROM 
                Order
            WHERE
                Id = :orderId
        ];
    }
}
