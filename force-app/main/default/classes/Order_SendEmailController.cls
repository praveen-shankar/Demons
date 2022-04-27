/*

## This controller will handle the ORDER Email to be sent to the Transport unit
## Author:     Nikita Phutane
## Email:      nikita.phutane@capgemini.com
## Date:       26-Aug-2015

## Updated on 04-Mar-2016 - Rohit Paul - C-03244 - Solution for Bedriftspakke Ekspress (BDX)

*/
public with sharing class Order_SendEmailController
{
     // Fields to be used in the Class
     public Order o {get;set;}                              // This will hold the information of the Order record
     public String transportUnitName {get;set;}             // This variable will hold the Transportation Unit Name
     public String email{get;set;}                          // This variable will hold the Transportation Unit's Email
     
     // Boolean Variables to control Visibility
     private Boolean isValidOrder {get;set;}                           // This Boolean variable will be set TRUE if we are able to fetch the required Order
     public Boolean validation_flag {get;set;}              // This Boolean will render the form only when all mandatory fields are updated on the Order Record
     public Boolean unit_Flag {get;set;}                    // This Boolean will render the back button when mandatory fields are not updated on the Order Record
     public Boolean isAdhocOrder {get;set;}                 
     public Boolean isMBHOrder {get;set;}                 
     public boolean customer_email_flag {get;set;}          // This variable will be TRUE if the field 'customer_email__c' has a value
     private boolean message_flag{get;set;}

     // Fields for BDX Special Service
     public Boolean isBDX {get; set;}                       // This variable will control the visibility of the Bedriftspakke Ekspress message section
     public String pickupPCMess {get; set;}                 // This variable will hold the message for the Pickup code message
     public String delPCSeverity {get; set;}                // This variable will hold the severity for the Delivery code message
     public String delPCMess {get; set;}                    // This variable will hold the message for the Delivery code available or not
     public String timeCheckSeverity {get; set;}            // This variable will hold the severity for the current time and related deadline
     public String timeCheckMess {get; set;}                // This variable will hold the message for the current time and related deadline

     private List<Order> ordList = new List<Order>();
     private Map<String,BDX_Pickup_Postcodes__c> bdx_pickup {get; set;}    // This MAP will hold the list of Pickup locations for BDX
     private Map<String,BDX_Delivery_Postcodes__c> bdx_del {get; set;}     // This MAP will hold the list of Delivery locations for BDX
     private static final Id Adhoc_RecordTypeId = KATSutilities.getRecordType('Adhoc_Orders'); 
     private static final Id MBH_RecordTypeId = KATSutilities.getRecordType('Receiver_Paid_Delivery');
     private static final Id simple_inquiry = KATSutilities.getRecordType('simple_inquiry');

     /*     CONSTRUCTOR      */ 
     public Order_SendEmailController(ApexPages.StandardController controller)
     {    
          //Initalize the FLAGS to FALSE. 
          validation_flag=false;
          unit_Flag=false;
          isValidOrder = false;
          isBDX = false;
          isAdhocOrder = false;
          isMBHOrder = false;
          // BDX Initialization
          delPCSeverity = 'info';
          timeCheckSeverity = 'info';
          pickupPCMess = '';
          delPCMess = '';
          timeCheckMess = '';
          bdx_pickup = new Map<String,BDX_Pickup_Postcodes__c>();
          bdx_del = new Map<String,BDX_Delivery_Postcodes__c>();
          
          //Fetching the Order details and storing them in Variable 'o' for accessibility
          o = (Order)controller.getRecord();


          if(o.id == null)
          {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Missing relation to Order. Please go back to the Order and try again!'));
          }
          else
          {    
               ordList = [SELECT status,
                           Type,
                           EffectiveDate,
                           customer_email__c,
                           ShippingPostalCode,
                           business_name_for_pickup__c,
                           phone_number__c,
                           Send_email_to_customer__c,
                           contact_person__c,
                           Description,
                           number_of_packages__c,
                           Vekt_volum_str__c,
                           delivery_Postcode__c,
                           reason__c,
                           EndDate,
                           postalUnit__c,
                           Bank_account_no__c,
                           Amount__c,
                           OrderNumber__c,
                           Sendingsnummer__c,
                           RecordType.Id,
                           RecordType.developerName,
                           account.crm_Customer_Status_Role_3__c,
                           Case__c
                      FROM Order 
                     WHERE id =:o.id 
                     LIMIT 1];

               

               //Check if the ordList contains an order record
               if(ordList.size() == 1)
               {
                    o = ordList[0];
                  //  if(o.status.equalsIgnoreCase('Email Sent'))
                      if(o.status.equalsIgnoreCase('Epost sent'))
                    {
                        isValidOrder = false;
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Ordre ferdig og Epost sent'));
                        //CSPhase2 Supriya 19122016
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,System.Label.cs_Orders_complete));
                        
                    }
                    else
                    {
                        isValidOrder = true;
                    }
               }
               else
               {
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Ordren ikke funnet!'));
                    //CSPhase2 Supriya 19122016
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, System.Label.cs_Order_not_found));
               } 

               // Check if the Order Type selected is BDX
               if(!String.isEmpty(o.Type))
               {    
                   // if(o.Type.equalsIgnoreCase('Business Parcel Express'))
                       
                    if(o.Type.equalsIgnoreCase('bedriftspakke ekspress'))
                    {
                         isBDX = true;
                         bdx_pickup = BDX_Pickup_Postcodes__c.getAll();
                         bdx_del = BDX_Delivery_Postcodes__c.getAll();
                         this.checksForBDX();
                    }
                    
               }    
          }
          
     }

     /*
     This function will:
     Run only if the Order type selected by the user is Bedriftspakke ekspress.
     - This function will check the Post Code of Shipping Address (which is the Pickup address) and check if there are any special messages
     - This function will check the Delivery location Post Code and check if Bedriftspakke ekspress is available at that location or not
     - This function will also check if the deadline for taking this order has crossed or not.
     All the above will be shown to the user as page messages - info. 
     System will not stop any process.
     */
     public void checksForBDX()
     {
          // Here we will check for current time and date set for delivery
          Datetime curr = Datetime.now();              // Returns current Date and Time
          if((curr.hour() >= 12) && (curr.date() >= o.EffectiveDate))
          {
               timeCheckSeverity = 'ERROR';
               timeCheckMess = System.Label.cs_BookingExceed;
          }
          else
          {
               timeCheckSeverity = 'CONFIRM';
               timeCheckMess = System.Label.cs_OrderCollecting;
          }

          // Here we will check for the Pickup Post code and provide appropriate message
          if(String.isEmpty(o.ShippingPostalCode))
          {
               pickupPCMess = System.Label.cs_UpdateZip;
          }
          else
          {
               if(bdx_pickup.containsKey(o.ShippingPostalCode))
               {
                    pickupPCMess = bdx_pickup.get(o.ShippingPostalCode).Name + ' : ' + bdx_pickup.get(o.ShippingPostalCode).City_Poststed__c + ' : ' + bdx_pickup.get(o.ShippingPostalCode).Message__c;
               }
               else
               {
                    pickupPCMess = System.Label.cs_NomessageForZip + o.ShippingPostalCode;
               }     
          }
          
          // Here we will check for the Delivery Post code and provide appropriate message
          if(String.isEmpty(o.delivery_Postcode__c))
          {
               delPCSeverity = 'ERROR';
               delPCMess = System.Label.cs_LackZip;
          }
          else
          {
               if(bdx_del.containsKey(o.delivery_Postcode__c))
               {
                    delPCSeverity = 'CONFIRM';
                    delPCMess = System.Label.cs_BusinessParcel + o.delivery_Postcode__c + ' : ' + bdx_del.get(o.delivery_Postcode__c).City__c;
               }
               else
               {
                    delPCSeverity = 'ERROR';
                    delPCMess = System.Label.cs_BusinessParcelNo + o.delivery_Postcode__c;
               }     
          }


     }

 
     /*
     This function will:
     Check if all the required fields have data.If yes Set the 'validation_flag' field to TRUE and call the 'transportUnit()' function. 
     */

     public void validateData()
     {
         
          if(isValidOrder)
          {
               Boolean isNotValid = false; 
               Boolean isNotValidMBH = false;
               
                 if( (o.account.crm_Customer_Status_Role_3__c == 'I' || o.account.crm_Customer_Status_Role_3__c == 'i' || String.isEmpty(o.account.crm_Customer_Status_Role_3__c) && o.recordtype.developername=='Adhoc_Orders') ){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.cs_customer_invalid));
                    
                    isNotValid = true;
               }

               if(String.isEmpty(o.ShippingPostalCode))
               {
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Mangler Postnummer henteadresse'));
                    //CSPhase2, Supriya , 19122016
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.cs_Missing_Post_number));
                    
                    isNotValid = true;
               }

               if(o.Case__c == null)
               {
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Mangler Saknummer'));   
                    //CSPhase2, Supriya , 19122016
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.cs_Case_number_mising));                      
                    isNotValid = true; 
               }

               if(o.RecordType.Id == Adhoc_RecordTypeId)
               {   
               isAdhocOrder = true;            
               //Check if all the required fields have data, Set the 'isNotValid' field to TRUE if any of the required fields is blank.
                    if(String.isEmpty(o.Type))
                    {
                       //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Bestillingstype er ikke valgt'));
                       //CSPhase2, Supriya , 19122016
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.cs_Booking_type_not_selected));
                         isNotValid = true;
                    }
                    
                         
                    if(String.isEmpty(o.business_name_for_pickup__c))
                    {
                         //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Mangler Firmanavn'));
                         //CSPhase2, Supriya , 19122016
                         
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.cs_Missing_Firstname));
                         isNotValid = true;
                    }
                    
                    if(String.isEmpty(o.phone_number__c))
                    {
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Mangler Telefon'));
                        //CSPhase2, Supriya , 19122016
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.cs_Missing_telephoneno));
                        isNotValid = true;
                    }
                    
                    if(String.isEmpty(o.contact_person__c))
                    {
                         //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Mangler Kontaktperson'));
                         //CSPhase2, Supriya , 19122016
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.cs_Missing_Contact_Person));
                         
                       
                         isNotValid = true;
                    }
                    
                    if(String.isEmpty(o.Description))
                    {
                         //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Mangler Beskrivelse'));
                         //CSPhase2, Supriya , 19122016
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.cs_Missing_Description));
                         
                         isNotValid = true;
                    }
                    
                    if(String.isEmpty(o.number_of_packages__c))
                    {
                         //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Mangler Antall kolli'));
                          //CSPhase2, Supriya , 19122016
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.cs_Missing_Number_of_packages));
                         isNotValid = true;
                    }
                    
                    if(String.isEmpty(o.Vekt_volum_str__c))
                    {
                         //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Mangler Vekt/volum/str'));
                          //CSPhase2, Supriya , 19122016
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.cs_Missing_weight_Volume));
                        
                         isNotValid = true;
                    }
          
               }

               else if(o.RecordType.Id == MBH_RecordTypeId)
               { 
               
                  isMBHOrder = true;
                  //Validation for record type MBH 
                  if(String.isEmpty(o.Sendingsnummer__c))
                    {
                         //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Mangler Sendingsnummer'));
                         //CSPhase2, Supriya , 19122016
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.cs_Missing_Sending_Number));
                         
                        isNotValid = true;
                    } 

                    if(String.isEmpty(o.reason__c))
                    {
                         //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Mangler Årsak'));
                          //CSPhase2, Supriya , 19122016
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.cs_Missing_Cause));
                         isNotValid = true;
                    } 

                   // else if(o.reason__c.equalsIgnoreCase('Cancellation'))
                    else if(o.reason__c.equalsIgnoreCase('Avbestilling'))
                    {
                         if(String.isEmpty(o.OrderNumber__c))
                         {
                         //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Dersom kunden ikke har ordrenummer, må vi ha de fire siste sifrene på kortet som ble benyttet ved bestilling'));
                         //CSPhase2, Supriya , 19122016
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.cs_Missing_Order_number));
                         
                         isNotValid = true;
                         }

                         if(o.Amount__c == null)
                         {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Mangler Beløp'));
                            //CSPhase2, Supriya , 19122016
                        // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.cs_Missing_Amount));    
                      
                         isNotValid = true;  
                         }

                         
                    }  

                    if(o.postalUnit__c == null)   
                    {
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Mangler Postal enhet'));
                     //CSPhase2, Supriya , 19122016
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.cs_Missing_Postal_Unit));
                    isNotValid = true; 
                    }  
                    
               }

               // We will try to check the transportation unit only when the basic information is updated.
               // This helps reduce un-necessary processing.   
               if(!isNotValid)
               {
                    validation_flag = true;
                    transportUnit();
               }

               
          }
     }

     /*
     This function will:
     Search the transport unit to which the email is to be sent based on the ORDER'S ShippingPostalCode.
     */

     public void transportUnit()
     {
          //Check if the ShippingPostalCode is NUMERIC AND 4 DIGIT.
          if((!o.ShippingPostalCode.isNumeric()) || (o.ShippingPostalCode.length() != 4))
          {
               //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Feil Postnummer'));
               //CSPhase2, Supriya , 19122016
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.cs_Wrong_Zip));
          }
          else
          {    
               for(Adhoc_order_details__c a: Adhoc_order_details__c.getAll().values())
               {    
                    //Check if the transport unit is active.
                    if(a.Active__c)
                    {
                         //Check if the Order's ShippingPostalCode lies in between Start_postal_code__c and End_postal_code__c of any record of the custom setting Adhoc_order_details__c
                         if((a.Start_postal_code__c <= o.ShippingPostalCode) && (o.ShippingPostalCode <= a.End_postal_code__c))
                         {
                              transportUnitName = a.transport_unit_name__c;
                              email = a.Email__c;
                              unit_Flag = true;
                         }
                    }
               }

               // Error message if Unit was not found
               if(!unit_Flag)
               {
                   //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Kan ikke finne lokal avdeling for dette postnummer'));
                   //CSPhase2, Supriya , 19122016
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.cs_local_branch_not_found));
               }
          }
     }

     /*
     This function will:
     Set the Transport_unit_email__c and Transport_unit_name__c on the order and set order status to 'Ready to send'.
     Update the Order to database.
     */
     
     public void sendEmailToTransportUnit()
     {
           //save the name and the email of the transport unit to which the Order email is to be send in the orders internal fields.
          o.Transport_unit_email__c = email;
          o.Transport_unit_name__c = transportUnitName;

          //Update the order status to ready to send.
          o.status = 'Ready to send';
          
          try
          {    //updating the order status to 'Ready to send' in database will trigger the workflow rule 'Order Send email to transport unit'
               update o;
               //set the unit_Flag to false to rerender the ORDER SUMMARY pageblock.
               unit_Flag = false;
               // Hide the BDX section
               isBDX = false;
               
               //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'E-post vellykket sendt'));
               //CSPhase2, Supriya , 19122016
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,System.Label.cs_Email_successfully_sent));

              // if(o.RecordType.Id == MBH_RecordTypeId && o.reason__c.equalsIgnoreCase('Cancellation'))
                  /*if(o.RecordType.Id == MBH_RecordTypeId && o.reason__c.equalsIgnoreCase('Avbestilling'))
               { 
                    Case c = createCaseForMBH(o.Case__c);
                    if(c != null)
                    {
                        Database.insert(c);  
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Ny relatert sak er opprettet'));
                         //CSPhase2, Supriya , 19122016
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,System.Label.cs_New_related_case_created));
                    }
                    else
                    {
                       // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Feil! Relatert sak kunne ikke opprettes automatisk'));
                        //CSPhase2, Supriya , 19122016
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.cs_related_case_not_created));
                    }
               }*/
               
               Approval.LockResult[] lrList = Approval.lock(ordList, false);
          }
          
          catch(Exception e)
          {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.cs_File+':' + e.getMessage()));
          }

          

     }


     public void loadNotification()
     {
          // This variable to count the number of notifications for this record type which gets displayed
          Integer count = 0;
          
          for(Order_Notifications__c n:Order_Notifications__c.getAll().values())
          {
               if(n.Aktiv__c && n.Record_Type__c.equalsIgnoreCase(o.RecordType.developerName))
               {
                    if(String.isEmpty(o.Type))
                    {
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,n.Notification__c));
                         count = count + 1;
                    }
                    else if(n.Order_Type__c.equalsIgnoreCase(o.Type))
                    {
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,n.Notification__c));   
                         count = count + 1;
                    }                         
               }
          }
          
          if(count == 0)
          {
              //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Ingen opplysninger'));
              //CSPhase2, Supriya , 19122016
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.cs_No_information));
              
               
          }
          
     }
//
     /*private Case createCaseForMBH(Id ParentCaseid)
     {
          List<Case> pcList = new List<Case>(); 
          pcList = [SELECT Id, 
                           AccountId,
                           ContactId,
                           Description,
                           SuppliedPhone,
                           SuppliedEmail,
                           SuppliedName 
                      FROM Case 
                     WHERE id =:ParentCaseid];
          
          try
          {
               if(pcList.size() < 1 || pcList.size() > 1)
               {
                   //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Feil med sak knyttet til ordre, Kontroller og forsøk igjen'));
                   //CSPhase2, Supriya , 19122016
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_faulty_matters));
               }
               else if(pcList.size() == 1)
               {
                   Group g =[select Id from Group where DeveloperName = 'LogistikkFakturering' and Type = 'Queue'];

                   Case childCase = pcList[0].clone(false,false,false,false);
                   childCase.Subject ='MBH - Avbestilling';
                   childCase.ParentId = pcList[0].Id;
                   childCase.RecordTypeId = simple_inquiry;
                   childCase.OwnerId = g.Id;
                   return childcase;
               }
          }
          catch(Exception e)
          {
               //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Fant ikke køen Logistikk fakturering! - ' + e.getMessage()));
               //CSPhase2, Supriya , 19122016
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.cs_queue_logistics_biling +' - ' + e.getMessage()));
          }
          return null;
     }*/
}