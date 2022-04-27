public class Parser {
    
    public static string xmlparser(string res){
    try{
        String EnhetsNr_name;
        String Navn_name;
        String Epost_name;
        String resultlist;
        Dom.Document doc = new Dom.Document();
        doc.load(res);
        Dom.XMLNode a = doc.getRootElement();//dataset + diffgram nodes
        for(dom.XmlNode aa : a.getChildElements()) {
            system.debug('a: '+aa);
            if(aa.getName()=='diffgram')//diffgram
                for(dom.XmlNode aaa : aa.getChildElements()){//NewDataSet
                    system.debug('xml: '+aaa);
                    if(aaa.getname()=='NewDataSet'){
                        for(dom.XmlNode b : aaa.getChildElements()){//Table
                            if(b.getname()=='Table'){
                                EnhetsNr_name = b.getChildElement('EnhetsNr', null).getText();
                                Navn_name = b.getChildElement('Navn', null).getText();
                                Epost_name = b.getChildElement('Epost', null).getText();
                                System.debug('EnhetsNr_name: '+EnhetsNr_name);
                                System.debug('Navn_name: '+Navn_name);
                                System.debug('Epost_name: '+Epost_name);
                                resultlist = EnhetsNr_name + ','+ Navn_name+',' +Epost_name;                                
                                
                            }
                        }
                    }
                }
        }
    return resultlist;    
    }
        catch(exception e){
            System.debug('~~~~exception');
            return 'null';
            
        }
    }
}