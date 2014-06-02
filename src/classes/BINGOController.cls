/**
    BingoController controls the BINGO page and both BINGO components.

    @author David Schach

    Dev Team Chris Shackelford
            Brad Gross

    @version     2.1 2011-02-18

*/

global with sharing class BINGOController {

    private id myid;
    public List<User> bingos {get; private set;}
    private List<User> allusers;
    private Set<Id> userids;
    public User me {get; set;}
    public User user1 {get; set;}
    public User user2 {get; set;}
    public User user3 {get; set;}
    public User user4 {get; set;}
    public User user5 {get; set;}
    public User user6 {get; set;}
    public User user7 {get; set;}
    public User user8 {get; set;}
    public User user9 {get; set;}
    public User user10 {get; set;}
    public User user11 {get; set;}
    public User user12 {get; set;}
    public User user13 {get; set;}
    public User user14 {get; set;}
    public User user15 {get; set;}
    public User user16 {get; set;}
    public User user17 {get; set;}
    public User user18 {get; set;}
    public User user19 {get; set;}
    public User user20 {get; set;}
    public User user21 {get; set;}
    public User user22 {get; set;}
    public User user23 {get; set;}
    public User user24 {get; set;}
    public User user25 {get; set;}
    
    //public List<User> bingousers {get; set;}
    
    private static final Integer totalsquares = 25;
    
    private static final Integer querylimit = 10000;
    
    /**
        The constructor for BingoController
    */
    
    public BingoController() {
        myid = UserInfo.getUserId();
        userids = new Set<Id>();
        
        // Users Following Me
        for (EntitySubscription es : [select Id, ParentId, SubscriberId  from EntitySubscription WHERE ParentId = :myid LIMIT :querylimit]) {
            userids.add(es.SubscriberId);
        }
        
        // Users I'm Following
        for (EntitySubscription es : [select Id, SubscriberId, ParentId  from EntitySubscription WHERE SubscriberId = :myid LIMIT :querylimit]) {
            if (('' + es.parentid).substring(0, 3) == '005') // users only
                userids.add(es.ParentId);
        }
        
        allusers = [SELECT id, smallphotourl, FullPhotoUrl, name FROM User where Id IN :userids AND IsActive = TRUE ];
        Set<Integer> usedindices = new Set<Integer>();
        bingos = new List<User>();
        
        while (usedindices.size() < allusers.size()) {
            Integer index =  math.round(Math.random() * (allusers.size() - 1));
            
            //system.debug('INDEX VALUE: ' + index);
            if (!usedindices.contains(index)) {
                usedindices.add(index);
                bingos.add(allusers[index]);
                
                if (usedindices.size() > totalsquares) { break; } // Break WHILE loop
            }
        }
        
        me = [SELECT id, smallphotourl, FullPhotoUrl, name FROM User where Id = :myid   ];
        
        if (bingos.size() >= 1) {user1 = bingos[0];}
        
        if (bingos.size() >= 2) {user2 = bingos[1];}
        
        if (bingos.size() >= 3) {user3 = bingos[2];}
        
        if (bingos.size() >= 4) {user4 = bingos[3];}
        
        if (bingos.size() >= 5) {user5 = bingos[4];}
        
        if (bingos.size() >= 6) {user6 = bingos[5];}
        
        if (bingos.size() >= 7) {user7 = bingos[6];}
        
        if (bingos.size() >= 8) {user8 = bingos[7];}
        
        if (bingos.size() >= 9) {user9 = bingos[8];}
        
        if (bingos.size() >= 10) {user10 = bingos[9];}
        
        if (bingos.size() >= 11) {user11 = bingos[10];}
        
        if (bingos.size() >= 12) {user12 = bingos[11];}
        
        if (bingos.size() >= 13) {user13 = bingos[12];}
        
        if (bingos.size() >= 14) {user14 = bingos[13];}
        
        if (bingos.size() >= 15) {user15 = bingos[14];}
        
        if (bingos.size() >= 16) {user16 = bingos[15];}
        
        if (bingos.size() >= 17) {user17 = bingos[16];}
        
        if (bingos.size() >= 18) {user18 = bingos[17];}
        
        if (bingos.size() >= 19) {user19 = bingos[18];}
        
        if (bingos.size() >= 20) {user20 = bingos[19];}
        
        if (bingos.size() >= 21) {user21 = bingos[20];}
        
        if (bingos.size() >= 22) {user22 = bingos[21];}
        
        if (bingos.size() >= 23) {user23 = bingos[22];}
        
        if (bingos.size() >= 24) {user24 = bingos[23];}
        
        if (bingos.size() >= 25) {user25 = bingos[24];}
    }
    
    /**
        Method getChooseRender
    
        @return String
    */
    
    public String getChooseRender() {
        if (ApexPages.currentPage().getParameters().get('p') != null) return 'pdf';
        else return null;
    }
    
    /**
        Method showAsPDF navigates to the same Visualforce page, but flushes the cache and
        performs a GET.  It also places the 'p' parameter in the URL, so ChooseRender
        returns 'pdf' to the page RenderAs attribute.
        Note: This also reshuffles the BINGO card, so this does NOT merely display the current
        BINGO card as a pdf.
    
        @return PageReference
    */
    
    public PageReference showAsPDF() {
        PageReference pdfPage =  ApexPages.currentPage();
        pdfpage.getParameters().put('p', 'p');
        pdfpage.setRedirect(true);
        return pdfpage;
    }
    
    /**
        Method NewCard navigates to the same Visualforce page, but flushes the cache and
        performs a GET.  It does NOT place any 'p' parameter in the URL, so the new page
        renders as html.  This effectively reshuffles the BINGO card.
    
        @return PageReference
    */
    
    public PageReference NewCard() {
        PageReference pageRef = Page.BINGO;
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /**
        Method deprecated, now that renderAs is included in Page.BINGO.
    */
    /*
        public PageReference MakePDF(){
        PageReference pageRef = Page.BINGO_PDF;
        pageRef.setRedirect(false);
        return pageRef;
        }
    */
    
}