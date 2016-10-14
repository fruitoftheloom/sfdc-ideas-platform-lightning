({

	getIdeaExperts : function( component, ideaId, callback ) {

        // get apex controller action
        var action = component.get( "c.getIdeaExperts" );

        // set the parameters
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
            	console.log( "Error getting idea experts, ideaId=" + ideaId );
            }

        });

        $A.enqueueAction( action );

    }

})