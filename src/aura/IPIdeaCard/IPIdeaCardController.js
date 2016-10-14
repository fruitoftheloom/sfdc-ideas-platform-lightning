({

	doInit : function( component ) {

		var truncateText = component.get("v.truncateText");

		if( truncateText ) {

			var idea = component.get("v.idea");

			if( idea && idea.Body__c ) {
				idea.Body__c = idea.Body__c.substring( 0, 300 ) + "...";
			}

		}

	},

    viewIdea : function( component ) {

        var ideaId = component.get("v.idea").Id;

        if( ideaId ) {

            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": ideaId,
                "slideDevName": "detail"
            });
            navEvt.fire();

        }

        return false;

    }

})