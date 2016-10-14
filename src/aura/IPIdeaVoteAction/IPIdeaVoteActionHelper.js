({

	hasVotedOnIdea : function( component, ideaId, callback ) {

        // get apex controller action
        var action = component.get( "c.hasVotedOnIdea" );

        // set the parameters
        action.setParams({
            ideaId : ideaId
        });

        action.setCallback( this, function( response ) {

            var state = response.getState();

            if( state === "SUCCESS" ) {
                callback( response.getReturnValue() );
            }
            else {
            	console.log( "Error getting checking idea vote, ideaId=" + ideaId );
            }

        });

        $A.enqueueAction( action );

    },

    hasLockStatus : function( component, ideaId, callback ) {

        // get apex controller action
        var action = component.get( "c.hasLockStatus" );

        // set the parameters
        action.setParams({
            ideaId : ideaId
        });

        action.setCallback( this, function( response ) {

            var state = response.getState();

            if( state === "SUCCESS" ) {
                callback( response.getReturnValue() );
            }
            else {
            	console.log( "Error getting checking lock status, ideaId=" + ideaId );
            }

        });

        $A.enqueueAction( action );

    },

    voteForIdea : function( component, ideaId, direction, callback ) {

        var action = component.get( "c.voteForIdea" );

        action.setParams({
            ideaId : ideaId,
            direction : direction
        });

        action.setCallback( this, function( response ) {

            var state = response.getState();

            if( state === "SUCCESS" ) {
                callback( response.getReturnValue() );
            }
            else {
            	console.log( "Error getting voting for idea, ideaId=" + ideaId );
            }

        });

        $A.enqueueAction( action );

    }

})