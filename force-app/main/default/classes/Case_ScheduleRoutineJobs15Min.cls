global class Case_ScheduleRoutineJobs15Min implements Schedulable
{
    static final String APEX_JOB_NAME = 'Case_Scheduled_Job';

    global void execute(SchedulableContext sc)
    {
        Case_ScheduleRoutineJobs15Min.OEBS_OrderRelease();
        Case_ScheduleRoutineJobs15Min.AutoCloseCases();
    }
    
    // This function will start the 15 min scheduler
    static public void startOrderReleaseScheduler_15min() 
    {
        String CRON1 = '0 0 * * * ?';
        String CRON2 = '0 15 * * * ?';
        String CRON3 = '0 30 * * * ?';
        String CRON4 = '0 45 * * * ?';
        Case_ScheduleRoutineJobs15Min.startOrderReleaseScheduler(1, CRON1);
        Case_ScheduleRoutineJobs15Min.startOrderReleaseScheduler(2, CRON2);
        Case_ScheduleRoutineJobs15Min.startOrderReleaseScheduler(3, CRON3);
        Case_ScheduleRoutineJobs15Min.startOrderReleaseScheduler(4, CRON4);
    }
    
    // This function creates a new job based on the function parameters passed
    static public void startOrderReleaseScheduler(Integer jobNumber, String cron)
    {
        System.schedule('Case_Scheduled_Job_' + jobNumber ,cron, new Case_ScheduleRoutineJobs15Min());
    }


    // This function will check for OEBS Cases which did not send the Release Order successfully and try sending it again
    static private void OEBS_OrderRelease()
    {
        List<Case> caseToBeReleasedList = new List<Case>();

        caseToBeReleasedList = [SELECT id 
                                  FROM Case 
                                 WHERE Origin = 'OEBS'
                                   AND recordTypeId = :KATSutilities.getRecordType('deviation_case')
                                   AND OEBS_Order_Status__c = 'Release failed' LIMIT 100];
        
        list<Id> caseIdToBeReleasedList = new list<id>();
        
        for(Case caseToBeReleased : caseToBeReleasedList)
        {
            caseIdToBeReleasedList.add(caseToBeReleased.id);
            
            if(caseIdToBeReleasedList.size() == 10)
            {
                OEBS_OrderController.releaseOrderListNotifyOwnerFuture(caseIdToBeReleasedList);
                caseIdToBeReleasedList.clear();
            }
        }
        if(caseIdToBeReleasedList.size() > 0)
        OEBS_OrderController.releaseOrderListNotifyOwnerFuture(caseIdToBeReleasedList);
    }

    // This function will check for all Cases which should be closed automatically and closes it
    static private void AutoCloseCases()
    {
        List<Case> casesToBeClosed = new List<Case>();
        Map<Id,QueueDetails__c> autoCloseQueues = new Map<Id,QueueDetails__c>();

        environment_settings__c autoCloseLim = environment_settings__c.getInstance('auto_close_limit');
        String lim = '10';

        if(autoCloseLim != null)
        {
            lim = autoCloseLim.value__c;
        }
/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        String qry = 'SELECT Id, CaseNumber, OwnerId, Subject, Description, Code_Event__c, Category__c, Produkt__c, Service_Product__c, Code_Reason1__c, reason__c, Code_Reason2__c, To_be_Closed__c FROM Case WHERE To_be_Closed__c = true AND isClosed = false LIMIT ' + lim;

        casesToBeClosed = Database.query(qry);

        if(casesToBeClosed.size() > 0)
        {
            // Create a Queue Details map
            /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
            for(QueueDetails__c qd: [SELECT Id, 
                                            OwnerId,
                                            Auto_Close_Case__c,
                                            Code_Event__c,
                                            Code_Event__r.Name,
                                            Product__c,
                                            Product__r.Name,
                                            Service_Product__c,
                                            Service_Product__r.Name,
                                            Code_Reason1__c,
                                            Code_Reason1__r.Name,
                                            Code_Reason2__c,
                                            Code_Reason2__r.Name
                                       FROM QueueDetails__c])
            {
                autoCloseQueues.put(qd.OwnerId,qd);
            }

            try
            {
                for(Case c: casesToBeClosed)
                {
                    // We will set the defaults and close the case IF:
                    // - There is a QueueDetails__c setup
                    // - The Henvendelsestype details is missing information which is mandatory before closing
                    if(autoCloseQueues.containsKey(c.OwnerId))
                    {
                        QueueDetails__c qd = new QueueDetails__c();
                        qd = autoCloseQueues.get(c.OwnerId);

                         c.Status = 'Avsluttet';
                        //CSPhase2 Supriya 22122016
                        //c.Status='Closed';
                        
                        
                        c.To_be_Closed__c = false;
                       /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */ 
                        if(c.Code_Event__c == null || c.Service_Product__c == null || c.Code_Reason1__c == null)
                        {
                            // Setting Henvendelsestype
                            c.Code_Event__c = qd.Code_Event__c;
                            c.Category__c = qd.Code_Event__r.Name;
                            // Setting Product
                            c.Service_Product__c = qd.Service_Product__c; /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
                            c.Produkt__c = qd.Service_Product__r.Name;
                            // Setting Arsak1 (Reason 1)
                            c.Code_Reason1__c = qd.Code_Reason1__c;
                            c.reason__c = qd.Code_Reason1__r.Name;
                            // Setting Arsak2 (Reason 2)
                            c.Code_Reason2__c = qd.Code_Reason2__c;
                        }
                        
                        if(String.isBlank(c.Subject))
                        {
                            // c.Subject = 'No Subject - Case Auto Closed';
                           //CSphase2 Supriya 22122016
                           c.Subject = System.Label.cs_No_Subject_Case_Auto_Closed;
                        }

                        if(String.isBlank(c.Description))
                        {
                            //c.Description = 'No Description';
                            //CSphase2 Supriya 22122016
                            c.Description = System.Label.cs_No_Description;
                        }
                    }
                }

                Database.update(casesToBeClosed);
            }
            catch(Exception e)
            {
                String exp = e.getMessage();
                List<CaseComment> comList = new List<CaseComment>();

                for(Case c: casesToBeClosed)
                {
                    CaseComment cTemp = new CaseComment();
                    //cTemp.CommentBody = 'Error encountered while auto-closing:\n' + exp;
                    //CSphase2 Supriya 22122016
                    cTemp.CommentBody = System.Label.cs_Error_encountered+'\n' + exp;
                    cTemp.isPublished = false;
                    cTemp.ParentId = c.Id;

                    comList.add(cTemp);
                }

                Database.insert(comList);
            }

        }

    }
}