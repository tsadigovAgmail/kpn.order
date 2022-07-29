public class StubUtil implements StubProvider{
    public StubUtil(Map<string, Object> results){
        this.results = results;
    }
    
    public Map<string, Object> results = new Map<string, Object>();
    public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, 
        Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames, 
        List<Object> listOfArgs) {
        
            return this.results.get(stubbedMethodName);
    }
}
