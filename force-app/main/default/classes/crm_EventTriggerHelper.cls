/*
Created By: Supriya Goel
Object  :Event
Date: 29 april 2016
Helper class for EventTrigger

*/

public class crm_EventTriggerHelper{

    public static void addfeedItems(List<Event> EventList){ 
        List<FeedItem> feeditems = new List<FeedItem>();
        for (Event e: EventList ) {
            FeedItem f= new FeedItem();
            //Add on the detail object
            
            f.parentId=e.WhatId;
            f.body=  'Please Note: This event was created before the start date of the event';
            f.type = 'LinkPost';
            f.title =  e.subject;
            f.LinkUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/'+ e.id;
            
             //Add for the event
             
            feeditems.add(f);
            FeedItem f1= new FeedItem();
            f1.parentId=e.id;
            f1.body=  'Please Note: This event was created before the start date of the event';
            feeditems.add(f1);
        }
        try{
            if (feeditems.size()>0 ){
                insert feeditems; 
            }
        }catch(Exception e) { crm_Exception_handler.createExceptionRecords(e);}
    }
 }