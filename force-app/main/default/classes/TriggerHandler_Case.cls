/*
* Method for handeling events in triggers on the Case Object
*/

public with sharing class TriggerHandler_Case {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	
	list<ID> accountsOnCase = new list<ID>();
	list<division_types__c> divisionTypes = new list<division_types__c>();
	
	map<Id, Account> accountlist = new map<Id, Account>();
	
	public TriggerHandler_Case(boolean isExecuting, integer size) {
		m_isExecuting = isExecuting;
		BatchSize = size;
		
		divisionTypes = division_types__c.getAll().values();
	}
}