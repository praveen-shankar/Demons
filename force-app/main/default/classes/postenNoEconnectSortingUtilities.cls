public with sharing class postenNoEconnectSortingUtilities {
    public enum REVENUE { POST, LOGISTIKK, POST_AND_LOGISTIKK }
    private REVENUE revenueType;
    
    public List<postenNoEconnectKatsSaksearchcustome.Customer_element> sort(List<postenNoEconnectKatsSaksearchcustome.Customer_element> customers) {
        List<postenNoEconnectKatsSaksearchcustome.Customer_element> sortedCustomers = new List<postenNoEconnectKatsSaksearchcustome.Customer_element>();
        
        if (customers != null){
            List<CustomerWrapper> wrappedCustomers = createCustomerWrapper(customers);

            wrappedCustomers.sort();
            sortedCustomers = unwrapCustomers(wrappedCustomers);
        }
        return sortedCustomers;
    }

    virtual class CustomerWrapper implements Comparable {
        public postenNoEconnectKatsSaksearchcustome.Customer_element customer;
        public Double totalRevenueCurrentYear;
        public Double totalRevenuePreviousYear;
        
        public CustomerWrapper(postenNoEconnectKatsSaksearchcustome.Customer_element customer) {
            this.customer = customer;
                totalRevenueCurrentYear = customer.Revenues.TotalRevenueCurrentYear_L + customer.Revenues.TotalRevenueCurrentYear_P;
                totalRevenuePreviousYear = customer.Revenues.TotalRevenuePreviousYear_L + customer.Revenues.TotalRevenuePreviousYear_P;
        }
        
        public Integer compareTo(Object obj) {
            CustomerWrapper other = (CustomerWrapper) obj;
            
            Integer compareResult = Integer.valueOf(other.totalRevenueCurrentYear - this.totalRevenueCurrentYear);
            if(other.totalRevenueCurrentYear == 0 && this.totalRevenueCurrentYear == 0) {
                compareResult = Integer.valueOf(other.totalRevenuePreviousYear - this.totalRevenuePreviousYear);
            }
            return compareResult;
        }
    }
    
    class CustomerPostWrapper extends CustomerWrapper {
        CustomerPostWrapper(postenNoEconnectKatsSaksearchcustome.Customer_element customer) {
            super(customer);
            
            totalRevenueCurrentYear = customer.Revenues.TotalRevenueCurrentYear_P;
            totalRevenuePreviousYear = customer.Revenues.TotalRevenuePreviousYear_P;
        }
    }
    
    class CustomerLogistikkWrapper extends CustomerWrapper {
        CustomerLogistikkWrapper(postenNoEconnectKatsSaksearchcustome.Customer_element customer) {
            super(customer);
            
            totalRevenueCurrentYear = customer.Revenues.TotalRevenueCurrentYear_L;
            totalRevenuePreviousYear = customer.Revenues.TotalRevenuePreviousYear_L;
        }
    }

    
    public postenNoEconnectSortingUtilities(REVENUE revenueType) {
        this.revenueType = revenueType;
    }
    
    
    private List<CustomerWrapper> createCustomerWrapper(List<postenNoEconnectKatsSaksearchcustome.Customer_element> customers) {
        List<CustomerWrapper> wrappedCustomers = new List<CustomerWrapper>();
        
        for(postenNoEconnectKatsSaksearchcustome.Customer_element customer: customers) {
            if (customer.Revenues == null) {
                customer.Revenues = new postenNoEconnectKatsSaksearchcustome.RevenueType();
            }
            
            if (customer.Revenues.TotalRevenuePreviousYear_L == null) {
                customer.Revenues.TotalRevenuePreviousYear_L = 0;
            }
            if (customer.Revenues.TotalRevenueCurrentYear_L == null) {
                customer.Revenues.TotalRevenueCurrentYear_L = 0;
            }
            if (customer.Revenues.TotalRevenuePreviousYear_P == null) {
                customer.Revenues.TotalRevenuePreviousYear_P = 0;
            }
            if (customer.Revenues.TotalRevenueCurrentYear_P == null) {
                customer.Revenues.TotalRevenueCurrentYear_P = 0;
            }
        }
        
        if(revenueType == REVENUE.POST) {
            for(postenNoEconnectKatsSaksearchcustome.Customer_element customer: customers) {
                wrappedCustomers.add(new CustomerPostWrapper(customer));
            }
        } else if(revenueType == REVENUE.LOGISTIKK) {
            for(postenNoEconnectKatsSaksearchcustome.Customer_element customer: customers) {
                wrappedCustomers.add(new CustomerLogistikkWrapper(customer));
            }
        } else {
            for(postenNoEconnectKatsSaksearchcustome.Customer_element customer: customers) {
                wrappedCustomers.add(new CustomerWrapper(customer));
            }
        }
        return wrappedCustomers;
    }
    
    private List<postenNoEconnectKatsSaksearchcustome.Customer_element> unwrapCustomers(List<CustomerWrapper> wrappedCustomers) {
        List<postenNoEconnectKatsSaksearchcustome.Customer_element> unwrappedCustomers = new List<postenNoEconnectKatsSaksearchcustome.Customer_element>();
        
        for(CustomerWrapper wrappedCustomer : wrappedCustomers) {
            unwrappedCustomers.add(wrappedCustomer.customer);
        }
        return unwrappedCustomers;
    }
}