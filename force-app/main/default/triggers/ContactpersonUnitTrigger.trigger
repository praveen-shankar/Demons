//Odigo CTI Project
//Date: 04 October 2017
//Trigger created to copy phone number to Contact phone field to allow click to dial
//Created trigger for future scalability

trigger ContactpersonUnitTrigger on Unit_Contact__c (before insert,before update) {
    for(Unit_Contact__c c : trigger.new){
        if(String.isNotBlank(c.cell_phone__c))
            c.Contact__c = c.cell_phone__c.replaceAll(' ','').trim();
        else if(String.isNotBlank(c.phone__c))
            c.Contact__c = c.phone__c.replaceAll(' ','').trim();   
    }
}