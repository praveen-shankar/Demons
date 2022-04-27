/*
 * Author -Supriya Goel
  12 oct 2019 
*/
public class Delete_EDIErrorLogsSchedulable implements Schedulable {
   public void execute(SchedulableContext sc) {
     
        Database.executeBatch(new Delete_EDIErrorLogsBatch(),10);
   }
}