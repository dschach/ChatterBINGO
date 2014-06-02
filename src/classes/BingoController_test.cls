@isTest
private class BingoController_test {
	
	/**
	    TestMethod - inserts 30 users, has them each follow the running User,
	    and renders the BINGO card.
	*/
	private static  TestMethod void testBINGO_30() {
	
		List<User> users = new List<User>();
		
		for (Integer i = 0; i < 30; i++)   {
			User u = createTestUser(getSuperProfile());
			users.add(u);
		}
		
		insert users;
		List<EntitySubscription> followers = new List<EntitySubscription>();
		
		for (User u : users) {
			EntitySubscription es = new EntitySubscription(SubscriberId = u.id, ParentId = UserInfo.getUserId());
			followers.add(es);
		}
		
		insert followers;
		
		test.starttest();
		Test.setCurrentPage(Page.Bingo);
		
		BINGOController controller = new BINGOController();
		String NewCard = controller.NewCard().getUrl();
		System.assertEquals('/apex/bingo', NewCard);
		
		String CardPDF = controller.showAsPDF().getUrl();
		System.assertEquals('/apex/bingo?p=p', CardPDF);
		test.stoptest();
	}
	
	/**
	    TestMethod - inserts 2 users, has them each follow the running User,
	    and renders the BINGO card.
	    It also has the running User follow each of the 2 inserted users.
	    This is because the BINGO card draws from a User's followers and
	    from those users who follow the User.
	*/
	
	private static  TestMethod void testBINGO_2() {
	
		List<User> users = new List<User>();
		
		for (Integer i = 0; i < 2; i++)    {
			User u = createTestUser(getSuperProfile());
			users.add(u);
		}
		
		insert users;
		List<EntitySubscription> followers = new List<EntitySubscription>();
		
		for (User u : users) {
			EntitySubscription es = new EntitySubscription(SubscriberId = u.id, ParentId = UserInfo.getUserId());
			followers.add(es);
		}
		
		insert followers;
		
		followers = new List<EntitySubscription>();
		
		for (User u : users) {
			EntitySubscription es = new EntitySubscription(SubscriberId = UserInfo.getUserId(), ParentId = u.id);
			followers.add(es);
		}
		
		insert followers;
		
		test.starttest();
		Test.setCurrentPage(Page.Bingo);
		
		BINGOController controller = new BINGOController();
		String NewCard = controller.NewCard().getUrl();
		System.assertEquals('/apex/bingo', NewCard);
		String CardPDF = controller.showAsPDF().getUrl();
		System.assertEquals('/apex/bingo?p=p', CardPDF);
		test.stoptest();
	}
	
	/**
	    TestMethod - inserts 0 users, has them each follow the running User,
	    and renders the BINGO card.
	    This method also verifies that the card is first shown as a html page, not a pdf.
	*/
	private static TestMethod void testBINGO_0() {
	
		test.starttest();
		Test.setCurrentPage(Page.Bingo);
		
		BINGOController controller = new BINGOController();
		System.assertEquals(null, controller.getChooserender()); //We are not making a PDF
		String NewCard = controller.NewCard().getUrl();
		System.assertEquals('/apex/bingo', NewCard);
		String CardPDF = controller.showAsPDF().getUrl();
		System.assertEquals('/apex/bingo?p=p', CardPDF);
		
		test.stoptest();
	}
	
	/**
	    TestMethod - inserts 0 users, has them each follow the running User,
	    and renders the BINGO card as a PDF.
	*/
	private static TestMethod void testShowAsPDF() {
		test.starttest();
		Test.setCurrentPage(Page.Bingo);
		ApexPages.currentPage().getParameters().put('p', 'p');
		BINGOController controller = new BINGOController();
		System.assertEquals('pdf', controller.getChooserender()); //We are making a PDF
		test.stoptest();
	}
	
	public static Profile TheProfile;
	
	/**
	    Helper method to find a ModifyAllData User profile for each of the test users we create.
	    @return Profile
	*/
	
	public static Profile getSuperProfile() {
		if (TheProfile == null) {
			for (Profile p : [SELECT Id, PermissionsModifyAllData, Name FROM Profile LIMIT 100]) {
				if (p.PermissionsModifyAllData) {
					TheProfile = p;
					return TheProfile;
				}
			}
		}
		
		return TheProfile;
	}
	
	
	// All code below adapted from ActionPlans, written by Matias Menafra
	
	/**
	    Creates a new User
	    @return testUser
	*/
	
	public static User createTestUser(Profile p) {
	
		//USER U = [ SELECT ID FROM USER WHERE ID = :USERINFO.GETUSERID()];
		//RETURN U;
		
		String namePrefix = createRandomWord();
		
		User testUser = new User();
		testUser.Email              = 'test@test.com';
		testUser.Username           = namePrefix + '@testuser.com';
		testUser.LastName           = 'test';
		testUser.Alias              = 'test';
		testUser.ProfileId          = p.Id;
		testUser.LanguageLocaleKey  = 'en_US';
		testUser.LocaleSidKey       = 'en_US';
		testUser.TimeZoneSidKey     = 'America/Chicago';
		testUser.EmailEncodingKey   = 'UTF-8';
		
		//insert testUser;
		
		return testUser;
	}
	/**
	    Random words are required for testing
	    as you will likely run into any word I can insert
	    during a test class and produce false test results.
	*/
	public static  String createRandomWord() {
	
		String ret = 'schach' + math.rint(math.random() * 100000);
		
		return ret;
	}
	
}