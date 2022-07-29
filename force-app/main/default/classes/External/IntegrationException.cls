public class IntegrationException extends Exception{
    public string endpoint{get; protected set;}
    public IntegrationException (string message, string endpoint){
        this.setMessage(message); 
        this.endpoint = endpoint;
    }
}
