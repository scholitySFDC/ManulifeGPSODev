import { LightningElement, wire } from 'lwc';
import getOverdueTasks from '@salesforce/apex/CCaseOverdueTasks.getOverdueTasks';

export default class CaseOutstandingTasks extends LightningElement {

    @wire(getOverdueTasks)
    overdueTasks;

    get numOverdueTasks() {
        console.log(this.overdueTasks.data);
        return this.overdueTasks.data;
    }

}