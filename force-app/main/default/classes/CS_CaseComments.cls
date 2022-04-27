public class CS_CaseComments {
    @AuraEnabled
 public static List<CaseComment> getcaseComments(String caseId) {
  List<CaseComment> commentlist= new List<CaseComment>();  
  commentlist =[SELECT Id, parentid,CommentBody,createdby.name,createdDate,IsPublished FROM CaseComment  where parentid =:caseId];
   return commentlist ;
    
    }
    
    @AuraEnabled
    public static String insertcomment(String caseId, String bodytext, Boolean publicvalue){        
        CaseComment c=new CaseComment();
        c.ParentId=caseId;
        c.CommentBody=bodytext;
         if(publicvalue== null)
            c.IsPublished=false;
        else
        c.IsPublished=publicvalue;
        
        System.debug('###ccc'+ c);
        
        try {
            insert c; 
            return 'true';
        }
       
       catch(Exception e)
        {
            return 'false';
        }
            
    }
      @AuraEnabled
    public static String updatecomment(String caseId, String bodytext, Boolean publicvalue){
        
        //CaseComment c=new CaseComment();
       // c=[SELECT Id, parentid,CommentBody,createdby.name,createdDate,IsPublished FROM CaseComment  where Id =:caseId];
       // c.CommentBody=bodytext;
       // c.IsPublished=publicvalue;
        try
        {
            CaseComment c=new CaseComment();
            c.Id=caseId;
            // c=[SELECT Id, parentid,CommentBody,createdby.name,createdDate,IsPublished FROM CaseComment  where Id =:caseId];
       system.debug('cc id'+c.Id);
            c.CommentBody=bodytext;
        c.IsPublished=publicvalue;
       
            update c;
            return 'true';
        }
       catch(QueryException qe) 
       {
            return 'false';
       }
       
            
    }
    
        
    @AuraEnabled
    public static Boolean deleterecord(String caseId) {
        List<CaseComment> delList = new List<CaseComment>();
        delList=[Select Id from CaseComment where Id =:caseId];
        if(delList.size()>0)
        {
           delete delList;
            return true;
            
        }
        else
            return false;
        
    }
      @AuraEnabled
 public static CaseComment loadCasecommentDetails(String casecommentId) {
    CaseComment casecommentdetail = new CaseComment();
  try {
                        casecommentdetail = [SELECT Id, parentid,CommentBody,createdby.name,createdDate,IsPublished FROM CaseComment  where Id =:casecommentId];
                     
                } catch(QueryException qe) {
                        //<!--CSphase2, Akash, 20122016-->
                        //ExceptionController.handleException(true, true, qe, 'Det ligger en feil i forbindelse med spørringen som gjøres i kontrolleren til OEBS_ReleaseOrderPageController', 'Kan ikke finne sak eller saken passer ikke kriteriene for å frigis.');
                        
                }
                
                system.debug('###casecommentdetail ' + casecommentdetail );
                
                return casecommentdetail ;
                
               }
     @AuraEnabled(cacheable=true)
 public static Case loadCaseDetails(String caseId) {
    Case casedetail = new Case();
  try {
                        casedetail = [SELECT Id, subject,description FROM Case where Id =:caseId];
                     
                } catch(QueryException qe) {
                        //<!--CSphase2, Akash, 20122016-->
                        //ExceptionController.handleException(true, true, qe, 'Det ligger en feil i forbindelse med spørringen som gjøres i kontrolleren til OEBS_ReleaseOrderPageController', 'Kan ikke finne sak eller saken passer ikke kriteriene for å frigis.');
                        
                }
                
               // system.debug('###casecommentdetail ' + casecommentdetail );
                
                return casedetail ;
                
               }
    
  }