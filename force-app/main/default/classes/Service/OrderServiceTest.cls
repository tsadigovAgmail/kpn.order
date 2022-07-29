@IsTest
public class OrderServiceTest {
    @isTest
    private static void testActivate(){
        Pricebook2 pricebook = new Pricebook2(
            Name = 'Test PriceBook'
        );
        insert pricebook;

        Account acc = new Account(
            Name = 'Test Account'
        );
        insert acc;

        Contract theContract = new Contract(
            AccountId = acc.Id,
            StartDate = System.today(),
            ContractTerm = 3,
            Pricebook2Id = pricebook.id
        );
        insert theContract;

        Order ord = new Order(
            AccountId = acc.Id,
            ContractId = theContract.Id,
            Status = 'Draft',
            EffectiveDate = System.today()
        );
        insert ord;

        SapOrder sapStub = (SapOrder)Test.createStub(SapOrder.class, new StubUtil(new Map<string, object>{
            'activate'=>null
        }));
        
        SapOrder.s_instance = sapStub;

        OrderService.instance.activate(ord.Id);
    }
}
