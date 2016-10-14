trigger IPVoteTrigger on IP_Vote__c (before insert) {
    if(Trigger.isInsert){
        
        Set<Id> ideaIds = new Set<Id>();
        for(IP_Vote__c vote : Trigger.new){
            ideaIds.add(vote.Idea__c);
        }
        
        Map<Id, IP_Idea__c> ideas = new Map<Id, IP_Idea__c>([SELECT Id, Zone__c, Zone__r.Points_Per_Vote__c FROM IP_Idea__c WHERE Id IN :ideaIds]);
        
        for(IP_Vote__c vote : Trigger.new){
            Decimal pointsPerVote = ideas.get(vote.Idea__c).Zone__r.Points_Per_Vote__c;
            
            if(vote.Upvote__c){
                vote.Points__c = pointsPerVote;
            } else{
                vote.Points__c = pointsPerVote * -1;
            }
        }
    }
}