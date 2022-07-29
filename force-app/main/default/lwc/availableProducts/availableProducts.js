import { LightningElement, wire, api, track } from 'lwc';
import getAvailableProducts from "@salesforce/apex/OrderProductController.getAvailableProducts";
import getOrderProducts from "@salesforce/apex/OrderProductController.getOrderProducts";
import addProduct from "@salesforce/apex/OrderProductController.addProduct";


const actions = [
    { label: 'add to order', name: 'add' }
];

const columns = [
    { label: 'Name', fieldName: 'Name', sortable: "true", cellAttributes:{ class:{fieldName:'textColor'}}},
    { label: 'List Price', fieldName: 'UnitPrice', sortable: "true"},
    { type: 'action', typeAttributes: { rowActions: actions, menuAlignment: 'left' } }
];

export default class AvailableProducts extends LightningElement {
    @api 
    recordId;
    
    @wire(getAvailableProducts,{ orderId: '$recordId'})
    products ;

    @track
    refreshTime = Date.now();

    @wire(getOrderProducts,{ orderId: '$recordId', refreshTime:'$refreshTime'})
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
                    const idx = this.orderProducts?.data?.findIndex( ( orderProduct ) => orderProduct.PricebookEntryId == availableProduct.Id );
                    const existing = idx >= 0;
                    const orderProduct = existing ? this.orderProducts.data[idx] : {};
                    const style = existing ? {textColor:'slds-text-color_success'}:{};
                    
                    return {
                        ...availableProduct,
                        ...{
                            existing : existing,
                            OrderProductId: orderProduct?.Id,
                            Quantity: orderProduct?.Quantity || 0,
                            Product2Id: availableProduct.Product2Id,
                            PriceBookEntryId: availableProduct.Id,
                            OrderId: this.recordId,
                            OrderProduct:orderProduct
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

    get error(){
        return [this.products.error];
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

    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        switch (action.name) {
            case 'add':
                const record={
                    Id:row.OrderProductId, 
                    OrderId:row.OrderId, 
                    PriceBookEntryId:row.PriceBookEntryId,
                    UnitPrice: row.UnitPrice,
                    Quantity:row.Quantity
                };
                addProduct({item:record})
                    .then(result=>this.refreshTime = Date.now())//TODO: we have all the data at hand, can do without fetching from server
                    .catch(e=>this.products.error = e.body.message + '\n' + e.body.stackTrace);
                break;
        }
    }


}