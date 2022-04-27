/*If user is sent to customer search and it is unknown if they want private or business search,
the user is sent to a page to decide which searchtype they want.*/

public class CustomerSearch_chooseSearchType {
        public String caseId {get; private set;}
        private String phone;
        private String url;
        
        public CustomerSearch_chooseSearchType() {
                caseId = ApexPages.currentPage().getParameters().get('caseId');
                phone = ApexPages.currentPage().getParameters().get('phone');
                url = '/apex/';
        }
        
        public PageReference goToCase() {
                return new PageReference('/' + caseId);
        }
        
        public PageReference goToPrivateSearch() {
                url += 'customersearch_private';
                addUrlParameters();
                return new PageReference(url);
        }
        
        public PageReference goToBusinessSearch() {
                url += 'customersearch_business';
                addUrlParameters();
                return new PageReference(url);
        }
        
        private void addUrlParameters() {
                String parameters = '';
                if(String.isNotBlank(caseId)) {
                        url += getPageParameterPrefix(url) + 'caseId=' + caseId;
                }
                if(String.isNotBlank(phone)) {
                        url += getPageParameterPrefix(url) + 'phone=' + phone;
                }
        }
        
        /*Find out if the parameter should start with ? or & based on curret url*/
        private String getPageParameterPrefix(String currentUrl) {
                if(String.isNotBlank(currentUrl)) {
                        if(currentUrl.contains('?')) {
                                return '&';
                        }
                        return '?';
                }
                return null;
        }
}