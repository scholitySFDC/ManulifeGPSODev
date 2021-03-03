public class CCaseOverdueTasks {
    @AuraEnabled(cacheable=true)
    public static integer getOverdueTasks() {
        integer numOverdueTasks = 0;
        try {
            List<Task> overdueTasks = [SELECT Id FROM Task WHERE Status = 'Overdue'];
            numOverdueTasks = overdueTasks.size();
        } catch(Exception e) {
            System.debug('Failed to return number of overdue tasks.');
        }
        
        return numOverdueTasks;
    }
}