@isTest
class CS_MarkReadTest {

static Case c;
  static CS_MarkRead ctrl;
  static User testUser;
 
  
  static testMethod void testmarkread() {
  
    c = new Case();
    List<Case> clist= new List<Case>();
    clist.add(c);
    insert clist;
    ctrl = new CS_MarkRead(new ApexPages.StandardSetController(clist));
    
   
    List<Profile> profiles = [select Id from Profile where name='System Administrator'];
    DateTime timestamp = dateTime.now();
    String appendTimeStamp = timestamp.format('MMddyyyyhhmmss','America/New_York');
    testUser = new User(
      alias='t'+ appendTimeStamp.substring(0,4),
      email='test'+appendTimeStamp+'@posten.capgemini.com.test',
      emailencodingkey='UTF-8', 
          lastname='Testing', languagelocalekey='en_US',
          localesidkey='en_US', 
          profileid = profiles.get(0).Id,
          timezonesidkey='America/Los_Angeles',      
          username='mahoel'+appendTimeStamp+'@posten.capgemini.com.test'
      );
    
    insert testUser;
    
   
    
    ctrl.getselectedCases();
    
    }
    
}