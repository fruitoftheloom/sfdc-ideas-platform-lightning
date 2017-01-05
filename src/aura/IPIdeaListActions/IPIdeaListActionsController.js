({
	doInit : function( component, event, helper ) {

        var zoneId = component.get( "v.recordId" ); 
        
        helper.getZone( component, zoneId, function( result ) {            
            component.set( "v.zone", result );                       
        });
        
        helper.setIsIdeaAdmin( component, function( result ) {            
            component.set( "v.isIdeaAdmin", result );                       
        });
        
    },
    
    onSortChange : function( component, event, helper ) {

        var sort = event.source.get( "v.value" );

        // update attribute value
       	component.set( "v.sort", sort );       
        
        helper.refreshIdeaList( component );

    },

    filterIdeaList : function( component, event, helper ) {
        
        var filter = event.source.get("v.label");

        // update attribute value
        component.set( "v.filter", filter );        

        helper.refreshIdeaList( component );
        
    },
    
    redirectToZone : function( component, event, helper ) {
        
        var getUrl = window.location;
		var redirectUrl = getUrl .protocol + "//" + getUrl.host + "/" + component.get( "v.recordId" ) + "?nooverride=1";
        window.location = redirectUrl;        
        
    }
    
})