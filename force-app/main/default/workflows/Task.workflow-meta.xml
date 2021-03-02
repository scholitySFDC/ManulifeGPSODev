<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Task_Status_to_Overdue</fullName>
        <field>Status</field>
        <literalValue>Overdue</literalValue>
        <name>Task Status to Overdue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Change Task Status to Overdue</fullName>
        <actions>
            <name>Task_Status_to_Overdue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ActivityDate &lt;  TODAY()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Task.ActivityDate</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
