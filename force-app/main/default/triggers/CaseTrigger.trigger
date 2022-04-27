trigger CaseTrigger on Case (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	if(system.isBatch() == false){
		TriggerDispatcher.Entry('Case', trigger.IsBefore, trigger.IsDelete, trigger.isAfter,
									trigger.IsInsert, trigger.IsUpdate, trigger.IsExecuting, 
									trigger.new, trigger.newmap, trigger.old, trigger.oldmap);
	}
	
}