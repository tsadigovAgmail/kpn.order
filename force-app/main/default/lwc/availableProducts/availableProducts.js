import { LightningElement, wire, api, track } from 'lwc';
import getData from "@salesforce/apex/OrderProductController.getAvailableProducts";

const columns = [
    { label: 'Name', fieldName: 'Name', sortable: "true"  },
    { label: 'List Price', fieldName: 'UnitPrice', sortable: "true" }
];

export default class AvailableProducts extends LightningElement {
    @api 
    recordId;
    @wire(getData,{ orderId: '$recordId'})
    products = [];
    columns = columns;

    get count(){
        return this.products?.data?.length || 0;
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
            let parseData = [...this.products.data];//JSON.parse(JSON.stringify(this.data));
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
                console.log(result);
                return result;
            });
            this.products = {data: parseData, error: undefined};
        }catch(exp){
            this.products = {data: parseData, error: exp};
            console.error(exp);
        }
    }  
}