public class Case_PIB_Message_Controller
{
public List<SelectOption> paginationSizeOptions{get;set;}
public List<SelectOption> Category{ get; set;}
public String selectedCategory{ get; set;} 
public String postalUnit{get;set;}
public String postalUnitName{get;set;}
public list <cs_case_pib_messages__c> pibMessageslist{get;set;}
public cs_case_pib_messages__c  pibmessage{get;set;}
public list <cs_case_pib_messages__c> childPibmessages{get;set;} 
public boolean messagedetailflag{get;set;}
public boolean childmessageflag{get;set;}
public Integer size{get;set;} 
public Integer noOfRecords{get; set;} 
public String inputTextMessage{get;set;}
public boolean showRecords{get;set;}
public cs_case_pib_messages__c postChildPIBmessage{get;set;}
public ApexPages.StandardSetController con{get; set;} 
public integer Countofnew{get; set;}
private Id pibid;
public boolean showerror{get;set;}
public boolean statusShowerror{get;set;}

public Case_PIB_Message_Controller(ApexPages.StandardController controller)
{
messagedetailflag=false;
childmessageflag =false;
showerror=false;
postalUnit=Apexpages.currentpage().getparameters().get('postalUnit');
size=10;
inputTextMessage=null;
selectedCategory= 'None';
statusShowerror = false;

   if(postalUnit!=null)
  {
   PostalUnit__c p = [Select id,Name from PostalUnit__c where unit_number__c=:postalUnit Limit 1];
   if(p !=null)
   {
   postalUnitName = 'PIB Meldinger : ' + p.Name;
   
   pibMessageslist = [Select id,cs_description__c,cs_related_postal_unit__c,cs_subject__c,category__c,parent_Case_PIB_Message__c,CreatedBy.Name,CreatedDate from cs_case_pib_messages__c where Postal_Unit_Number__c =: postalUnit and parent_Case_PIB_Message__c=null];
   String status ='New';
   Countofnew= database.countQuery ('SELECT count() FROM cs_case_pib_messages__c WHERE category__c =: status and Postal_Unit_Number__c =: postalUnit and parent_Case_PIB_Message__c=null ' );
    
    if(pibMessageslist!=null && pibMessageslist.size()>0)
    {
      showRecords  = true;
     }

    else
    {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.warning,'Postenheten har ingen PIB-meldinger'));
    }
    
    }

  }

  else
  {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'No Postal unit selected'));
  }
  
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('5','5'));
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('50','50'));
       

}


public PageReference querypibDetails()
{
  try
  {
    pibid =System.currentPageReference().getParameters().get('pibid');
    System.debug ('@@pib'+pibid);
    

    pibmessage=[Select cs_description__c,cs_subject__c,cs_pib_case__c,category__c,CreatedBy.Name,CreatedDate,parent_Case_PIB_Message__c from cs_case_pib_messages__c where id=:pibid Limit 1];

    if(pibmessage!=null)
    {
      childPibmessages = [Select cs_description__c,cs_subject__c,cs_pib_case__c,parent_Case_PIB_Message__c,category__c,CreatedBy.Name,CreatedDate from cs_case_pib_messages__c where parent_Case_PIB_Message__c=:pibid order by createdDate  desc];
      messagedetailflag = true;
      
      this.Category= new List<SelectOption>();
      Category.add(new SelectOption('None','None'));
      Category.add(new SelectOption('Done','Utført'));
      Category.add(new SelectOption('Not Found','Ikke funnet'));
      selectedCategory='None';
      
      if(childPibmessages!=null)
      childmessageflag =true;
      inputTextMessage =null;
      
    }

  }

  Catch(Exception e)
  {
  // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.warning,'I am here2'));
  }

return null; 


}

public void closepib()
{ 
 messagedetailflag = false;
 childmessageflag =false;   
    
 
  
}

Public void countNewMessages(){

String status ='New';
Countofnew= database.countQuery ('SELECT count() FROM cs_case_pib_messages__c WHERE category__c =: status and Postal_Unit_Number__c =: postalUnit and parent_Case_PIB_Message__c=null ' );

}

public void savepib()
{
  try
  {   
  if(selectedCategory!='None')
  {
  
  if(inputTextMessage!=null || inputTextMessage!='')
  createChildPIB();
  
  pibmessage.category__c=selectedCategory;
  
  update pibmessage;
  inputTextMessage = null;
  }
 
  else
  {
  showerror = true;
   // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.warning,'Please select Category'));
  }
  
  }
  
  catch(Exception e)
  {
  }
  
}


public void createChildPIB()
{

try{

if(inputTextMessage!=null || inputTextMessage!='')
{
postChildPIBmessage=new cs_case_pib_messages__c();
postChildPIBmessage.cs_subject__c =pibmessage.cs_subject__c; 
postChildPIBmessage.cs_description__c =inputTextMessage;
postChildPIBmessage.parent_Case_PIB_Message__c =pibmessage.parent_Case_PIB_Message__c; 
postChildPIBmessage.parent_Case_PIB_Message__c=pibmessage.id;
postChildPIBmessage.cs_pib_case__c=pibmessage.cs_pib_case__c;
if(selectedCategory!='None')
postChildPIBmessage.category__c=selectedCategory;

insert postChildPIBmessage;

childPibmessages = [Select cs_description__c,cs_subject__c,cs_pib_case__c,parent_Case_PIB_Message__c,category__c,CreatedBy.Name,CreatedDate from cs_case_pib_messages__c where parent_Case_PIB_Message__c=:pibid order by createdDate  desc];
messagedetailflag = true;
      
      
for(cs_case_pib_messages__c pibc:childPibmessages)
{
pibc.category__c=selectedCategory;
}    

//update childPibmessages;  
      
if(childPibmessages!=null)
childmessageflag =true;
inputTextMessage=null;
showerror=false;

ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Message Posted Successfully'));

}

else{
showerror=true;
}

}

Catch(Exception e)
{

ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.warning,'An error occured' + e));
}



}



 public ApexPages.StandardSetController setCon {
       get {   
         if(setCon == null) {
         string searchquery ='Select id,cs_description__c,cs_related_postal_unit__c,cs_subject__c,category__c,CreatedBy.Name,CreatedDate from cs_case_pib_messages__c ';  
  
                if(postalUnit!=null)   
                searchquery =searchquery +' where Postal_Unit_Number__c=:postalUnit and parent_Case_PIB_Message__c=null order by createdDate  desc';
                
         
               System.debug('@@query in load' +searchquery );
               setCon = new ApexPages.StandardSetController(Database.getQueryLocator(searchquery));
               setCon.setPageSize(size);  
               noOfRecords = setCon.getResultSize();
            }     
                  
            return setCon;
        }
        set;
    }
    


    public Boolean hasNext  
    {  
        get  
        {  
            return con.getHasNext();  
        }  
        set;  
    }  
    public Boolean hasPrevious  
    {  
        get  
        {  
            return con.getHasPrevious();  
        }  
        set;  
    }  
    public Integer pageNumber  
    {  
        get  
        {  
            return con.getPageNumber();  
        }  
        set;  
    }  
    public void previous()  
    {  
        con.previous();  
    }  
    public void next()  
    {  
        con.next();  
    }  
    
     
    
     public List<cs_case_pib_messages__c> getpibDetail() {
        return (List<cs_case_pib_messages__c>) setCon.getRecords();

    }
    
    public PageReference refreshPageSize() {
         setCon.setPageSize(size);
         refresh();
         return null;
    }
    
     public pageReference refresh() {
        setCon = null;
        setCon.setPageNumber(1);
        noOfRecords = setCon.getResultSize();
        return null;
    }


    

}