global class CaseHandler implements Messaging.InboundEmailHandler
{
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope)
      {
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          
          if(email.subject.startsWith('Lukking av sak'))
          {
              String cNo = email.subject.subString(email.subject.indexOf('{') + 1,email.subject.indexOf('}')).trim();
              String epostRef = email.subject.subString(email.subject.indexOf('['),email.subject.indexOf(']') + 1).trim();
              Case c = null;
              List<QueueDetails__c> q = new List<QueueDetails__c>();
              list<Id> queueId = new List<id>();
              
              try
              {
                  c = [SELECT Id, CaseNumber, OwnerId,Status,hidden_owner_type__c,hidden_queue_id__c FROM Case WHERE CaseNumber = :cNo AND case_referens__c = :epostRef];
                   
                    
                  if(c != null)
                  { 
                
                  queueId.add(c.OwnerId);

                    if(c.hidden_owner_type__c =='Queue')
                    {
                      q = [Select Name,queue_owner__c from QueueDetails__c where OwnerId =:queueId Limit 1];
                       System.debug('In this queue' );   
                     
                    
                    if(q.size()>0)
                    {
                     System.debug('In this queue1' );   
                      if (q[0].queue_owner__c!=null)
                      {
                        c.OwnerId =q[0].queue_owner__c; 
                          System.debug('In this queue2' + q[0].queue_owner__c);   
                        //c.hidden_owner_type__c='User';
                      }
                    }
                  }
                  
                  String statuscase= c.status;
                  if(!(statuscase.contains('Avsluttet')||statuscase.contains('Spam')))
                  {
                   c.Status = 'Avsluttet - kunde';
                  }
                      //CSphase2 supriya 23122016
                      
                     // c.Status = 'Closed - customer';
                      
                      
                      CaseComment cc = new CaseComment();
                      cc.ParentId = c.Id;
                     // cc.CommentBody = 'Sak lukket av kunde: ' + email.plainTextBody;
                      //Csphase2 supriya 23122016
                      cc.CommentBody = System.label.cs_Case_closed_by_customer+': ' + email.plainTextBody;
                               
                     
                      database.insert(cc);
                      database.update(c);
                  }
                  else
                  {    
                      result.success = false;
                      //result.message = 'Unnlatt å avslutte saken automatisk. Ta kontakt med kundestøtte for å avslutte saken.';
                      //Csphase2 supriya 23122016
                      result.message = System.label.cs_Failed_to_close_case;
                       
                      return result;
                  }
              }
              catch(exception e)
              {
                  result.success = false;
                   //result.message = 'Unnlatt å avslutte saken automatisk. Ta kontakt med kundestøtte for å avslutte saken.';
                  //Csphase2 Supriya 26122016
                  result.message = System.Label.cs_Failed_to_close_case;
                                  
                  return result;
              }

          result.success = true;
           //Csphase2 supriya 23122016
           // result.message = 'Saken er Avsluttet etter kundens ønske';
          result.message = System.Label.cs_Case_closed_by_customer;
        
          return result;
          }
       result.success = false;
       //result.message = 'Unnlatt å avslutte saken automatisk. Ta kontakt med kundestøtte for å avslutte saken.';
       //Csphase2 supriya 23122016
       result.message = System.label.cs_Failed_to_close_case;
                       
       return result;   
          
      }
  }