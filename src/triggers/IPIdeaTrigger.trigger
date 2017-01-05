trigger IPIdeaTrigger on IP_Idea__c (before insert, before update, after insert) {

    // Set initial status
    if( Trigger.isInsert && Trigger.isBefore ) {
        
        // Sets the status of the idea to the initial status of the zone
        IPIdeaTriggerHelper.setIdeaInitialStatus( Trigger.New );     
    
    }else if( Trigger.isInsert && Trigger.isAfter ) {
        
        // Insert new vote if this is a new Idea
        IPIdeaTriggerHelper.createInitialVote( Trigger.New );  
        
    }
    
    if( Trigger.isUpdate && Trigger.isBefore ) {
    	
        // Performs logic to update the idea status and notify experts via chatter when the point threshold is reached
        IPIdeaTriggerHelper.evaluateIdeaPointThreshold( Trigger.New );
    
    }      

}