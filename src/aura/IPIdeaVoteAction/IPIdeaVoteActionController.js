({
	doInit : function(component, event, helper) {

        var ideaId = component.get( "v.recordId" );

        helper.hasVotedOnIdea( component, ideaId, function( result ) {
            component.set( "v.hasVotedOnIdea", result );
        });

        helper.hasLockStatus( component, ideaId, function( result ) {
            component.set( "v.hasLockStatus", result );
        });

	},

    voteUp : function( component, event, helper ) {

        var ideaId = component.get( "v.recordId" );

        if( ideaId ) {

            helper.voteForIdea( component, ideaId, true, function() {

				component.set( "v.hasVotedOnIdea", true );

                // force record refresh which will reload vote related list
                $A.get('e.force:refreshView').fire();

            });

        }

    }

})