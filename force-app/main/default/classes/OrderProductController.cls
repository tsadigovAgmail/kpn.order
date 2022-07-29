public with sharing class OrderProductController {
    private static Id getPriceBookIdFor(Id orderId){
        Id priceBookId = [SELECT priceBook2Id FROM Order WHERE Id=:orderId].priceBook2Id;
        if(null == priceBookId) 
            priceBookId = [SELECT ID FROM PriceBook2 WHERE IsStandard=true].Id;
        return priceBookId;
    }

    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getAvailableProducts(Id orderId) {
        Id priceBookId = getPriceBookIdFor(orderId);

        return [
            SELECT Id, Name, Product2Id, UnitPrice, ProductCode 
            FROM PricebookEntry
            WHERE Pricebook2Id=:priceBookId
            LIMIT 200
        ];//TODO: paging
    }

    @AuraEnabled(cacheable=true)
    public static List<OrderItem> getOrderProducts(Id orderId) {
        Id priceBookId = getPriceBookIdFor(orderId);
        
        return [
            SELECT Id, Product2Id,ProductName__c, OrderId, PricebookEntryId, Quantity, UnitPrice, TotalPrice
            FROM OrderItem
            WHERE OrderId=:orderId
            LIMIT 200
        ];//TODO: paging
    }
}
