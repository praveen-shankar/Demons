/*
 * Author - Rajeev Shekhar
*/
public class edi_fetchLMErrorsSchedulable implements Schedulable {
   public void execute(SchedulableContext sc) {
       String triggerId = (sc != null) ? sc.getTriggerId() : null;
       edi_fetchLMErrorsAndEmail.process(triggerId);
   }
}