public class OrderDto {
    public string accountNumber{get;set;}
    public string orderNumber{get;set;}
    public string type{get;set;}
    public string status{get;set;}
    public List<OrderItemDto> orderProducts {get;set;}

    public static OrderDto wrap(Order orderRecord){
        OrderDto orderWrapper = new OrderDto();

        orderWrapper.accountNumber = orderRecord.accountId;
        orderWrapper.orderNumber = orderRecord.orderNumber;
        orderWrapper.type = orderRecord.type;
        orderWrapper.status = orderRecord.status;

        List<OrderItemDto> orderProducts = new List<OrderItemDto> ();
        for(OrderItem itemRecord : orderRecord.OrderItems){
            orderProducts.add(OrderItemDto.wrap(itemRecord));
        }
        orderWrapper.orderProducts = orderProducts;

        return orderWrapper;
    }
}
