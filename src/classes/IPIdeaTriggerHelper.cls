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
    
    public static void createInitialVote( List<IP_Idea__c> ideaList ){
        
        List<IP_Vote__c> voteList = new List<IP_Vote__c>();
        
        for( IP_Idea__c idea : ideaList ) {
            
            IP_Vote__c vote = new IP_Vote__c(
                Idea__c = idea.Id,
                Points__c = idea.Zone__r.Points_Per_Vote__c,
                Upvote__c = true
            );
            
            voteList.add( vote );
            
        }      
        
        insert voteList; 
        
    }
    
    public static void setIdeaInitialStatus( List<IP_Idea__c> ideaList ){
        Map<Id, IP_Zone__c> initialStatuses = getInitialStatuses( ideaList );
        
        for( IP_Idea__c idea : ideaList ) {
            idea.Status__c = initialStatuses.get(idea.Zone__c).Statuses__r[0].Id;
        }   
    }
    
    public static void evaluateIdeaPointThreshold( List<IP_Idea__c> ideaList ){
        
        List<IP_Idea__c> thresholdReachedIdeaList = getPointThresholdReachedIdeaList( ideaList );
        
        if( !thresholdReachedIdeaList.isEmpty() ){
            
            //Query the list of ideas to get the related category values to use in the chatter post.
            thresholdReachedIdeaList = [
                SELECT
                Id,
                Category__c,
                Category__r.Post_to_Chatter_Message__c,
                Category__r.Post_to_Chatter_as_User__c
                FROM IP_Idea__c
                WHERE Id IN :thresholdReachedIdeaList
            ];
            
            //Subscribes experts to the ideas and then posts to chatter to send them a notification.
            subscribeExpertsToIdea( thresholdReachedIdeaList );
            createPointThresholdPost( thresholdReachedIdeaList );
        }
    }
    
    public static List<IP_Idea__c> getPointThresholdReachedIdeaList( List<IP_Idea__c> ideaList ){
        List<IP_Idea__c> thresholdReachedIdeaList = new List<IP_Idea__c>();
        Map<Id, IP_Zone__c> thresholdStatuses = getThresholdStatuses( ideaList );
        
        for( IP_Idea__c idea : ideaList ) {
            Decimal pointThreshold = thresholdStatuses.get( idea.Zone__c ).Point_Threshold__c;
            
            if( idea.Total_Score__c >= pointThreshold && !idea.Point_Threshold_Reached__c ) {
                idea.Point_Threshold_Reached__c = true;
                idea.Status__c = thresholdStatuses.get( idea.Zone__c ).Statuses__r[0].Id;
                thresholdReachedIdeaList.add( idea );
            }
        }
        return thresholdReachedIdeaList;
    }
    
    public static void subscribeExpertsToIdea( List<IP_Idea__c> ideaList ){
        Map<Id,List<Id>> ideaToExpertsMap = new Map<Id,List<Id>>();
        Set<Id> categoryIdSet = new Set<Id>();
        
        for( IP_Idea__c idea : ideaList ){
            categoryIdSet.add( idea.Category__c );
        }
        Map<Id,List<Id>> categoryToExpertsMap = getCategoryToExpertsMap( categoryIdSet );
        
        for( IP_Idea__c idea : ideaList ){
            if( categoryToExpertsMap.get( idea.Category__c ) != null ){
                ideaToExpertsMap.put( idea.Id, categoryToExpertsMap.get( idea.Category__c ) );
            }
        }
        
        if( !ideaToExpertsMap.isEmpty() ){
            IPChatterUtils.addFollowersToRecords( ideaToExpertsMap );
        }
    }
    
    public static void createPointThresholdPost( List<IP_Idea__c> ideaList ){
        Map<Id, String> recordIdToBodyMap = new Map<Id, String>();
        List<FeedItem> feedItemList = new List<FeedItem>();
        
        for( IP_Idea__c idea : ideaList ){
            String body;
            String chatterMessage = idea.Category__r.Post_to_Chatter_Message__c;
            if( String.isBlank( chatterMessage ) ){
                body = 'Point Threshold Reached';
            }else{
                body = chatterMessage;
            }
            feedItemList.add( IPChatterUtils.createFeedItem( idea.Id, body, idea.Category__r.Post_to_Chatter_As_User__c ) );
        }
        
        insert feedItemList;
        
    }
    
    public static Map<Id,List<Id>> getCategoryToExpertsMap( Set<Id> categoryIdSet ) {
        Map<Id,List<Id>> categoryToExpertsMap = new Map<Id,List<Id>>();
        
        List<IP_Expert__c> expertList = [
            SELECT 
            Id,
            User__c,
            Category__c
            FROM IP_Expert__c 
            WHERE Category__c = :categoryIdSet
        ];
        
        for( Id cId : categoryIdSet ){
            for( IP_Expert__c expert : expertList ){
                if( expert.Category__c == cId ){
                    if( categoryToExpertsMap.get( cId ) == null ){
                        categoryToExpertsMap.put( cId, new List<Id>{expert.User__c} );
                    }else{
                        List<Id> tempIdList = categoryToExpertsMap.get( cId );
                        tempIdList.add( expert.User__c );
                        categoryToExpertsMap.put( cId, tempIdList );
                    }
                }
            }
        }     
        
        return categoryToExpertsMap;
    }
    
}