({
	doInit : function(cmp, event, helper) {
        var recordId = cmp.get("v.recordId");
        var actions;
        var isProfileAccess = true;
        var currentprofileName = cmp.get('v.currentProfileName');
        var DeleteButtonVisibleProfile = $A.get("$Label.c.Delete_Button_Visible_Profile");
        var getActiveAgreementOpportunities = cmp.get("v.getActiveAgreementOpportunities");
        cmp.set('v.deleteDisabled', false);
        
		console.log('recordId-------------'+recordId);
		console.log('getActiveAgreementOpportunities-------------'+JSON.stringify(getActiveAgreementOpportunities));
        
        if(cmp.get('v.singleSelection') == '1') {
            cmp.set('v.maxRowSelection','1')
        }
		
        console.log('currentprofileName----'+currentprofileName);
        console.log('DeleteButtonVisibleProfile----'+DeleteButtonVisibleProfile);
        console.log('DeleteButtonVisibleProfile.indexOf(currentprofileName)----'+DeleteButtonVisibleProfile.indexOf(currentprofileName));
        
        //Visible Delete Button on Custom Label profiles
        if(!$A.util.isEmpty(DeleteButtonVisibleProfile) && !$A.util.isEmpty(currentprofileName) && DeleteButtonVisibleProfile.indexOf(currentprofileName) > -1){
            actions = [
                { label: 'Edit', name: 'edit' },
                { label: 'Delete', name: 'delete' }
                ];
        }else{
             actions = [{ label: 'Edit', name: 'edit' } ];
        }    
        
        // Hide Checkbox Column
        /*if(cmp.get('v.hideShow').toLowerCase() == 'hide') {
            cmp.set('v.hideCheckboxColumn', true)
        }*/

        // Column Settings
        var cols = new Array();
        for (var i=101; i < 111; i++) {
            var varIcon = ''      
            var test =cmp.get('v.column'+i.toString().substring(1)+'_fieldName');
				console.log('test--------------'+test);                                 
            if(cmp.get('v.column'+i.toString().substring(1)+'_fieldName')) {
                if (i.toString().substring(1) === '01') {
                    varIcon = cmp.get('v.column'+i.toString().substring(1)+'_icon')
                }
				console.log(i);  
				var cellClass =  
					cmp.get('v.column'+i.toString().substring(1)+'_type').toLowerCase() == 'number' ||
					cmp.get('v.column'+i.toString().substring(1)+'_type').toLowerCase() == 'currency'
					? 
                	{
                		fieldName : cmp.get('v.column'+i.toString().substring(1)+'_fieldName') + 'class'
                	}
            		:
            		{};
                var isOppNameCol = cmp.get('v.column'+i.toString().substring(1)+'_fieldName') == 'Name';
                var agreementNameCol = cmp.get('v.column'+i.toString().substring(1)+'_fieldName') == 'crm_AgreementName__c';
                var isDate = cmp.get('v.column'+i.toString().substring(1)+'_label') == 'Date';
                if(isDate){
                    cols.push({
                        iconName: varIcon,
                        label: cmp.get('v.column'+i.toString().substring(1)+'_label'), 
                        fieldName: cmp.get('v.column'+i.toString().substring(1)+'_fieldName'), 
                        type: cmp.get('v.column'+i.toString().substring(1)+'_type'), 
                        sortable: true,
                        wrapText: true,
                        initialWidth: cmp.get('v.column'+i.toString().substring(1)+'_width'), 
                        editable: false,
                        cellAttributes: {
                            alignment: cmp.get('v.column'+i.toString().substring(1)+'_align'),
                            class: cellClass                        	
                        }
                    });
        		    
                }else if(isOppNameCol) {
                    debugger;
                     cols.push({
                        iconName: varIcon,
                        label: cmp.get('v.column'+i.toString().substring(1)+'_label'), 
                        fieldName: 'oppRecordURL', 
                        type: 'url', 
                        sortable: true,
                        wrapText: true,
                        initialWidth: cmp.get('v.column'+i.toString().substring(1)+'_width'), 
                        editable: false,
                         typeAttributes: {label: { fieldName: 'OpportunityName' } , target : "_blank"},
                        cellAttributes: {
                            alignment: cmp.get('v.column'+i.toString().substring(1)+'_align'),
                            class: cellClass                        	
                        }
                    });
                 
                }else if(agreementNameCol) {
                    debugger;
                     cols.push({
                        iconName: varIcon,
                        label: cmp.get('v.column'+i.toString().substring(1)+'_label'), 
                        fieldName: 'agreementRecordURL', 
                        type: 'url', 
                        sortable: true,
                        wrapText: true,
                        initialWidth: cmp.get('v.column'+i.toString().substring(1)+'_width'), 
                        editable: false,
                         typeAttributes: {label: { fieldName: 'Agreement' } , target : "_blank"},
                        cellAttributes: {
                            alignment: cmp.get('v.column'+i.toString().substring(1)+'_align'),
                            class: cellClass                        	
                        }
                    });
                 
                }else{
                    cols.push({
                        iconName: varIcon,
                        label: cmp.get('v.column'+i.toString().substring(1)+'_label'), 
                        fieldName: cmp.get('v.column'+i.toString().substring(1)+'_fieldName'), 
                        type: cmp.get('v.column'+i.toString().substring(1)+'_type'), 
                        sortable: true,
                        wrapText: true,
                        initialWidth: cmp.get('v.column'+i.toString().substring(1)+'_width'), 
                        editable: false,
                        cellAttributes: {
                            alignment: cmp.get('v.column'+i.toString().substring(1)+'_align'),
                            class: cellClass                        	
                        }
                    });
            	}
                
                
            }
            console.log('cols--------------'+JSON.stringify(cols)); 
        }
         cols.push({ type: 'action', 
                            typeAttributes: { rowActions: actions } ,initialWidth: 100 });
        cmp.set('v.tablecolumns', cols);

        if(cmp.get('v.getActiveAgreementOpportunities') && cmp.get('v.getActiveAgreementOpportunities').length > 0){
            var recordSize = cmp.get('v.getActiveAgreementOpportunities').length;
            cmp.set("v.recordSize", recordSize);
            
            var listActiveAgreementOpportunities = cmp.get('v.getActiveAgreementOpportunities');
              for(var i in listActiveAgreementOpportunities){
                  var row = listActiveAgreementOpportunities[i];
                 
                      
                  
                  row.OpportunityName = row.Name;
    			  row.oppRecordURL = '/'+ row.Id;
             	  if(!$A.util.isEmpty(row.Amount)){
                  	row.Amount = row.CurrencyIsoCode + ' ' + row.Amount;
                  }else{
                      row.Amount = '';
                  }
                  if(!$A.util.isEmpty(row.crm_Agreement__c)){
                      row.Agreement = row.crm_AgreementName__c;
                  		row.agreementRecordURL = '/'+ row.crm_Agreement__c;
                  }else{
                      row.Agreement = '';
                      row.agreementRecordURL = '';
                  }
              }
            console.log('testmyStandard1=----------------------'+JSON.stringify(listActiveAgreementOpportunities));
            cmp.set('v.tabledata', listActiveAgreementOpportunities);
           // cmp.set('v.preSelection', cmp.get('v.selectedRows_standard1'));
        }
    },
    
     handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
         
        var opportunityID = row.Id;
		debugger;
        
        switch (action.name) {
            case 'edit':
                
               
         		//('Edit: ' + JSON.stringify(row) +opportunityID);
               var editRecordEvent = $A.get("e.force:editRecord");
                editRecordEvent.setParams({
                     "recordId": opportunityID
               });
               
                
    			editRecordEvent.fire();
                
                break;
            case 'delete': 
               
                var modal = cmp.find("deleteModal");
            	$A.util.removeClass(modal, 'hideDiv');
                cmp.set("v.OpportunityDeleteRecordId",opportunityID);
                
                //helper.hlpRemoveOpportunity(cmp, event, helper ,rowId);
                break;
        }
         
    },
    
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    fnDeleteOpprtunity :function(cmp,event, helper){
        debugger;
         cmp.set("v.deleteDisabled", true);     
    	helper.hlpRemoveOpportunity(cmp, event, helper);
       // cmp.set("v.deleteDisabled", false);
        
    },
     fnCloseDeleteWarning : function(component) {
        var modal = component.find("deleteModal");
        $A.util.addClass(modal, 'hideDiv');
    },
    
   
    
})