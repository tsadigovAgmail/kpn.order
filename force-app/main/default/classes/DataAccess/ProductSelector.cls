public with sharing class ProductSelector {
    private ProductSelector(){}

    private static ProductSelector s_instance;
    public  static ProductSelector instance{get{return s_instance = (null==s_instance) ? new ProductSelector():s_instance;}}

    public List<PricebookEntry> selectAvailableProducts(Id priceBookId) {
        
        return [
            SELECT Id, Name, Product2Id, UnitPrice, ProductCode 
            FROM PricebookEntry
            WHERE Pricebook2Id=:priceBookId
            LIMIT 200
        ];
    }
}
