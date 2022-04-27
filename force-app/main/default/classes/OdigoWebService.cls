/**
 *  This class is used by Odigo to find Accounts in Salesforce associated with a phone number
 *  The phone number might be registrered directly with the Account or indirectly by a Contact associated with the Account.
 *  The phone number might be a regular Phone, MobilePhone, OtherPhone, Fax or AssistantPhone
 *
 */

global class OdigoWebService {
/**
     * Caller recognition used by IVR to recognized incomming call and route the caller to correct queue
     *          VIP - Caller is placed in VIP queue  
     *          SK - (Storkunde) Caller is presented with KSL input menu
     *          NONE - Caller is routed to PBK IVR
     * @param anumber telephone number of the incomming caller
     * @return the segment of the recognized account (VIP, SK, SMB, or empty string);
     */
    Webservice static String getSegmentByCallerId(String anumber) {
        String segment = '';
        //boolean checkBackSystems = false;//commented by Rajeev S, 23 June 2017
        Boolean checkPriority = true;
        Account customer = null;
        anumber = anumber.trim();
        if (!KATSutilities.isEmpty(anumber)){
            Odigo_CustomerInfo customerInfo = new Odigo_CustomerInfo();
            //customer = customerInfo.getAccountByAPhoneNumber(anumber, checkBackSystems, checkPriority);//Commented by Rajeev S
            customer = customerInfo.getAccountByAPhoneNumber(anumber,checkPriority);
        }
        
        String none = 'NONE';
        String crmStatus = (customer != null ? customer.CRMStatus__c : none);
       
        if(String.isNotBlank(crmStatus)){
         if(crmStatus.equalsIgnoreCase('VIP') && !KATSUtilities.isEmpty(customer.Sector__c)){ 
            crmStatus += '_' + customer.Sector__c.replaceAll(' ', '_');         
         }
       }
        
       //This is done to ensure non segmentet customers also returns NONE
      return (!KATSUtilities.isEmpty(crmStatus) ? crmStatus : none); 
    }
    
}//End OdigoWebService