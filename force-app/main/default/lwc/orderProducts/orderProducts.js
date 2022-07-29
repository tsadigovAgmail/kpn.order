import { LightningElement, wire, api, track } from 'lwc';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi';
import getData from "@salesforce/apex/OrderProductController.getOrderProducts";


const columns = [
    { label: 'Name', fieldName: 'ProductName__c', sortable : "true" },
    { label: 'Unit Price', fieldName: 'UnitPrice', sortable : "true" },
    { label: 'Quantity', fieldName: 'Quantity', sortable : "true" },
    { label: 'Total Price', fieldName: 'TotalPrice', sortable : "true" }
];

export default class OrderProducts extends LightningElement {
    @api 
    recordId;
    @wire(getData,{ orderId: '$recordId', refreshTime: '$refreshTime'})
    products;
    columns = columns;
    get count(){
        return this.products?.data?.length || 0;
    }
    
    @track
    refreshTime = Date.now();

    channel = '/data/OrderItemChangeEvent';
    subscription;

    connectedCallback(){
        this.subscribe();
    }

    subscribe(){
        subscribe(this.channel, -1, 
            (message)=>{
                
                // Did any of the records on the screen change
                let shouldRefresh = false;
                for(let id of message.data.payload.ChangeEventHeader.recordIds){
                    if(0 <= this.products.data.findIndex((orderProduct=>orderProduct.Id == id))){
                        shouldRefresh = true;
                        break;
                    }
                }

                // Is new record created ?
                if(message.data.payload.ChangeEventHeader.changeType = "CREATE" && message.data.payload.OrderId == this.recordId)
                    shouldRefresh = true;

                if(shouldRefresh)
                    this.refreshTime = Date.now();
            }
        )
        .then(response => {
            this.subscription = response;
        });
        //TODO: .error();
    }

    @track sortBy;
    @track sortDirection;
    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        try{
            let parseData = [...this.products.data];
            // Return the value stored in the field
            let keyValue = (a) => {
                return a[fieldname];
            };
            // cheking reverse direction
            let isReverse = direction === 'asc' ? 1: -1;
            // sorting data
            parseData.sort((x, y) => {
                x = keyValue(x) || ''; // handling null values
                y = keyValue(y) || '';
                // sorting values based on direction
                let result = isReverse * ((x > y) - (y > x));
                return result;
            });
            this.products = {data: parseData, error: undefined};
        }catch(exp){
            this.products = {data: parseData, error: exp};
            console.error(exp);
        }
    }    
}