public class SapOrder {
    public final string ENDPOINT = 'https://turalsadik.kpn.requestcatcher.com/SapOrder';

    public void activate(OrderDto order){
        HttpRequest req = new HttpRequest();
        req.setBody(JSON.serialize(order));
        req.setEndpoint(ENDPOINT);
        Http protocol = new Http();
        HttpResponse resp = protocol.send(req);
        if(200 != resp.getStatusCode()){
            throw new IntegrationException(resp.getStatus(), ENDPOINT);
        }
    }


    @TestVisible
    private static SapOrder s_instance;
    public  static SapOrder instance{get{return s_instance = (null==s_instance) ? new SapOrder():s_instance;}}


    
}
