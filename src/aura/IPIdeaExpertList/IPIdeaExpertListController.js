({
	doInit : function( component, event, helper ) {

        var ideaId = component.get( "v.recordId" );

        helper.getIdeaExperts( component, ideaId, function( result ) {
        	component.set( "v.expertList", result );
        });

    }

})