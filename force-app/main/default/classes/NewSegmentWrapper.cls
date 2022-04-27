public class NewSegmentWrapper 
{   
    public String accountId;    
    public segmentreqchange[] reqchangesegments;
    
    public class segmentreqchange
    {        
        public String serviceGroupvalue;
        public String proposedresponsibleSeller;
        public boolean chkServiceGroupvalue;        
    }
    
    public static NewSegmentWrapper parse(String json)
    {
        return (NewSegmentWrapper) System.JSON.deserialize(json, NewSegmentWrapper.class);
    }
    
}