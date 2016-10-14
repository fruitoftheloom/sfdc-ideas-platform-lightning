({
	doInit : function( component, event, helper ) {

        var ideaId = component.get( "v.recordId" );

        helper.getIdea( component, ideaId, function( result ) {

            component.set( "v.idea", result );

            var zoneId = result.Zone__r.Id;

            helper.getZone( component, zoneId, function( zoneResult ) {
                component.set( "v.zone", zoneResult );
            });

            helper.isExpert( component, ideaId, function( isExpertResult ) {
                component.set( "v.isExpert", isExpertResult );
            });

        });

    },

    updateIdea : function( component, event, helper) {

        var zoneId = component.get( "v.zone" ).Id;
        var idea = component.get( "v.idea" );

        helper.saveIdea( component, zoneId, idea, function() {

            // force record refresh which will reload vote related list
            $A.get('e.force:refreshView').fire();

        });

    }

})