/**
 * Columns definition
 * :: used in examples
 */
export const SAMPLE_COLUMNS_DEFINITION_BASIC = [
        {
            type: 'url',
            fieldName: 'taskNameUrl',
            label: 'Task Name',
            typeAttributes: {
                label: { fieldName: 'taskName' },
            },
        },
        {
            type: 'text',
            fieldName: 'taskStatus',
            label: 'Task Status',
        },
        {
            type: 'date',
            fieldName: 'dueDate',
            label: 'Due Date',
            sortable: true
        },
        {
            type: 'text',
            fieldName: 'assignedTo',
            label: 'Assigned To',
        }
    ];



/**
 * Sample data
 * :: used by examples
 */
export const SAMPLE_DATA_BASIC = [];