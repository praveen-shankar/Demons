// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.crm_customer_number__c with Account.crm_customer_number__c
@isTest
private class zzz_Case_SendEmailToPostalUnitController
{
    // Test constructor with case reference
    // This test method will have all the required details on the Case, before opening the page.
    @isTest static void TestScenario1()
    {
    
        environment_settings__c envSetting = new environment_settings__c();
        envSetting.Name = 'BatchEmailNotification'; 
     // envSetting.ReplyToEmailAddress__c = 'test.salesforce@tcs.com';
        envSetting.value__c = 'test@posten.no';
        insert envSetting;
        // Creating Test Account
        Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        Account acc1 = new Account();
        acc1.Name = 'Test Account 1';
        acc1.crm_customer_number__c = '998837666';
        acc1.recordtypeid=RecordTypeId;
        database.insert(acc1);

        // Creating Test Postal Unit
        PostalUnit__c pu1 = new PostalUnit__c();
        pu1.Name = 'PostalUnit1';
        pu1.unit_number__c = '000001';
        Database.insert(pu1);

        // Custom Settings Record to be Added
        environment_settings__c es1 = new environment_settings__c();
        es1.Name = 'emailToPostalUnitDaysPrior';
        es1.value__c = '2';
        es1.Description__c = 'Test Setup Value';
        Database.insert(es1);

        Case c = new Case();
        c.Subject = 'Test Case 1';
        c.Description = 'This is a test';
        c.AccountId = acc1.id;
        c.change_address_ref_no__c = '123456';
        c.unit_to_blame__c = pu1.id;

        database.insert(c);

        Case_SendEmailToPostalUnitController testPage;

        Test.startTest();

        Test.setCurrentPage(Page.Case_SendEmailToPostalUnit);
        ApexPages.StandardController con = new ApexPages.StandardController(c);

        testPage = new Case_SendEmailToPostalUnitController(con);
        testPage.changeCategory();
        testPage.getCustomerDetailViaEconnect();
        
        // We now try to schedule an email. But it will fail as we have not updated any information on the page
        testPage.scheduleEmailToPostalUnit();

        // ----------------------------------------------------------------------------------------------------------------------------------- //
        // We here will try and set different values and selecting date of Delivery as current date
        testPage.addr_postCode = 'ABCDE';                           // Will fail as non-numeric
        testPage.c.Send_to_Postal_Unit__c = Date.today();           // Will fail as cannot be set as today's date
        testPage.scheduleEmailToPostalUnit();

        // ----------------------------------------------------------------------------------------------------------------------------------- //
        // Now We will set the date of delivery for exact same date
        // Also, the PostCode will be checked for length
        testPage.addr_postCode = '12345';
        DateTime tempDate = (DateTime) Date.today();                // Temporary variable to move to the new date
        Integer count = 0;
        while(count < 2)
        {
            tempDate = tempDate.addDays(1);

            // This checks if we moved forward to a Sunday of Saturday
            // If its a weekday we add it to count, otherwise we do not consider it as a working day
            if(!tempDate.format('E').equalsIgnoreCase('sun'))
            {
                count = count + 1;
            }

        }

        testPage.c.Send_to_Postal_Unit__c = tempDate.date();                // Email due date should exactly land on todays date
        testPage.scheduleEmailToPostalUnit();        
        
        // ----------------------------------------------------------------------------------------------------------------------------------- //
        // Testing for Sunday as the selected date of delivery
        tempDate = (DateTime) Date.today();                 // Temporary variable to move to the new date
        Boolean findNextSunday = true;
        while(findNextSunday)
        {
            tempDate = tempDate.addDays(1);

            // This checks if we moved forward to a Sunday of Saturday
            // If its a weekday we add it to count, otherwise we do not consider it as a working day
            if(tempDate.format('E').equalsIgnoreCase('sun'))
            {
                findNextSunday = false;
            }

        }
        
        testPage.c.Send_to_Postal_Unit__c = tempDate.date();                // Email due date should exactly land on todays date
        testPage.scheduleEmailToPostalUnit();

        // ----------------------------------------------------------------------------------------------------------------------------------- //
        // Testing for proper date of Delivery and all the required fields updated
        tempDate = (Datetime) Date.today();
        tempDate = tempDate.addDays(2);
        while(!tempDate.format('E').equalsIgnoreCase('sun'))
        {
            tempDate = tempDate.addDays(1);
        }
        testPage.c.Send_to_Postal_Unit__c = tempDate.date();

        // Adding and selecting Customer Name
        testPage.cust2Add = 'Test User 1';
        testPage.addRecepient();
        testPage.custList[0].sel = true;

        // Setting other details
        testPage.c.temp_email_PostalUnit__c = 'rohit.paul@capgemini.com';

        testPage.setAddress();
        testPage.addr_street = 'Test Street';
        testPage.addr_city = 'Test City';
        testPage.addr_postCode = '0190';
        
        testPage.alternative = 'We selected one alternative';


        testPage.scheduleEmailToPostalUnit();

        // ----------------------------------------------------------------------------------------------------------------------------------- //

        testPage.sendEmailNow();

        Test.stopTest();

    }

    // This test will make sure the correct process is followed with all the required data updated in the form
    // This scenario is for the Case with the Ref.adr.dring reference number
    @isTest static void TestScenario2()
    {
    
        environment_settings__c envSetting = new environment_settings__c();
        envSetting.Name = 'BatchEmailNotification'; 
     // envSetting.ReplyToEmailAddress__c = 'test.salesforce@tcs.com';
        envSetting.value__c = 'test@posten.no';
        insert envSetting;
        // Creating Test Account
        Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        Account acc1 = new Account();
        acc1.Name = 'Test Account 1';
        acc1.crm_customer_number__c = '998837666';
        acc1.recordTypeid=RecordTypeId;
        database.insert(acc1);

        // Creating Test Postal Unit
        PostalUnit__c pu1 = new PostalUnit__c();
        pu1.Name = 'PostalUnit1';
        pu1.unit_number__c = '000001';
        Database.insert(pu1);

        // Custom Settings Record to be Added
        environment_settings__c es1 = new environment_settings__c();
        es1.Name = 'emailToPostalUnitDaysPrior';
        es1.value__c = '2';
        es1.Description__c = 'Test Setup Value';
        Database.insert(es1);

        Case c = new Case();
        c.Subject = 'Test Case 1';
        c.Description = 'This is a test';
        c.AccountId = acc1.id;
        c.change_address_ref_no__c = 'P000001';
        c.unit_to_blame__c = pu1.id;

        database.insert(c);

        Id caseId = c.id;

        c = [SELECT Subject,
                    temp_email_PostalUnit__c,
                    Send_to_Postal_Unit__c,
                    Send_Email_to_Postal_Unit__c,
                    Private_Comments__c,
                    Account.crm_customer_number__c,
                    Account.Name,
                    unit_to_blame__c,
                    Description,
                    case_referens__c,
                    CaseNumber,
                    OwnerID,
                    change_address_ref_no__c FROM CASE WHERE id = :caseId LIMIT 1];

        Case_SendEmailToPostalUnitController testPage;

        Test.startTest();

        Test.setCurrentPage(Page.Case_SendEmailToPostalUnit);
        ApexPages.StandardController con = new ApexPages.StandardController(c);

        testPage = new Case_SendEmailToPostalUnitController(con);

        // Adding addresses to the Address List: addrList
        testPage.addrList.add(new Case_SendEmailToPostalUnitController.CustomerAddressHolder('strt1','cty1','0011'));
        testPage.addrList.add(new Case_SendEmailToPostalUnitController.CustomerAddressHolder('strt2','cty2','0022'));

        // Testing for proper date of Delivery and all the required fields updated
        Datetime tempDate = (Datetime) Date.today();
        tempDate = tempDate.addDays(2);
        while(tempDate.format('E').equalsIgnoreCase('sat')||tempDate.format('E').equalsIgnoreCase('sun'))
        {
            tempDate = tempDate.addDays(1);
        }
        testPage.c.Send_to_Postal_Unit__c = tempDate.addDays(7).date();

        // Adding and selecting Customer Name
        testPage.cust2Add = 'Test User 1';
        testPage.addRecepient();
        testPage.custList[0].sel = true;

        // Setting other details
        testPage.c.temp_email_PostalUnit__c = 'rohit.paul@capgemini.com';

        // Setting Address
        testPage.addrList[0].sel = true;
        testPage.setAddress();

        testPage.addr_street = 'Test Street';
        testPage.addr_city = 'Test City';
        testPage.addr_postCode = '0190';

        testPage.alternative = 'We selected one alternative';


        testPage.scheduleEmailToPostalUnit();

        Date testDate = testPage.c.Send_to_Postal_Unit__c.addDays(7);

        testPage.toggleReScheduleDateField();                       // Make the date field visible

        // We first remove the current date and try to set it
        testPage.c.Send_to_Postal_Unit__c = null;
        testPage.reScheduleEmailToPostalUnit(); 


        // Now we will try and reschedule to today's date
        testPage.c.Send_to_Postal_Unit__c = Date.today();           // Set to current Date
        testPage.reScheduleEmailToPostalUnit();                     // Replan the schedule


        // Now we set delivery date to ensure email could be delivered only today
        tempDate = (DateTime) Date.today();                         // Temporary variable to move to the new date
        Integer count = 0;
        while(count < 2)
        {
            tempDate = tempDate.addDays(1);

            // This checks if we moved forward to a Sunday of Saturday
            // If its a weekday we add it to count, otherwise we do not consider it as a working day
            if(!(tempDate.format('E').equalsIgnoreCase('sun')||tempDate.format('E').equalsIgnoreCase('sat')))
            {
                count = count + 1;
            }

        }

        testPage.c.Send_to_Postal_Unit__c = tempDate.date();        // Email due date should exactly land on todays date
        testPage.reScheduleEmailToPostalUnit();                     // Replan the schedule


        // Testing for Sunday as the selected date of delivery
        tempDate = (DateTime) Date.today();                 // Temporary variable to move to the new date
        Boolean findNextSunday = true;
        while(findNextSunday)
        {
            tempDate = tempDate.addDays(1);

            // This checks if we moved forward to a Sunday of Saturday
            // If its a weekday we add it to count, otherwise we do not consider it as a working day
            if(tempDate.format('E').equalsIgnoreCase('sun')||tempDate.format('E').equalsIgnoreCase('sat'))
            {
                findNextSunday = false;
            }

        }
        
        testPage.c.Send_to_Postal_Unit__c = tempDate.date();        // Email due date should exactly land on Sunday
        testPage.reScheduleEmailToPostalUnit(); 

        // Now we will try and reschedule for a future date
        testPage.c.Send_to_Postal_Unit__c = testDate;               // Move the date forward by 1 week
        testPage.reScheduleEmailToPostalUnit();                     // Replan the schedule

        // Once rescheduled, now we will reset it
        testPage.resetScheduledEmailToPostalUnit();


        Test.stopTest();
    }


    // This test will make sure the correct process is followed with all the required data updated in the form
    // This scenario is for the Case with no reference number. Hence Sonelas
    @isTest static void TestScenario3()
    {
        environment_settings__c envSetting = new environment_settings__c();
        envSetting.Name = 'BatchEmailNotification'; 
     // envSetting.ReplyToEmailAddress__c = 'test.salesforce@tcs.com';
        envSetting.value__c = 'test@posten.no';
        insert envSetting;
        // Creating Test Account
        Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        Account acc1 = new Account();
        acc1.Name = 'Test Account 1';
        acc1.crm_customer_number__c = '998837666';
        acc1.recordTypeid=RecordTypeId;
        database.insert(acc1);
        
        PostalUnit__c pu1 = new PostalUnit__c();
        pu1.Name = 'PostalUnit1';
        pu1.unit_number__c = '000001';
        Database.insert(pu1);

        // Custom Settings Record to be Added
        environment_settings__c es1 = new environment_settings__c();
        es1.Name = 'emailToPostalUnitDaysPrior';
        es1.value__c = '2';
        es1.Description__c = 'Test Setup Value';
        Database.insert(es1);

        Case c = new Case();
        c.Subject = 'Test Case 1';
        c.Description = 'This is a test';
        c.AccountId = acc1.id;
        c.unit_to_blame__c = pu1.id;

        database.insert(c);

        Case_SendEmailToPostalUnitController testPage;

        Test.startTest();

        Test.setCurrentPage(Page.Case_SendEmailToPostalUnit);
        ApexPages.StandardController con = new ApexPages.StandardController(c);

        testPage = new Case_SendEmailToPostalUnitController(con);

        // Testing for proper date of Delivery and all the required fields updated
        Datetime tempDate = (Datetime) Date.today();
        tempDate = tempDate.addDays(2);
        while(!(tempDate.format('E').equalsIgnoreCase('sat')||tempDate.format('E').equalsIgnoreCase('sun')))
        {
            tempDate = tempDate.addDays(1);
        }
        testPage.c.Send_to_Postal_Unit__c = tempDate.addDays(6).date();

        // Adding and selecting Customer Name
        testPage.cust2Add = 'Test User 1';
        testPage.addRecepient();
        testPage.custList[0].sel = true;

        // Setting other details
        testPage.c.temp_email_PostalUnit__c = 'rohit.paul@capgemini.com';

        testPage.addr_street = 'Test Street';
        testPage.addr_city = 'Test City';
        testPage.addr_postCode = '0190';

        testPage.alternative = 'We selected one alternative';


        testPage.scheduleEmailToPostalUnit();

        // Now we will try and reschedule for a future date
        testPage.toggleReScheduleDateField();                                                       // Make the date field visible
        testPage.c.Send_to_Postal_Unit__c = testPage.c.Send_to_Postal_Unit__c.addDays(7);           // Move the date forward by 1 week
        testPage.reScheduleEmailToPostalUnit();                                                     // Replan the schedule

        // Once rescheduled, now we will reset it
        testPage.resetScheduledEmailToPostalUnit();


        Test.stopTest();
    }


    // This test method try to re-open an already scheduled page.
    @isTest static void TestScenario4()
    {
        environment_settings__c envSetting = new environment_settings__c();
        envSetting.Name = 'BatchEmailNotification'; 
     // envSetting.ReplyToEmailAddress__c = 'test.salesforce@tcs.com';
        envSetting.value__c = 'test@posten.no';
        insert envSetting;
        // Creating Test Account
        Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        Account acc1 = new Account();
        acc1.Name = 'Test Account 1';
        acc1.crm_customer_number__c = '998837666';
        acc1.recordtypeid=RecordTypeId;
        database.insert(acc1);

        // Creating Test Postal Unit
        PostalUnit__c pu1 = new PostalUnit__c();
        pu1.Name = 'PostalUnit1';
        pu1.unit_number__c = '000001';
        Database.insert(pu1);

        // Custom Settings Record to be Added
        environment_settings__c es1 = new environment_settings__c();
        es1.Name = 'emailToPostalUnitDaysPrior';
        es1.value__c = '2';
        es1.Description__c = 'Test Setup Value';
        Database.insert(es1);

        Case c = new Case();
        c.Subject = 'Test Case 1';
        c.Description = 'This is a test';
        c.AccountId = acc1.id;
        c.change_address_ref_no__c = 'P000001';
        c.unit_to_blame__c = pu1.id;

        database.insert(c);

        Case_SendEmailToPostalUnitController testPage;

        Test.startTest();

        Test.setCurrentPage(Page.Case_SendEmailToPostalUnit);
        ApexPages.StandardController con = new ApexPages.StandardController(c);

        testPage = new Case_SendEmailToPostalUnitController(con);

        // Testing for proper date of Delivery and all the required fields updated
        Datetime tempDate = (Datetime) Date.today();
        tempDate = tempDate.addDays(2);
        while(!(tempDate.format('E').equalsIgnoreCase('sat')||tempDate.format('E').equalsIgnoreCase('sun')))
        {
            tempDate = tempDate.addDays(1);
        }
        testPage.c.Send_to_Postal_Unit__c = tempDate.addDays(6).date();

        // Adding and selecting Customer Name
        testPage.cust2Add = 'Test User 1';
        testPage.addRecepient();
        testPage.custList[0].sel = true;

        // Setting other details
        testPage.c.temp_email_PostalUnit__c = 'rohit.paul@capgemini.com';

        testPage.addr_street = 'Test Street';
        testPage.addr_city = 'Test City';
        testPage.addr_postCode = '0190';

        testPage.alternative = 'We selected one alternative';


        testPage.scheduleEmailToPostalUnit();

        // Now we try to open the page again
        Test.setCurrentPage(Page.Case_SendEmailToPostalUnit);
        ApexPages.StandardController con2 = new ApexPages.StandardController(c);

        testPage = new Case_SendEmailToPostalUnitController(con2);


        Test.stopTest();


    }

    // Plan and send the email now
    @isTest static void TestScenario5()
    {
        environment_settings__c envSetting = new environment_settings__c();
        envSetting.Name = 'BatchEmailNotification'; 
     // envSetting.ReplyToEmailAddress__c = 'test.salesforce@tcs.com';
        envSetting.value__c = 'test@posten.no';
        insert envSetting;
        // Creating Test Account
        Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        Account acc1 = new Account();
        acc1.Name = 'Test Account 1';
        acc1.crm_customer_number__c = '998837666';
        acc1.recordtypeid=RecordTypeId;
        database.insert(acc1);

        // Creating Test Postal Unit
        PostalUnit__c pu1 = new PostalUnit__c();
        pu1.Name = 'PostalUnit1';
        pu1.unit_number__c = '000001';
        Database.insert(pu1);

        // Custom Settings Record to be Added
        environment_settings__c es1 = new environment_settings__c();
        es1.Name = 'emailToPostalUnitDaysPrior';
        es1.value__c = '2';
        es1.Description__c = 'Test Setup Value';
        Database.insert(es1);

        Case c = new Case();
        c.Subject = 'Test Case 1';
        c.Description = 'This is a test';
        c.AccountId = acc1.id;
        c.change_address_ref_no__c = 'P000001';
        c.unit_to_blame__c = pu1.id;

        database.insert(c);

        Case_SendEmailToPostalUnitController testPage;

        Test.startTest();

        Test.setCurrentPage(Page.Case_SendEmailToPostalUnit);
        ApexPages.StandardController con = new ApexPages.StandardController(c);

        testPage = new Case_SendEmailToPostalUnitController(con);

        // Testing for proper date of Delivery and all the required fields updated
        Datetime tempDate = (Datetime) Date.today();
        tempDate = tempDate.addDays(2);
        while(!(tempDate.format('E').equalsIgnoreCase('sat')||tempDate.format('E').equalsIgnoreCase('sun')))
        {
            tempDate = tempDate.addDays(1);
        }
        testPage.c.Send_to_Postal_Unit__c = tempDate.addDays(6).date();

        // Adding and selecting Customer Name
        testPage.cust2Add = 'Test User 1';
        testPage.addRecepient();
        testPage.custList[0].sel = true;

        // Setting other details
        testPage.c.temp_email_PostalUnit__c = 'rohit.paul@capgemini.com';

        testPage.addr_street = 'Test Street';
        testPage.addr_city = 'Test City';
        testPage.addr_postCode = '0190';

        testPage.alternative = 'We selected one alternative';


        testPage.scheduleEmailToPostalUnit();

        // Once scheduled, we will send it off at once
        testPage.sendEmailNow();

        Test.stopTest();


    }

    // This test method will not have the Account or the Postal Unit on the Case, before opening the page.
    @isTest static void TestScenario6()
    {
        
        environment_settings__c envSetting = new environment_settings__c();
        envSetting.Name = 'BatchEmailNotification'; 
     // envSetting.ReplyToEmailAddress__c = 'test.salesforce@tcs.com';
        envSetting.value__c = 'test@posten.no';
        insert envSetting;
        
        Case c = new Case();
        c.Subject = 'Test Case 1';
        c.Description = 'This is a test';
        
        database.insert(c);

        Case_SendEmailToPostalUnitController testPage;

        Test.startTest();

        Test.setCurrentPage(Page.Case_SendEmailToPostalUnit);
        ApexPages.StandardController con = new ApexPages.StandardController(c);

        testPage = new Case_SendEmailToPostalUnitController(con);
        testPage.changeCategory();

        Test.stopTest();

    }

}