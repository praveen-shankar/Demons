/*
*	This class is the controller of the CustomerSearch_business.page
*
*	The purpose of this class is to search for business accounts within Caeasar and KATS
*	
*	Apart from getter and setters for the search parameters and the controller this class have three
*	public methods goDo(), searchBusinessAccount(), createNewContact(). It allso have two helperclasses
*	AccountSearchResult and ContactSearchResult. Both classes are used as wrappers for the combined Caesar
*	and KATS searchresults
*	
*	searchBusinessAccount() is used for searching for the business accounts. It will
*	search after both local and Caesar accounts and collect them in a map that is displayed to the user
*
*	createNewContact() is used when the user wants to create a new contact to add to the case
*
*	goDo() is used for processing account, contact and the case. goDo() will in many cases be called
*	several times before returning a new page. goDo will in the end return one of two possible pages;
*	the selected account or a case with the selected account (and contact)
*/

public class CustomerSearch_business_controller {

}