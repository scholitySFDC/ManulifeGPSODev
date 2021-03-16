import { LightningElement, api } from 'lwc';
import getTasksByProject from '@salesforce/apex/CActionPlanController.getTasksByProject'
import markRecordComplete from '@salesforce/apex/CActionPlanController.markRecordComplete'
import {
    SAMPLE_COLUMNS_DEFINITION_BASIC,
    SAMPLE_DATA_BASIC
} from './sampleData';

export default class LwcTable extends LightningElement {
    @api recordId;

    // definition of columns for the tree grid
    gridColumns = SAMPLE_COLUMNS_DEFINITION_BASIC;

    // data provided to the tree grid
    gridData = SAMPLE_DATA_BASIC;


    connectedCallback() {
        // this.recordId = '5004c000001pPYZAA2';
        this.getTasksByProjectData(this.value);
    }

    getTasksByProjectData(scope) {
        getTasksByProject({projectId : this.recordId, scope : scope}).then(response => {
            let dataGrid = [];
            response.forEach((arrayItem) => {
                let extensibleArrayItem = Object.assign({}, arrayItem)
                
                let old_key = 'children';
                let new_key = '_children';

                if (old_key in extensibleArrayItem) {
                    Object.defineProperty(extensibleArrayItem, new_key,
                        Object.getOwnPropertyDescriptor(extensibleArrayItem, old_key));
                    delete extensibleArrayItem[old_key];
                }

                dataGrid.push(extensibleArrayItem);
            });
            console.log(dataGrid);
            console.log(JSON.stringify(response));
            this.gridData = dataGrid;
        }).catch(error => {
            console.log(error);
        });
    }


    value = 'own';

    get options() {
        return [
            { label: 'My Tasks', value: 'own' },
            { label: 'All Tasks', value: 'all' },
        ];
    }

    handleChange(event) {
        this.value = event.detail.value;
        console.log(this.value);
        this.getTasksByProjectData(this.value);
    }

    onRowAction(event) {
        // const actionName = event.detail.action.name;
        const clickedRowColumnContext = event.detail.row;
        let scope = '';
        let recordId = '';
        if (clickedRowColumnContext.taskId != null) {
            recordId = clickedRowColumnContext.taskId;
            scope = 'Task';
        } else if (clickedRowColumnContext.actionPlanId != null) {
            recordId = clickedRowColumnContext.actionPlanId;
            scope = 'ActionPlan';
        }
        console.log({recordId: recordId , recordType : scope});
        markRecordComplete({recordId: recordId , recordType : scope}).then((response) => {
            this.getTasksByProjectData(this.value);
        }).catch(error => {
            console.log(error);
        });

    }

}