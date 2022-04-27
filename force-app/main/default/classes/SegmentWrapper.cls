public class SegmentWrapper{
        public String accountId;
        
        
        public segmentreqchange[] reqchangesegments;
        public class segmentreqchange{
            public String month;
           // public String year;
            public String responsibleSeller;
            public String responsibleSellermanager;
            public String segId;
            public String serviceGroupvalue;
            public String proposedresponsibleSeller;
            public String proposedresponsibleSellermanager;
            public String reasonofchange;
           
        }
        public static SegmentWrapper parse(String json){
            return (SegmentWrapper) System.JSON.deserialize(json, SegmentWrapper.class);
        }

    }