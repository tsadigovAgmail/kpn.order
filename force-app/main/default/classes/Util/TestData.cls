@IsTest
public class TestData {
    public Pricebook2 pricebook;
    public Account acc;
    public Contract theContract;
    public Order theOrder;
    public Product2 prodA;
    public Product2 prodB;

    public PricebookEntry priceA;
    public PricebookEntry priceB;

    public OrderItem item;

    public static TestData setup(){
        TestData data = new TestData();

        data.pricebook = new Pricebook2(
            Name = 'Test PriceBook',
            IsActive = true
        );
        insert data.pricebook;

        data.acc = new Account(
            Name = 'Test Account'
        );
        insert data.acc;

        data.theContract = new Contract(
            AccountId = data.acc.Id,
            StartDate = System.today(),
            ContractTerm = 3,
            Pricebook2Id = data.pricebook.id
        );
        insert data.theContract;

        data.theOrder = new Order(
            AccountId = data.acc.Id,
            ContractId = data.theContract.Id,
            Status = 'Draft',
            EffectiveDate = System.today()
        );
        insert data.theOrder;


        data.prodA = new Product2(Name = 'Test Product A');
        data.prodB = new Product2(Name = 'Test Product B');
        insert new List<Product2>{data.prodA, data.prodB};


        insert new List<PricebookEntry>{
            new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = data.prodA.Id, UnitPrice = 123),
            new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = data.prodB.Id, UnitPrice = 456)
        };        
        
        data.priceA = new PricebookEntry(Pricebook2Id = data.pricebook.Id, Product2Id = data.prodA.Id, UnitPrice = 123);
        data.priceB = new PricebookEntry(Pricebook2Id = data.pricebook.Id, Product2Id = data.prodB.Id, UnitPrice = 456);

        insert new List<PricebookEntry>{data.priceA, data.priceB};

        insert data.item = new OrderItem(OrderId = data.theOrder.Id, Product2Id = data.prodA.Id, PricebookEntryId = data.priceA.Id, UnitPrice = 123, Quantity = 1);
        return data;
    }
}
