// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
@isTest
private class zzz_MultilevelDependentPicklist 
{
    // Test that the controller is created with the right parameters
    static testMethod void ControllerTest1() 
    {
        createCustomSetting();
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
        Code_Event__c ce1 = new Code_Event__c(Name='MyTestEvent');
        ce1.CaseTypeMultiselect__c = 'Klage';
        //CSpahse2 Supriya 29122016
        //ce1.CaseTypeMultiselect__c = 'Complaint';
        ce1.IsActive__c = true;
        insert ce1;
        
        // Creating Product Family Record
        id prodFamRecId = [select id from RecordType where DeveloperName='Product_Family' and SobjectType='Service_Product__c'].id;//KATSutilities.getRecordType('Product_Family'); added as part of 7th Nov Release
        Service_Product__c pf1 = new Service_Product__c(Name='MyTestProductFamily',recordTypeId = prodFamRecId); /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        insert pf1;
        
        
        // Creating Product Record
        RecordType rcdtyp = [select id , developerName from RecordType where developerName = 'Product' and sobjectType = 'Service_Product__c' limit 1];
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        Service_Product__c p1 = new Service_Product__c(Name='MyTestProduct', Produktfamilie__c = pf1.id, recordTypeId = rcdtyp.id, check_kollinummer__c = true, check_adresseendring__c = true, check_fakturanummer__c = true);
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
        cr12.Service_Product__c = p1.id; /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        database.insert(cr12);
        
        
        QueueDetails__c qd1 = new QueueDetails__c();
        qd1.Code_Event__c = ce1.id;
        qd1.Service_Product__c = p1.id; /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        qd1.Code_Reason1__c = cr1.id;
        qd1.Code_Reason2__c = cr2.id;
        qd1.queue_name__c = 'Test Queue Detail';
        qd1.ownerId = testGroup.id;
        database.insert(qd1);
        
        
        // Creating Test Case
        Case c1 = new Case();
        c1.recordTypeId = KATSutilities.getRecordType('complaint');
        //c1.Status = 'Ny';
        //CSphase2 Supriya 29122016
        c1.Status = 'New';
        c1.Category__c = 'MyTestEvent';
        c1.OwnerId = testGroup.id;
        insert c1;
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        Case c = [SELECT Code_Event__c,
                  Status, RecordType.DeveloperName,
                  RecordType.Name,
                  Product.Produktfamilie__c,
                  Service_Product__r.Produktfamilie__c,
                  Service_Product__c,
                  ProductId,
                  Code_Reason1__c,
                  Code_Reason2__c,
                  Code_Reason2__r.Name,
                  Shipment_identification__c,
                  get_Queue_Defaults__c,
                  hidden_queue_id__c,
                  Invoice_no__c,
                  change_address_ref_no__c,
                  CaseNumber,
                  Produkt__c,
                  Category__c,
                  reason__c,
                  party_number__c
                  FROM Case
                  WHERE id = :c1.Id
                 ];
        
        Test.startTest();
        
        // Creating standard controller for the created Case
        ApexPages.StandardController controller = new ApexPages.StandardController(c);
        
        // Creating an instance of the controller class and calling the constructor
        MultilevelDependentPicklist mdp = new MultilevelDependentPicklist(controller);
        
        // Calling the setDefaults function as it is called from the page (Action on load)
        mdp.setDefaultsForHenvendelsestype();
        
        // When page loads the sections call the get methods to populate the drop downs
        mdp.toggleCategorySec();                                        // Makes the edit section visible
        mdp.getEventOpts();                                             // Loads Code Events
        mdp.getProductFamiliesOpts();                                   // Loads possible Product Families
        mdp.getProductOpts();                                           // Loads possible Products
        mdp.getReason1Opts();                                           // Loads Code Reason 1 list
        mdp.getReason2Opts();                                           // Loads Code Reason 2 list
        
        // First we select the Code Event and refresh the rest of the sections
        mdp.eventId = ce1.id;
        mdp.getProductFamiliesOpts();                                   // Loads possible Product Families
        mdp.getProductOpts();                                           // Loads possible Products
        mdp.getReason1Opts();                                           // Loads Code Reason 1 list
        mdp.getReason2Opts();                                           // Loads Code Reason 2 list
        
        // Saving the details on the Case
        mdp.Save();
        
        // We will not re-open the Case page to load this section again
        controller = new ApexPages.StandardController(c);
        mdp = new MultilevelDependentPicklist(controller);
        
        mdp.toggleCategorySec();                                        // Makes the edit section visible
        mdp.getEventOpts();                                             // Loads Code Events
        mdp.getProductFamiliesOpts();                                   // Loads possible Product Families
        mdp.getProductOpts();                                           // Loads possible Products
        mdp.getReason1Opts();                                           // Loads Code Reason 1 list
        mdp.getReason2Opts();                                           // Loads Code Reason 2 list
        
        mdp.SaveAndClose();                                             // We will just Save and Close the Case
        
        // Changing the Record Type
        c.recordTypeId = KATSutilities.getRecordType('simple_inquiry');
        database.update(c);
        
        c = [SELECT Code_Event__c,
             Status, RecordType.DeveloperName,
             RecordType.Name,
             Product.Produktfamilie__c,
             ProductId,
             Service_Product__r.Produktfamilie__c,
             Service_Product__c,
             Code_Reason1__c,
             Code_Reason2__c,
             Code_Reason2__r.Name,
             Shipment_identification__c,
             get_Queue_Defaults__c,
             hidden_queue_id__c,
             Invoice_no__c,
             change_address_ref_no__c,
             CaseNumber,
             Produkt__c,
             Category__c,
             reason__c,
             Party_number__c
             FROM Case
             WHERE id = :c1.Id
            ];
        
        // Now we will open the Case again and this time for a Closed Case
        controller = new ApexPages.StandardController(c);
        mdp = new MultilevelDependentPicklist(controller);
        
        
        Test.stopTest();
        
        
    }
    
    
    
    // This Test function will cover such situation where there are no setups in the background
    // For Henveldelsestype Values
    static testMethod void ControllerTest2()
    { 
        createCustomSetting();
        crm_AccountRecordTypes__c rr = new crm_AccountRecordTypes__c();
        rr.Name = 'Relation level Customer';
        rr.crm_Record_Type_Label__c ='Relation level Customer';
        insert rr;
        // Creating Code Event Record
        Code_Event__c ce1 = new Code_Event__c(Name='MyTestEvent');
        ce1.CaseTypeMultiselect__c = 'Klage';
        //Cspahse2 Supriya 29122016
        //ce1.CaseTypeMultiselect__c = 'Complaint';
        ce1.IsActive__c = true;
        
        
        // Creating Product Family Record
        id prodFamRecId = [select id from RecordType where DeveloperName='Product_Family' and SobjectType='Service_Product__c'].id;//KATSutilities.getRecordType('Product_Family'); added as part of 7th Nov Release
        Service_Product__c pf1 = new Service_Product__c(Name='MyTestProductFamily',recordTypeId = prodFamRecId);
        insert pf1;
        
        
        // Creating Product Record
        RecordType rcdtyp = [select id , developerName from RecordType where developerName = 'Product' and sobjectType = 'Service_Product__c' limit 1];
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        Service_Product__c p1 = new Service_Product__c(Name='MyTestProduct', Produktfamilie__c = pf1.id, recordTypeId = rcdtyp.id, check_kollinummer__c = true, check_adresseendring__c = true, check_fakturanummer__c = true);
        insert p1;       
        
        // Creating Code Reason 1 Record
        Code_Reason1__c cr1 = new Code_Reason1__c(Name='MyTestReason1');
        insert cr1;
        
        // Creating Code Reason 2 Record
        Code_Reason2__c cr2 = new Code_Reason2__c(Name='MyTestReason2');
        insert cr2;
        
        // Creating Test Case
        Case c1 = new Case();
        c1.recordTypeId = KATSutilities.getRecordType('complaint');
        //c1.Status = 'Ny';
        //Csphase2 Supriya 29122016 
        c1.Status = 'New';
        c1.Category__c = 'MyTestEvent';
          Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        Account a = new Account(Name = 'TestAccount',crm_customer_number__c = 'BLNOCTest');
        a.recordtypeid= recordtypeid;
        insert a;
        c1.AccountId = a.id;
        insert c1;
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        Case c = [SELECT Code_Event__c,
                  Status, RecordType.DeveloperName,
                  RecordType.Name,
                  Product.Produktfamilie__c,
                  ProductId,
                  Service_Product__r.Produktfamilie__c,
                  Service_Product__c,
                  Code_Reason1__c,
                  Code_Reason2__c,
                  Code_Reason2__r.Name,
                  Shipment_identification__c,
                  get_Queue_Defaults__c,
                  hidden_queue_id__c,
                  Invoice_no__c,
                  change_address_ref_no__c,
                  CaseNumber,
                  Produkt__c,
                  Category__c,
                  reason__c,
                  Party_number__c,
                  Product.Produktfamilie__r.Name,
                  Service_Product__r.Produktfamilie__r.Name
                  FROM Case
                  WHERE id = :c1.Id
                 ];
        
        Test.startTest();
        
        // Creating standard controller for the created Case
        ApexPages.StandardController controller = new ApexPages.StandardController(c);
        
        // Creating an instance of the controller class and calling the constructor
        MultilevelDependentPicklist mdp = new MultilevelDependentPicklist(controller);
        
        // Calling the setDefaults function as it is called from the page (Action on load)
        mdp.setDefaultsForHenvendelsestype();
        
        // First we set the values of these records
        mdp.eventId = ce1.id;
        mdp.productFamily = pf1.id;
        mdp.productId = p1.id;
        mdp.reason1Id = cr1.id;
        mdp.reason2Id = cr2.id;
        
        // We will delete the record before searching for them
        /* database.delete(ce1);
database.delete(pf1);
database.delete(p1);
database.delete(cr1);
database.delete(cr2);*/
        
        // When page loads the sections call the get methods to populate the drop downs
        mdp.toggleCategorySec();                                        // Makes the edit section visible
        mdp.getEventOpts();                                             // Loads Code Events
        mdp.getProductFamiliesOpts();                                   // Loads possible Product Families
        mdp.getProductOpts();                                           // Loads possible Products
        mdp.getReason1Opts();                                           // Loads Code Reason 1 list
        mdp.getReason2Opts();                                           // Loads Code Reason 2 list
        
        Test.stopTest();
    }
    
    
    // This Test function will cover for Product without a Product Family
    static testMethod void ControllerTest3() 
    {
        createCustomSetting();
        // Creating Code Event Record
        Code_Event__c ce1 = new Code_Event__c(Name='Faktura');
        ce1.CaseTypeMultiselect__c = 'Klage';
        //Csphase2 Supriya 29122016
        //ce1.CaseTypeMultiselect__c = 'Complaint';
        ce1.IsActive__c = true;
        insert ce1;
        
        // Creating Product Record
        RecordType rcdtyp = [select id , developerName from RecordType where developerName = 'Product' and sobjectType = 'Service_Product__c' limit 1];
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        Service_Product__c p1 = new Service_Product__c(Name='MyTestProduct', recordTypeId = rcdtyp.id, check_kollinummer__c = true, check_adresseendring__c = true, check_fakturanummer__c = true);
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
        cep1.Service_Product__c = p1.id;/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        cep1.IsActive__c = true;
        database.insert(cep1);
        
        // Creating setup for Product and Code Reason 1
        CodeProdReason__c cpr1 = new CodeProdReason__c();
        cpr1.Henvendelsestype__c = ce1.id;
        cpr1.Service_Product__c = p1.id;/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        cpr1.Code_reason1__c = cr1.id;
        cpr1.IsActive__c = true;
        database.insert(cpr1);
        
        
        // Creating setup for Code Reason 1 and Code Reason 2
        Code_Reason_12__c cr12 = new Code_Reason_12__c();
        cr12.Code_reason1__c = cr1.Id;
        cr12.Code_reason2__c = cr2.Id;
        cr12.Service_Product__c = p1.id;/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        database.insert(cr12);
        
        // Creating Test Case
        Case c1 = new Case();
        c1.recordTypeId = KATSutilities.getRecordType('complaint');
        //c1.Status = 'Ny';
        //Csphase2 Supriya 29122016
        c1.Status = 'New';
        c1.Category__c = 'Invoice';
        insert c1;
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        Case c = [SELECT Code_Event__c,
                  Status, RecordType.DeveloperName,
                  RecordType.Name,
                  Product.Produktfamilie__c,
                  ProductId,
                  Service_Product__r.Produktfamilie__c,
                  Service_Product__c,
                  Code_Reason1__c,
                  Code_Reason2__c,
                  Code_Reason2__r.Name,
                  Shipment_identification__c,
                  get_Queue_Defaults__c,
                  hidden_queue_id__c,
                  Invoice_no__c,
                  change_address_ref_no__c,
                  CaseNumber,
                  Produkt__c,
                  Category__c,
                  reason__c,
                  Party_number__c
                  FROM Case
                  WHERE id = :c1.Id
                 ];
        
        Test.startTest();
        
        // Creating standard controller for the created Case
        ApexPages.StandardController controller = new ApexPages.StandardController(c);
        
        // Creating an instance of the controller class and calling the constructor
        MultilevelDependentPicklist mdp = new MultilevelDependentPicklist(controller);
        
        // Calling the setDefaults function as it is called from the page (Action on load)
        mdp.setDefaultsForHenvendelsestype();
        
        // When page loads the sections call the get methods to populate the drop downs
        mdp.toggleCategorySec();                                        // Makes the edit section visible
        mdp.getEventOpts();                                             // Loads Code Events
        mdp.getProductFamiliesOpts();                                   // Loads possible Product Families
        mdp.getProductOpts();                                           // Loads possible Products
        mdp.getReason1Opts();                                           // Loads Code Reason 1 list
        mdp.getReason2Opts();                                           // Loads Code Reason 2 list
        
        // We will try to Save to check if Validations work
        mdp.Save();
        mdp.SaveAndClose();
        
        // First we select the Code Event and refresh the rest of the sections
        mdp.eventId = ce1.id;
        
        // We will try to Save to check if Validations work
        mdp.Save();
        
        Test.stopTest();
    }
    
    
    // This test script will try to test exception handling
    static testMethod void ControllerTest4() 
    {
        createCustomSetting();
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
        Code_Event__c ce1 = new Code_Event__c(Name='MyTestEvent');
        ce1.CaseTypeMultiselect__c = 'Klage';
        //Csphase2 Supriya 29122016
        //ce1.CaseTypeMultiselect__c = 'Complaint';
        ce1.IsActive__c = true;
        insert ce1;
        
        // Creating Product Family Record
        id prodFamRecId = [select id from RecordType where DeveloperName='Product_Family' and SobjectType='Service_Product__c'].id;//KATSutilities.getRecordType('Product_Family'); added as part of 7th Nov Release
        Service_Product__c pf1 = new Service_Product__c(Name='MyTestProductFamily',recordTypeId = prodFamRecId);/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        insert pf1;
        
        
        // Creating Product Record
        RecordType rcdtyp = [select id , developerName from RecordType where developerName = 'Product' and sobjectType = 'Service_Product__c' limit 1];
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        Service_Product__c p1 = new Service_Product__c(Name='MyTestProduct', Produktfamilie__c = pf1.id, recordTypeId = rcdtyp.id, check_kollinummer__c = true, check_adresseendring__c = true, check_fakturanummer__c = true);
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
        cep1.Service_Product__c  = p1.id;/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        cep1.IsActive__c = true;
        database.insert(cep1);
        
        // Creating setup for Product and Code Reason 1
        CodeProdReason__c cpr1 = new CodeProdReason__c();
        cpr1.Henvendelsestype__c = ce1.id;
        cpr1.Service_Product__c  = p1.id;/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        cpr1.Code_reason1__c = cr1.id;
        cpr1.IsActive__c = true;
        database.insert(cpr1);
        
        
        // Creating setup for Code Reason 1 and Code Reason 2
        Code_Reason_12__c cr12 = new Code_Reason_12__c();
        cr12.Code_reason1__c = cr1.Id;
        cr12.Code_reason2__c = cr2.Id;
        cr12.Service_Product__c  = p1.id;/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        database.insert(cr12);
        
        QueueDetails__c qd1 = new QueueDetails__c();
        qd1.Code_Event__c = ce1.id;
        qd1.Service_Product__c  = p1.id;/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        qd1.Code_Reason1__c = cr1.id;
        qd1.Code_Reason2__c = cr2.id;
        qd1.queue_name__c = 'Test Queue Detail';
        qd1.ownerId = testGroup.id;
        database.insert(qd1);
        
        // Creating Test Case
        Case c1 = new Case();
        c1.recordTypeId = KATSutilities.getRecordType('complaint');
        c1.Status = 'Ny';
        //Csphase2 Supriya 29122016
        c1.Status = 'New';
        c1.Category__c = 'invoice';
        c1.ownerId = testGroup.id;
        insert c1;
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        Case c = [SELECT Code_Event__c,
                  Status,
                  RecordType.Name, RecordType.DeveloperName,
                  Product.Produktfamilie__c,
                  ProductId,
                  Service_Product__r.Produktfamilie__c ,
                  Service_Product__c ,
                  Code_Reason1__c,
                  Code_Reason2__c,
                  Code_Reason2__r.Name,
                  Shipment_identification__c,
                  get_Queue_Defaults__c,
                  hidden_queue_id__c,
                  Invoice_no__c,
                  change_address_ref_no__c,
                  CaseNumber,
                  Produkt__c,
                  Category__c,
                  reason__c,
                  Party_number__c
                  FROM Case
                  WHERE id = :c1.Id
                 ];
        
        Test.startTest();
        
        c.get_Queue_Defaults__c = false;
        
        // Creating standard controller for the created Case
        ApexPages.StandardController controller = new ApexPages.StandardController(c);
        
        // Creating an instance of the controller class and calling the constructor
        MultilevelDependentPicklist mdp = new MultilevelDependentPicklist(controller);
        
        // When page loads the sections call the get methods to populate the drop downs
        mdp.toggleCategorySec();                                        // Makes the edit section visible
        mdp.getEventOpts();                                             // Loads Code Events
        mdp.getProductFamiliesOpts();                                   // Loads possible Product Families
        mdp.getProductOpts();                                           // Loads possible Products
        mdp.getReason1Opts();                                           // Loads Code Reason 1 list
        mdp.getReason2Opts();                                           // Loads Code Reason 2 list
        
        // First we select the Code Event and refresh the rest of the sections
        mdp.eventId = ce1.id;
        mdp.getProductFamiliesOpts();                                   // Loads possible Product Families
        mdp.getProductOpts();                                           // Loads possible Products
        mdp.getReason1Opts();                                           // Loads Code Reason 1 list
        mdp.getReason2Opts();                                           // Loads Code Reason 2 list
        
        c.get_Queue_Defaults__c = true;
        
        // We will remove the Case from the Database.
        // Saving should throw an exception
        Database.delete(c);
        
        mdp.toggleCategorySec();                                        // Makes the edit section visible
        
        // Saving the details on the Case
        mdp.Save();
        
        // Trying to Save and Close
        mdp.SaveAndClose();
        
        // Trying to set defaults
        mdp.setDefaultsForHenvendelsestype();
        
        Test.stopTest();
    }
    
    // This test script will check if Category__c was updated in the background
    // This is for Cases coming in from OEBS
    // This test script will try to test exception handling
    static testMethod void ControllerTest5() 
    {
        createCustomSetting();
        // Creating Code Event Record
        Code_Event__c ce1 = new Code_Event__c(Name='MyTestEvent');
        ce1.CaseTypeMultiselect__c = 'Klage';
        //Csphase2 Supriya 29122016
        //ce1.CaseTypeMultiselect__c = 'Complaint';
        ce1.IsActive__c = true;
        insert ce1;
        
        // Creating Test Case
        Case c1 = new Case();
        c1.recordTypeId = KATSutilities.getRecordType('complaint');
        //c1.Status = 'Ny';
        //Csphase2 Supriya 29122016
        c1.Status = 'New';
        c1.Category__c = 'MyTestEvent';
        database.insert(c1);
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        Case c = [SELECT Code_Event__c,
                  Status, RecordType.DeveloperName,
                  RecordType.Name,
                  Product.Produktfamilie__c,
                  ProductId,
                  Service_Product__r.Produktfamilie__c,
                  Service_Product__c,
                  Code_Reason1__c,
                  Code_Reason2__c,
                  Code_Reason2__r.Name,
                  Shipment_identification__c,
                  get_Queue_Defaults__c,
                  hidden_queue_id__c,
                  Invoice_no__c,
                  change_address_ref_no__c,
                  CaseNumber,
                  Produkt__c,
                  Category__c,
                  reason__c,
                  Party_number__c
                  FROM Case
                  WHERE id = :c1.Id
                 ];
        
        Test.startTest();
        
        
        // Making sure that defaults are not set this time
        c.get_Queue_Defaults__c = false;
        
        // Creating standard controller for the created Case
        ApexPages.StandardController controller = new ApexPages.StandardController(c);
        
        // Creating an instance of the controller class and calling the constructor
        MultilevelDependentPicklist mdp = new MultilevelDependentPicklist(controller);
        
        // Calling the setDefaults function as it is called from the page (Action on load)
        mdp.setDefaultsForHenvendelsestype();
        
        Test.stopTest();
    }
    
    
    
    
    static testMethod void ControllerTest6() 
        
    {
        createCustomSetting();
        crm_AccountRecordTypes__c rr = new crm_AccountRecordTypes__c();
        rr.Name = 'Relation level Customer';
        rr.crm_Record_Type_Label__c ='Relation level Customer';
        insert rr;
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
        Code_Event__c ce1 = new Code_Event__c(Name='MyTestEvent');
         ce1.CaseTypeMultiselect__c = 'Klage';
        //Csphase2 Supriya 29122016
        //ce1.CaseTypeMultiselect__c = 'Complaint';
        ce1.IsActive__c = true;
        insert ce1;
        
        // Creating Product Family Record
        id prodFamRecId = [select id from RecordType where DeveloperName='Product_Family' and SobjectType='Service_Product__c'].id;//KATSutilities.getRecordType('Product_Family'); added as part of 7th Nov Release
        Service_Product__c pf1 = new Service_Product__c(Name='Gods Nasjonalt',recordTypeId = prodFamRecId);/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        insert pf1;
        
        
        // Creating Product Record
        RecordType rcdtyp = [select id , developerName from RecordType where developerName = 'Product' and sobjectType = 'Service_Product__c' limit 1];
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        Service_Product__c p1 = new Service_Product__c(Name='MyTestProduct', Produktfamilie__c = pf1.id, recordTypeId = rcdtyp.id, check_kollinummer__c = true, check_adresseendring__c = true, check_fakturanummer__c = true);
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
        cep1.Service_Product__c = p1.id;/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        cep1.IsActive__c = true;
        database.insert(cep1);
        
        // Creating setup for Product and Code Reason 1
        CodeProdReason__c cpr1 = new CodeProdReason__c();
        cpr1.Henvendelsestype__c = ce1.id;
        cpr1.Service_Product__c = p1.id;/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        cpr1.Code_reason1__c = cr1.id;
        cpr1.IsActive__c = true;
        database.insert(cpr1);
        
        
        // Creating setup for Code Reason 1 and Code Reason 2
        Code_Reason_12__c cr12 = new Code_Reason_12__c();
        cr12.Code_reason1__c = cr1.Id;
        cr12.Code_reason2__c = cr2.Id;
        cr12.Service_Product__c = p1.id;/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        database.insert(cr12);
        
        
        QueueDetails__c qd1 = new QueueDetails__c();
        qd1.Code_Event__c = ce1.id;
        qd1.Service_Product__c = p1.id;
        qd1.Code_Reason1__c = cr1.id;
        qd1.Code_Reason2__c = cr2.id;
        qd1.queue_name__c = 'Test Queue Detail';
        qd1.ownerId = testGroup.id;
        database.insert(qd1);
        
        Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        Account a = new Account(Name = 'TestAccount',crm_customer_number__c = 'BLNOCTest');
        a.recordtypeid= recordtypeid;
        insert a;
        
        // Creating Test Case
        Case c1 = new Case();
        c1.recordTypeId = KATSutilities.getRecordType('complaint');
        //c1.Status = 'Ny';
        //Cspahse2 Supriya 29122016
        c1.status='New';
        c1.Category__c = 'MyTestEvent';
        c1.OwnerId = testGroup.id;
        c1.AccountId = a.id;
        insert c1;
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        Case c = [SELECT Code_Event__c,
                  Status, RecordType.DeveloperName,
                  RecordType.Name,
                  Party_number__c,
                  Product.Produktfamilie__c,
                  ProductId,
                  Service_Product__r.Produktfamilie__c,
                  Service_Product__c,
                  Code_Reason1__c,
                  Code_Reason2__c,
                  Code_Reason2__r.Name,
                  Shipment_identification__c,
                  get_Queue_Defaults__c,
                  hidden_queue_id__c,
                  Invoice_no__c,
                  change_address_ref_no__c,
                  CaseNumber,
                  Produkt__c,
                  Category__c,
                  reason__c,
                  Product.Produktfamilie__r.Name,
                  Service_Product__r.Produktfamilie__r.Name
                  FROM Case
                  WHERE id = :c1.Id
                 ];
        
        Test.startTest();
        
        // Creating standard controller for the created Case
        ApexPages.StandardController controller = new ApexPages.StandardController(c);
        
        // Creating an instance of the controller class and calling the constructor
        MultilevelDependentPicklist mdp = new MultilevelDependentPicklist(controller);
        
        // Calling the setDefaults function as it is called from the page (Action on load)
        mdp.setDefaultsForHenvendelsestype();
        
        // When page loads the sections call the get methods to populate the drop downs
        mdp.toggleCategorySec();                                        // Makes the edit section visible
        mdp.getEventOpts();                                             // Loads Code Events
        mdp.getProductFamiliesOpts();                                   // Loads possible Product Families
        mdp.getProductOpts();                                           // Loads possible Products
        mdp.getReason1Opts();                                           // Loads Code Reason 1 list
        mdp.getReason2Opts();                                           // Loads Code Reason 2 list
        
        // First we select the Code Event and refresh the rest of the sections
        mdp.eventId = ce1.id;
        mdp.getProductFamiliesOpts();                                   // Loads possible Product Families
        mdp.getProductOpts();                                           // Loads possible Products
        mdp.getReason1Opts();                                           // Loads Code Reason 1 list
        mdp.getReason2Opts();                                           // Loads Code Reason 2 list
        
        // Saving the details on the Case
        mdp.Save();
        
        // We will not re-open the Case page to load this section again
        controller = new ApexPages.StandardController(c);
        mdp = new MultilevelDependentPicklist(controller);
        
        mdp.toggleCategorySec();                                        // Makes the edit section visible
        mdp.getEventOpts();                                             // Loads Code Events
        mdp.getProductFamiliesOpts();                                   // Loads possible Product Families
        mdp.getProductOpts();                                           // Loads possible Products
        mdp.getReason1Opts();                                           // Loads Code Reason 1 list
        mdp.getReason2Opts();                                           // Loads Code Reason 2 list
        
        mdp.SaveAndClose();                                             // We will just Save and Close the Case
        
        //Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        Account a1 = new Account(Name = 'TestAccount',crm_customer_number__c = '123456');
        a1.recordtypeid= Recordtypeid;
        insert a1;
        c1.AccountId = a1.id;
        database.update(c1);
        
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        c = [SELECT Code_Event__c,
             Status, RecordType.DeveloperName,
             RecordType.Name,
             Party_number__c,
             Product.Produktfamilie__c,
             ProductId,
             Service_Product__r.Produktfamilie__c,
             Service_Product__c,
             Code_Reason1__c,
             Code_Reason2__c,
             Code_Reason2__r.Name,
             Shipment_identification__c,
             get_Queue_Defaults__c,
             hidden_queue_id__c,
             Invoice_no__c,
             change_address_ref_no__c,
             CaseNumber,
             Produkt__c,
             Category__c,
             reason__c,
             Product.Produktfamilie__r.Name,
             Service_Product__r.Produktfamilie__r.Name
             FROM Case
             WHERE id = :c1.Id
            ];
        
        // Now we will open the Case again and this time for a Closed Case
        controller = new ApexPages.StandardController(c);
        mdp = new MultilevelDependentPicklist(controller);
        
        
        Test.stopTest();
        
        
    }
    
    
    
    static testMethod void ControllerTest7() 
    {
        createCustomSetting();    
        crm_AccountRecordTypes__c rr = new crm_AccountRecordTypes__c();
        rr.Name = 'Relation level Customer';
        rr.crm_Record_Type_Label__c ='Relation level Customer';
        insert rr;
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
        Code_Event__c ce1 = new Code_Event__c(Name='MyTestEvent');
        ce1.CaseTypeMultiselect__c = 'Klage';
        //Csphase2 Supriya 29122016
        //ce1.CaseTypeMultiselect__c = 'Complaint';
        ce1.IsActive__c = true;
        insert ce1;
        
        // Creating Product Family Record
        id prodFamRecId = [select id from RecordType where DeveloperName='Product_Family' and SobjectType='Service_Product__c'].id;//KATSutilities.getRecordType('Product_Family'); added as part of 7th Nov Release
        Service_Product__c pf1 = new Service_Product__c(Name='Gods Nasjonalt',recordTypeId = prodFamRecId);/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        insert pf1;
        
        
        // Creating Product Record
        RecordType rcdtyp = [select id , developerName from RecordType where developerName = 'Product' and sobjectType = 'Service_Product__c' limit 1];
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        Service_Product__c p1 = new Service_Product__c(Name='MyTestProduct', Produktfamilie__c = pf1.id, recordTypeId = rcdtyp.id, check_kollinummer__c = true, check_adresseendring__c = true, check_fakturanummer__c = true);
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
        cep1.Service_Product__c = p1.id;/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        cep1.IsActive__c = true;
        database.insert(cep1);
        
        // Creating setup for Product and Code Reason 1
        CodeProdReason__c cpr1 = new CodeProdReason__c();
        cpr1.Henvendelsestype__c = ce1.id;
        cpr1.Service_Product__c = p1.id;/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        cpr1.Code_reason1__c = cr1.id;
        cpr1.IsActive__c = true;
        database.insert(cpr1);
        
        
        // Creating setup for Code Reason 1 and Code Reason 2
        Code_Reason_12__c cr12 = new Code_Reason_12__c();
        cr12.Code_reason1__c = cr1.Id;
        cr12.Code_reason2__c = cr2.Id;
        cr12.Service_Product__c = p1.id;/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        database.insert(cr12);
        
        
        QueueDetails__c qd1 = new QueueDetails__c();
        qd1.Code_Event__c = ce1.id;
        qd1.Service_Product__c = p1.id;/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        qd1.Code_Reason1__c = cr1.id;
        qd1.Code_Reason2__c = cr2.id;
        qd1.queue_name__c = 'Test Queue Detail';
        qd1.ownerId = testGroup.id;
        database.insert(qd1);
        
        Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        Account a = new Account(Name = 'TestAccount',crm_customer_number__c = 'BLNOCTest');
        a.recordtypeid= recordtypeid;
        insert a;
        
        // Creating Test Case
        Case c1 = new Case();
        c1.recordTypeId = KATSutilities.getRecordType('complaint');
        //c1.Status = 'Ny';
        //cpahse2 Supriya 29122016
        c1.status='New';
        c1.Category__c = 'MyTestEvent';
        c1.OwnerId = testGroup.id;
        c1.AccountId = a.id;
        c1.Code_Event__c = ce1.id;
        // c1.Product.Produktfamilie__c = pf1.id;
        c1.Service_Product__c = p1.id;
        
        c1.AccountId = a.id;  
        insert c1;
        
        
        
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        Case c = [SELECT Code_Event__c,
                  Status, RecordType.DeveloperName,
                  RecordType.Name,
                  Party_number__c,
                  Product.Produktfamilie__c,
                  ProductId,
                  Service_Product__r.Produktfamilie__c,
                  Service_Product__c,
                  Code_Reason1__c,
                  Code_Reason2__c,
                  Code_Reason2__r.Name,
                  Shipment_identification__c,
                  get_Queue_Defaults__c,
                  hidden_queue_id__c,
                  Invoice_no__c,
                  change_address_ref_no__c,
                  CaseNumber,
                  Produkt__c,
                  Category__c,
                  reason__c,
                  Product.Produktfamilie__r.Name,
                  Service_Product__r.Produktfamilie__r.Name
                  FROM Case
                  WHERE id = :c1.Id
                 ];
        
        Test.startTest();
        
        // Creating standard controller for the created Case
        ApexPages.StandardController controller = new ApexPages.StandardController(c);
        
        // Creating an instance of the controller class and calling the constructor
        MultilevelDependentPicklist mdp = new MultilevelDependentPicklist(controller);
        
        // Calling the setDefaults function as it is called from the page (Action on load)
        //mdp.setDefaultsForHenvendelsestype();
        
        // When page loads the sections call the get methods to populate the drop downs
        mdp.toggleCategorySec();                                        // Makes the edit section visible
        mdp.getEventOpts();                                             // Loads Code Events
        mdp.getProductFamiliesOpts();                                   // Loads possible Product Families
        mdp.getProductOpts();                                           // Loads possible Products
        mdp.getReason1Opts();                                           // Loads Code Reason 1 list
        mdp.getReason2Opts();                                           // Loads Code Reason 2 list
        
        // First we select the Code Event and refresh the rest of the sections
        mdp.eventId = ce1.id;
        mdp.getProductFamiliesOpts();                                   // Loads possible Product Families
        mdp.getProductOpts();                                           // Loads possible Products
        mdp.getReason1Opts();                                           // Loads Code Reason 1 list
        mdp.getReason2Opts();                                           // Loads Code Reason 2 list
        
        // Saving the details on the Case
        mdp.Save();
        
        // We will not re-open the Case page to load this section again
        controller = new ApexPages.StandardController(c);
        mdp = new MultilevelDependentPicklist(controller);
        
        mdp.toggleCategorySec();                                        // Makes the edit section visible
        mdp.getEventOpts();                                             // Loads Code Events
        mdp.getProductFamiliesOpts();                                   // Loads possible Product Families
        mdp.getProductOpts();                                           // Loads possible Products
        mdp.getReason1Opts();                                           // Loads Code Reason 1 list
        mdp.getReason2Opts();                                           // Loads Code Reason 2 list
        
        mdp.SaveAndClose();                                             // We will just Save and Close the Case
        
       // Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        Account a1 = new Account(Name = 'TestAccount',crm_customer_number__c = '123456');
        a1.recordtypeid=recordtypeid;
        insert a1;
        c1.AccountId = a1.id;
        database.update(c1);
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        c = [SELECT Code_Event__c,
             Status, RecordType.DeveloperName,
             RecordType.Name,
             Party_number__c,
             Product.Produktfamilie__c,
             ProductId,
             Service_Product__r.Produktfamilie__c,
             Service_Product__c,
             Code_Reason1__c,
             Code_Reason2__c,
             Code_Reason2__r.Name,
             Shipment_identification__c,
             get_Queue_Defaults__c,
             hidden_queue_id__c,
             Invoice_no__c,
             change_address_ref_no__c,
             CaseNumber,
             Produkt__c,
             Category__c,
             reason__c,
             Product.Produktfamilie__r.Name,
             Service_Product__r.Produktfamilie__r.Name
             FROM Case
             WHERE id = :c1.Id
            ];
        
        // Now we will open the Case again and this time for a Closed Case
        controller = new ApexPages.StandardController(c);
        mdp = new MultilevelDependentPicklist(controller);
        
        mdp.toggleCategorySec();                                        // Makes the edit section visible
        mdp.getEventOpts();                                             // Loads Code Events
        mdp.getProductFamiliesOpts();                                   // Loads possible Product Families
        mdp.getProductOpts();                                           // Loads possible Products
        mdp.getReason1Opts();                                           // Loads Code Reason 1 list
        mdp.getReason2Opts();                                           // Loads Code Reason 2 list
        
        // First we select the Code Event and refresh the rest of the sections
        mdp.eventId = ce1.id;
        mdp.getProductFamiliesOpts();                                   // Loads possible Product Families
        mdp.getProductOpts();                                           // Loads possible Products
        mdp.getReason1Opts();                                           // Loads Code Reason 1 list
        mdp.getReason2Opts();                                           // Loads Code Reason 2 list
        
        
        Test.stopTest();
        
        
    }
    
    
    static testMethod void ControllerTest8() 
    {
        createCustomSetting();    
        crm_AccountRecordTypes__c rr = new crm_AccountRecordTypes__c();
        rr.Name = 'Relation level Customer';
        rr.crm_Record_Type_Label__c ='Relation level Customer';
        insert rr;
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
        Code_Event__c ce1 = new Code_Event__c(Name='Behovsavdekking');
        ce1.CaseTypeMultiselect__c = 'Klage';
        //Csphase2 Supriya 29122016
        //ce1.CaseTypeMultiselect__c = 'Complaint';
        ce1.IsActive__c = true;
        insert ce1;
        
        // Creating Product Family Record
        id prodFamRecId = [select id from RecordType where DeveloperName='Product_Family' and SobjectType='Service_Product__c'].id;//KATSutilities.getRecordType('Product_Family'); added as part of 7th Nov Release
        Service_Product__c pf1 = new Service_Product__c(Name='Gods Nasjonalt',recordTypeId = prodFamRecId);/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        insert pf1;
        
        
        // Creating Product Record
        RecordType rcdtyp = [select id , developerName from RecordType where developerName = 'Product' and sobjectType = 'Service_Product__c' limit 1];
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        Service_Product__c p1 = new Service_Product__c(Name='MyTestProduct', Produktfamilie__c = pf1.id, recordTypeId = rcdtyp.id, check_kollinummer__c = true, check_adresseendring__c = true, check_fakturanummer__c = true);
        insert p1;       
        
        // Creating Code Reason 1 Record
        Code_Reason1__c cr1 = new Code_Reason1__c(Name='Leads til salg');
        insert cr1;
        
        // Creating Code Reason 2 Record
        Code_Reason2__c cr2 = new Code_Reason2__c(Name='MyTestReason2');
        insert cr2;
        
        // Creating setup for Code Event and Product
        Code_Event_Prod__c cep1 = new Code_Event_Prod__c();
        cep1.Code_Event__c = ce1.id;
        cep1.Service_Product__c = p1.id;/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        cep1.IsActive__c = true;
        database.insert(cep1);
        
        // Creating setup for Product and Code Reason 1
        CodeProdReason__c cpr1 = new CodeProdReason__c();
        cpr1.Henvendelsestype__c = ce1.id;
        cpr1.Service_Product__c = p1.id;/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        cpr1.Code_reason1__c = cr1.id;
        cpr1.IsActive__c = true;
        database.insert(cpr1);
        
        
        // Creating setup for Code Reason 1 and Code Reason 2
        Code_Reason_12__c cr12 = new Code_Reason_12__c();
        cr12.Code_reason1__c = cr1.Id;
        cr12.Code_reason2__c = cr2.Id;
        cr12.Service_Product__c = p1.id;/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        database.insert(cr12);
        
        
        QueueDetails__c qd1 = new QueueDetails__c();
        qd1.Code_Event__c = ce1.id;
        qd1.Service_Product__c = p1.id;/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        qd1.Code_Reason1__c = cr1.id;
        qd1.Code_Reason2__c = cr2.id;
        qd1.queue_name__c = 'Test Queue Detail';
        qd1.ownerId = testGroup.id;
        database.insert(qd1);
        
        Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        Account a = new Account(Name = 'TestAccount',crm_customer_number__c = 'BLNOCTest',Orga__c='999');
        a.recordtypeid= recordtypeid;
        insert a;
        
        // Creating Test Case
        Case c1 = new Case();
        c1.AccountEmail__c='test@test.com';
        c1.AccountPhone__c='75500000';
        c1.subject='test Subject';
        c1.LM_current_postal_address__c='LM_current_postal_address__c';
        c1.LM_current_country__c='LM_current_country__c';
        c1.description='description';
        c1.LM_current_zip_code__c='4028';
        c1.recordTypeId = KATSutilities.getRecordType('complaint');
        //c1.Status = 'Ny';
        //cpahse2 Supriya 29122016
        c1.status='New';
        c1.Category__c = 'MyTestEvent';
        c1.OwnerId = testGroup.id;
        c1.AccountId = a.id;
        c1.Code_Event__c = ce1.id;
        // c1.Product.Produktfamilie__c = pf1.id;
        c1.Service_Product__c = p1.id;
        c1.Code_Reason1__c = cr1.id;
        
        c1.AccountId = a.id;  
        insert c1;
        
        
        
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        Case c = [SELECT Code_Event__c,
                  Status, RecordType.DeveloperName,
                  RecordType.Name,
                  Party_number__c,
                  Product.Produktfamilie__c,
                  ProductId,
                  Service_Product__r.Produktfamilie__c,
                  Service_Product__c,
                  Code_Reason1__c,
                  Code_Reason2__c,
                  Code_Reason2__r.Name,
                  Shipment_identification__c,
                  get_Queue_Defaults__c,
                  hidden_queue_id__c,
                  Invoice_no__c,
                  change_address_ref_no__c,
                  CaseNumber,
                  Produkt__c,
                  Category__c,
                  reason__c,
                  Product.Produktfamilie__r.Name,
                  Service_Product__r.Produktfamilie__r.Name,
                  description,AccountPhone__c,subject,LM_current_postal_address__c,LM_current_country__c,AccountEmail__c,LM_current_zip_code__c,Accountid,Code_Event__r.name
                  FROM Case
                  WHERE id = :c1.Id
                 ];
        
        //system.debug('MS Test '+c.Accountid);
        //system.debug('MS Test '+c.Account.Recordtypeid);
        //system.debug('MS Test '+KATSutilities.getRecordType('crm_Party_level_Customer'));
        
        Test.startTest();
        
        // Creating standard controller for the created Case
        ApexPages.StandardController controller = new ApexPages.StandardController(c);
        
        // Creating an instance of the controller class and calling the constructor
        MultilevelDependentPicklist mdp = new MultilevelDependentPicklist(controller);
        
        // Calling the setDefaults function as it is called from the page (Action on load)
        //mdp.setDefaultsForHenvendelsestype();
        
        // When page loads the sections call the get methods to populate the drop downs
        mdp.toggleCategorySec();                                        // Makes the edit section visible
        mdp.getEventOpts();                                             // Loads Code Events
        mdp.getProductFamiliesOpts();                                   // Loads possible Product Families
        mdp.getProductOpts();                                           // Loads possible Products
        mdp.getReason1Opts();                                           // Loads Code Reason 1 list
        mdp.getReason2Opts();                                           // Loads Code Reason 2 list
        
        // First we select the Code Event and refresh the rest of the sections
        mdp.eventId = ce1.id;
        mdp.getProductFamiliesOpts();                                   // Loads possible Product Families
        mdp.getProductOpts();                                           // Loads possible Products
        mdp.getReason1Opts();                                           // Loads Code Reason 1 list
        mdp.getReason2Opts();                                           // Loads Code Reason 2 list
        
        // Saving the details on the Case
        mdp.Save();
        
        // We will not re-open the Case page to load this section again
        controller = new ApexPages.StandardController(c);
        mdp = new MultilevelDependentPicklist(controller);
        
        mdp.toggleCategorySec();                                        // Makes the edit section visible
        mdp.getEventOpts();                                             // Loads Code Events
        mdp.getProductFamiliesOpts();                                   // Loads possible Product Families
        mdp.getProductOpts();                                           // Loads possible Products
        mdp.getReason1Opts();                                           // Loads Code Reason 1 list
        mdp.getReason2Opts();                                           // Loads Code Reason 2 list
        
        mdp.SaveAndClose();                                             // We will just Save and Close the Case
        
       // Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        Account a1 = new Account(Name = 'TestAccount',crm_customer_number__c = '123456');
        a1.recordtypeid=recordtypeid;
        insert a1;
        c1.AccountId = a1.id;
        database.update(c1);
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        c = [SELECT Code_Event__c,
             Status, RecordType.DeveloperName,
             RecordType.Name,
             Party_number__c,
             Product.Produktfamilie__c,
             ProductId,
             Service_Product__r.Produktfamilie__c,
             Service_Product__c,
             Code_Reason1__c,
             Code_Reason2__c,
             Code_Reason2__r.Name,
             Shipment_identification__c,
             get_Queue_Defaults__c,
             hidden_queue_id__c,
             Invoice_no__c,
             change_address_ref_no__c,
             CaseNumber,
             Produkt__c,
             Category__c,
             reason__c,
             Product.Produktfamilie__r.Name,
             Service_Product__r.Produktfamilie__r.Name
             FROM Case
             WHERE id = :c1.Id
            ];
        
        // Now we will open the Case again and this time for a Closed Case
        controller = new ApexPages.StandardController(c);
        mdp = new MultilevelDependentPicklist(controller);
        
        mdp.toggleCategorySec();                                        // Makes the edit section visible
        mdp.getEventOpts();                                             // Loads Code Events
        mdp.getProductFamiliesOpts();                                   // Loads possible Product Families
        mdp.getProductOpts();                                           // Loads possible Products
        mdp.getReason1Opts();                                           // Loads Code Reason 1 list
        mdp.getReason2Opts();                                           // Loads Code Reason 2 list
        
        // First we select the Code Event and refresh the rest of the sections
        mdp.eventId = ce1.id;
        mdp.getProductFamiliesOpts();                                   // Loads possible Product Families
        mdp.getProductOpts();                                           // Loads possible Products
        mdp.getReason1Opts();                                           // Loads Code Reason 1 list
        mdp.getReason2Opts();                                           // Loads Code Reason 2 list
        
        Test.stopTest();
        
        
    }
    
    
    // END OF TEST SCRIPT
    
    static testMethod void createCustomSetting() {
        List<cs_CaseRecordTypeToEnquiryTypMap__c> lcs = new List<cs_CaseRecordTypeToEnquiryTypMap__c>();
        
        cs_CaseRecordTypeToEnquiryTypMap__c cs1 = new cs_CaseRecordTypeToEnquiryTypMap__c();
        cs1.Name = 'campaign';
        cs1.cs_Code_Event_Api__c =' Kampanje';
        lcs.add(cs1);
        
        cs_CaseRecordTypeToEnquiryTypMap__c cs2 = new cs_CaseRecordTypeToEnquiryTypMap__c();
        cs2.Name = 'Cargo_Claims';
        cs2.cs_Code_Event_Api__c ='Reklamasjon Gods';
        lcs.add(cs2);
        
        cs_CaseRecordTypeToEnquiryTypMap__c cs3 = new cs_CaseRecordTypeToEnquiryTypMap__c();
        cs3.Name = 'complaint';
        cs3.cs_Code_Event_Api__c =' Klage';
        lcs.add(cs3);
        
        cs_CaseRecordTypeToEnquiryTypMap__c cs4 = new cs_CaseRecordTypeToEnquiryTypMap__c();
        cs4.Name = 'deviation_case';
        cs4.cs_Code_Event_Api__c =' Avvik';
        lcs.add(cs4);
        
        cs_CaseRecordTypeToEnquiryTypMap__c cs5 = new cs_CaseRecordTypeToEnquiryTypMap__c();
        cs5.Name = 'distribution_plan_case';
        cs5.cs_Code_Event_Api__c =' Avtale';
        lcs.add(cs5);
        
        cs_CaseRecordTypeToEnquiryTypMap__c cs6 = new cs_CaseRecordTypeToEnquiryTypMap__c();
        cs6.Name = 'Gjenligg';
        cs6.cs_Code_Event_Api__c =' Gjenligg';
        lcs.add(cs6);
        
        cs_CaseRecordTypeToEnquiryTypMap__c cs7 = new cs_CaseRecordTypeToEnquiryTypMap__c();
        cs7.Name = 'internal_support    ';
        cs7.cs_Code_Event_Api__c =' Internsupport';
        lcs.add(cs7);
        
        cs_CaseRecordTypeToEnquiryTypMap__c cs8 = new cs_CaseRecordTypeToEnquiryTypMap__c();
        cs8.Name = 'Internsupport';
        cs8.cs_Code_Event_Api__c =' Avvik';
        lcs.add(cs8);
        
        cs_CaseRecordTypeToEnquiryTypMap__c cs9 = new cs_CaseRecordTypeToEnquiryTypMap__c();
        cs9.Name = 'planned_distribution_case';
        cs9.cs_Code_Event_Api__c =' Bestillinger';
        lcs.add(cs9);
        
        cs_CaseRecordTypeToEnquiryTypMap__c cs10 = new cs_CaseRecordTypeToEnquiryTypMap__c();
        cs10.Name = 'simple_inquiry';
        cs10.cs_Code_Event_Api__c ='Rådgivning/Informasjon';
        lcs.add(cs10);
        
        insert lcs;
    }
    
}