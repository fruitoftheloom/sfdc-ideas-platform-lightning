@isTest
public class IPIdeaControllerTest {

    @isTest
    static void test_getUserId() {
        Test.startTest();

        String userId = IPIdeaController.getUserId();

        Test.stopTest();

        system.assertEquals((String) UserInfo.getUserId(), userId);
    }

    @isTest
    static void test_getIdeasByZoneId_noFilterOrSort(){

        IP_Zone__c zone = createZone();
        IP_Status__c initialStatus = createInitialStatus(zone.Id);
        IP_Idea__c idea = createIdea(zone.Id);
        IP_Idea__c idea2 = createIdea(zone.Id);

        Map<Id, IP_Idea__c> ideaMap = new Map<Id, IP_Idea__c>();
        ideaMap.put(idea.Id, idea);
        ideaMap.put(idea2.Id, idea2);

        Test.startTest();

        List<IP_Idea__c> retrievedIdeas = IPIdeaController.getIdeasByZoneId( zone.Id, '', '' );

        Test.stopTest();

        System.assert(retrievedIdeas.size() == 2);
        for(IP_Idea__c i : retrievedIdeas){
            System.assert(ideaMap.containsKey(i.Id));
        }
    }

    @isTest
    //In addition to testing the filter code, this also tests that the workflow rule is updating the status correctly when the point threshold is reached.
    static void test_getIdeasByZoneId_filter(){
        IP_Zone__c zone = createZone();
        IP_Status__c initialStatus = createInitialStatus(zone.Id);
        IP_Status__c thresholdStatus = createThresholdStatus(zone.Id);
        IP_Idea__c idea = createIdea(zone.Id);
        IP_Idea__c idea2 = createIdea(zone.Id);
        IP_Vote__c vote = createVote(idea2.Id);
        IP_Vote__c vote2 = createVote(idea2.Id);

        Test.startTest();

        List<IP_Idea__c> retrievedIdeas = IPIdeaController.getIdeasByZoneId( zone.Id, 'Threshold', '' );

        Test.stopTest();

        System.assert(retrievedIdeas.size() == 1);
        for(IP_Idea__c i : retrievedIdeas){
            System.assertEquals(i.Id, idea2.Id);
        }
    }

    @isTest
    static void test_getIdeasByZoneId_sortPopular(){
        IP_Zone__c zone = createZone();
        IP_Status__c initialStatus = createInitialStatus(zone.Id);
        IP_Status__c thresholdStatus = createThresholdStatus(zone.Id);
        IP_Idea__c idea = createIdea(zone.Id);
        IP_Idea__c idea2 = createIdea(zone.Id);
        IP_Vote__c vote = createVote(idea2.Id, false);

        Test.startTest();

        List<IP_Idea__c> retrievedIdeas = IPIdeaController.getIdeasByZoneId( zone.Id, '', 'Popular' );

        Test.stopTest();

        System.assertEquals(retrievedIdeas[0].Id, idea2.Id);
        System.assertEquals(retrievedIdeas[1].Id, idea.Id);
    }

    @isTest
    static void test_getIdeasByZoneId_sortTrending(){
        IP_Zone__c zone = createZone();
        IP_Status__c initialStatus = createInitialStatus(zone.Id);
        IP_Status__c thresholdStatus = createThresholdStatus(zone.Id);
        IP_Idea__c idea = createIdea(zone.Id);
        IP_Idea__c idea2 = createIdea(zone.Id);
        IP_Vote__c vote = createVote(idea2.Id, false);

        Test.startTest();

        List<IP_Idea__c> retrievedIdeas = IPIdeaController.getIdeasByZoneId( zone.Id, '', 'Trending' );

        Test.stopTest();

        System.assertEquals(retrievedIdeas[0].Id, idea.Id);
        System.assertEquals(retrievedIdeas[1].Id, idea2.Id);
    }

    @isTest
    static void test_getIdeasByZoneId_sortRecent(){
        IP_Zone__c zone = createZone();
        IP_Status__c initialStatus = createInitialStatus(zone.Id);
        IP_Status__c thresholdStatus = createThresholdStatus(zone.Id);
        IP_Category__c category = createCategory( zone.Id );
        IP_Idea__c idea = createIdea(zone.Id);
        IP_Idea__c idea2 = new IP_Idea__c(
            Title__c = 'Title',
            Body__c = 'Body',
            Category__c = category.Id,
            Zone__c = zone.Id
        );

        insert idea2;

        Test.startTest();

        List<IP_Idea__c> retrievedIdeas = IPIdeaController.getIdeasByZoneId( zone.Id, '', 'Recent' );

        Test.stopTest();

        System.assertEquals(retrievedIdeas[0].Id, idea.Id);
        System.assertEquals(retrievedIdeas[1].Id, idea2.Id);
    }

    @isTest
    static void test_hasVotedOnIdea_true(){
        IP_Zone__c zone = createZone();
        IP_Status__c initialStatus = createInitialStatus(zone.Id);
        IP_Status__c thresholdStatus = createThresholdStatus(zone.Id);
        IP_Idea__c idea = createIdea(zone.Id);
        IP_Vote__c vote = createVote(idea.Id, false);

        Test.startTest();

        Boolean voted = IPIdeaController.hasVotedOnIdea( idea.Id );

        Test.stopTest();

        System.assert(voted);
    }

    @isTest
    static void test_hasVotedOnIdea_false(){
        IP_Zone__c zone = createZone();
        IP_Status__c initialStatus = createInitialStatus(zone.Id);
        IP_Status__c thresholdStatus = createThresholdStatus(zone.Id);
        IP_Idea__c idea = createIdea(zone.Id);
        IP_Vote__c vote = [SELECT Id FROM IP_Vote__c WHERE Idea__c = :idea.Id];

        Delete vote;

        Test.startTest();

        Boolean voted = IPIdeaController.hasVotedOnIdea( idea.Id );

        Test.stopTest();

        System.assert(!voted);
    }

    @isTest
    static void test_getIdeaVoteList(){
        IP_Zone__c zone = createZone();
        IP_Status__c initialStatus = createInitialStatus(zone.Id);
        IP_Status__c thresholdStatus = createThresholdStatus(zone.Id);
        IP_Idea__c idea = createIdea(zone.Id);
        IP_Vote__c vote = [SELECT Id FROM IP_Vote__c WHERE Idea__c = :idea.Id];
        IP_Vote__c vote2 = createVote(idea.Id, false);
        IP_Vote__c vote3 = createVote(idea.Id, false);

        Map<Id, IP_Vote__c> voteMap = new Map<Id, IP_Vote__c>();
        voteMap.put(vote.Id, vote);
        voteMap.put(vote2.Id, vote2);
        voteMap.put(vote3.Id, vote3);

        Test.startTest();

        List<IP_Vote__c> voteList = IPIdeaController.getIdeaVoteList( idea.Id );

        Test.stopTest();

        for(IP_Vote__c v : voteList){
            System.assert(voteMap.containsKey(v.Id));
        }
    }

    @isTest
    static void test_voteForIdea(){
        IP_Zone__c zone = createZone();
        IP_Status__c initialStatus = createInitialStatus(zone.Id);
        IP_Status__c thresholdStatus = createThresholdStatus(zone.Id);
        IP_Idea__c idea = createIdea(zone.Id);

        Test.startTest();

        IPIdeaController.voteForIdea( idea.Id, true );

        Test.stopTest();

        List<IP_Vote__c> voteList = [SELECT Id FROM IP_Vote__c WHERE Idea__c = :idea.Id];

        System.assert(voteList.size() == 2);
    }

    @isTest
    static void test_saveIdea_newIdea(){

        IP_Zone__c zone = createZone();
        IP_Status__c initialStatus = createInitialStatus(zone.Id);
        IP_Status__c thresholdStatus = createThresholdStatus(zone.Id);
        IP_Category__c category = createCategory( zone.Id );
        IP_Idea__c idea = new IP_Idea__c(
            Title__c = 'Title',
            Body__c = 'Body',
            Category__c = category.Id
        );

        Test.startTest();

        IP_Idea__c newIdea = IPIdeaController.saveIdea( zone.Id, idea);

        Test.stopTest();

        newIdea = [SELECT Id, Total_Score__c FROM IP_Idea__c WHERE Id = :newIdea.Id];

        System.assert(newIdea.Total_Score__c == zone.Points_Per_Vote__c);
    }

    @isTest
    static void test_isExpert_true(){
        IP_Zone__c zone = createZone();
        IP_Status__c initialStatus = createInitialStatus(zone.Id);
        IP_Idea__c idea = createIdea(zone.Id);
        IP_Category__c category = [SELECT Id, Zone__c FROM IP_Category__c WHERE Id = :idea.Category__c];
        IP_Expert__c expert = createExpert(zone.Id, category.Id);

        Test.startTest();

        Boolean isZoneExpert = IPIdeaController.isExpert( idea.Id );

        Test.stopTest();

        System.assert(isZoneExpert);
    }

    @isTest
    static void test_isZoneExpert_false(){
        IP_Zone__c zone = createZone();
        IP_Status__c initialStatus = createInitialStatus(zone.Id);
        IP_Idea__c idea = createIdea(zone.Id);
        IP_Category__c category = [SELECT Id, Zone__c FROM IP_Category__c WHERE Id = :idea.Category__c];

        Test.startTest();

        Boolean isZoneExpert = IPIdeaController.isExpert( idea.Id );

        Test.stopTest();

        System.assert(!isZoneExpert);
    }

    private static IP_Zone__c createZone(){
        IP_Zone__c zone = new IP_Zone__c (
            Name = 'Test Zone',
            Points_Per_Vote__c = 10,
            Point_Threshold__c = 15
        );

        insert zone;
        return zone;
    }

    private static IP_Idea__c createIdea(Id zoneId){

        IP_Category__c category = createCategory( zoneId );

        IP_Idea__c idea = new IP_Idea__c(
            Title__c = 'Title',
            Body__c = 'Body',
            Category__c = category.Id,
            Zone__c = zoneId
        );

        insert idea;
        return idea;
    }

    private static IP_Vote__c createVote(Id ideaId){
        IP_Vote__c vote = createVote(ideaId, true);
        return vote;
    }

    private static IP_Vote__c createVote(Id ideaId,Boolean upvote){
        IP_Vote__c vote = new IP_Vote__c(
            Idea__c = ideaId,
            Upvote__c = upvote
        );

        insert vote;
        return vote;
    }

    private static IP_Category__c createCategory( Id zoneId ) {

        IP_Category__c category = new IP_Category__c(
            Zone__c = zoneId,
            Name = 'Information Technology'
        );

        insert category;
        return category;

    }

    private static IP_Status__c createInitialStatus( Id zoneId ) {

        IP_Status__c status = new IP_Status__c(
            Zone__c = zoneId,
            Name = 'Initial',
            Initial_Status__c = true,
            Display_Order__c = 1
        );

        insert status;
        return status;

    }

    private static IP_Status__c createThresholdStatus( Id zoneId ) {

        IP_Status__c status = new IP_Status__c(
            Zone__c = zoneId,
            Name = 'Threshold',
            Threshold_Status__c = true,
            Display_Order__c = 2
        );

        insert status;
        return status;

    }

    private static IP_Expert__c createExpert( Id zoneId, Id categoryId ){
        IP_Expert__c expert = new IP_Expert__c(
        	Zone__c = zoneId,
            User__c = UserInfo.getUserId(),
            Category__c = categoryId
        );

        insert expert;
        return expert;
    }

}