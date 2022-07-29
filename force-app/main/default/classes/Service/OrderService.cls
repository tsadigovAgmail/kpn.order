public with sharing class OrderService {
    //dependencies
    public OrderItemSelector orderItems{get; private set;}
    public ProductSelector products{get; private set;}
    public OrderSelector orders{get; private set;}
    public PricebookSelector priceBooks{get; private set;}
    
    @TestVisible
    private OrderService(OrderSelector orders, OrderItemSelector orderItems, ProductSelector products, PricebookSelector priceBooks){
        this.orders = orders;
        this.orderItems = orderItems;
        this.products = products;
        this.priceBooks = priceBooks;
    }

    private OrderService(){
        this(OrderSelector.instance, OrderItemSelector.instance, ProductSelector.instance, PricebookSelector.instance);
    }

    @TestVisible
    private static OrderService s_instance;
    public  static OrderService instance{get{return s_instance = (null==s_instance) ? new OrderService():s_instance;}}


    public List<OrderItem> getOrderProducts(Id orderId) {
        return orderItems.selectByOrder(orderId);
    }

    public List<PricebookEntry> getAvailableProducts(Id orderId) {
        return products.selectAvailableProducts( pricebooks.findIdByOrder( orderId ) );
    }

    public OrderItem addProduct(OrderItem itemObject){
        
        if(null == itemObject.Quantity){
            itemObject.Quantity = 0;
        }
        itemObject.Quantity = 1 + (null == itemObject.Quantity ? 0 : itemObject.Quantity); 
        upsert itemObject;
        return itemObject;
    }

    public void activate(Id orderId){
        SapOrder.instance.activate(OrderDto.wrap(orders.getById(orderId)));
        update new Order(Id=orderId,Status='Activated');
    }

    public String getOrdertatus(Id orderId){
        return orders.getById(orderId).Status;
    }
}
