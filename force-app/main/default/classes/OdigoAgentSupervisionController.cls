//Author - Rajeev S
//CTI Project
//This class uses "OdigoCti.VFC03Supervison" class to get live queue traffic details from Odigo
//Used by "OdigoAgentSupervision" VF page

public with sharing class OdigoAgentSupervisionController{
    
    //Initializations
    public String odigologin = null;
    public Boolean showall = false;
    public Boolean initialised{get; set;}
    public Map<String,List<cls_Statistics>> responseMap{get;set;}
    public Map<String,List<cls_Statistics>> responseMapNew{get;set;}
    public Set<String> keys {get;set;} 
    public Map<String,String> metricsMap {get;set;}
    public Map<String,Odigo_Gates__c> gatesLabelMap;
    public User us;
    public Map<String,Integer> LWTmap {get;set;}
    
    //Constructor
    public OdigoAgentSupervisionController(){
            LWTmap = new Map<String,Integer>();
            keys = new Set<String>();
            responseMap = new Map<String,List<cls_Statistics>>();
            responseMapNew = new Map<String,List<cls_Statistics>>();
            metricsMap = new Map<String,String>();
            initialised=false;
            
            
            //Query the Odigo userId for the user in context
            //Users without Odigo login won't see any data from Odigo
            us = [Select Show_All_AgentSupervisionData__c From User Where Id = :UserInfo.getUserId()];
           
            showall = us.Show_All_AgentSupervisionData__c;
            
            //Query the KPIs needed. Using a custom setting "environment_settings__c".
            //To add more KPIs, add comma separated values in "Value__c" field of the custom setting.
            //Format of the KPIs -> "Id=Name". Example -> "18=Total Calls waiting"
            for(String s : environment_settings__c.getValues('odigo_agent_supervision_kpi').value__c.split(','))
                metricsMap.put(s.substringbefore('='),s.substringAfter('='));
            
            //Get all gate mapping from custom setting    
            gatesLabelMap = new Map<String,Odigo_Gates__c>(Odigo_Gates__c.getAll());
            for(Odigo_Gates__c o : gatesLabelMap.values()){
                LWTmap.put(o.Label__c,Integer.valueOf(o.LWT__c));
            }                
    }
    
    
   
    
    
    //Refresh Method
    public Pagereference refresh(){
        return Page.OdigoAgentSupervision.setRedirect(true);
    }
    
    
    //Inner class
    public class cls_statisticsWithKey{
        public List<cls_Statistics> statistics;
        public String key;    
    }
    
    
    //Inner class
    public class cls_Statistics {
        public String value{get;set;}
        public Integer id{get;set;}
        public Integer dataType{get;set;}
        
    }
    
}