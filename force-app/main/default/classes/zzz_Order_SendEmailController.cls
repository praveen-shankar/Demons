@isTest


/*
This is a test class for the Order_SendEmailController class
*/

private class zzz_Order_SendEmailController
{
    

    //this function will test the senario where ORDER ID IS NULL.

    static testMethod void testValidateData_1() 
    {
        Order o1=new Order();
        Order_SendEmailController sendEmail = new Order_SendEmailController(new ApexPages.StandardController(o1)); 
        //sendEmail.validateData();
    }

    //this function will test the senario where ORDER DOES NOT HAVE ALL THE MANDATORY FIELDS TO SEND ORDER EMAIL FILLED.
    static testMethod void testValidateData_2() 
    {
        Account acct1 = new Account(Name = 'Test1');
        upsert acct1;

        Order o2=new Order();
        o2.EffectiveDate=System.today();
        o2.AccountId=acct1.id;
        //o2.status='Ny';
        //Csphase2 Supriya 29122016
        o2.status='New';
        o2.RecordTypeId = KATSutilities.getRecordType('Adhoc_Orders');
        insert(o2);
        
        Order_SendEmailController sendEmail = new Order_SendEmailController(new ApexPages.StandardController(o2)); 
        sendEmail.validateData();
    }


    //this function will test the senario where THE 'ShippingPostalCode' FIELD VALUE IS NOT PRESENT IN THE CUSTOM SETTINGS 

    static testMethod void testValidateData_3() 
    {
    
        Order o3=testOrderAdhoc();
        o3.ShippingPostalCode='7000';
        o3.RecordTypeId = KATSutilities.getRecordType('Adhoc_Orders');
        insert(o3);
        testAdhoc_order_details();

        Order_SendEmailController sendEmail = new Order_SendEmailController(new ApexPages.StandardController(o3)); 
        sendEmail.validateData();


    }

    //this function will test the senario where THE 'ShippingPostalCode' IS NOT AN INTEGER

    static testMethod void testValidateData_4() 
    {
        Order o4 = testOrderAdhoc();
        o4.ShippingPostalCode='TEST CODE';
        insert(o4);
        testAdhoc_order_details();

        Order_SendEmailController sendEmail = new Order_SendEmailController(new ApexPages.StandardController(o4)); 
        sendEmail.validateData();

    }


    //this function will test the senario where THE 'ShippingPostalCode' FIELD VALUE IS PRESENT IN THE CUSTOM SETTINGS AND ACTIVE
    
    static testMethod void testValidateData_5() 
    {
        Order o5 = testOrderAdhoc();
        o5.ShippingPostalCode='1200';
        o5.type = 'Adhoc';
        //Csphse2 no change required

        insert(o5);
        testAdhoc_order_details();

        Order_SendEmailController sendEmail = new Order_SendEmailController(new ApexPages.StandardController(o5)); 
        sendEmail.customer_email_flag=false;  
        sendEmail.validateData();
        sendEmail.sendEmailToTransportUnit();
    }

     //this function will test the senario where THERE WILL BE AN EXCEPTION WHILE UPDATING Order AS THE ORDER IS DELETED
    static testMethod void testValidateData_6() 
    {   
        Account acct1 = new Account(Name = 'Test1');
        upsert acct1;

        Order o6=new Order();
        o6.EffectiveDate=System.today();
        o6.AccountId=acct1.id;
        //o6.status='Ny';
        //Csphase2 Supriya 29122016
         o6.status='New';
        insert(o6); 
        delete(o6); 

        Order_SendEmailController sendEmail = new Order_SendEmailController(new ApexPages.StandardController(o6)); 
        sendEmail.validateData();
        sendEmail.sendEmailToTransportUnit();
    }

    static testMethod void testValidateData_7() 
    {
        Order o = testOrderMBH();
        o.ShippingPostalCode='Test';
        //o.reason__c ='Avbestilling';//Cancellation
        //Csphase2 Supriya 29122016
        o.reason__c ='Cancellation';
        insert(o);
        testAdhoc_order_details();

        Order_SendEmailController sendEmail = new Order_SendEmailController(new ApexPages.StandardController(o)); 
        sendEmail.customer_email_flag=false; 
        sendEmail.validateData();
        update o;
        sendEmail.sendEmailToTransportUnit();
    }


    static testMethod void testValidateData_8() 
    {
        Order o5 = testOrderAdhoc();
        o5.ShippingPostalCode='1200';
        //o5.type = 'Bedriftspakke ekspress';
        //Csphase2 Supriya 29122016
        o5.type = 'Business Parcel Express';
        insert(o5);
        testAdhoc_order_details();
        // testNotification_details('Note1','This is a test','Adhoc_Orders','Bedriftspakke ekspress',true); 
        testNotification_details('Note1','This is a test','Adhoc_Orders','Business Parcel Express',true); 
        //Csphase2 supriya 29122016
        testBDX_order_details();

        Order_SendEmailController sendEmail = new Order_SendEmailController(new ApexPages.StandardController(o5)); 
        sendEmail.customer_email_flag=false;
        sendEmail.loadNotification();

        sendEmail.validateData();
        sendEmail.sendEmailToTransportUnit();
    }


    static testMethod void testValidateData_12() 
    {
        Order o5 = testOrderAdhoc();
        //o5.type = 'Bedriftspakke ekspress';
        //Csphase2 Supriya 29122016
        o5.type = 'Business Parcel Express';
        o5.delivery_Postcode__c = '1200';
        insert(o5);

        testAdhoc_order_details();
       // testNotification_details('Note1','This is a test','Adhoc_Orders','Bedriftspakke ekspress',true); 
        testNotification_details('Note1','This is a test','Adhoc_Orders','Business Parcel Express',true); 
        //Csphase2 supriya 29122016
        testBDX_order_details();

        Order_SendEmailController sendEmail = new Order_SendEmailController(new ApexPages.StandardController(o5)); 
        sendEmail.customer_email_flag=false;
        sendEmail.loadNotification();

        sendEmail.validateData();
        sendEmail.sendEmailToTransportUnit();
    }

    static testMethod void testValidateData_9() 
    {
        Account acct1 = new Account(Name = 'Test1');
        upsert acct1;

        Order o2=new Order();
        o2.EffectiveDate=System.today();
        o2.AccountId=acct1.id;
        //o2.status='Ny';
        //Csphase2 Supriya 29122016
        o2.status='New';
        o2.RecordTypeId = KATSutilities.getRecordType('Receiver_Paid_Delivery');
        insert(o2);

        testNotification_details('Note1','This is a test','Receiver_Paid_Delivery',null,true); 

        Order_SendEmailController sendEmail = new Order_SendEmailController(new ApexPages.StandardController(o2)); 
        sendEmail.validateData();
        sendEmail.loadNotification();
    }

    static testMethod void testValidateData_10() 
    {
        Account acct1 = new Account(Name = 'Test1');
        upsert acct1;

        Order o2=new Order();
        o2.EffectiveDate=System.today();
        o2.AccountId=acct1.id;
       // o2.status='Epost sent';//Email sent
        //Csphase2 Supriya 29122016
        o2.status='Epost sent';//Email sent
        o2.RecordTypeId = KATSutilities.getRecordType('Adhoc_Orders');
        insert(o2);
        
        Order_SendEmailController sendEmail = new Order_SendEmailController(new ApexPages.StandardController(o2)); 
        sendEmail.validateData();
        sendEmail.loadNotification();
    }

    static testMethod void testValidateData_11() 
    {
        Order o5 = testOrderAdhoc();
        o5.ShippingPostalCode='Test';
        o5.type = 'Adhoc';

        insert(o5);
        testAdhoc_order_details();

        Order_SendEmailController sendEmail = new Order_SendEmailController(new ApexPages.StandardController(o5)); 
        sendEmail.customer_email_flag=false;  
        sendEmail.validateData();
        sendEmail.sendEmailToTransportUnit();
    }


     static testMethod void testValidateData_13() 
    {
        Order o = testOrderMBH();
        o.ShippingPostalCode='Test';
        o.reason__c ='Avbestilling';//Cancellation
        //Csphase2 Supriya 29122016
  
        insert(o);
        testAdhoc_order_details();

        Order_SendEmailController sendEmail = new Order_SendEmailController(new ApexPages.StandardController(o)); 
        sendEmail.customer_email_flag=false; 
        sendEmail.validateData();
        update o;
        sendEmail.sendEmailToTransportUnit();
    }

    //This is an internal function to set all the order fields and return the ORDER OBJECT.

    private static Order testOrderAdhoc() 
    {
        Account acct1 = new Account(Name = 'Test1');
        insert(acct1);

        Case c = new Case();
        c.RecordTypeId = KATSutilities.getRecordType('planned_distribution_case');
        insert c;

        Order o=new Order();
        o.RecordTypeId = KATSutilities.getRecordType('Adhoc_Orders');
        o.EffectiveDate=System.today();
        o.AccountId=acct1.id;
       // o.status='Ny';
       //Csphase2 Supriya 29122016
        o.status='New';
        o.business_name_for_pickup__c='Test';
        o.phone_number__c='551255451';
        o.contact_person__c='Test User';
        o.Description='Test for Order';
        o.number_of_packages__c='3';
        o.Vekt_volum_str__c='200 cc';
        o.Case__c=c.id;

        return o;

    }

    private static Order testOrderMBH() 
    {
        Account acct1 = new Account(Name = 'Test1');
        insert(acct1);

        PostalUnit__c pu = new PostalUnit__c(Name ='Test Enhet',unit_number__c ='123456');
        insert (pu);

        Case c = new Case();
        c.RecordTypeId = KATSutilities.getRecordType('planned_distribution_case');
        insert c;

        Order o = new Order();
        o.RecordTypeId = KATSutilities.getRecordType('Receiver_Paid_Delivery');
        o.EffectiveDate=System.today();
        o.AccountId=acct1.id;
        o.Type = 'bedriftspakke ekspress';
        // o.status='Ny';
       //Csphase2 Supriya 29122016
        o.status='New';
        o.Sendingsnummer__c='123289911'; 
        o.postalUnit__c = pu.Id;
        o.Case__c=c.id;

        return o;

    }

//This is an internal function to set the custom settig Adhoc_order_details and insert it ti database .
    private static void testAdhoc_order_details()
    {
        Adhoc_order_details__c aodTest = new Adhoc_order_details__c(name='testTransportUnit',transport_unit_name__c='Adhoc',Start_postal_code__c='0001',End_postal_code__c='2000',Active__c=true);
        insert(aodTest);
    }

    private static void testBDX_order_details()
    {
        BDX_Delivery_Postcodes__c BDXTest = new BDX_Delivery_Postcodes__c(name='testBDXTransportUnit',City__c ='1200');
        insert(BDXTest);
    }

    private static void testNotification_details(String name,String note,String recordType, String orderType,boolean active)
    {
        Order_Notifications__c onTest = new Order_Notifications__c(Name= name,Notification__c= note ,Record_Type__c=recordType,Order_Type__c=orderType,Aktiv__c=active);
        insert(onTest);
    }
}