public class OrderItemDto {
    public string name{get;set;}
    public string code{get;set;}
    public decimal unitPrice{get;set;}
    public decimal quantity{get;set;}

    public static OrderItemDto wrap(OrderItem itemRecord){
        OrderItemDto wrapper = new OrderItemDto();

        wrapper.name = itemRecord.ProductName__c;
        wrapper.code = itemRecord.OrderItemNumber;
        wrapper.unitPrice = itemRecord.unitPrice;
        wrapper.quantity = itemRecord.quantity;

        return wrapper;
    }
}
