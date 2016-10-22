public class IPIdeaSeedUtility {
	
	public static void createSampleData() {
		
		IP_Zone__c zone = createZone();
		
		createStatuses( zone.Id );
		
		createCategory( zone.Id, 'Lightning' );
		createCategory( zone.Id, 'Process Builder' );
										
	}	
	
	private static IP_Zone__c createZone() {
		
		IP_Zone__c zone = new IP_Zone__c(
			Name = 'Sample Community',
			Points_Per_Vote__c = 10,
			Point_Threshold__c = 100
		);
		
		insert zone;
		
		return zone;
		
	}
	
	private static void createStatuses( Id zoneId ) {
		
		List<IP_Status__c> statusList = new List<IP_Status__c>();
		
		IP_Status__c initialStatus = new IP_Status__c(
			Name = 'New',
			Zone__c = zoneId,
			Initial_Status__c = true,
			Display_Order__c = 10
		);		
		
		IP_Status__c underReviewStatus = new IP_Status__c(
			Name = 'Under Review',
			Zone__c = zoneId,
			Threshold_Status__c = true,
			Display_Order__c = 20
		);	
		
		IP_Status__c deliveredStatus = new IP_Status__c(
			Name = 'Delivered',
			Zone__c = zoneId,
			Lock_Status__c = true,
			Display_Order__c = 30
		);	
		
		statusList.add( initialStatus );
		statusList.add( underReviewStatus );
		statusList.add( deliveredStatus );
		
		insert statusList;
		
	}
	
	private static IP_Category__c createCategory( Id zoneId, String categoryName ) {
		
		IP_Category__c category = new IP_Category__c(
			Name = categoryName,
			Zone__c = zoneId			 						
		);
		
		insert category;
		
		return category;
		
	}
	
}