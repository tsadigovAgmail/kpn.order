import { LightningElement, api } from 'lwc';

export default class ErrorPanel extends LightningElement {
  @api errors;
  get hasErrors(){
      return this.errors && this.errors.filter(e=>e).length>0;
  }
}