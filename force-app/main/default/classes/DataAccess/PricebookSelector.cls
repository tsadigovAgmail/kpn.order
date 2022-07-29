public with sharing class PricebookSelector {
    private PricebookSelector(){}

    private static PricebookSelector s_instance;
    public  static PricebookSelector instance{get{return s_instance = (null==s_instance) ? new PricebookSelector():s_instance;}}

    public Id findIdByOrder(Id orderId){
        Id priceBookId = [SELECT priceBook2Id FROM Order WHERE Id=:orderId].priceBook2Id;
        if(null == priceBookId) 
            priceBookId = [SELECT ID FROM PriceBook2 WHERE IsStandard=true].Id;
        return priceBookId;
    }
}
