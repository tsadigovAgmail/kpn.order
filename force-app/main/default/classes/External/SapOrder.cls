public class SapOrder {
    public final string ENDPOINT = 'http://mockbin.org/bin/590f22ba-3b02-4a85-ad16-c75085a4ef82';

    public string activate(OrderDto order){
        HttpRequest req = new HttpRequest();
        req.setBody(JSON.serialize(order));
        req.setEndpoint(ENDPOINT);
        req.setMethod('POST');
        req.setTimeout(5000);
        Http protocol = new Http();
        HttpResponse resp = protocol.send(req);
        if(200 != resp.getStatusCode()){
            throw new IntegrationException(resp.getStatus(), ENDPOINT);
        }
        return '1234';
    }


    @TestVisible
    private static SapOrder s_instance;
    public  static SapOrder instance{get{return s_instance = (null==s_instance) ? new SapOrder():s_instance;}}


    
}
