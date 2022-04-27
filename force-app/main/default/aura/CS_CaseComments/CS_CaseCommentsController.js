({
    doInit: function (component, event, helper) {
        var actions =[{
            label : $A.get("$Label.c.Edit"),
            name : 'Edit',
            iconName : 'action:preview'
        },
                      {label : $A.get("$Label.c.Delete"),
            name : 'Delete',
                       iconName : 'action:delete' }       
                     ]
        component.set('v.mycolumns', [
            { label: $A.get("$Label.c.Comments"), fieldName: 'CommentBody', type: 'text'},
            { label: $A.get("$Label.c.User"), fieldName: 'Createdname', type: 'url', typeAttributes: { label: { fieldName: 'Createdname' }, target:'_self'}},
            { label: $A.get("$Label.c.Public"), fieldName: 'IsPublished', type: 'boolean'},
            { label: $A.get("$Label.c.Created_Date"), fieldName: 'CreatedDate', type: 'date' ,typeAttributes: {
    day: 'numeric',
    month: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
                timeZone: 'Africa/Algiers',
    hour12: false
  },
            },
           
            {type: 'action', typeAttributes : {rowActions: actions}}
        ]);
        component.set('v.mycolumns1', [
             { label: $A.get("$Label.c.Comments"), fieldName: 'CommentBody', type: 'text'},
            { label: $A.get("$Label.c.User"), fieldName: 'Createdname', type: 'url', typeAttributes: { label: { fieldName: 'Createdname' }, target:'_self'}},
            { label: $A.get("$Label.c.Public"), fieldName: 'IsPublished', type: 'boolean'},
            { label: $A.get("$Label.c.Created_Date"), fieldName: 'CreatedDate', type: 'date' ,typeAttributes: {
    day: 'numeric',
    month: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
                timeZone: 'Africa/Algiers',
    hour12: false
  },
            }
            
            
        ]);
        
        helper.getAllCaseComments(component, event, helper); 
      //  helper.initColumnsWithActions(component, event, helper)
    },
    
    handleColumnsChange: function (component, event, helper) {
       // helper.initColumnsWithActions(component, event, helper)
    },
    
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        console.log(row.Id);
        var onRowActionHandler = cmp.get('v.onRowActionHandler');

        if(onRowActionHandler){
            console.log('Inside onrowAction')
            $A.enqueueAction(onRowActionHandler)                       
        }else{            
            switch (action.name) {
                case 'Edit':
                    console.log('inside edit');
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
            "relatedListId": "CaseComments",
            "parentRecordId": cmp.get("v.recordId")
        });
        relatedListEvent.fire();
    },
       
	handleCreateRecord : function (cmp, event, helper) {
        var recId=cmp.get("v.recordId");
        console.log(recId);
        var pbody;
        
        $A.createComponent("c:newCaseComment", {
                CaseId: cmp.get("v.recordId"),
            CasecommentId: null
            	
            },
                           
            function(content, status) {
                
                if (status === "SUCCESS") {
                    
                    pbody = content;
                    cmp.find('overlayLib').showCustomModal({
                        body: pbody,
                        header: $A.get("$Label.c.New_Case_Comment"),
                        showCloseButton: true,
                        closeCallback: function() {
                            
                        }
                    })
                }
            });
       /* var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:newCaseComment",
            //You can pass attribute value from Component1 to Component2
            componentAttributes :{
            "CaseId": recId
              }
        });
        navigateEvent.fire();*/
        /*var createRecordEvent = $A.get("e.force:createRecord");
        
        alert(recId);
        createRecordEvent.setParams({
            "entityApiName": 'CaseComment',
            "defaultFieldValues": {
                "ParentId" : recId,
                "useRecordTypeCheck":1
            }
        });
        createRecordEvent.fire();*/
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