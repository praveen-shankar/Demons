/* Created By: Bhavani Prasad 
Test class: Test class for crm_Event_SendToNPS
*/
@isTest
public class crm_Event_SendToNPS_Test {
    static testMethod void noNPSsettings() {
    
        crm_TestDataFactory.CreateCustomSetting();
        delete crm_nps_settings_sales__c.getall().values();
        crm_nps_settings_sales__c nps = new crm_nps_settings_sales__c(name='Medallia', endpoint_url__c='TestEndpoint', Password__c='Pass123', Username__c='TestUser',client_certificate__c='crm_NPS_Certificate_Sales');
        List<crm_nps_settings_sales__c> npsList = new List<crm_nps_settings_sales__c>();
        npsList.add(nps);
        insert npsList;
        
        User testUser = KatsTestUtilities.getTestKundekonsulentUser();
        Account a = KatsTestUtilities.getTestBusinessAccount();
        Contact c = KatsTestUtilities.getTestContact();
        
        Event e1 = new Event(subject='Test',crm_Interaction_Type__c='Phone',crm_Interaction_Type_Category__c='Sales Meeting',crm_NPS_Status__c='',whatid=a.id, whoid=c.id, DurationInMinutes=30, startDateTime=System.today()-2);
        List<Id> eventIds = new List<Id>();
        test.startTest();
            insert e1;
            eventIds.add(e1.id);
            crm_Event_SendToNPS.sendEventsToNPS(eventIds);
        test.stopTest();
        
        //Control
        Event testEvent = [SELECT crm_NPS_Status__c, id FROM Event WHERE id = :e1.id];
        system.assertEquals(testEvent.crm_NPS_Status__c, crm_Event_SendToNPS.NPS_NO_SETTINGS);
    }
    
     static testMethod void sendRecordToNPS() {
        
        crm_TestDataFactory.CreateCustomSetting();
        delete crm_nps_settings_sales__c.getall().values();
        crm_nps_settings_sales__c nps = new crm_nps_settings_sales__c(name='Medallia', endpoint_url__c='TestEndpoint', Password__c='Pass123', Username__c='TestUser',Send_to_NPS__c = true, client_certificate__c='crm_NPS_Certificate_Sales');
        List<crm_nps_settings_sales__c> npsList = new List<crm_nps_settings_sales__c>();
        npsList.add(nps);
        insert npsList;
        
        User testUser = KatsTestUtilities.getTestKundekonsulentUser();
        Account a = KatsTestUtilities.getTestBusinessAccount();
        Contact c = KatsTestUtilities.getTestContact();
        
        Event e1 = new Event(subject='Test',crm_Interaction_Type__c='Phone',crm_Interaction_Type_Category__c='Sales Meeting',crm_NPS_Status__c='',whatid=a.id, whoid=c.id, DurationInMinutes=30, startDateTime=System.today()-2);
        List<Id> eventIds = new List<Id>();
        test.startTest();
            insert e1;
            eventIds.add(e1.id);
            crm_Event_SendToNPS.sendEventsToNPS(eventIds);
        test.stopTest();
        
        //Control
        Event testEvent = [SELECT crm_NPS_Status__c, id FROM Event WHERE id = :e1.id];
        //system.assertEquals(testEvent.crm_NPS_Status__c, crm_Event_SendToNPS.NPS_SUCCESS);
    }
    
    static testMethod void sendMultipleRecordToNPS() {
        
        crm_TestDataFactory.CreateCustomSetting();
        delete crm_nps_settings_sales__c.getall().values();
        crm_nps_settings_sales__c nps = new crm_nps_settings_sales__c(name='Medallia', endpoint_url__c='TestEndpoint', Password__c='Pass123', Username__c='TestUser',Send_to_NPS__c = true,client_certificate__c='crm_NPS_Certificate_Sales' );
        List<crm_nps_settings_sales__c> npsList = new List<crm_nps_settings_sales__c>();
        npsList.add(nps);
        insert npsList;
        
        User testUser = KatsTestUtilities.getTestKundekonsulentUser();
        Account a = KatsTestUtilities.getTestBusinessAccount();
        Contact c = KatsTestUtilities.getTestContact();
        
        Event e1 = new Event(subject='Test',crm_Interaction_Type__c='Phone',crm_Interaction_Type_Category__c='Sales Meeting',crm_NPS_Status__c='',whatid=a.id, whoid=c.id, DurationInMinutes=30, startDateTime=System.today()-2);
        Event e2 = new Event(subject='Test1',crm_Interaction_Type__c='Phone',crm_Interaction_Type_Category__c='Sales Meeting',crm_NPS_Status__c='',whatid=a.id, whoid=c.id, DurationInMinutes=30, startDateTime=System.today()-3);
        Event e3 = new Event(subject='Test2',crm_Interaction_Type__c='Phone',crm_Interaction_Type_Category__c='Sales Meeting',crm_NPS_Status__c='',whatid=a.id, whoid=c.id, DurationInMinutes=30, startDateTime=System.today()-1);
        List<Id> eventIds = new List<Id>();
        List<Event> events = new List<Event>();
        events.add(e1);
        events.add(e2);
        events.add(e3);
        eventIds.add(e1.id);
        eventIds.add(e2.id);
        eventIds.add(e3.id);
        test.startTest();
            insert events;
            crm_Event_SendToNPS.sendEventsToNPS(eventIds);
        test.stopTest();
        
        //Control
        Event testEvent1 = [SELECT crm_NPS_Status__c, id FROM Event WHERE id = :e1.id];
        Event testEvent2 = [SELECT crm_NPS_Status__c, id FROM Event WHERE id = :e2.id];
        Event testEvent3 = [SELECT crm_NPS_Status__c, id FROM Event WHERE id = :e3.id];
        //system.assertEquals(testEvent.crm_NPS_Status__c, crm_Event_SendToNPS.NPS_SUCCESS);
    }
    
    static testMethod void noContactInEvent() {
        
        crm_TestDataFactory.CreateCustomSetting();
        delete crm_nps_settings_sales__c.getall().values();
        crm_nps_settings_sales__c nps = new crm_nps_settings_sales__c(name='Medallia',endpoint_url__c='TestEndpoint', Password__c='Pass123', Username__c='TestUser',Send_to_NPS__c=true,client_certificate__c='crm_NPS_Certificate_Sales');
        List<crm_nps_settings_sales__c> npsList = new List<crm_nps_settings_sales__c>();
        npsList.add(nps);
        insert npsList;
  
        
        User testUser = KatsTestUtilities.getTestKundekonsulentUser();
        Account a = KatsTestUtilities.getTestBusinessAccount();
        
        
        Event e1 = new Event(subject='Test',crm_Interaction_Type__c='Phone',crm_Interaction_Type_Category__c='Sales Meeting',crm_NPS_Status__c='',whatid=a.id, DurationInMinutes=30, startDateTime=System.today()-2);
        List<Id> eventIds = new List<Id>();
        test.startTest();
            insert e1;
            eventIds.add(e1.id);
            crm_Event_SendToNPS.sendEventsToNPS(eventIds);
        test.stopTest();
        
        //Control
        Event testEvent = [SELECT crm_NPS_Status__c, id FROM Event WHERE id = :e1.id];
        system.assertEquals(testEvent.crm_NPS_Status__c, null);
    }
    
}