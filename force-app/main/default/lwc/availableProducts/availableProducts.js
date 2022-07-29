import { LightningElement, wire, api, track } from 'lwc';
import getAvailableProducts from "@salesforce/apex/OrderProductController.getAvailableProducts";
import getOrderProducts from "@salesforce/apex/OrderProductController.getOrderProducts";

const columns = [
    { label: 'Name', fieldName: 'Name', sortable: "true", cellAttributes:{ class:{fieldName:'textColor'}}},
    { label: 'List Price', fieldName: 'UnitPrice', sortable: "true"}
];

export default class AvailableProducts extends LightningElement {
    @api 
    recordId;
    
    @wire(getAvailableProducts,{ orderId: '$recordId'})
    products ;

    @wire(getOrderProducts,{ orderId: '$recordId'})
    orderProducts ;

    @track 
    sortedBy = 'Name';

    @track 
    sortedDirection = 'asc';

    @api
    filterString
    
    handleKeyChange(event){
        this.filterString = event.target.value;
    }

    columns = columns;

    // provides back reference relation [priceBookEntry]->[orderLineItem] 
    get mergedProducts(){
        try{
            const result=this.products?.data?.map(
                availableProduct =>{
                    const idx = this.orderProducts?.data?.findIndex( ( orderProd ) => orderProd.PricebookEntryId == availableProduct.Id );
                    const existing = idx >= 0;
                    const orderProd = existing ? this.orderProducts.data[idx] : {};
                    const style = existing ? {textColor:'slds-text-color_success'}:{};
                    
                    return {
                        ...orderProd,
                        ...availableProduct,
                        ...{
                            existing : existing 
                        },
                        ...style,
                    };
                }
            );
            return result;
        }
        catch(exp){
            console.error(exp);
        }
        
    }

    get sortedProducts(){
        return this.mergedProducts
        ?.filter( (prod)=> 
            (!this.filterString || prod.Name?.includes(this.filterString))
        )
        ?.sort(
            (a, b)=>{
                if(a.existing  != b.existing){ // 2.a Products that are already added to the order should appear on top 
                    return a.existing ? -1 : 1;
                }
                else{
                    let ax = a[this.sortedBy];
                    let bx = b[this.sortedBy];
                    if(ax == bx)
                        return 0;
                    else 
                        return (ax > bx ? 1 : -1) * (this.sortedDirection == 'desc' ? -1 : 1);
                }
            }
        );
    }

    updateColumnSorting(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
   }

}