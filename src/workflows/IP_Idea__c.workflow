<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>IP_Notify_Experts_Point_Threshold_Reached</fullName>
        <description>IP - Notify Experts Point Threshold Reached</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IP_Email_Templates/IP_Notify_Experts_Point_Threshold_Reached</template>
    </alerts>
    <alerts>
        <fullName>IP_Notify_Submitter_Status_Changed</fullName>
        <description>IP - Notify Submitter Status Changed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IP_Email_Templates/IP_Notify_Submitter_Status_Changed</template>
    </alerts>
    <alerts>
        <fullName>IP_Notify_Submitter_on_Create</fullName>
        <description>IP - Notify Submitter on Create</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IP_Email_Templates/IP_Notify_Submitter_on_Create</template>
    </alerts>
</Workflow>
