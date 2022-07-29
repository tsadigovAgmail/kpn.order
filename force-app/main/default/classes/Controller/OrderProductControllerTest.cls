@IsTest
public class OrderProductControllerTest {

    @isTest
    private static void testActivate(){
        TestData data = TestData.setup();
 
        SapOrder sapStub = (SapOrder)Test.createStub(SapOrder.class, new StubUtil(new Map<string, object>{
            'activate'=>null
        }));
        
        SapOrder.s_instance = sapStub;

        OrderProductController.activate(data.theOrder.Id);
    }

    @isTest
    private static void testGetAvailableProducts(){
        TestData data = TestData.setup();

        List<PricebookEntry> options = OrderProductController.getAvailableProducts(data.theOrder.Id);
        System.assert(options.size() == 2);
    }

    @isTest
    private static void testGetOrderProducts(){
        TestData data = TestData.setup();

        List<OrderItem> options = OrderProductController.getOrderProducts(data.theOrder.Id);
        System.assert(options.size() == 1);
    }

    @isTest
    private static void testAddProduct(){
        TestData data = TestData.setup();
        decimal expected = data.item.Quantity + 1;
        OrderItem item = OrderProductController.addProduct(data.item);
        System.assertEquals(expected, item.Quantity);
    }

    @isTest
    private static void testAddProduct0(){
        TestData data = TestData.setup();
        data.item.Quantity = null;
        OrderItem item = OrderProductController.addProduct(data.item);
        System.assertEquals(1, item.Quantity);
    }
    
}
