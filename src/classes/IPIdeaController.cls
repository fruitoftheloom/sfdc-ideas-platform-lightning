public with sharing class IPIdeaController { 
    
    public IPIdeaController( ApexPages.StandardController controller ) {

    }  
    
    public PageReference redirectToLightning() {
        
        String ideaId = ApexPages.currentPage().getParameters().get('id');
        
        PageReference reference = new PageReference( '/one/one.app#/sObject/' + ideaId + '/view' );
        
        reference.setRedirect( true );
        
        return reference;       
        
    }
    
    @AuraEnabled
    public static String getUserId() {
        return UserInfo.getUserId();
    }

    @AuraEnabled
    public static List<IP_Idea__c > getIdeasByZoneId( Id zoneId, String filterBy, String sortBy ) {
        
        String baseQuery = 'SELECT Id, Body__c, Category__r.Name, Zone__c, CreatedDate, CreatedBy.Id, CreatedBy.Name, CreatedBy.FullPhotoUrl, CreatedBy.SmallPhotoUrl, LastViewedDate, Status__r.Name, Title__c, Total_Votes__c, Total_Score__c FROM IP_Idea__c WHERE Zone__c = :zoneId';

        Boolean hasFilter = ( String.isNotBlank( filterBy ) && filterBy != 'All' );
        Boolean hasSort = ( String.isNotBlank( sortBy ) && sortBy != 'All' );

        if( hasFilter ) {

            filterBy = String.escapeSingleQuotes( filterBy );
            String tempFilterBy = '%' + filterBy + '%';
            String filterQuery = ' AND ( Status__r.Name = :filterBy OR Category__r.Name LIKE :tempFilterBy )';

            baseQuery += filterQuery;

        }

        if( hasSort ) {

            // translate option to correct field on Idea object
            if( sortBy == 'Popular' ) {
                sortBy = 'Total_Votes__c';
            }
            else if( sortBy == 'New' ) {
                sortBy = 'CreatedDate';
            }
            else if( sortBy == 'Recent Activity' ) {
                sortBy = 'LastModifiedDate';
            }
            else {
                sortBy = null;
            }
            
            if(String.isNotBlank( sortBy )){
                baseQuery += ' ORDER BY ' + sortBy + ' DESC';
            }

        } else {
            baseQuery += ' ORDER BY CreatedDate DESC';
        }
        
        List<IP_Idea__c> ideaList = Database.query( baseQuery );
        
        return ideaList;

    }

    @AuraEnabled
    public static Boolean isExpert( String ideaId ) {        
        
        List<IP_Expert__c> expertList = getIdeaExperts( ideaId );
        
        Id currentUserId = getUserId();

        for( IP_Expert__c expert : expertList ) {
            if( expert.User__c == currentUserId ) {
                return true;
            }
        }

        return false;
        
    }
    
    @AuraEnabled
    public static List<IP_Expert__c> getIdeaExperts( String ideaId ) {
        
        IP_Idea__c idea = getIdea( ideaId );
        
        List<IP_Expert__c> expertList = [
            SELECT 
                Id,
                User__c,
                User__r.Email,
                User__r.Name,
                User__r.SmallPhotoUrl
            FROM 
                IP_Expert__c 
            WHERE  
                Zone__c = :idea.Zone__c
                AND
                Category__c = :idea.Category__c
        ];
        
        return expertList;
        
    }

    @AuraEnabled
    public static Boolean hasVotedOnIdea( String ideaId ) {

        String userId = getUserId();

        Integer count = [SELECT count() FROM IP_Vote__c WHERE CreatedById = :userId AND Idea__c = :ideaId];

        if( count > 0 ) {
            return true;
        }

        return false;

    }
    
    @AuraEnabled
    public static Boolean hasLockStatus( String ideaId ) {

        String userId = getUserId();

        IP_Idea__c idea = getIdea(ideaId);

        if(idea.Status__r.Lock_Status__c){
            return true;
        }
        
        return false;

    }
    
    @AuraEnabled
    public static Boolean isIdeaAdmin( ) {

        String userId = getUserId();
        
        try{
        	PermissionSetAssignment psa = [ SELECT Id
                                          	FROM PermissionSetAssignment
                                          	WHERE AssigneeId = :userId
                                          		AND PermissionSet.Name = 'IP_Idea_Admin'
                                          ];
            return true;
        }catch( Exception e ){
            return false;
        }

    }

    @AuraEnabled
    public static List<IP_Vote__c> getIdeaVoteList( String ideaId ) {

        List<IP_Vote__c> voteList = [
            SELECT
                Id,
                CreatedBy.Name,
                CreatedBy.SmallPhotoUrl,
                Upvote__c
            FROM
                IP_Vote__c
            WHERE
                Idea__c = :ideaId
        ];

        return voteList;

    }

    @AuraEnabled
    public static void voteForIdea( String ideaId, Boolean direction ) {

        IP_Vote__c vote = new IP_Vote__c();

        vote.Idea__c = ideaId;
        vote.Upvote__c = direction;

        insert vote;

    }

    @AuraEnabled
    public static IP_Idea__c getIdea( String ideaId ) {
        
        IP_Idea__c idea = [
            SELECT 
                Id, 
                Body__c, 
                Category__c,
                Category__r.Name,
                Zone__c,
                Zone__r.Name, 
                CreatedDate, 
                CreatedBy.Id, 
                CreatedBy.Name, 
                CreatedBy.FullPhotoUrl, 
                CreatedBy.SmallPhotoUrl, 
                LastViewedDate, 
                Status__r.Name,
                Status__r.Lock_Status__c,
                Title__c, 
                Total_Votes__c, 
                Total_Score__c 
            FROM
                IP_Idea__c 
            WHERE
                Id = :ideaId
        ];
        
        return idea;
        
    }
    
    @AuraEnabled
    public static IP_Idea__c saveIdea( String zoneId, IP_Idea__c idea ) {

        
        // Determine if the record is an existing idea to determine if an initial vote needs to be created
        Boolean isNewIdea = false;
        if( String.isBlank( idea.Id ) ){
            isNewIdea = true;
        }
        
        if( isNewIdea ){
            // set zone id
            idea.Zone__c = zoneId;
        }

        upsert idea;
        return idea;
    }

    @AuraEnabled
    public static IP_Zone__c getZone( String zoneId ) {
        return [
            SELECT
                Id,
                Name,
                OwnerId,
                (SELECT Name FROM Statuses__r ORDER BY Display_Order__c asc),
                (SELECT Name FROM Categories__r WHERE Available__c = true)
            FROM
                IP_Zone__c 
            WHERE
                Id = :zoneId
        ];
    }
    
}