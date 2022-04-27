trigger CaseAttachmentPresent on Attachment (after insert,after delete,after undelete, before insert) 
{
Set<Id> caseIds = new Set<Id>();
   
if(trigger.isInsert || trigger.isundelete)
{
  for(Attachment att : trigger.New)
  {    
    //Check if added attachment is related to case,if yes add the caseId in the set.
    if(att.ParentId.getSobjectType() == Case.SobjectType)
    {
      caseIds.add(att.ParentId);
    }
  }

    if(caseIds!=null && caseIds.size()>0)
    CaseAttachmentPresentHelper.updateCaseWhichHasAttach(caseIds);
    
}

if(trigger.isInsert && trigger.isBefore)
{
    String userName=[select id,Name from user where id=:UserInfo.getUserId() limit 1 ].Name;
  System.debug('##'+  trigger.New);
    System.debug('## userName'+  userName);
  List<attachment> toupdateList = new List<Attachment>();
  for(Attachment att : trigger.New){  
  
   System.debug('##'+  att.ParentId  + att.ParentId.getSobjectType() + att.createdby.Name + att.createdbyId);
    //Check if added attachment is related to case
      if(att.ParentId.getSobjectType() == Case.SobjectType){ 
      /* if(userName == 'Mybring' || userName == 'Konsernportalen1')
               att.IsPrivate = false;
           else
                att.IsPrivate = true; */
    }
      
   //att.IsPrivate = false; 
    
  }
      
}

//Add atttachment description if not created by myBring.

If(Trigger.isInsert && Trigger.isAfter){
	List<Id> attId = New List<Id>();
    for(Attachment att : Trigger.New){
        attId.add(att.Id);
    }
    CaseAttachmentPresentHelper.addAttachmentDescription(attId);
        
}
    
if(trigger.isDelete)
{   
//Here we are checking the older instance because after delete the Attachment parentid will be null.
  for(Attachment att : trigger.old)
  { 
     //Check if added attachment is related to case,if yes add the CaseId it in the set
    if(att.ParentId.getSobjectType() == Case.SobjectType)
    {
    caseIds.add(att.ParentId);
    }
  }
   
    
}

}