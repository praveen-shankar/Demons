({
   
    getAllCaseComments : function(component,event,helper) {
        var action = component.get('c.getcaseComments');
        action.setParams({
            caseId: component.get("v.recordId")
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               var rows = response.getReturnValue();     
            for (var i = 0; i < rows.length; i++) { 
                var row = rows[i]; 
                //as data columns with relationship __r can not be displayed directly in data table, so generating dynamic columns 
                
                    row.Createdname = row.CreatedBy.Name; 
                   // row.AccountName = row.Opportunity__r.Account.Name; 
                   // item['URL'] = '/lightning/r/Case/' + item['Id'] + '/view'; 
                 
            } 
                component.set('v.mydata', rows);
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    flattenStructure : function (helper,topObject, prefix, toBeFlattened) {
      for (const prop in toBeFlattened) {
        const curVal = toBeFlattened[prop];
        if (typeof curVal === 'object') {
          helper.flattenStructure(helper, topObject, prefix + prop + '_', curVal);
        } else {
          topObject[prefix + prop] = curVal;
        }
      }
    },    
    
   initColumnsWithActions: function (component, event, helper) {
        var customActions = component.get('v.customActions')
        if( !customActions.length){
            customActions = [
                { label: 'Edit', name: 'edit' },
                { label: 'Delete', name: 'delete' }
	        ]         
        }
        
        var columns = component.get('v.columns')        
        var columnsWithActions = []
        columnsWithActions.push(...columns)
        columnsWithActions.push({ type: 'action', typeAttributes: { rowActions: customActions } })
        component.set('v.columnsWithActions',  columnsWithActions)
    },    
    
    removeRecord: function (cmp, row) {
      /*  var modalBody;
        var modalFooter;
        var sobjectLabel = cmp.get('v.sobjectLabel')
        $A.createComponents([
            ["c:deleteRecordContent",{sobjectLabel:sobjectLabel}],
            ["c:deleteRecordFooter",{record: row, sobjectLabel:sobjectLabel}]
        ],
        function(components, status){
            if (status === "SUCCESS") {
                modalBody = components[0];
                modalFooter = components[1];
                cmp.find('overlayLib').showCustomModal({
                   header: "Delete " + sobjectLabel,
                   body: modalBody, 
                   footer: modalFooter,
                   showCloseButton: true
               })
            }
        }
       );*/
        var action = cmp.get('c.deleterecord');
        var recId=cmp.get("v.recordId");
        action.setParams({
            caseId: row.Id
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse='true')
                {
              			var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "title": 'Success',
                            "message": 'Case comment deleted successfully',
                            "type":"success"
                        
                    });
                         resultsToast.fire();
                    var redirect = $A.get("e.force:navigateToSObject");
        
                    // Pass the record ID to the event
                    redirect.setParams({
                        "recordId": recId
                    });
                    
                    // Open the record
                    redirect.fire(); 
                		
                   }
                else
                {
                   var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "title": 'Error',
                            "message": 'Case comment cannot be deleted',
                            "type":"error"
                        
                    });
                         resultsToast.fire();
                		$A.get("e.force:refreshView").fire(); 
                }
                
            }else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        
        $A.enqueueAction(action);
	//$A.get("e.force:refreshView").fire();
		        
    },
    
	editRecord : function (cmp, row) {
         var pbody;
       // Console.log('Row'+row.Id);
       // Console.log('Record Id'+cmp.get("v.recordId") );
        $A.createComponent("c:newCaseComment", {
                CasecommentId: row.Id,
            	CaseId: cmp.get("v.recordId")
            	
            },
                           
            function(content, status) {
                
                if (status === "SUCCESS") {
                    
                    pbody = content;
                    cmp.find('overlayLib').showCustomModal({
                        body: pbody,
                        header: "Edit Case Comment",
                        showCloseButton: true,
                        closeCallback: function() {
                            
                        }
                    })
                }
            });
       /* var createRecordEvent = $A.get("e.force:editRecord");
        createRecordEvent.setParams({
            "recordId": row.Id
        });
        createRecordEvent.fire();*/
	}, 
})