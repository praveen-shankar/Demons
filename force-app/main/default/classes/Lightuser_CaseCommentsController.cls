public with sharing class Lightuser_CaseCommentsController {
    
    public String commentBody { get; set; }
    public String sender { get; set; }
    public String buttonText { get; set; }
    public Id caseId {get; set;}
    
    public Lightuser_CaseCommentsController() {
        caseId = ApexPages.currentPage().getParameters().get('id');
        String status = '';
        buttonText = System.Label.cs_CaseComnt;
        try {
            status = [SELECT status FROM Case WHERE ID = :caseId LIMIT 1 ].status;
        } catch(QueryException e) {
            buttonText = System.Label.cs_CaseComnt;
        }
        if(status.contains('Avsluttet')) {//api name
        //CSphase2 supriya 26122016
        //if(status.contains('Closed')) {
            //201206 - aolsen, changed text on button
            buttonText = System.Label.cs_case_comment;
        }
    }
    
    public cComments[] comments{
        get{
            caseId = ApexPages.currentPage().getParameters().get('id');
            List<cComments> comments = new List<cComments>();
            for(CaseComment comment : [Select LastModifiedDate, LastModifiedBy.Id, LastModifiedBy.Name, IsPublished, CreatedDate, CreatedBy.Id, CreatedBy.Name, CommentBody From CaseComment c where ParentId = :caseId order by c.LastModifiedDate desc])
            {
                cComments tempcComment = new cComments();
                tempcComment.cComment = comment;
                
                // Build String to display.
                tempcComment.commentText = '<b>Opprettet av: ' + comment.CreatedBy.Name + ' (' + comment.CreatedDate.format() + ') &nbsp&nbsp | &nbsp&nbsp ';
                tempcComment.commentText += 'Sist endret av: ' +  comment.LastModifiedBy.Name + ' (' + comment.LastModifiedDate.format() + ')</b><br>';
                //CSphase2 supriya 26122016
                tempcComment.commentText = '<b>' + System.Label.cs_created_by +': ' + comment.CreatedBy.Name + ' (' + comment.CreatedDate.format() + ') &nbsp&nbsp | &nbsp&nbsp ';
                tempcComment.commentText += System.Label.cs_last_edited_by +': ' +  comment.LastModifiedBy.Name + ' (' + comment.LastModifiedDate.format() + ')</b><br>';
               
                tempcComment.commentText += comment.CommentBody;
               /* 
                if(comment.IsPublished)
                    tempcComment.PublicPrivateAction = 'Make Private';
                else
                    tempcComment.PublicPrivateAction = 'Make Public';
                    */
                //Add to list
                comments.add(tempcComment); 
            }
            return comments;
        }
        
        set;
    }
    
    private boolean insertComment(Id caseId) {
        try {
            CaseComment caseComment = new CaseComment();
            
            Case c = [SELECT c.id, c.Status FROM Case c WHERE c.Id =:caseId LIMIT 1];
           if(c.Status.contains('Avsluttet')){//api name
           //Csphase2 supriya 26122016
           //if(c.Status.contains('Closed')){
                //commentBody = 'Forespørsel om gjenåpning av sak: ' + commentBody;
                //Csphase2 supriya 26122016
                commentBody = System.Label.cs_Request_for_reopening+': ' + commentBody;
                //
            }
            caseComment.CommentBody = commentBody + '\n -' + sender;
            caseComment.ParentId = caseId;
        
            insert caseComment;
            
        } catch(QueryException e) {
            return false;
        } catch(DMLException e) {
            return false;
        }
        return true;
    }
        
    public PageReference NewComment()
    {
        caseId = ApexPages.currentPage().getParameters().get('id');
        if(insertComment(caseId)) {
           
           PageReference ref=new PageReference('/Lightuser_CaseDetailView?id=' + caseId);
           ref.setRedirect(true);
           return ref;
           // return new PageReference('/Lightuser_searchCase?id=' + caseId);
        }
        return null;
    }

    public class cComments {
    
        public CaseComment cComment {get; set;}
        public String commentText {get; set;}
        //public String PublicPrivateAction {get; set;}
    }
}