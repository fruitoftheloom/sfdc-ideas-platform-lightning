public class IPChatterUtils {
    /* Code currently not in use and left in for reference
    //@future
    public static void addFollowerToRecord(Id userId, Id recordId) {
        EntitySubscription es = new EntitySubscription();
        es.subscriberId = userId;
        es.parentId = recordId;

        Database.SaveResult sr = Database.insert(es,false);
    }
    
    //@future
    public static void addFollowersToRecord(List<Id> userIds, Id recordId) {
        EntitySubscription[] esList = new List<EntitySubscription>();
        for (Id userId : userIds) {
            EntitySubscription es = new EntitySubscription();
            es.subscriberId = userId;
            es.parentId = recordId;
            esList.add(es);
        }
        Database.insert(esList,false);
    }
    */
    //Cannot use @future with a collection of collections
    public static void addFollowersToRecords(Map<Id,List<Id>> recordIdToFollowersMap) {
        EntitySubscription[] esList = new List<EntitySubscription>();
        for (Id recordId : recordIdToFollowersMap.keySet()) {
            for(Id userId : recordIdToFollowersMap.get(recordId)){
                EntitySubscription es = new EntitySubscription();
                es.subscriberId = userId;
                es.parentId = recordId;
                esList.add(es);
            }            
        }
        Database.insert(esList,false);
    }
    
    public static FeedItem createFeedItem( Id recordId, String body, Id userId ){
        FeedItem feedItem = new FeedItem();
        feedItem.Body = body;
        feedItem.ParentId = recordId;
        feedItem.CreatedById = userId;

        return feedItem;
    }
}