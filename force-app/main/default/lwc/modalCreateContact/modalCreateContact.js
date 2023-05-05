import LightningModal from 'lightning/modal';
import { api } from 'lwc';
import { customLabels } from './labels.js';
export default class ModalCreateContact extends LightningModal  {
    @api content;
    get customLabels() {
        return customLabels;
    } 
    closeModal() {
        this.close('Success');
    }

}