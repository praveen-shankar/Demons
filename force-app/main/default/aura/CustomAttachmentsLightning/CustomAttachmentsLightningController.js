({
    doInit: function (component, event, helper) {
        var actions =[{
            label : 'Edit',
            name : 'Edit',
            iconName : 'action:preview'
        },
                      {label : 'Delete',
            name : 'Delete',
                       iconName : 'action:delete' }       
                     ]
        component.set('v.mycolumns', [
            { label: 'Custom Attachment Detail Name', fieldName: 'linkName', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target:'_self'}},
            { label: 'Attachment', fieldName: 'linkAttachmentname', type: 'url',typeAttributes: { label: { fieldName: 'Attachmentname' }, target:'_self'}},
            { label: 'Selected User', fieldName: 'Username', type: 'text' },
            
             
            {type: 'action', typeAttributes : {rowActions: actions}}
        ]);
        helper.getAllCaseAttachments(component, event, helper); 
      //  helper.initColumnsWithActions(component, event, helper)
    },
    
    handleColumnsChange: function (component, event, helper) {
       // helper.initColumnsWithActions(component, event, helper)
    },
    
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        console.log(row.Attachment__c);
        var onRowActionHandler = cmp.get('v.onRowActionHandler');

        if(onRowActionHandler){
            $A.enqueueAction(onRowActionHandler)                       
        }else{            
            switch (action.name) {
                case 'Edit':
                    helper.editRecord(cmp, row)
                    break;
                case 'Delete':
                    helper.removeRecord(cmp, row)
                    break;
            }
        }
    },
    
    handleGotoRelatedList : function (cmp, event, helper) {
        var relatedListEvent = $A.get("e.force:navigateToRelatedList");
        relatedListEvent.setParams({
            "relatedListId": "Custom_Attachment_Details__r",
            "parentRecordId": cmp.get("v.recordId")
        });
        relatedListEvent.fire();
    },
       
	handleCreateRecord : function (cmp, event, helper) {
        var recId=cmp.get("v.recordId");
        console.log(recId);
        
         var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
              "url": "/apex/CaseNewCustomAttachFile?id="+recId,
              "isredirect": "true"
            });
            urlEvent.fire();
       
      
	},   
        
	handleToastEvent  : function (cmp, event, helper) {
        var eventType = event.getParam('type');
        var eventMessage= event.getParam('message');
        if(eventType == 'SUCCESS' && eventMessage.includes(cmp.get('v.sobjectLabel'))){
            helper.fetchData(cmp, event, helper)
        	event.stopPropagation();            
        }        
	},   
    
})