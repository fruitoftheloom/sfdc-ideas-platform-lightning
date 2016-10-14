({

    getIdeaList : function ( component, ideaListOptions, callback ) {

        // get current user
        var zoneId = component.get( "v.recordId" );

        this.refreshIdeaList( component, zoneId, ideaListOptions, function( result ) {

            component.set( "v.ideaList", result );

            if( callback ) {
            	callback( result );
            }

        });

    },

	refreshIdeaList : function( component, zoneId, options, callback ) {

	    // get apex controller action
        var action = component.get( "c.getIdeasByZoneId" );

        var params = {
        	zoneId : zoneId
        };

        if( options ) {
            params.filterBy = options.filter;
            params.sortBy = options.sort;
        }

        // set the parameters
        action.setParams( params );

        action.setCallback( this, function( response ) {

            var state = response.getState();
            var result = response.getReturnValue();

            if( state === "SUCCESS" ) {
                callback( result );
            }
            else {
            	console.log( "Error refreshing idea list, zoneId=" + zoneId );
            }

        });

        $A.enqueueAction( action );

	}

})