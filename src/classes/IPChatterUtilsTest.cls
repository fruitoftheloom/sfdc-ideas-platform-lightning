@isTest
public class IPChatterUtilsTest {
	
    public static Id getCurrentUserId(){
        return UserInfo.getUserId();
    }
    
    public static Account createAccount(){
        Account a = new Account( Name = 'Test Account' );
        return a;
    }
    
    /* Code not in use, but left in for reference
    @isTest(seeAllData = true)
    public static void test_add_follower_to_record(){
        Id userId = getCurrentUserId();
        Account newAccount = createAccount();
        insert newAccount;
        
        ChatterUtils.addFollowerToRecord( userId, newAccount.Id );
        
        ConnectApi.FollowerPage fp = ConnectApi.Chatter.getFollowers( Network.getNetworkId(), newAccount.Id); 
        List<ConnectApi.Subscription> subscriptions = fp.followers;
		
		System.assertEquals( 1, subscriptions.size() );        
    }
    
    @isTest(seeAllData = true)
    public static void test_add_followers_to_record(){
        List<Id> userIdList = new List<Id>();
        Id userId = getCurrentUserId();
        
        userIdList.add( userId );
        
        Account newAccount = createAccount();
        insert newAccount;
        
        ChatterUtils.addFollowersToRecord( userIdList, newAccount.Id );
        
        ConnectApi.FollowerPage fp = ConnectApi.Chatter.getFollowers( Network.getNetworkId(), newAccount.Id); 
        List<ConnectApi.Subscription> subscriptions = fp.followers;
		
		System.assertEquals( 1, subscriptions.size() );        
    }
	*/
    
    @isTest(seeAllData = true)
    public static void test_add_followers_to_records(){
        List<Id> userIdList = new List<Id>();
        Id userId = getCurrentUserId();
        
        userIdList.add( userId );
        
        Account newAccount = createAccount();
        insert newAccount;
        
        Map<Id,List<Id>> recordIdToFollowerIdMap = new Map<Id,List<Id>>();        
		recordIdToFollowerIdMap.put( newAccount.Id, userIdList );   
        
        IPChatterUtils.addFollowersToRecords( recordIdToFollowerIdMap );
        
        List<ConnectApi.FollowerPage> followerPageList = new List<ConnectApi.FollowerPage>();
        for( Id i : recordIdToFollowerIdMap.keySet() ){
            followerPageList.add( ConnectApi.Chatter.getFollowers( Network.getNetworkId(), i ) );
        }
        
        List<List<ConnectApi.Subscription>> subscriptionsList = new List<List<ConnectApi.Subscription>>();
        for( ConnectApi.FollowerPage fp : followerPageList ){
            subscriptionsList.add( fp.followers );
        }
        
        System.assertEquals( 1, subscriptionsList.size() );        
    }
    
    @isTest
    public static void test_create_feed_item(){
        Id userId = getCurrentUserId();
        String body = 'Test chatter post';
        Account newAccount = createAccount();
        insert newAccount;
        
        FeedItem newFeedItem = IPChatterUtils.createFeedItem( newAccount.Id, body, userId );
        
        System.assertEquals( body, newFeedItem.body );
        System.assertEquals( newAccount.Id, newFeedItem.parentId );
        System.assertEquals( userId, newFeedItem.CreatedById );
    }
    
    
}