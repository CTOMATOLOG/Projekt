import LightningModal from 'lightning/modal';
import { api } from 'lwc';

export default class ModalCreateTask extends LightningModal {
    @api content;
    description
    closeModal() {
        this.close('Success');
    }
    handleInput(event){
        this.description = event.target.value;
    }
}