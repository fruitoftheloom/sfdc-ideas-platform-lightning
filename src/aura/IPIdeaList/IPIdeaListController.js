({

    doInit : function( component, event, helper ) {

        helper.getIdeaList( component, {}, function() {

        });

    },

    getIdeaList : function( component, event, helper ) {

        var ideaListOptions = {
            filter : event.getParam( "filter" ),
            sort : event.getParam( "sort" )
        };

        component.set( "v.filter", ideaListOptions.filter );

        helper.getIdeaList( component, ideaListOptions, function() {

        });

    }

})