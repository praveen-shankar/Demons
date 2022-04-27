global class WaveAgreementMonthlySchedulable implements Schedulable {
   global void execute(SchedulableContext sc) {
      WaveAgreementMonthlyBatch ba = new WaveAgreementMonthlyBatch(); 
      database.executebatch(ba,10);
   }
}