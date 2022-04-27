@isTest
private class CS_CaseRelatedToUnitTest {
   
    static testMethod void CaseRelatedToUnitmethod() {
    PostalUnit__c p1= new PostalUnit__c();
    p1.name= 'Test111';
   
     p1.unit_number__c ='0911';
     p1.DRM_id__c = '111';
    insert p1;
    
    
    PostalUnit__c p2= new PostalUnit__c();
    p2.name= 'Test2222';
     p2.unit_name__c='0912';
     p2.unit_number__c='0912';
     p2.DRM_id__c='111122';
    insert p2;
     CS_CaseRelatedToUnit.searchDB('PostalUnit__c', '','',10,'', 'Test');
    
    
    
    
    }
    
 }