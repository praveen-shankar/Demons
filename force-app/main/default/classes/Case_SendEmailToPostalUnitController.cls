/*

## This controller will handle the Email to be sent to the Postal Unit
## Author:  Rohit Paul
## Email:   rohit.paul@capgemini.com
## Date:    27-Jul-2015

## This page is used to prepare all the information required from the user.
## Once all the information is added by the user we:
## - Set the Date on which email will set in the field: Case:Send til Postal Enhet  [Send_to_Postal_Unit__c]
## - Content of the Email Body is added to the field:   Case:Private Kommentarer    [Private_Comments__c]
## - Email Id of the Postal Unit is set in the field:   Case:Postal Enhet Email     [temp_email_PostalUnit__c]

## These values set a Workflow Rule: 'Send Email to Postal Unit Scheduler'
## This workflow rule will run at 01:00 AM on the date for sending email
## This workflow rule will set the field (checkbox):    Case:Send Email to Postal Unit  [Send_Email_to_Postal_Unit__c]

## When the above checkbox is TRUE
## Another Workflow Rule is triggered: 'Send Email to Postal Unit'
## This workflow rule sends the email to the Postal Unit

## When the email is already scheduled, the user can click on 'Send Now' button
## This button will mark the field: Send_Email_to_Postal_Unit__c to TRUE which runs the Workflow Rule: 'Send Email to Postal Unit' at once

Cs-Phase 2- Akshata Asukar - 03/01/2017 - Replaced all occurance of party_number__c with crm_customer_number__c
*/
public class Case_SendEmailToPostalUnitController
{
    // General Variable declarations
    public Case c {get; set;}                                       // This will hold the Case information and fields needed

    // Variables for Setting data for Email
    public String sel_Category {get; set;}                          // This variable will hold the selected Category: addr OR sone
    public String categoryRef {get; set;}                           // This variable will hold the reference number as per selected category
    public String sonelasRef {get; set;}                            // This variable will hold the Sonelås reference number as per selected category
    public String addr_street {get; set;}                           // This variable will hold the 'Street' part of the address
    public String addr_city {get; set;}                             // This variable will hold the 'City' part of the address
    public String addr_postCode {get; set;}                         // This variable will hold the 'Postal Code' part of the address
    public String cust2Add {get; set;}                              // This variable will hold the 'Name' of the customer who we need to add to the list
    public List<CustomerNameHolder> custList {get; set;}            // This variable will hold the list of Customer names to be sent in the email
    public String alternative {get; set;}                           // This variable will hold the activity which must be performed by the Postal Unit
    private Date dateOfDelivery {get; set;}                         // This variable will hold the actual Date of Delivery which will be mentioned in the email
    private Integer noOfDays {get; set;}                            // This variable will store the number of Days before we need to schedule
    public String nxtPossDOD {get; set;}                            // This string will hold the next possible date of Delivery for page display

    // Variable to hold data from Backend system
    public postenNoEconnectUtilities eConnect {get; set;}           // This variable will help us connect and get data
    public EConnectWrapper_GetCustomerData eConData {get; set;}     // This variable will hold the data from backend system
    public List<CustomerAddressHolder> addrList {get; set;}         // This variable will hold the list of addresses in scope
    public PostalUnit__c pu {get; set;}                             // This variable will hold the Postal Unit related details

    // Visibility Boolean Variables
    public Boolean isScheduled {get; set;}
    public Boolean noAccount {get; set;}
    public Boolean hasEconnectData {get; set;}
    public Boolean noPostalUnit {get; set;}
    public Boolean reSchedule {get; set;}
    public Boolean isSentNow {get; set;}
    public Boolean canSendNow {get; set;}

    // Constants for Case Comment Messages
    public static final String SCHEDULED = 'SCHEDULED';
    public static final String RESCHEDULED = 'RESCHEDULED';
    public static final String CANCELLED = 'RESET';
    public static final String SENT = 'SENT';

    // ############################################################################################################################
    // ------------------------------------   CONTROLLER  -------------------------------------------------------------------------
    // ############################################################################################################################

    public Case_SendEmailToPostalUnitController(ApexPages.StandardController controller)
    {
        // Setting variable default values and allocating memory space for Lists
        sonelasRef = '';
        isScheduled = false;
        noAccount = false;
        hasEconnectData = false;
        noPostalUnit = false;
        reSchedule = false;
        isSentNow = false;
        canSendNow = false;
        addrList = new List<CustomerAddressHolder>();
        custList = new List<CustomerNameHolder>();

        // Fetching value from Custom Setting: 'emailToPostalUnitDaysPrior' to get
        // The number of days before the actual delivery date the email must be sent to postal unit
        if(environment_settings__c.getall().containsKey('emailToPostalUnitDaysPrior'))
        {
            noOfDays = Integer.valueOf(environment_settings__c.getall().get('emailToPostalUnitDaysPrior').value__c);    
        }
        else
        {
            noOfDays = 2;
        }

        // This portion of the code must only run when actual code is executed
        // While running a test class, addFields function throws error
        if(!Test.isRunningTest())
        {
            controller.addFields(new List<String>{'Subject',
                                                    'temp_email_PostalUnit__c',
                                                    'Send_to_Postal_Unit__c',
                                                    'Send_Email_to_Postal_Unit__c',
                                                    'Private_Comments__c',
                                                    'Account.crm_customer_number__c',
                                                    'Account.Name',
                                                    'Account.crm_Updated_by_CDH__c',
                                                    'unit_to_blame__c',
                                                    'Description',
                                                    'case_referens__c',
                                                    'CaseNumber',
                                                    'OwnerID',
                                                    'change_address_ref_no__c'});   
        }
        
        // Fetching the Case details and storing them in Variable 'c' for accessibility
        c = (Case)controller.getRecord();

        // Checking if we have already scheduled to send an email
        if(c.Send_to_Postal_Unit__c != null)
        {
            isScheduled = true;
        }
        else
        {
            c.Private_Comments__c = '';
        }

        // Setting next possible Date of Delivery
        Datetime nextPoss = (Datetime)this.setRequiredWeekday(Date.today(),noOfDays,false); // This calculates date to delivery based on email date
        nxtPossDOD = nextPoss.format('E, dd.MMM.yyyy');

        // Checking if Reference number for Adreseendring is updated on the Case
        // If it has, then set reference number as default
        if(String.isBlank(c.change_address_ref_no__c))
        {
            sel_Category = 'sone';
        }
        else
        {
            sel_Category = 'addr';
            categoryRef = c.change_address_ref_no__c.trim();
        }

        // Creating a variable to fetch information from the backend system
        eConnect = new postenNoEconnectUtilities();

        // If we have a lined account - then perform the fetching of customer information
        if(!String.isBlank(c.Account.crm_customer_number__c) || c.Account.crm_customer_number__c != null)
        {
            // We will perform a callout only when we do not have an email scheduled
            // This will ensure unnecessary callouts to be performed
            if(!isScheduled)
            {
                this.getCustomerDetailViaEconnect();
            }
        }
        else
        {
            noAccount = true;
            hasEconnectData = true;
        }

        // If Postal Unit is not updated on the Case then show error message on the top of the page
        // Else fetch the information required
        
        
        if(String.isBlank(c.unit_to_blame__c) || c.unit_to_blame__c == null)
        {
            noPostalUnit = true;
        }
        else
        {
            List<PostalUnit__c> tempList = new List<PostalUnit__c>();
            tempList = [SELECT Name, unit_name__c, unit_number__c, email__c FROM PostalUnit__c WHERE Id = :c.unit_to_blame__c LIMIT 1];
            if(tempList.size() == 1)
            {
                pu = tempList[0];
                if(String.isEmpty(c.temp_email_PostalUnit__c))
                {
                    c.temp_email_PostalUnit__c = pu.email__c;   
                  
                }
            }
            else
            {
                noPostalUnit = true;
                
            }
        }
    }






    // ############################################################################################################################
    // THE FOLLOWING FUNCTIONS ASSIST IN SETTING VALUES ON THE PAGE
    // ############################################################################################################################

    // The following function will assist in:
    // Setting the value in reference field automatically
    // This function will be called everytime the selection is changed
    public void changeCategory()
    {
        if(sel_Category.equalsIgnoreCase('addr') && !String.isBlank(c.change_address_ref_no__c))
        {
            if(!(categoryRef.equalsIgnoreCase(c.change_address_ref_no__c.trim())))
            {
                sonelasRef = categoryRef;
            }
            categoryRef = c.change_address_ref_no__c.trim();
        }
        else if(sel_Category.equalsIgnoreCase('sone'))
        {
            categoryRef = sonelasRef;
        }
    }

    // The following function will assist in:
    // - Fetch the Name entered by the User in the field 'Mottaker' under section 'Recepients'
    // - Add this name to the list of Recepients and display on the page.
    // - Wipe the field's content after load
    public void addRecepient()
    {
        if(cust2Add != null)
        {
            if(String.isNotBlank(cust2Add))
            {
                custList.add(new CustomerNameHolder(cust2Add));
                cust2Add = '';  
            }
        }
    }

    // The following function will assist in:
    // Checking which particular address was selected by the user
    // The selected address is set in the input fields
    // The checkbox selected is again reset to ensure we always are able to select one address 
    public void setAddress()
    {
        for(CustomerAddressHolder ah: addrList)
        {
            if(ah.sel == true)
            {
                addr_street = ah.street;
                addr_city = ah.city;
                addr_postCode = ah.postCode;

                ah.sel = false;
            }
        }
    }

    // ############################################################################################################################







    // ############################################################################################################################
    // THE FOLLOWING FUNCTIONS ASSIST IN POPULATING DEFAULT VALUES ON THE PAGE AT THE TIME OF LOADING
    // 
    // These functions will look into various aspects of the Case, Postal Unit and Backend systems
    // To provide all the information required by the user to prepare and schedule this email 
    // ############################################################################################################################

    // The following function performs the below mentioned action:
    // - Checks if its the actual code running and calls the Webservice to fetch information
    // - If we are able to fetch information, we call the function 'setAddressAndRecepientList':
    //      - to find related Customers/Recepients
    //      - to find related Addresses
    public void getCustomerDetailViaEconnect()
    {
        try
        {
            if(test.isRunningTest())
            {
                //eConData = new EConnectWrapper_GetCustomerData(mock_KatsSakgetcustomer.getPrivateAccount()); // Manually assigned in test
                eConData = new EConnectWrapper_GetCustomerData(mock_Crmgetcustome.getPrivateAccount()); // Manually assigned in test
            } 
            else
            {   
                // Performing Callout to get Customer details   
                 String[] InformationType=new String[]{'CustomerDetails','ForwardingDetails'};
                if(c.Account.crm_Updated_by_CDH__c) 
                    eConData = new EConnectWrapper_GetCustomerData(eConnect.getCustomer(null,c.Account.crm_customer_number__c ,InformationType) );
                else
                    eConData = new EConnectWrapper_GetCustomerData(eConnect.getCustomer(c.Account.crm_customer_number__c ,null,InformationType) );
                System.debug('@@@eConData@@@'+eConData );
            }
            system.debug('CustomerDetailExtension - requestData - ' + this.eConData);
        } 
        catch(Calloutexception coe) 
        {
            system.debug('CustomerDetailExtension - requestData - No connection to eConnect - ' + coe.getMessage());
            //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Forbindelse til eConnect feilet - ' + coe.getMessage() ));
            //CSPhase2 Supriya 22122016=>labels added
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.label.cs_Connection_to_eConnect_failed+' - ' + coe.getMessage() ));
            
        }
        catch(Exception e)
        {
            system.debug('CustomerDetailExtension - requestData - ' + e.getMessage());
            //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Fant ingen kunder med aktørnummer' + c.Account.crm_customer_number__c ));
            //CSPhase2 Supriya 22122016=>labels added
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.label.cs_No_customers_with_party_number  + c.Account.crm_customer_number__c )); 
        }

        if(eConData != null)
        {
            hasEconnectData = true;

            // Refreshing the Address List
            this.setAddressAndRecepientList();
        }
        else
        {
            hasEconnectData = false;    
        }
    }

    // The following function performs the below mentioned action:
    // - We try and populate 2 lists: Recepients & Addresses
    // - Addresses:
    //      - If Reference number is provided, we will pick up the address from Reference Number
    private void setAddressAndRecepientList()
    {
        Boolean personAcc = false;

        // Refreshing the current list as Econnect Data has been refreshed
        addrList = new List<CustomerAddressHolder>();
        custList = new List<CustomerNameHolder>();

        // Adding the Name of the Account as the first Recepient
        // For Person Account: Name of the account holder
        // For Business Account: name of the company
        custList.add(new CustomerNameHolder(c.Account.Name));

        // Address will be set only when we have data from Econnect
        if(hasEconnectData)
        {
            EConnectWrapper_GetCustomerData.ForwardingElement frwdList = new EConnectWrapper_GetCustomerData.ForwardingElement();
            
             system.debug('!!!!no'+ eConData.OrganizationParty.PartyNumber);

            // We will add the addresses from backend system to our Address List if Reference Number is available on the Case
            if(!(String.isBlank(c.change_address_ref_no__c) || c.change_address_ref_no__c == null))
            {
                // We will check if the Account is Business (Bedrift) or Private (Privat)
                System.debug('@@@eConData.OrganizationParty.PartyNumber@@'+eConData.OrganizationParty.PartyNumber);
                System.debug('eConData.PersonParty.PartyNumber'+eConData.PersonParty.PartyNumber);
                if(eConData.OrganizationParty.PartyNumber != '-' && eConData.OrganizationParty.PartyNumber !='')
                {
                    frwdList = eConData.organizationParty.forwardingElements;
                    
                     system.debug('!!!!frwdList line 353 '+ frwdList );
                }
                else if(eConData.PersonParty.PartyNumber != '-' && eConData.PersonParty.PartyNumber !='')
                {
                    
                    frwdList = eConData.PersonParty.forwardingElements;
                    system.debug('!!!!person '+ frwdList );
                    personAcc = true;
                }

                // Setting the addresses from the backend system to our list based on Forwarding details
                // We are looking for:
                // - Forwarding Type: Oppbevaring
                // - Reference Number which matched the Ref.adr.endring field data on the Case
                
                System.debug('@@@frwdList.forwardingTypes' + frwdList.forwardingTypes);
                for(EConnectWrapper_GetCustomerData.ForwardingType fwType: frwdList.forwardingTypes)
                {
                     System.debug('@@@fwType'+ fwType + c.change_address_ref_no__c );
                    if(fwType.Type_x.equalsIgnoreCase('oppbevaring') && (c.change_address_ref_no__c.equalsIgnoreCase(fwType.Number_x)))
                    {
                    
                     System.debug('@@@fin inside' );
                        //addrList.add(new CustomerAddressHolder(fwType.FromAddress.BuildingNumber+','+fwType.FromAddress.BuildingName+','+fwType.FromAddress.StreetName+','+fwType.FromAddress.PostOfficeBox, fwType.FromAddress.CityName, fwType.FromAddress.PostalCode));
                        //addrList.add(new CustomerAddressHolder(fwType.FromAddress.street, fwType.FromAddress.City, fwType.FromAddress.PostalCode));
                        
                        
                          String address='';
                      
                            if(fwType.FromAddress.StreetName!=null)
                           address =fwType.FromAddress.StreetName;
                       if(fwType.FromAddress.BuildingNumber!=null)
                           address+=' '+fwType.FromAddress.BuildingNumber;
                           
                            if(fwType.FromAddress.BuildingName!=null)
                           address +=' '+fwType.FromAddress.BuildingName;
                           
                           
                            if(fwType.FromAddress.PostOfficeBox!=null)
                           address +=' '+fwType.FromAddress.PostOfficeBox;
                       
                           
                          addrList.add(new CustomerAddressHolder(address , fwType.FromAddress.CityName, fwType.FromAddress.PostalCode));
                        
                        // In case of Person Account - We are picking the Name of the customer from the Reference Number
                        if(personAcc)
                        {
                            for(EConnectWrapper_GetCustomerData.PersonNameType pnt:fwType.OtherParties.Party)
                            {
                                String n = '';
                                if(pnt.FirstName != null)
                                    n = n + pnt.FirstName;

                                if(pnt.MiddleName != null)
                                    n = n + ' ' + pnt.MiddleName;

                                if(pnt.LastName != null)
                                    n = n + ' ' + pnt.LastName;

                                custList.add(new CustomerNameHolder(n.trim()));
                            }
                            
                        }
                    }
                }
            }

            // Else we will add for the Address list which are of Type: Postadresse
            else
            {
                EConnectWrapper_GetCustomerData.AddressElement adressList = new EConnectWrapper_GetCustomerData.AddressElement();
                
                system.debug('!!!!no'+ eConData.OrganizationParty.PartyNumber);
                
                 system.debug('!!!!elements'+ eConData.PersonParty.PartyNumber);

                // We will check if the Account is Business (Bedrift) or Private (Privat)
                if(eConData.OrganizationParty.PartyNumber != '-' && eConData.OrganizationParty.PartyNumber!='' )
                {
                    adressList = eConData.organizationParty.addressElements;
                }
                else if(eConData.PersonParty.PartyNumber != '-' && eConData.PersonParty.PartyNumber !='')
                {
                    adressList = eConData.PersonParty.addressElements;
                }
                  system.debug('!!!!adressList'+ adressList);
                   
                   System.debug('adressList.addressTypes'+ adressList.addressTypes );
                // Setting the addresses from the backend system to our list based on Address details
                for(EConnectWrapper_GetCustomerData.AddressType adType: adressList.addressTypes)
                {   System.debug('@@@adType'+ adType.AddressType );
                    if(adType.addressType.equalsIgnoreCase('PostalAddress')||adType.addressType.equalsIgnoreCase('postadresse'))
                    {
                       // addrList.add(new CustomerAddressHolder(adType.street, adType.City, adType.PostalCode));
                       //addrList.add(new CustomerAddressHolder(adType.BuildingNumber+','+adType.BuildingName+','+adType.StreetName+','+adType.PostOfficeBox, adType.CityName, adType.PostalCode));
                       String address='';
                      
                         if(adType.StreetName!=null)
                           address =adType.StreetName;
                       
                       if(adType.BuildingNumber!=null)
                           address +=' '+adType.BuildingNumber;
                           
                            if(adType.BuildingName!=null)
                           address +=' '+adType.BuildingName;
                           
                           
                            if(adType.PostOfficeBox!=null)
                           address +=' '+adType.PostOfficeBox;
                       
                           
                           addrList.add(new CustomerAddressHolder(address,  adType.CityName, adType.PostalCode));
                    }
                }
            }
        }
    }






    // ############################################################################################################################
    // FUNCTIONS TO PROCESS REQUEST
    // ############################################################################################################################

     public void sendEmailToPostalUnitcheck()
    { 
        scheduleEmailToPostalUnit();
        if(canSendNow==true)
            {
              System.debug('@@@@I am in here22222');
             this.sendEmailNow();
            }
        
       
   /* System.debug('@@@@I am in here0000');
        if(this.isValidData(false))
        {
        System.debug('@@@@I am in here11111');
        
            if(canSendNow=true)
            {
              System.debug('@@@@I am in here22222');
             this.sendEmailNow();
            }
            
            else
            {
            System.debug('@@@@I am in here33333');
             this.scheduleEmailToPostalUnit();
            }
    
        }*/
        
     }




    // The following function will assist in:
    // Making sure all the required information is available 
    // Set the schedular date to next possible weekday
    // Construct the email content and place it in the Private_Comments__c field
    public void scheduleEmailToPostalUnit()
    {
        // The following action will call the validation function
        // If validation is successful, we will set the email and schedule it as required
        if(this.isValidData(false))
        {
            // Setting email body
            c.Private_Comments__c = this.constructEmailBody();

            // Email address of Postal Unit is directly linked to the following field:
            // c.temp_email_PostalUnit__c

            // Setting date for scheduling Email to Postal Unit
            c.Send_to_Postal_Unit__c = this.setRequiredWeekday(c.Send_to_Postal_Unit__c,noOfDays,true);

            // Update the Case with this information
            try
            {
                Database.update(c);
                this.addCaseComment(SCHEDULED);

                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Sending av e-post til enhet er planlagt'));
                //CSphase2 Supriya 22122016
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,System.Label.cs_sending_email_device_planned));

                isScheduled = true;
                canSendNow = false;
            }
            catch(Exception e)
            {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Kunne ikke planlegge sending av e-post til enhet. Feil: ' + e.getMessage()));
                //CSphase2 Supriya 22122016
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  System.Label.cs_failed_to_schedule_device + e.getMessage()));  
               
            }
        }

    }

    
    private String constructEmailBody()
    {
        // We will first set the content of the email below:
        String emailBody = System.Label.cs_NotificationMail1;

        // Adding reference type and reference number:
        if(sel_Category.equalsIgnoreCase('addr'))
        {
            emailBody = emailBody +' ' + System.Label.cs_FarREf+' '+ this.categoryRef ;
        }
        else if(sel_Category.equalsIgnoreCase('sone'))
        {
            emailBody = emailBody + ' '+ System.Label.cs_zonelock;
        }

        // Adding name of the Recepients:
        emailBody = emailBody +'\n'+ System.Label.cs_Namerecipients;
        for(CustomerNameHolder cust: custList)
        {
            if(cust.sel == true)
            {
                emailBody = emailBody + '- ' + cust.custName ;
            }
        }
        emailBody = emailBody ;

        // Adding the selected Address:
        emailBody = emailBody + '\n' +  System.Label.cs_From_Address + ' :' +this.addr_street  ;
        emailBody = emailBody + '\n' + System.Label.cs_CodenCity+ this.addr_postCode + ' :' + this.addr_city ;

        // Adding message on what activity needs to be performed
       
        String selectedoption;
        String translatedselectedoption;
        
        if (this.alternative=='Posten ut i postkassen'){
            selectedoption='Checkout at Posten';
            translatedselectedoption=System.Label.cs_Checkout_at_Posten;
            }
          else {
             selectedoption='Retreive the record on his fetch office';
              translatedselectedoption=System.Label.cs_Retrieve_the_record_on_his_fetch_office;
             }
         //emailBody = emailBody + '\n' + System.Label.cs_applicable+': ' + selectedoption ;
         
          emailBody = emailBody + '\n' + System.Label.cs_applicable+': ' + translatedselectedoption;

        // Adding message on what date the delivery must be made
        Datetime dueDate = (Datetime)c.Send_to_Postal_Unit__c;
        emailBody = emailBody +'\n' +  System.Label.cs_Date+': ' + dueDate.format('yyyy-MM-dd') ;

        return emailBody.trim();
    }


    // The following function will assist in:
    // Checking if all the required information is available on the Page
    // If all required information is available then return 'True'
    // Else returns 'False'
    private Boolean isValidData(Boolean forSendNow)
    {
        Boolean valid = true;

        // Checking if we have email for the Postal Unit set
        if(c.temp_email_PostalUnit__c == null || String.isBlank(c.temp_email_PostalUnit__c))
        {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'E-post til enhet er ikke utfylt - vennligst fyll inn e-post'));
            //Csphase2 Supriya 22122016
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.cs_email_unit_not_proper));
            valid = false;
        }

        // Checking if we have Recepients selected
        Integer count = 0;
        for(CustomerNameHolder cust: custList)
        {
            if(cust.sel == true)
            {
                count = count + 1;
            }
        }
        if(count == 0)
        {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Velg en eller flere postmottakere'));
            //Csphase2 Supriya 22122016
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.cs_Select_recipients));
            valid = false;
        }


        // Checking address fields
        if(String.isBlank(addr_street))
        {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vennligst oppdater Gate/Sted'));
            //Csphase2 Supriya 22122016
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.cs_update_gate_area));
            
            valid = false;
        }

        if(String.isBlank(addr_city))
        {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vennligst oppdater Poststed'));
             //Csphase2 Supriya 22122016
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.label.cs_Please_update_City));
            valid = false;
        }
        if(String.isBlank(addr_postCode))
        {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vennligst oppdater Postnummer'));
            //Csphase2 Supriya 22122016
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.cs_Please_update_your_ZIP_code));
            valid = false;  
        }

        // Only numeric values are allowed in Post Code
        else if(!addr_postCode.isNumeric())
        {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Postnummer kan ikke inneholde tegn eller bokstaver'));
            //Csphase2 Supriya 22122016
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.cs_zip_not_include_chars));
            valid = false;
        }

        // Only 4 digits are allowed for Post Code
        else if(addr_postCode.length() != 4)
        {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Postnummer kan kun inneholde 4 tall'));
            //Csphase2 Supriya 22122016
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.cs_Zip_can_contain_only_4_numbers));
            valid = false;
        }

        // Checking if Alternative text was selected by the user
        if(alternative == null || String.isBlank(alternative))
        {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Velg et utleveringsalternativ'));
            //Csphase2 Supriya 22122016
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.cs_Choose_a_delivery_option));
            valid = false;
        }


        // Check if Date of Delivery was selected by the user
        // If yes, then check if the date of sending the email is lesser than today
        if(c.Send_to_Postal_Unit__c != null)
        {
            Date emailDate = this.setRequiredWeekday(c.Send_to_Postal_Unit__c,noOfDays,true);

            if(emailDate < Date.today())
            {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Valgt dato er ikke innenfor leveringsvilkårene - vennligst velg en annen dato.'));
                //Csphase2 Supriya 22122016
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.cs_selected_date));
                valid = false;
            }
            else if(emailDate == Date.today())
            {
                canSendNow = true;
                if(!forSendNow)
                    valid = false;
            }

            Datetime temp = c.Send_to_Postal_Unit__c;
            if(temp.format('E').equalsIgnoreCase('sun') || temp.format('E').equalsIgnoreCase('sat'))
            {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Utleveringsdato kan ikke være en lørdag eller søndag'));
                //Csphase2 Supriya 22122016
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.cs_Wrong_collect_date));
                valid = false;
            }
        }
        else
        {    
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Leverings dato'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_delivery_date));
            //Csphase2 Supriya 22122016
            valid = false;
        }

        return valid;
    }





    // The following function will:
    // - Clear the field: 'Send_to_Postal_Unit__c' which assists in Scheduling the Time-based Workflow
    // - Clear the field: 'Private_Comments__c' which holds the content to be added in the email
    // - Set the Boolean variable: 'isScheduled' to 'false' to show the Scheduler form again
    public void resetScheduledEmailToPostalUnit()
    {
        c.Send_to_Postal_Unit__c = null;
        c.Private_Comments__c = '';

        try
        {
            Database.update(c);
            this.addCaseComment(CANCELLED);

            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Sending av e-post er slettet'));
            //CSphase2 Supriya 22122016
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,System.Label.cs_Sending_e_mail_is_deleted));
            
          

            // Resetting some already set values
            isScheduled = false;
            addr_street = '';
            addr_city = '';
            addr_postCode = '';
            alternative = '';

            // Fetching latest data from Econnect
            this.getCustomerDetailViaEconnect();
        }
        catch(Exception e)
        {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Kunne ikke slette sending av e-post. Feil: ' + e.getMessage()));
            
                 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.cs_Could_not_delete_sending_e_mail_Error + e.getMessage()));
            //Csphase2 Supriya 22122016
        }
    }

    // The following function will:
    // Toggle the value of the Boolean Variable: reSchedule
    // This will help us to show/hide the field for reScheduling
    public void toggleReScheduleDateField()
    {
        if(reSchedule == true)
        {
            reSchedule = false;
        }
        else
        {
            reSchedule = true;
        }       
    }


    // The following function will:
    // - Fetch the new Date for Delivery/Action
    // - Remove the date from the current layout
    // - Set the new date in the email body
    // - Set the date for email scheduled as per the update
    public void reScheduleEmailToPostalUnit()
    {
        Boolean isOkayToReschd = true;
        Date emailDate;

        // We will validate if the new date selected can be scheduled for an email to Postal Unit
        // Check if Date of Delivery was selected by the user
        // If yes, then check if the date of sending the email is lesser than today
        if(c.Send_to_Postal_Unit__c != null)
        {
            emailDate = this.setRequiredWeekday(c.Send_to_Postal_Unit__c,noOfDays,true);
            
            if(emailDate < Date.today())
            {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Valgt dato er ikke innenfor leveringsvilkårene - vennligst velg en annen dato.'));
                //Csphase2 Supriya 22122016
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.cs_selected_dates_not_proper));
                
                isOkayToReschd = false;
            }
            else if(emailDate == Date.today())
            {
                canSendNow = true;
            }

            Datetime temp = c.Send_to_Postal_Unit__c;
            if(temp.format('E').equalsIgnoreCase('sun') || temp.format('E').equalsIgnoreCase('sat'))
            {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Utleveringsdato kan ikke være en lørdag eller søndag'));
                //Csphase2 Supriya 22122016
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.cs_Wrong_collect_date));
                isOkayToReschd = false;
            }
        }
        else
        {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Velg utleveringsdato'));
             //Csphase2 Supriya 22122016
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.cs_Select_delivery_date));
            isOkayToReschd = false;
        }
        
        if(isOkayToReschd)
        {
            // We will fix the date mentioned on the email body
            // We will first try to fetch the index till date section
            String temp = c.Private_Comments__c.trim();
            Integer pos = temp.length();
            pos = pos - 10;

            // Extracting the email body till 'Dato:' and appending the new date
            Datetime dueDate = (Datetime)c.Send_to_Postal_Unit__c;
            c.Private_Comments__c = temp.substring(0,pos) + dueDate.format('yyyy-MM-dd') + '\n';

            // We will fetch the new date and set it on the Case
            c.Send_to_Postal_Unit__c = this.setRequiredWeekday(c.Send_to_Postal_Unit__c,noOfDays,true);

            try
            {    
                if(canSendNow)
                {
                     sendEmailNow();   
                }
                else
                {                       
                    Database.update(c);
                    this.addCaseComment(RESCHEDULED);

                    this.toggleReScheduleDateField();

                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Ny utleveringsdato er lagret')); 
                    //Csphase2 Supriya 22122016
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, System.Label.cs_New_delivery_date_is_stored)); 
                }
                
            }
            catch(Exception e)
            {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Kunne ikke endre dato for utlevering.\n Feil: ' + e.getMessage()));
                //Csphase2 Supriya 22122016
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_could_not_change_disclosure + e.getMessage()));
                
            }
        }
    }


    // The following function will:
    // - Set the checkbox: Send_Email_to_Postal_Unit__c, to TRUE
    // - Once TRUE, it will trigger the Workflow Rule to send the email at once
    public void sendEmailNow()
    {
        Boolean toSend = true;

        if(c.Private_Comments__c.trim().equals('') && this.isValidData(true))
        {
            // Setting email body
            c.Private_Comments__c = this.constructEmailBody();
        }
        else if(c.Private_Comments__c.trim().equals('') && !this.isValidData(true))         
        {
            toSend = false;
        }

        if(toSend)
        {
            // Setting date for scheduling Email to Postal Unit
            c.Send_to_Postal_Unit__c = Date.today();

            // Setting governer variable to true
            c.Send_Email_to_Postal_Unit__c = true;

            try
            {
                Database.update(c);
                this.addCaseComment(SENT);

                canSendNow = false;
                isSentNow = true;
                isScheduled = true;
                reSchedule = false;
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'E-post ble sendt, vennligst oppdater siden'));
                //Csphase2 Supriya 22122016
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, System.Label.cs_email_sent_reload));
                   
            }
            catch(Exception e)
            {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'E-post kan ikke sendes nå - vennligst oppdater siden og prøv på nytt.\n Feil: ' + e.getMessage()));
                //Csphase2 Supriya 22122016
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_email_cannot_be_sent + e.getMessage()));
            }
        }
    }




    // ############################################################################################################################
    // SOME UTILITY FUNCTIONS
    // ############################################################################################################################


    // The following function will assist in:
    // Receiving Date of Delivery and Number of Days to reduce/add
    // It will check if its weekday. If not adds/reduces days
    // Returns the next possible Weekday!
    private Date setRequiredWeekday(Date target, Integer numOfDays, Boolean reduce)
    {
        Integer multiplier = 1;

        if(reduce)
        {
            multiplier = -1;
        }

        // We will move forward/backward in days to ensure required number of workdays are covered
        Integer count = 0;                              // This variable will compare to the numOfDays to check till we cover the required number of days
        DateTime tempDate = (DateTime) target;          // Temporary variable to move to the new date

        while(count < numOfDays || (tempDate.format('E').equalsIgnoreCase('sun') || tempDate.format('E').equalsIgnoreCase('sat')))
        {
            // This checks if tempDate is Sunday of Saturday
            // If its a weekday we add it to count, otherwise we do not consider it as a working day
            if(!(tempDate.format('E').equalsIgnoreCase('sun') || tempDate.format('E').equalsIgnoreCase('sat')))
            {
                count = count + 1;
            }

            tempDate = tempDate.addDays(multiplier);

        }


        return tempDate.date();

    }

    // The following function will assist in:
    // Receiving the type of action performed
    // Based on the Action, a Case Comment will be created and linked to the Case in scope
    private Boolean addCaseComment(String act)
    {
        // Create a new Case Comment Variable
        CaseComment com = new CaseComment();
        com.IsPublished = false;
        com.ParentId = c.Id;

        // Deciding the Message based on input Action
        if(act == SCHEDULED)
        {
            com.CommentBody = System.Label.cs_EmailSent4 + c.Send_to_Postal_Unit__c + System.Label.cs_EmailSent5 + c.Private_Comments__c;
        }
        else if(act == RESCHEDULED)
        {
            com.CommentBody = System.Label.cs_EmailSent3 + c.Send_to_Postal_Unit__c;
        }
        else if(act == CANCELLED)
        {
            com.CommentBody = System.Label.cs_EmailSent2;
        }
        else if(act == SENT)
        {
            com.CommentBody = System.Label.cs_EmailSent1 + c.Private_Comments__c;
        }
        else
        {
            return false;
        }

        // INSERT new comment on Case 
        // [TRY BLOCK NOT REQUIRED AS THIS WILL BE CALLED FROM WITHIN TRY BLOCK]
        Database.insert(com);
        return true;
    }




    // ############################################################################################################################
    // WRAPPER CLASSES FOR LISTING ON PAGE LAYOUT AND REQUIRED ACTIONS
    // ############################################################################################################################
    public class CustomerAddressHolder
    {
        // Variables associated with this class
        public Boolean sel {get; set;}
        public String street {get; set;}
        public String city {get; set;}
        public String postCode {get; set;}

        public CustomerAddressHolder(String streetDetail, String cityName, String postalCode)
        {
            sel = false;
            street = streetDetail;
            city = cityName;
            postCode = postalCode;
        }
    }

    public class CustomerNameHolder
    {       // Variables associated with this class
        public Boolean sel {get; set;}
        public String custName {get; set;}

        public CustomerNameHolder(String name)
        {
            sel = false;
            custName = name;
        }
    }


    
    // END OF CODE
}