trigger IPIdeaTrigger on IP_Idea__c (before insert, before update, after insert) {

    // Set initial status
    if( Trigger.isInsert && Trigger.isBefore ) {
        
        Map<Id, IP_Zone__c> initialStatuses = IPIdeaTriggerHelper.getInitialStatuses(Trigger.new);
        for( IP_Idea__c idea : Trigger.new ) {

            idea.Status__c = initialStatuses.get(idea.Zone__c).Statuses__r[0].Id;
            
        }        
    
    }

    // Insert new vote if this is a new Idea
    if( Trigger.isInsert && Trigger.isAfter ) {
        
        List<IP_Vote__c> voteList = new List<IP_Vote__c>();
        
        for( IP_Idea__c idea : Trigger.new ) {
        
            IP_Vote__c vote = new IP_Vote__c(
                Idea__c = idea.Id,
                Points__c = idea.Zone__r.Points_Per_Vote__c,
                Upvote__c = true
            );
            
            voteList.add( vote );
                        
        }       
        
        insert voteList;
        
    }
    else if( Trigger.isUpdate && Trigger.isBefore ) {
    
        //could modify this query to also pull the zone point threshold and do one query for this instead of two
        Map<Id, IP_Zone__c> thresholdStatuses = IPIdeaTriggerHelper.getThresholdStatuses(Trigger.new);

        for( IP_Idea__c idea : Trigger.new ) {
        
            Decimal pointThreshold = thresholdStatuses.get(idea.Zone__c).Point_Threshold__c;
            
            if( idea.Total_Score__c >= pointThreshold && !idea.Point_Threshold_Reached__c ) {
                
                idea.Point_Threshold_Reached__c = true;
                idea.Status__c = thresholdStatuses.get(idea.Zone__c).Statuses__r[0].Id;
                
            }                       
            
        }
    
    }      

}