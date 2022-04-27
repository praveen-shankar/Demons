public class TriggerDispatcher {
	public static Map<ID, Account> accToUpdate = new Map<ID, Account>();
	public static Map<ID, Case> casesToUpdate = new Map<ID, Case>();
	public static Map<ID, Case> casesToDelete = new Map<ID, Case>();
	
	public interface ITriggerEntry
	{
		void MainEntry(String TriggerObject, Boolean IsBefore, Boolean IsDelete, Boolean IsAfter, Boolean IsInsert, Boolean IsUpdate, Boolean IsExecuting, List<SObject> newlist, Map<ID, SObject> newmap, List<SObject> oldlist, Map<ID,SObject> oldmap);
		void InProgressEntry(String TriggerObject, Boolean IsBefore, Boolean IsDelete, Boolean IsAfter, Boolean IsInsert, Boolean IsUpdate, Boolean IsExecuting, List<SObject> newlist, Map<ID, SObject> newmap, List<SObject> oldlist, Map<ID,SObject> oldmap);
	}

	public static ITriggerEntry activefunction = null;
	
	public static void Entry(String TriggerObject, Boolean IsBefore, Boolean IsDelete, Boolean IsAfter, Boolean IsInsert, Boolean IsUpdate, Boolean IsExecuting, List<SObject> newlist, Map<ID, SObject> newmap, List<SObject> oldlist, Map<ID,SObject> oldmap)
	{	
		if(activefunction != null) 
		{
			activefunction.InProgressEntry(TriggerObject, IsBefore, IsDelete, IsAfter, IsInsert, IsUpdate, IsExecuting, newlist, newmap, oldlist, oldmap);
			return;
		}
		
		accToUpdate.clear();
		casesToDelete.clear();
		casesToUpdate.clear();
			
		
		if(TriggerObject == 'Account' && isBefore && IsInsert)
		{
			activefunction = new AccountController.AccountController_Before_Insert();
			activefunction.MainEntry(TriggerObject, IsBefore, IsDelete, IsAfter, IsInsert, IsUpdate, IsExecuting,  newlist, newmap, oldlist, oldmap);

			if(accToUpdate.size()>0) update accToUpdate.values();
			activefunction = null;
		}
		
		if(TriggerObject == 'Account' && isBefore && IsUpdate)
		{
			activefunction = new AccountController.AccountController_Before_Update();
			activefunction.MainEntry(TriggerObject, IsBefore, IsDelete, IsAfter, IsInsert, IsUpdate, IsExecuting,  newlist, newmap, oldlist, oldmap);

			if(accToUpdate.size()>0) update accToUpdate.values();
			activefunction = null;
		}
		
		if(TriggerObject == 'Case' && isBefore && IsInsert) {
			system.debug('Running CaseController_Before_Insert');
			activefunction = new CaseController.CaseController_Before_Insert();
			activefunction.MainEntry(TriggerObject, IsBefore, IsDelete, IsAfter, IsInsert, IsUpdate, IsExecuting,  newlist, newmap, oldlist, oldmap);
			
			CaseController.ResetParameters();
			if(casesToUpdate.size()>0) update casesToUpdate.values();
			activefunction = null;
		}
		
		if(TriggerObject == 'Case' && isBefore && IsUpdate) {
			activefunction = new CaseController.CaseController_Before_Update();
			activefunction.MainEntry(TriggerObject, IsBefore, IsDelete, IsAfter, IsInsert, IsUpdate, IsExecuting,  newlist, newmap, oldlist, oldmap);
			
			CaseController.ResetParameters();
			if(casesToUpdate.size()>0) update casesToUpdate.values();
			activefunction = null;
		}
		
		if(TriggerObject == 'Case' && isAfter && IsInsert) {
			activefunction = new CaseController.CaseController_After_Insert();
			activefunction.MainEntry(TriggerObject, IsBefore, IsDelete, IsAfter, IsInsert, IsUpdate, IsExecuting,  newlist, newmap, oldlist, oldmap);
			
			CaseController.ResetParameters();
			if(casesToUpdate.size()>0) update casesToUpdate.values();
			if(casesToDelete.size()>0) delete casesToDelete.values();			
			activefunction = null;
		}
		
		if(TriggerObject == 'Case' && isAfter && IsUpdate) {
			activefunction = new CaseController.CaseController_After_Update();
			activefunction.MainEntry(TriggerObject, IsBefore, IsDelete, IsAfter, IsInsert, IsUpdate, IsExecuting,  newlist, newmap, oldlist, oldmap);
			
			CaseController.ResetParameters();
			if(casesToUpdate.size()>0) update casesToUpdate.values();
			activefunction = null;
		}
	}
}