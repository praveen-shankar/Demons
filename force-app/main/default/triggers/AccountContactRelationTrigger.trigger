trigger AccountContactRelationTrigger on AccountContactRelation (after insert, after update, after delete) {

    if (Trigger.IsInsert && Trigger.IsAfter)//  || (Trigger.IsUpdate && Trigger.IsAfter)
    {
        System.debug('inside trigger');
        AccountContactRelationTriggerHelper.checkContactLevel(Trigger.New);
    }
    
      if (Trigger.IsDelete && Trigger.Isafter)
    {
        System.debug('inside trigger');
        AccountContactRelationTriggerHelper.checkContactLevel(Trigger.old);
    }

}