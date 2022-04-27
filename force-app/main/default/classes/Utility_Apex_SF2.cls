public class Utility_Apex_SF2 {
    
    /*
       //Random Unique key generator string key 
    */
    public static string generateUniqueString(string key){
        string  unique_Key ;
        if(key != null && key != ''){
          unique_Key = key + String.valueOf(Datetime.now().getTime()) + String.valueOf(Math.abs(Crypto.getRandomLong())); 
        }
        return unique_Key ;
    }
}