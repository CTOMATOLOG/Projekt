import { LightningElement, api, wire } from 'lwc'
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { customLabels } from './labels.js';
import ModalCreateContact from 'c/modalCreateContact';
import getReletedContacts from '@salesforce/apex/AccountLWCController.getReletedContacts';
import deleteContact from '@salesforce/apex/AccountLWCController.deleteContact';
export default class ReletedContactsOnAccount extends NavigationMixin(LightningElement) {
    @api recordId
    contactList = []
    get customLabels() {
        return customLabels;
    }
    createNewContact() {
        ModalCreateContact.open({
            size: 'medium',
            description: 'Modal for creating contact',
            content: this.recordId
        }).then(() => this.updateListOfContacts())
    }

    connectedCallback(){
        this.updateListOfContacts()
    }
    handlerContactNavigate(event) {
        event.preventDefault();
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId:  event.target.dataset['id'],
                objectApiName: 'Contact',
                actionName: 'view'
            }
        });
    }
    async deleteContactHandler(event){
        try{
            var contactToDelete = event.target.value
            await  deleteContact({pContact: contactToDelete})
            const toastEvent = new ShowToastEvent({
                title: "Success",
                message:  contactToDelete.Name + " "+customLabels.wasDeletedLabel+"!",
                variant: "success"
            });
            this.dispatchEvent(toastEvent);
            this.contactList = this.contactList.filter(contact => contact.Id !== contactToDelete.Id)
        }
        catch (e) {
            const toastEvent = new ShowToastEvent({
                title: customLabels.removalUnsuccessfulLabel,
                message: e.body.message,
                variant: "error"
            });
            this.dispatchEvent(toastEvent);
        }
    }
    updateListOfContacts(){
        getReletedContacts({pAccountId:this.recordId}).then(result=>{
            this.contactList = result;
        }).catch(e=>{})
    }
}