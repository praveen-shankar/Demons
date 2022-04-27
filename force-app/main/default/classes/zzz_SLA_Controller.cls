@isTest
private class zzz_SLA_Controller {
/*
    static {
        Account acc = new Account(Name = 'SlaPlaceholderAccount');
        upsert acc;
        
        BusinessHours bh = KATSutilities.getBusinessHours().get(KATSutilities.getDefaultBusinessHours());
        
        Entitlement ent = new Entitlement(
            AccountId = acc.id,
            BusinessHoursId = bh.id,
            Name = 'Test entitlement',
            SlaProcessId = null,
            IsPerIncident = false,
            StartDate = date.today().addDays(-7),
            Type = 'Web Support'
        );
        insert ent;
        
        Group g = new Group(Type = 'Queue', Name='Test queue SLA_Controller');
        insert g;
        
        System.runAs(KatsTestUtilities.getTestUser()) {
            List<QueueSObject> qList = new List<QueueSObject>();
            qList.add(new QueueSObject(SobjectType='Case', QueueId=g.Id));
            qList.add(new QueueSObject(SobjectType='QueueDetails__c', QueueId=g.Id));
            insert qList;
        }
        
        QueueDetails__c qd = new QueueDetails__c(
            queue_name__c=g.name + ' ' + System.now(),
            OwnerId=g.Id,
            Business_Hours__c = bh.Id,
            queue_deadline__c = 360
        );
        insert qd; 
    }*/
    
    static testMethod void test_SetSolutionAndResponse() {
        List<Case> cases = new List<Case>();
        List<Account> alist = new List<Account>();
        Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        Account acc1 = new Account(Name = 'Customer A', Customer_Segment__c = 'A', recordTypeid=RecordTypeId);
        Account acc2 = new Account(Name = 'Customer B', Customer_Segment__c = 'B', recordTypeid=RecordTypeId);
        Account acc3 = new Account(Name = 'Customer C', Customer_Segment__c = 'C', recordTypeid=RecordTypeId);
        //Account d = new Account(isPersonAccount = true);
        Account acc5 = new Account(Name = 'Bedrift', recordTypeid=RecordTypeId);
        alist.add(acc1);
        alist.add(acc2);
        alist.add(acc3);
        alist.add(acc5);
        upsert(alist);
        
        for(Integer i = 0; i < 200; i++){
            Case c = new Case();
                if(i<50){    
                    c.AccountId = acc1.id;
                    if(i<25){
                        c.RecordTypeId = KATSutilities.getRecordType('deviation_case');
                    }
                    if(i>25 && i<50){
                        c.RecordTypeId = KATSutilities.getRecordType('complaint');
                    }
                }
                if(i>50 && i<100){
                    c.AccountId = acc2.id;
                    if(i<75){
                        c.RecordTypeId = KATSutilities.getRecordType('deviation_case');
                    }
                    if(i>65 && i<100){
                        c.RecordTypeId = KATSutilities.getRecordType('complaint');
                    }
                }       
                if(i>100 && i<150){
                    c.AccountId = acc3.id;
                    if(i<125){
                        c.RecordTypeId = KATSutilities.getRecordType('deviation_case');
                    }
                    if(i>125 && i<150){
                        c.RecordTypeId = KATSutilities.getRecordType('complaint');
                    }
                }
                if(i>150 && i<200){
                    c.AccountId = acc5.id;
                    if(i<175){
                        c.RecordTypeId = KATSutilities.getRecordType('deviation_case');
                    }
                    if(i>175 && i<200){
                        c.RecordTypeId = KATSutilities.getRecordType('complaint');
                    }
                }   
           cases.add(c);
        }    
        
        insert cases;

        test.startTest();
        
        for(Integer i = 0; i < 200; i++){
            if(i>50){    
                cases[i].AccountId = acc2.id;
            }
            if(i>50 && i<100){
                cases[i].AccountId = acc3.id;
            }       
            if(i>100 && i<150){
                cases[i].AccountId = acc5.id;
            }
            if(i>100 && i<150){
                cases[i].AccountId = acc1.id;
            }       
        }
        
        upsert cases;
        
        test.stopTest();
    }
}