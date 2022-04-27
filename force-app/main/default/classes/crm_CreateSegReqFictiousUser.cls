public class crm_CreateSegReqFictiousUser {
 @AuraEnabled
 public static List < crm_segment__c > getSegments(String acctId) {

  Set < String > sg = new set < String > ();
  Schema.DescribeFieldResult fieldResult = Opportunity.crm_Opp_Service_Group__c.getDescribe();
  List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
  for (Schema.PicklistEntry f: ple) {
   //options.put(f.getLabel(), f.getValue());
   sg.add(f.getValue());
  }

  Set < String > status = new Set < String > {
   'Completed',
   'Rejected',
   'Cancelled'
  };
  List < Segment_Change_Request__c > reqList = [Select id, Service_Group__c from Segment_Change_Request__c where Customer__c =: acctId and status__c not in: status];
  System.debug('###reqList' + reqList);

  for (Segment_Change_Request__c req: reqList) {
   if (sg.contains(req.Service_Group__c))
    sg.remove(req.Service_Group__c);

  }
  System.debug('###sg' + sg);

  List < crm_segment__c > segmentList = new List < crm_segment__c > ();
  segmentList = [Select id, crm_Service_Group__c, crm_Sales_Responsible__r.name, crm_Sales_Responsible__r.ManagerId from crm_segment__c where crm_account__c =: acctId and crm_Service_Group__c in: sg];
  System.debug('###segmentList ' + segmentList);
  return segmentList;
 }

 @AuraEnabled
 public static List < crm_segment__c > getSegmentList(String segId) {

  List < crm_segment__c > segmentList = new List < crm_segment__c > ();
  segmentList = [Select id, crm_Service_Group__c, crm_Sales_Responsible__r.name, crm_Sales_Responsible__c, crm_Sales_Responsible__r.ManagerId from crm_segment__c where Id =: segId];
  System.debug('###segmentList' + segmentList);
  return segmentList;
 }



 @AuraEnabled
 public static Map < String, String > getmonth() {
  Map < String, string > monthMap = new Map < String, string > ();
  String months = System.Label.Months;
  List < String > monthList = new List < String > ();

  if (months != null)
   monthList = months.split(';');

  Integer monNum = 1;
  for (String mon: monthList) {
   MonthMap.put(String.valueof(monNum), mon);
   ++monNum;
  }

  system.debug('MonthMap' + MonthMap);
  return monthMap;

 }
 @AuraEnabled
 public static Map < String, String > getyear() {
  Map < String, String > yearMap = new Map < String, String > ();

  yearMap.put(String.valueOf(Date.Today().Year()), String.valueOf(Date.Today().Year()));
  yearMap.put(String.valueOf(Date.Today().addyears(1).Year()), String.valueOf(Date.Today().addyears(1).Year()));
  System.debug(yearMap);
  return yearMap;
 }
 
 @AuraEnabled
 public static Map < String, String > getresponsibleseller() {
  Map < String, String > userMap = new Map < String, String > ();
  Map < String, String > fictioususerMap = new Map < String, String > ();
  CRM_ficticous_user__mdt[] userslist= [SELECT Id, DeveloperName, MasterLabel, username__c FROM CRM_ficticous_user__mdt order by username__c asc];
  
  Set<String> usernames=  new Set<String>();
  for(CRM_ficticous_user__mdt u : userslist ){
      usernames.add(u.username__c);
      userMap.put(u.username__c, u.MasterLabel);  
  }
  System.debug(usernames);
  
  List<User> users= [Select id, username from  user where username in  : usernames];                                                          
                                                              
  for(User u  : users){
      fictioususerMap.put(u.id,userMap.get(u.username));
  }
  

  System.debug(fictioususerMap);
  return fictioususerMap;
 }
    
     @AuraEnabled
 public static List < String > savesegment(String json) {
  System.debug('&&&&json' + json);
  SegmentWrapper wrapper = SegmentWrapper.parse(json);

  List < Segment_Change_Request__c > segChangereqList = new List < Segment_Change_Request__c > ();
  Segment_Change_Request__c segmentchangereq = new Segment_Change_Request__c();
  if (String.isNotBlank(wrapper.accountId))
   segmentchangereq.Customer__c = wrapper.accountId;

  Set < String > sg = new Set < String > ();

  for (Integer i = 0; i < wrapper.reqchangesegments.size(); i++) {

   //if proposedresponsible seller!=null 
   if (String.isNotBlank(wrapper.reqchangesegments[i].serviceGroupvalue))
    sg.add(wrapper.reqchangesegments[i].serviceGroupvalue);


  }
  Set < String > sgSet = new Set < String > ();
  List < String > errorLogs = new List < String > ();

  Set < String > status = new Set < String > {
   'Initiated',
   'Submitted',
   'Approved',
   'Partially Approved'
  };
  List < Segment_Change_Request__c > reqList = [Select id, Service_Group__c from Segment_Change_Request__c where Customer__c =: wrapper.accountId and Service_Group__c in: sg and status__c in: status];
  System.debug('###reqList' + reqList);
  if (reqList.size() > 0) {
   //duplicate records
   for (Segment_Change_Request__c req: reqList) {
    sgSet.add(req.Service_Group__c);

   }
  }
  System.debug('###sgSet' + sgSet);

  for (Integer i = 0; i < wrapper.reqchangesegments.size(); i++) {
   if (String.valueof(wrapper.reqchangesegments[i].proposedresponsibleseller)!='None') {
    System.debug('###wrapper.reqchangesegments[i]' + wrapper.reqchangesegments[i]);

    if (String.isNotBlank(wrapper.reqchangesegments[i].serviceGroupvalue)) {
     if (!sgSet.contains(wrapper.reqchangesegments[i].serviceGroupvalue)) {
      Segment_Change_Request__c segaddobj = new Segment_Change_Request__c();

      segaddobj.Customer__c = wrapper.accountId;

      segaddobj.Service_Group__c = wrapper.reqchangesegments[i].serviceGroupvalue;


      if (String.isNotBlank(wrapper.reqchangesegments[i].proposedresponsibleseller))
       segaddobj.Proposed_Sales_Responsible__c = wrapper.reqchangesegments[i].proposedresponsibleseller;

      if (String.isNotBlank(wrapper.reqchangesegments[i].proposedresponsibleSellermanager))
       segaddobj.Proposed_Sales_Responsible_Manager__c = wrapper.reqchangesegments[i].proposedresponsibleSellermanager;

      if (String.isNotBlank(wrapper.reqchangesegments[i].responsibleseller))
       segaddobj.Current_Sales_Responsible__c = wrapper.reqchangesegments[i].responsibleseller;

      if (String.isNotBlank(wrapper.reqchangesegments[i].responsiblesellermanager))
       segaddobj.Current_Sales_Responsible_Manager__c = wrapper.reqchangesegments[i].responsiblesellermanager;



      if (String.isNotBlank(wrapper.reqchangesegments[i].month))
       segaddobj.Month__c = wrapper.reqchangesegments[i].month;

      if (String.isNotBlank(wrapper.reqchangesegments[i].reasonofchange))
       segaddobj.Reason_for_Change__c = wrapper.reqchangesegments[i].reasonofchange;

      /*if(String.isNotBlank(wrapper.reqchangesegments[i].year)) 
          segaddobj.Year__c=wrapper.reqchangesegments[i].year;*/

      segaddobj.Year__c = String.valueof(System.today().year());
      segaddobj.Change_Requester__c = UserInfo.getUserId();
      segaddobj.Start_Date__c = date.newInstance(System.today().year(), Integer.valueOf(wrapper.reqchangesegments[i].month), 1);
      segaddobj.Date_Requested_On__c = System.today();
      segaddobj.Ownerid = UserInfo.getUserId();


      System.debug('###segaddobj' + segaddobj);
      segChangereqList.add(segaddobj);

     } else {
      //add error message to a set and display it   
      //
      system.debug('##' + wrapper.reqchangesegments[i].serviceGroupvalue);

      errorLogs.add(wrapper.reqchangesegments[i].serviceGroupvalue);
      system.debug('errorLogs' + errorLogs);
      //wrapper.reqchangesegments[i].serviceGroupvalue)

     }

    } //end o chheck service grp

   } //end o check proposed responsible seller
  }
  if (segChangereqList.size() > 0)
   insert segChangereqList;

  return errorLogs;
 }



 @AuraEnabled
 public static String getproposedmanagerId(String proposedresponsibleSellerID) {
     system.debug('Inside getproposedresponsiblemanagerId');
     String  proposedresponsiblemanagerID='';
     List<User> userList = [Select  id , managerId from User where id=: proposedresponsibleSellerID];
      if (userList.size()>0 && userList[0].managerId!=null)
          proposedresponsiblemanagerID= userList[0].managerId;
          System.debug('proposedresponsiblemanagerID' + proposedresponsiblemanagerID + proposedresponsibleSellerID);
           return proposedresponsiblemanagerID;
 
 }

 



}