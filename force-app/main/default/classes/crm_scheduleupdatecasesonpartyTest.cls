/*
Created By:Supriya Goel
Date: 22 aug 2019
Test class for schedule weekly batch for updates cases
*/

@isTest
public class crm_scheduleupdatecasesonpartyTest{

    static testMethod void test(){
    crm_TestDataFactory.CreateCustomSetting();
    System.schedulableContext SC;
    crm_scheduleupdatecasesonparty sch = new crm_scheduleupdatecasesonparty();
    sch.execute(SC);
    }
}