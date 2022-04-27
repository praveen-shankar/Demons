/** Class for logging sObjects 
*	Currently only handles logging of Case sObjects.
*/
public with sharing class ContextLogger {

/**
*	Takes a list of ListItems that contains the sObjects with their corresponding log message.
*	The log action is dependent upon the type of sObject being logged. For Case sObjects a CaseComment is created.
*/
	public static void log(List<LogItem> itemsToLog) {
		List<CaseComment> caseComments = new List<CaseComment>();
		for(LogItem item : itemsToLog) {
			if(item.someObject.getsObjectType() == Case.sObjectType) {
				caseComments.add(new CaseComment(ParentId = item.someObject.Id, CommentBody = item.description));
			}
		}
		if(caseComments.size() > 0) {
			insert caseComments;
		}
	}
	
	
	public class LogItem {
		sObject someObject;
		String description;
		public LogItem(sObject someObject, String description) {
			this.someObject = someObject;
			this.description = description;
		}
	}
}