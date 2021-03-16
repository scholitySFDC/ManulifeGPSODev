public with sharing class CCaseOverdueTasks {
    
    @AuraEnabled(cacheable=true)
    public static Integer getOverdueTaskCount(Id caseId) {
        Integer numOverdueTasks = 0;
        try {      
            String overdueTaskCountQuery = 'SELECT Count() '
                + 'FROM Task '
                + 'WHERE IsClosed = false '
                    + 'AND ActivityDate < TODAY '
                    + 'AND WhatId = \'' + caseId + '\'';
            numOverdueTasks = Database.countQuery(overdueTaskCountQuery);
        } catch(Exception e) {
            System.debug('Failed to return number of overdue tasks.');
        }
        
        return numOverdueTasks;
    }

    @AuraEnabled(cacheable=true)
    public static String getProjectTaskOverdueReportId() {
        return [
            SELECT Id
            FROM Report
            WHERE DeveloperName = 'Project_Task_Overdue'
            LIMIT 1
        ]?.Id;
    }
}