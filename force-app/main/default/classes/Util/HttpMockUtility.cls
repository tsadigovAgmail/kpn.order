@isTest
global class HttpMockUtility implements HttpCalloutMock {
    public HttpResponse response;

    global HTTPResponse respond(HTTPRequest request) {
        return response; 
    }
}