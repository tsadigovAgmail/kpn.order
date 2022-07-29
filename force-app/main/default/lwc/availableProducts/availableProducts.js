import { LightningElement, wire, api, track } from 'lwc';
import getData from "@salesforce/apex/OrderProductController.getAvailableProducts";

const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'List Price', fieldName: 'UnitPrice'}
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
}