@isTest
public class zzz_Case_CleanUpRecords {
    
    static testMethod void testMethod1() {
        
        environment_settings__c envSetting = new environment_settings__c();
        envSetting.Name = 'BatchEmailNotification'; 
     // envSetting.ReplyToEmailAddress__c = 'test.salesforce@tcs.com';
        envSetting.value__c = 'test@posten.no';
        insert envSetting;
        QueueSobject queue = [Select QueueId from QueueSobject where Queue.DeveloperName = 'anonymize_cases' and SobjectType='Case' limit 1];
        
        
        Case_Anonymisation_Days__c datesetting = new Case_Anonymisation_Days__c();
        datesetting.Name = 'Default';
        datesetting.Number_Of_Days__c = 1277;
        datesetting.QueueId__c = queue.QueueId;
        datesetting.queue_name__c = 'anonymize_cases';
        insert datesetting;
        
        
            Case sampleCase = new Case();
            sampleCase.AccountEmail__c = 'sampleemail@abc.com';
            sampleCase.SuppliedEmail = 'sampleemail@abc.com';            
            sampleCase.Origin = 'Manuelt';           
        
            insert sampleCase;
           
        
        CaseComment comment = new CaseComment();
        comment.CommentBody = 'test';
        comment.ParentId = sampleCase.Id;
        insert comment;
        
         // Creating Code Event Record
        Code_Event__c ce1 = new Code_Event__c(Name='MyTestEvent');
        ce1.CaseTypeMultiselect__c = 'Klage';
        //CSpahse2 Supriya 29122016
        //ce1.CaseTypeMultiselect__c = 'Complaint';
        ce1.IsActive__c = true;
        insert ce1;
        
        // Creating Product Family Record
        id prodFamRecId = [select id from RecordType where DeveloperName='Product_Family' and SobjectType='Service_Product__c'].id;//KATSutilities.getRecordType('Product_Family'); added as part of 7th Nov Release
        Service_Product__c pf1 = new Service_Product__c(Name='MyTestProductFamily',recordTypeId = prodFamRecId); /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        insert pf1;
        
        
        // Creating Product Record
        RecordType rcdtyp = [select id , developerName from RecordType where developerName = 'Product' and sobjectType = 'Service_Product__c' limit 1];
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        Service_Product__c p1 = new Service_Product__c(Name='MyTestProduct', Produktfamilie__c = pf1.id, recordTypeId = rcdtyp.id, check_kollinummer__c = true, check_adresseendring__c = true, check_fakturanummer__c = true);
        insert p1;       
        
        // Creating Code Reason 1 Record
        Code_Reason1__c cr1 = new Code_Reason1__c(Name='MyTestReason1');
        insert cr1;
        
        // Creating Code Reason 2 Record
        Code_Reason2__c cr2 = new Code_Reason2__c(Name='MyTestReason2');
        insert cr2;
        
        
        sampleCase.Description = 'Testing';
        sampleCase.Code_Event__c = ce1.id;
        sampleCase.Service_Product__c = pf1.id;
        sampleCase.Produkt__c = p1.id;
        sampleCase.Code_Reason1__c= cr1.id;
        sampleCase.Code_Reason2__c = cr2.id;
        sampleCase.isanonymized__c = true;
        //sampleCase.Status = 'Closed';
        update sampleCase;   
        
        
            Case sampleCase1 = new Case();
            sampleCase1.AccountEmail__c = 'sampleemail@abc.com';
            sampleCase1.SuppliedEmail = 'sampleemail@abc.com';            
            sampleCase1.Origin = 'Manuelt';           
        
            insert sampleCase1;
           
        
        CaseComment comment1 = new CaseComment();
        comment1.CommentBody = 'test';
        comment1.ParentId = sampleCase1.Id;
        insert comment1;
        
        sampleCase1.Description = 'Testing';
        sampleCase1.Code_Event__c = ce1.id;
        sampleCase1.Service_Product__c = pf1.id;
        sampleCase1.Produkt__c = p1.id;
        sampleCase1.reason__c = 'Delivery time';
        sampleCase1.Code_Reason2__c =cr2.id;
        sampleCase1.isanonymized__c = true;
        sampleCase1.Status = 'Closed';
        update sampleCase1;   
        
          
             
        database.executeBatch(new Case_CleanUpRecords());  
        
        database.executeBatch(new Case_CleanUpRecords_CaseHistory());      
  
    }
}