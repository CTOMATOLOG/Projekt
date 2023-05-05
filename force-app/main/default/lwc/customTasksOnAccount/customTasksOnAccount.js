import { api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { customLabels } from './labels';
import ModalCreateTask from 'c/modalCreateTask';
import getReletedTasks from '@salesforce/apex/AccountLWCController.getReletedTasks';
import deleteTask from '@salesforce/apex/AccountLWCController.deleteTask'
export default class CustomTasksOnAccount extends NavigationMixin(LightningElement) {
    @api recordId;
    taskList = [];
    fullTaskList = [];
    isFull = false;
    get customLabels() {
        return customLabels;
    }
    connectedCallback(){
        this.updateListOfTasks()
    }
    createNewTask(){
        ModalCreateTask.open({
            size: 'medium',
            description: 'Modal for creating contact',
            content: this.recordId
        }).then(() => this.updateListOfTasks())
    }
    updateListOfTasks(){
        getReletedTasks({pAccountId:this.recordId}).then(result=>{
            this.fullTaskList = result;
            for (let task of this.fullTaskList) {

                task['CreatedDate'] = new Date(task['CreatedDate']).toLocaleString('en-US', {
                    year: 'numeric',
                    month: '2-digit',
                    day: '2-digit',
                    hour: '2-digit',
                    minute: '2-digit',
                    second: '2-digit',
                    hour12: false
                });
            }
        })
        .catch(e=>{})
        .finally(()=>{
            this.taskList = [...this.fullTaskList.slice(0,5)];
        })
    }
    showAll(){
        if(this.taskList == this.fullTaskList){
            this.taskList = [...this.fullTaskList.slice(0,5)];
            this.isFull = false;
        }else{
            this.taskList = this.fullTaskList;
            this.isFull = true;
        }
    }
    async deleteTaskHandler(event){
        try{
            var taskToDelete =  event.target.dataset['id']
            console.log(taskToDelete)
            await  deleteTask({pTask: taskToDelete})
            const toastEvent = new ShowToastEvent({
                title: "Success",
                message:  this.taskList.find(function(item) {
                    return item.Id === taskToDelete;
                  }).Name + " "+customLabels.wasDeletedLabel+"!",
                variant: "success"
            });
            this.dispatchEvent(toastEvent);
            this.taskList = this.taskList.filter(task => task.Id !== taskToDelete)
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
    showPopup(event) {
        const id = event.target.dataset['id'];
        const element = this.template.querySelector(`td[data-id="${id}"]`);
        const popupContent = element.querySelector('.popup-content');

        popupContent.style.display = 'block';
        popupContent.style.top = null;
        popupContent.style.left = null;
        popupContent.style.left = 50+'px';
        popupContent.style.top = event.clientY-popupContent.getBoundingClientRect().top+'px';

      }

      hidePopup(event) {
        const id = event.target.dataset['id'];
        const element = this.template.querySelector(`td[data-id="${id}"]`);
        const popupContent = element.querySelector('.popup-content');
        popupContent.style.display = 'none';
        popupContent.style.top = event.clientY
      }

      handlerNavigate(event) {
        event.preventDefault();
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId:  event.target.dataset['id'],
                objectApiName: 'Custom_Task__c',
                actionName: 'view'
            }
        });
    }

}