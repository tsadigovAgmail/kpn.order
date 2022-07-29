public with sharing class OrderProductController {
    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getAvailableProducts(Id orderId) {
        Id priceBookId = [SELECT priceBook2Id FROM Order WHERE Id=:orderId].priceBook2Id;
        return [
            SELECT Id, Name, Product2Id, UnitPrice, ProductCode 
            FROM PricebookEntry
            WHERE Pricebook2Id=:priceBookId
            LIMIT 200
        ];
    }
}
