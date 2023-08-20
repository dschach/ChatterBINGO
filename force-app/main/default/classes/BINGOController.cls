@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.Documentation-ApexDoc, PMD.ExcessivePublicCount, PMD.ApexDoc')
/**
 * BingoController controls the BINGO page and both BINGO components.
 * @author Chris Shackelford
 * @author David Schach
 * @author Brad Gross
 * @since 2011-02-18 First revision
 * @since 2023-08 v1.1
 * @group BINGO
 */
global with sharing class BINGOController {
	private Id myId;
	public List<User> bingos { get; private set; }
	private List<User> allUsers;
	private Set<Id> userIDs;
	public User me { get; set; }
	public User user1 { get; set; }
	public User user2 { get; set; }
	public User user3 { get; set; }
	public User user4 { get; set; }
	public User user5 { get; set; }
	public User user6 { get; set; }
	public User user7 { get; set; }
	public User user8 { get; set; }
	public User user9 { get; set; }
	public User user10 { get; set; }
	public User user11 { get; set; }
	public User user12 { get; set; }
	public User user13 { get; set; }
	public User user14 { get; set; }
	public User user15 { get; set; }
	public User user16 { get; set; }
	public User user17 { get; set; }
	public User user18 { get; set; }
	public User user19 { get; set; }
	public User user20 { get; set; }
	public User user21 { get; set; }
	public User user22 { get; set; }
	public User user23 { get; set; }
	public User user24 { get; set; }
	public User user25 { get; set; }

	/**
	 * We know the size of a standard BINGO board
	 */
	private static final Integer TOTAL_SQUARES = 25;
	/**
	 * Set an upper limit for records to query - important in large orgs
	 * like the Dreamforce 2010 org!
	 */
	private static final Integer QUERY_LIMIT = 999;

	/**
	 *  The constructor for BingoController
	 */
	public BingoController() {
		myId = UserInfo.getUserId();
		userIDs = new Set<Id>();

		// Users Following Me
		for (EntitySubscription es : [SELECT Id, ParentId, SubscriberId FROM EntitySubscription WHERE ParentId = :myId LIMIT :QUERY_LIMIT]) {
			userIDs.add(es.SubscriberId);
		}

		// Users I'm Following
		for (EntitySubscription es : [SELECT Id, SubscriberId, ParentId FROM EntitySubscription WHERE SubscriberId = :myId LIMIT :QUERY_LIMIT]) {
			/* Only include Users we are following. No records! */
			// prettier-ignore
			if (('' + es.Parentid).substring(0, 3) == '005') {
				userIDs.add(es.ParentId);
			}
		}

		allUsers = [SELECT Id, smallphotourl, FullPhotoUrl, Name FROM User WHERE Id IN :userIDs AND IsActive = TRUE];
		Set<Integer> usedIndices = new Set<Integer>();
		bingos = new List<User>();

		while (usedIndices.size() < allUsers.size()) {
			Integer index = Math.round(Math.random() * (allUsers.size() - 1));

			if (!usedIndices.contains(index)) {
				usedIndices.add(index);
				bingos.add(allUsers[index]);

				if (usedIndices.size() > TOTAL_SQUARES) {
					break;
				} // Break WHILE loop
			}
		}

		me = [SELECT Id, SmallPhotoUrl, FullPhotoUrl, Name FROM User WHERE Id = :myId];

		if (bingos.size() >= 1) {
			user1 = bingos[0];
		}

		if (bingos.size() >= 2) {
			user2 = bingos[1];
		}

		if (bingos.size() >= 3) {
			user3 = bingos[2];
		}

		if (bingos.size() >= 4) {
			user4 = bingos[3];
		}

		if (bingos.size() >= 5) {
			user5 = bingos[4];
		}

		if (bingos.size() >= 6) {
			user6 = bingos[5];
		}

		if (bingos.size() >= 7) {
			user7 = bingos[6];
		}

		if (bingos.size() >= 8) {
			user8 = bingos[7];
		}

		if (bingos.size() >= 9) {
			user9 = bingos[8];
		}

		if (bingos.size() >= 10) {
			user10 = bingos[9];
		}

		if (bingos.size() >= 11) {
			user11 = bingos[10];
		}

		if (bingos.size() >= 12) {
			user12 = bingos[11];
		}

		if (bingos.size() >= 13) {
			user13 = bingos[12];
		}

		if (bingos.size() >= 14) {
			user14 = bingos[13];
		}

		if (bingos.size() >= 15) {
			user15 = bingos[14];
		}

		if (bingos.size() >= 16) {
			user16 = bingos[15];
		}

		if (bingos.size() >= 17) {
			user17 = bingos[16];
		}

		if (bingos.size() >= 18) {
			user18 = bingos[17];
		}

		if (bingos.size() >= 19) {
			user19 = bingos[18];
		}

		if (bingos.size() >= 20) {
			user20 = bingos[19];
		}

		if (bingos.size() >= 21) {
			user21 = bingos[20];
		}

		if (bingos.size() >= 22) {
			user22 = bingos[21];
		}

		if (bingos.size() >= 23) {
			user23 = bingos[22];
		}

		if (bingos.size() >= 24) {
			user24 = bingos[23];
		}

		if (bingos.size() >= 25) {
			user25 = bingos[24];
		}
	}

	/**
	 * Take parameter and determine how to render the card
	 * <br>If parameter `p` has any value, will render as pdf.
	 *
	 * @return  `String` Render as pdf (pdf) or on-screen (null)
	 */
	public String getChooseRender() {
		if (ApexPages.currentPage().getParameters().get('p') != null) {
			return 'pdf';
		} else {
			return null;
		}
	}

	/**
	 * Method showAsPDF navigates to the same Visualforce page, but flushes the cache and performs a GET.
	 * <br>It also places the 'p' parameter in the URL, so ChooseRender returns 'pdf' to the page RenderAs attribute.
	 * <br>Note: This also reshuffles the BINGO card, so this does NOT merely display the current BINGO card as a pdf.
	 *
	 * @return  `PageReference` New Page, as PDF
	 */
	public PageReference showAsPDF() {
		PageReference pdfPage = ApexPages.currentPage();
		pdfpage.getParameters().put('p', 'p');
		pdfpage.setRedirect(true);
		return pdfpage;
	}

	/**
	 * Method newCard navigates to the same Visualforce page, but flushes the cache and performs a GET.
	 * <br>It does NOT place any 'p' parameter in the URL, so the new page renders as html.
	 * <br>This effectively reshuffles the BINGO card.
	 *
	 * @return `PageReference` refreshed page
	 */
	public PageReference newCard() {
		PageReference pageRef = Page.BINGO;
		pageRef.setRedirect(true);
		return pageRef;
	}
}