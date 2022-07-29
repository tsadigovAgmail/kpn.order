@IsTest
private class SapOrderTest {
    @IsTest
    private static void testActivate(){
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        HttpMockUtility http = new HttpMockUtility();
        http.response = response;

        Test.setMock(HttpCalloutMock.class, http);  
        
        OrderDto o = new OrderDto();

        SapOrder.instance.activate(o);

    }

    @IsTest
    private static void testActivateException(){
        HttpResponse response = new HttpResponse();
        response.setStatusCode(404);
        response.setStatus('Not found');

        HttpMockUtility http = new HttpMockUtility();
        http.response = response;

        Test.setMock(HttpCalloutMock.class, http);  
        
        OrderDto o = new OrderDto();

        try{
            SapOrder.instance.activate(o);
            system.assert(false, 'Exception needed to be thrown');
        }
        catch(IntegrationException actualException){
            system.assert(true);
        }
    }
}
