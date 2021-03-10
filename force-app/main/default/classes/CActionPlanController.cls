public inherited sharing class CActionPlanController {
    
    public CActionPlanController() {

    }

    @AuraEnabled(cacheable=true)
    public static List<CActionPlanObject> getTasksByProject(Id projectId, String scope) {

        // Action Plan Items associated with Action Plans
        List<ActionPlanItem> actionPlanItems = [
            SELECT
                Id, Name, ItemId, ItemState, ActionPlan.Id, ActionPlan.Name, 
                ActionPlan.Owner.Name, ActionPlan.TargetId, ActionPlan.Due_Date__c
            FROM ActionPlanItem 
            WHERE ActionPlan.TargetId =: projectId
        ];

        Map<Id, List<Id>> planIds = new Map<Id, List<Id>>();
        List<Id> itemIds = new List<Id>();
        for (ActionPlanItem actionPlanItem : actionPlanItems) {
            List<Id> actionPlanItemIds;
            Id actionPlanId = actionPlanItem.ActionPlan.Id;
            if (planIds.containsKey(actionPlanId)) {
                actionPlanItemIds = planIds.get(actionPlanId);
            } else {
                actionPlanItemIds = new List<Id>();
            }
            actionPlanItemIds.add(actionPlanItem.ItemId);
            planIds.put(actionPlanId, actionPlanItemIds);
            itemIds.add(actionPlanItem.ItemId);
        }

        Map<Id, Task> tasks = new Map<Id, Task>([
            SELECT Id, Subject, ActivityDate, Status, Owner.Id, OwnerId, Owner.Name FROM Task WHERE Id IN :itemIds
        ]);

        // Action Plan Associated with Case Id
        List<ActionPlan> actionPlans = [
            SELECT Id, Name, Owner.Name, ActionPlanState, Due_Date__c FROM ActionPlan WHERE TargetId = :projectId
        ];

        List<CActionPlanObject> actionPlanObjs = new List<CActionPlanObject>();
        for (ActionPlan actionPlan : actionPlans) {
            CActionPlanObject actionPlanObj = new CActionPlanObject();
            actionPlanObj.taskName = actionPlan.Name;
            actionPlanObj.taskNameUrl = System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+actionPlan.Id;
            actionPlanObj.taskStatus = actionPlan.ActionPlanState;
            actionPlanObj.dueDate = actionPlan.Due_Date__c;
            actionPlanObj.assignedTo = '';//actionPlan.Owner.Name;
            actionPlanObj.actionPlanId = actionPlan.Id;
            
            
            List<CActionPlanChildrenObject> childActionPlanObjs = new List<CActionPlanChildrenObject>();
            for(Id taskId : planIds.get(actionPlan.Id)) {
                Task taskItem = new Task();
                taskItem = tasks.get(taskId);
                
                System.debug(String.valueOf(taskItem.OwnerId));
                System.debug(String.valueOf(UserInfo.getUserId()));
                if (scope == 'own' && String.valueOf(taskItem.OwnerId) != String.valueOf(UserInfo.getUserId())) continue;

                CActionPlanChildrenObject childActionPlanObj = new CActionPlanChildrenObject();
                childActionPlanObj.taskName = taskItem.Subject;
                childActionPlanObj.taskNameUrl = System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+taskItem.Id;
                childActionPlanObj.taskStatus = taskItem.Status;
                childActionPlanObj.dueDate = taskItem.ActivityDate;
                childActionPlanObj.assignedTo = taskItem.Owner.Name;
                childActionPlanObj.taskId = taskItem.Id;
                childActionPlanObjs.add(childActionPlanObj);
            }
            actionPlanObj.children = childActionPlanObjs;
            actionPlanObjs.add(actionPlanObj);
        }

        System.debug(actionPlanObjs);

        // for(ActionPlanItem actionPlanItem: actionPlanItems) {
        //     CActionPlanObject actionPlanObj = new CActionPlanObject();
        //     actionPlanObj.taskName = actionPlanItem.Name;
        //     actionPlanObj.taskNameUrl = System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+actionPlanItem.Id;
        //     actionPlanObj.taskStatus = actionPlanItem.ItemState;
        //     actionPlanObj.dueDate = '10/20/2021';
        //     actionPlanObj.assignedTo = actionPlanItem.ActionPlan.Owner.Name;

        //     List<CActionPlanObject> childActionPlanObjs = new List<CActionPlanObject>();
        //     for(Task task : tasks) {
        //         if (task.Id == actionPlanItem.ItemId) {
        //             CActionPlanObject childActionPlanObj = new CActionPlanObject();
        //             childActionPlanObj.taskName = task.Subject;
        //             childActionPlanObj.taskNameUrl = System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+task.Id;
        //             childActionPlanObj.taskStatus = task.Status;
        //             childActionPlanObj.dueDate = '10/20/2021';
        //             childActionPlanObj.assignedTo = task.Owner.Name;
        //             childActionPlanObjs.add(actionPlanObj);
        //         }
        //     }

        //     if (childActionPlanObjs.size() > 0) {
        //         actionPlanObj.children = childActionPlanObjs;
        //     }
        //     actionPlanObjs.add(actionPlanObj);
        // }

        // System.debug(actionPlanObjs);

        return actionPlanObjs;
    } 
}