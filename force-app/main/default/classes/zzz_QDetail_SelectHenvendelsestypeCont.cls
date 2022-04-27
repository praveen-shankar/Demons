@isTest
private class zzz_QDetail_SelectHenvendelsestypeCont
{
    // This test will be conducted for QueueDetail when no default Record Type is selected
    @isTest static void TestScenario1()
    {   
        // Creating a Queue for reference
        Group testGroup = new Group(Name='test group', Type='Queue');
        insert testGroup;

        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue1 = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue1;
            QueuesObject testQueue2 = new QueueSObject(QueueID = testGroup.id, SObjectType = 'QueueDetails__c');
            insert testQueue2;

        }

        // Creating Code Event Record
        Code_Event__c ce1 = new Code_Event__c(Name='Faktura');
        //ce1.CaseTypeMultiselect__c = 'Klage';
        //Csphase2 Supriya 29122016
        ce1.CaseTypeMultiselect__c = 'Complaint';
        ce1.IsActive__c = true;
        insert ce1;

        // Creating Product Family Record
        id prodFamRecId = [select id from RecordType where DeveloperName='Product_Family' and SobjectType='Service_Product__c'].id;//KATSutilities.getRecordType('Product_Family'); added as part of 7th Nov Release
        Service_Product__c pf1 = new Service_Product__c(Name='MyTestProductFamily',recordTypeId = prodFamRecId);/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        insert pf1;

        // Creating Product Record
        //Id prodRecId = KATSutilities.getRecordType('Product');
    Id prodRecId = [select id from RecordType where DeveloperName='Product' and SobjectType='Service_Product__c'].id;
        Service_Product__c p1 = new Service_Product__c(Name='MyTestProduct', Produktfamilie__c = pf1.id, recordTypeId = prodRecId, check_kollinummer__c = true, check_adresseendring__c = true, check_fakturanummer__c = true);/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        insert p1;       

        // Creating Code Reason 1 Record
        Code_Reason1__c cr1 = new Code_Reason1__c(Name='MyTestReason1');
        insert cr1;

        // Creating Code Reason 2 Record
        Code_Reason2__c cr2 = new Code_Reason2__c(Name='MyTestReason2');
        insert cr2;

        // Creating setup for Code Event and Product
        Code_Event_Prod__c cep1 = new Code_Event_Prod__c();
        cep1.Code_Event__c = ce1.id;
        cep1.Service_Product__c = p1.id; /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        cep1.IsActive__c = true;
        database.insert(cep1);

        // Creating setup for Product and Code Reason 1
        CodeProdReason__c cpr1 = new CodeProdReason__c();
        cpr1.Henvendelsestype__c = ce1.id;
        cpr1.Service_Product__c = p1.id; /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        cpr1.Code_reason1__c = cr1.id;
        cpr1.IsActive__c = true;
        database.insert(cpr1);


        // Creating setup for Code Reason 1 and Code Reason 2
        Code_Reason_12__c cr12 = new Code_Reason_12__c();
        cr12.Code_reason1__c = cr1.Id;
        cr12.Code_reason2__c = cr2.Id;
        cr12.Service_Product__c = p1.id;
        database.insert(cr12);

        // Creating QueueDetail__c record
        QueueDetails__c qd1 = new QueueDetails__c();
        qd1.queue_name__c = 'Test Queue Detail';
        qd1.ownerId = testGroup.id;
        database.insert(qd1);

        Test.startTest();

        // Creating standard controller for the created QueueDetail Record
        ApexPages.StandardController controller = new ApexPages.StandardController(qd1);

        // Creating an instance of the controller class and calling the constructor
        QDetail_SelectHenvendelsestypeController qdc = new QDetail_SelectHenvendelsestypeController(controller);

        // We begin by editing the section (Click on Rediger button)
        qdc.toggleCategorySec();
        // Reset the View, Click on Cancel (Avbryt button)
        qdc.toggleCategorySec();
        // Again click on Edit to open the edit section
        qdc.toggleCategorySec();

        // Once the Edit section is visible, all the Select Option lists will be populated
        qdc.getEventOpts();
        qdc.getProductFamiliesOpts();
        qdc.getProductOpts();
        qdc.getReason1Opts();
        qdc.getReason2Opts();

        // At this stage if we try to Save, the system should allow with no values set
        qdc.saveDefaults();

        // Next, we will set the Code_Event record and try to generate the Product Family List
        qdc.eventId = ce1.id;
        qdc.getProductFamiliesOpts();
        // We will now try to Save the defaults and the system will allow to do so with just Code_Event set
        qdc.saveDefaults();


        // Next, we will set the Product Family and try to generate the Product List
        qdc.productFamily = pf1.id;
        qdc.getProductOpts();
        // We will not Save the defaults set so far
        qdc.saveDefaults();


        // Next, we will set the Product and try to generate the Arsak1 List
        qdc.productId = p1.id;
        qdc.getProductOpts();
        // We will not Save the defaults set so far
        qdc.saveDefaults();

        // Next, we will set the Arsak1 and try to generate the Arsak2 List
        qdc.reason1Id = cr1.id;
        qdc.getReason1Opts();
        // We will not Save the defaults set so far
        qdc.saveDefaults();

        // Next, we will set the Arsak2 value
        qdc.reason2Id = cr2.id;
        qdc.getReason2Opts();
        // We will not Save the defaults set so far
        qdc.saveDefaults();
        

        // We will now reload the page and the controller will be able to find the new values set in the constructor
        id qdId = qd1.id;
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        qd1 = [SELECT Product__c,
                      Product__r.Produktfamilie__c,
                      Service_Product__r.Produktfamilie__c,
                      Service_Product__c,
                      Code_Reason1__c,
                      Code_Reason2__c,
                      Code_Event__c,
                      Def_Rec_Type__c
                 FROM QueueDetails__c
                WHERE Id = :qdId
              ];


        // Creating standard controller for the created QueueDetail Record
        controller = new ApexPages.StandardController(qd1);
        // Creating an instance of the controller class and calling the constructor
        qdc = new QDetail_SelectHenvendelsestypeController(controller);


        // Throwing exception now while we try to update the QueueDetail, but its deleted earlier
        database.delete(qd1);
        // Trying to Save Defaults
        qdc.saveDefaults();



        Test.stopTest();

    }



    // This test will be conducted for QueueDetail - Default Record Type is selected
    // But Missing setups
    @isTest static void TestScenario2()
    {
        // Creating a Queue for reference
        Group testGroup = new Group(Name='test group', Type='Queue');
        insert testGroup;

        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue1 = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue1;
            QueuesObject testQueue2 = new QueueSObject(QueueID = testGroup.id, SObjectType = 'QueueDetails__c');
            insert testQueue2;

        }

        // Creating Code Event Record
        Code_Event__c ce1 = new Code_Event__c(Name='Faktura');
              
        //ce1.CaseTypeMultiselect__c = 'Klage';
        //Csphase2 Supriya 29122016
        ce1.CaseTypeMultiselect__c = 'Complaint';
        ce1.IsActive__c = true;
        insert ce1;

        // Creating Product Family Record
        id prodFamRecId = [select id from RecordType where DeveloperName='Product_Family' and SobjectType='Service_Product__c'].id;//KATSutilities.getRecordType('Product_Family'); added as part of 7th Nov Release
        Service_Product__c pf1 = new Service_Product__c(Name='MyTestProductFamily',recordTypeId = prodFamRecId);
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        //Service_Product__c pf1 = new Service_Product__c(Name='MyTestProductFamily',recordTypeId = prodFamRecId);
        insert pf1;

        // Creating Product Record
        //Id prodRecId = KATSutilities.getRecordType('Product');
    Id prodRecId = [select id from RecordType where DeveloperName='Product' and SobjectType='Service_Product__c'].id;
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        Service_Product__c p1 = new Service_Product__c(Name='MyTestProduct', Produktfamilie__c = pf1.id, recordTypeId = prodRecId, check_kollinummer__c = true, check_adresseendring__c = true, check_fakturanummer__c = true);
        insert p1;       

        // Creating Code Reason 1 Record
        Code_Reason1__c cr1 = new Code_Reason1__c(Name='MyTestReason1');
        insert cr1;

        // Creating Code Reason 2 Record
        Code_Reason2__c cr2 = new Code_Reason2__c(Name='MyTestReason2');
        insert cr2;

        // Creating QueueDetail__c record
        QueueDetails__c qd1 = new QueueDetails__c();
        qd1.queue_name__c = 'Test Queue Detail';
        qd1.ownerId = testGroup.id;
        //qd1.Def_Rec_Type__c = 'Klage';
        //Csphase2 Supriya 29122016
        qd1.Def_Rec_Type__c = 'Complaints';
        
        database.insert(qd1);

        Test.startTest();

        // Creating standard controller for the created QueueDetail Record
        ApexPages.StandardController controller = new ApexPages.StandardController(qd1);

        // Creating an instance of the controller class and calling the constructor
        QDetail_SelectHenvendelsestypeController qdc = new QDetail_SelectHenvendelsestypeController(controller);
        // We begin by editing the section (Click on Rediger button)
        qdc.toggleCategorySec();

        // Once the Edit section is visible, all the Select Option lists will be populated
        qdc.getEventOpts();
        qdc.getProductFamiliesOpts();
        qdc.getProductOpts();
        qdc.getReason1Opts();
        qdc.getReason2Opts();

        // Here we try to associate Ids directly, but due to missing setups we will not have the lists populated
        qdc.eventId = ce1.id;
        qdc.productFamily = pf1.id;
        qdc.productId = p1.id;
        qdc.reason1Id = cr1.id;
        qdc.reason2Id = cr2.id;
        // Fetching List again
        qdc.getEventOpts();
        qdc.getProductFamiliesOpts();
        qdc.getProductOpts();
        qdc.getReason1Opts();
        qdc.getReason2Opts();        



        Test.stopTest();
    }


}