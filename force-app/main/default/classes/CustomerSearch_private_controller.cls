/*
*	This class is the controller of the CustomerSearch_private.page
*
*	The purpose of this class is to search for private accounts within FOT and KATS
*	
*	Apart from getter and setters for the search parameters and the controller this class have three
*	public methods goDo(), searchBusinessAccount(). It allso have one helper class AccountSearchResult.
*	Both classes are used as wrappers for the combined Caesar and KATS searchresults.
*	
*	searchPrivateAccount() is used for searching for the business accounts. It will
*	search after both local and FOT accounts and collect them in a map that is displayed to the user
*
*	goDo() is used for processing account, contact and the case. goDo() will in many cases be called
*	several times before returning a new page. goDo will in the end return one of two possible pages;
*	the selected account or a case with the selected account (and contact)
*/
public class CustomerSearch_private_controller {

}