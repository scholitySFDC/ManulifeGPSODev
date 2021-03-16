import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getOverdueTaskCount from '@salesforce/apex/CCaseOverdueTasks.getOverdueTaskCount';
import getProjectTaskOverdueReportId from '@salesforce/apex/CCaseOverdueTasks.getProjectTaskOverdueReportId';

export default class CaseOutstandingTasks extends NavigationMixin(LightningElement) {

    @api recordId;

    @wire(getOverdueTaskCount, {caseId : '$recordId'})
    overdueTasks;

    @wire(getProjectTaskOverdueReportId)
    projectTaskOverdueReportId;

    get numOverdueTasks() {
        return this.overdueTasks && this.overdueTasks.data;
    }

    redirectToOverdueTaskReport(evt) {
        evt.preventDefault();
        evt.stopPropagation();
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.projectTaskOverdueReportId && this.projectTaskOverdueReportId.data,
                objectApiName: 'Report',
                actionName: 'view'
            },
            state: {
                fv4: this.recordId
            }
        });
    }

}