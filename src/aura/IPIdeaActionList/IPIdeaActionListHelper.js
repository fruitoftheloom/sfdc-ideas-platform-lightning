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

    refreshIdeaList : function( component ) {

        var refreshEvent = $A.get( "e.c:IPIdeaListRefreshEvent" );

        refreshEvent.setParams({
            sort : component.get("v.sort"),
            filter : component.get("v.filter")
        });

        // refresh the idea list
        refreshEvent.fire();

    }

})