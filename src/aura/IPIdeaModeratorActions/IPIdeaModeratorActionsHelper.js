({

	getZone : function( component, zoneId, callback ) {

        // get apex controller action
        var action = component.get( "c.getZone" );

        // set the parameters
        action.setParams({
            zoneId : zoneId
        });

        action.setCallback( this, function( response ) {

            var state = response.getState();
            var result = response.getReturnValue();

            if( state === "SUCCESS" ) {
                callback( result );
            }
            else {
            	console.log( "Error getting zone, zoneId=" + zoneId );
            }

        });

        $A.enqueueAction( action );

    },

    isExpert : function( component, ideaId, callback ) {

        // get apex controller action
        var action = component.get( "c.isExpert" );

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
            	console.log( "Error getting checking for expert, ideaId=" + ideaId );
            }

        });

        $A.enqueueAction( action );

    },

    getIdea : function( component, ideaId, callback ) {

        var action = component.get( "c.getIdea" );

        action.setParams({
            ideaId : ideaId
        });

        action.setCallback( this, function( response ) {

            var state = response.getState();
			var result = response.getReturnValue();

            if( state === "SUCCESS" ) {
                callback( result );
            }
            else {
            	console.log( "Error getting idea, ideaId=" + ideaId );
            }

        });

        $A.enqueueAction( action );

    },

    saveIdea : function( component, zoneId, idea, callback ) {

        var action = component.get( "c.saveIdea" );

        action.setParams({
            idea : idea,
            zoneId : zoneId
        });

        action.setCallback( this, function( response ) {

            var state = response.getState();
			var result = response.getReturnValue();

            if( state === "SUCCESS" ) {
                callback( result );
            }
            else {
            	console.log( "Error saving idea, ideaId=" + ideaId );
            }

        });

        $A.enqueueAction( action );

    }

})