//***Utility class for some of the basic conversions to String in Salesforce
//***Author - Rajeev S
//***Test method in "zzz_SendCaseAttachmentsController" class.

public class KATS_ConversionUtility{
  
      
      
      /* string representation if an Integer value */
      public static String ToString(integer Value){
          return Value.format();
      }
 
      
       /* string representation if a Double value */
      public static String ToString(Double Value){
          return Value.format();
      }
 
  
      /* string representation if a Boolean value */
      public static String ToString(Boolean Value){
          if (Value)
              return 'true';
          else
              return 'false';
      }
     
     
     
      /* string representation if a Long value */
      public static String ToString(Long Value){
          return Value.format();
      }
 
  
  
      /* string representation if a Date value */
      public static String ToString(Date Value){
          return Value.format();
      }
 
  
  
      /* string representation if a Date value with formatting */
      public static String ToString(Date Value,String format){
              Datetime temp = Datetime.newInstance(Value.year(), Value.month(), Value.day());
          return temp.format(format);
      }
 
      
      /* string representation if a Datetime value */
      public static String ToString(Datetime Value){
          return Value.format();
      }
 
  
      /* string representation if a Datetime value with formatting */
      public static String ToString(Datetime Value,String format){
          return Value.format(format);
      }
 
  
      /* string representation if a Time value */
      public static String ToString(Time Value){
          return String.valueOf(Value);
      }
 
  
      /* string representation if a Time value with formating */
      public static String ToString(Time Value, String format){
              Datetime temp = Datetime.newInstance(1970, 1, 1, Value.hour(), Value.minute(), Value.second());
          return temp.format(format);
      }

      
      /* string representation if a Decimal value */
      public static String ToString(Decimal Value){
        return Value.format();
      }
 
  
      /* string representation if a Decimal value with or without Scientific Notation */
      public static String ToString(Decimal Value, Boolean ScientificNotation){
        if (ScientificNotation)
             return Value.format();
        else
             return Value.toPlainString();
      }
 
  
      /* string representation if a file's size, such as 2 KB, 4.1 MB, etc */
      public static String FileSizeToString(Long Value){
        if(Value != null){  
          if (Value < 1024)
              return ToString(Value) + ' Bytes';
          else if (Value >= 1024 && Value < (1024*1024)){
          //KB
              Decimal kb = Decimal.valueOf(Value);
              kb = kb.divide(1024,2);
              return ToString(kb) + ' KB';
          }
          else if (Value >= (1024*1024) && Value < (1024*1024*1024)){
          //MB
              Decimal mb = Decimal.valueOf(Value);
              mb = mb.divide((1024*1024),2);
              return ToString(mb) + ' MB';
          }
          else{
          //GB
              Decimal gb = Decimal.valueOf(Value);
              gb = gb.divide((1024*1024*1024),2);
              return ToString(gb) + ' GB';
          }
        }else{
          return '0 Bytes';
        }
      }
 
  
      public static String CurrencyToString(Decimal Value, String CurrencyChar){
             return CurrencyChar + ToString(Value);
      }
 
}