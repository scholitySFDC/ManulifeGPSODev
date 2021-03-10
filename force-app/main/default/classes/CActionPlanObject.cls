public inherited sharing class CActionPlanObject {
    @auraEnabled
    public String taskName;
    @auraEnabled
    public String taskNameUrl;
    @auraEnabled
    public String taskStatus;
    @auraEnabled
    public Date dueDate;
    @auraEnabled
    public String assignedTo;
    @auraEnabled
    public List<CActionPlanChildrenObject> children;
    public Id actionPlanId;

    public CActionPlanObject() {

    }
}