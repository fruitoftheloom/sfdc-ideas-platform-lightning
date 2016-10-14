public class IPIdeaTriggerHelper {
    public static Map<Id, IP_Zone__c> getInitialStatuses(List<IP_Idea__c> ideas){
        Set<Id> zoneIds = getZoneIds(ideas);
        
        Map<Id, IP_Zone__c> initialStatuses = new Map<Id, IP_Zone__c>([SELECT Id, (SELECT Id FROM Statuses__r WHERE Initial_Status__c = true)
                                                                        FROM IP_Zone__c
                                                                        WHERE Id IN :zoneIds
                                                                       ]);

        return initialStatuses;
    }
    
    public static Map<Id, IP_Zone__c> getThresholdStatuses(List<IP_Idea__c> ideas){
        Set<Id> zoneIds = getZoneIds(ideas);
        
        Map<Id, IP_Zone__c> thresholdStatuses = new Map<Id, IP_Zone__c>([SELECT Id, Point_Threshold__c, (SELECT Id FROM Statuses__r WHERE Threshold_Status__c = true)
                                                                        FROM IP_Zone__c
                                                                        WHERE Id IN :zoneIds
                                                                       ]);
        
        return thresholdStatuses;
    }
    
    public static Set<Id> getZoneIds(List<IP_Idea__c> ideas){
        Set<Id> zoneIds = new Set<id>();
        for(IP_Idea__c idea : ideas){
            zoneIds.add(idea.Zone__c);
        }
        
        return zoneIds;
    }
}