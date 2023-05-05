import newLabel from '@salesforce/label/c.New_label';
import deleteLabel from '@salesforce/label/c.Delete_label'
import wasDeletedLabel from '@salesforce/label/c.Was_deleted_label'
import removalUnsuccessfulLabel from '@salesforce/label/c.Removal_unsuccessful_label';
import yourTasks from '@salesforce/label/c.Your_Tasks';
import description from '@salesforce/label/c.Description';
import createDate from '@salesforce/label/c.Create_Date';
import viewAll from '@salesforce/label/c.View_All';
import showLess from '@salesforce/label/c.Show_Less';
const customLabels = {
    newLabel, deleteLabel, wasDeletedLabel, removalUnsuccessfulLabel, yourTasks, description, createDate,
    viewAll, showLess
}
export { customLabels }