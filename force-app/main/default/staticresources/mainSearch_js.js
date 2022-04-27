/*******************************************************
* Used for VF bug workaround.
* 
* The following will for some reason (incl Sprint '11) create a select-element with the same number of onclick calls to alert() as rowNum is currently incremented to.
* <apex:variable var="rowNum" value="0" />
* <apex:repeat value="{!myCollection}" var="myElement">
* 	<apex:inputField onchange="alert('{!rowNum}');" value="{!new_case_data.recordTypeId}" />
* 	<apex:variable var="rowNum" value="{!VALUE(rowNum) + 1}" />
* </apex:repeat>
* 
* Therefore the following code i required to store the rowNum in a hidden field next to the select-element. The select element will then query the previous sibling element to get the corrent row value.
********************************************************/

/*Will reset all input elements under "topElement" to default value*/
function clearAllInputs(topElement) {
	if(topElement == null) { return; }
	var inputElements = topElement.getElementsByTagName('INPUT');

	for (var i=0; i<inputElements.length; i++) {
		if(inputElements[i].type == 'text') {
			inputElements[i].value=''; //resetFieldValue(inputElements[i]);
			//console.log(inputElements[i]);
		}
	}
}

/* For signaling load in progress */
function isLoading(isLoading) {
	//console.log(isLoading);
	var loaderElementsVisibility;
	if(isLoading) {
		document.body.style.cursor = 'progress';
		loaderElementsVisibility = 'visible';
		//enableDisableButtons(false);
		startTimer();
	}
	else {
		document.body.style.cursor = 'auto';
		loaderElementsVisibility = 'hidden';
		//enableDisableButtons(true);
		stopTimer();
	}

	spinnerElements = document.getElementsByClassName('KATS_spinner')
	for(var i=0; i<spinnerElements.length; i++) {
		spinnerElements[i].style.visibility = loaderElementsVisibility;
	}

}

var areButtonsEnabled=true;
/*function enableDisableButtons(doEnable) {
	areButtonsEnabled = doEnable;
	var buttons = document.getElementsByClassName('btnDisabled');

	for(var i=0; i<buttons.length; i++) {

		if(doEnable) {
			buttons[i].className = 'btn';
			buttons[i].disabled = false;
		}
		else {
			buttons[i].className = 'btnDisabled';
			buttons[i].disabled = true;
		}
	}
}*/

/* Will disable all input elements under topElement unless class name is "enabledClassName". If "enabledClassName" is null, all fields will be enabled.  */
function disableEnableInputs(topElement, enabledClassName) {
	var inputElements = topElement.getElementsByTagName('INPUT');
	for(var i=0; i < inputElements.length; i++) {
		//alert(inputElements[i].className);
		if(inputElements[i].type == 'text') {
			if(inputElements[i].className == enabledClassName || enabledClassName.substring(0, inputElements[i].className.length)===inputElements[i].className) {
				inputElements[i].style.color = '';
				inputElements[i].style.backgroundColor = '';
			}
			else {
				inputElements[i].style.color = 'gray';
				inputElements[i].style.backgroundColor = '#f8f8f8';
			}
		}
	}
} 



var currentSearchModus = '';	//"FOT" || "CEASAR" || "OM" || "AR" || "FW" || "LM" (ForWarding address)
var currentSearchTab = 'tabBusiness';		// tabPrivate || tabBusiness || tabShipment
/* Call search. Searchtype is derived from currentSearchModus */
function doSearch() {
	//console.log('searching in modus: ' + currentSearchModus);

	switch(currentSearchTab) {
		case 'tabPrivate':	searchPersonAccount(currentSearchModus);	break;
		case 'tabBusiness':	searchBusinessAccounts(currentSearchModus);	break;
		case 'tabShipment':	searchShipments(currentSearchModus);		break;
	}
}

function setSearchTabInURL() {
	if(navigator.appName.search(/\w*microsoft\w*/i) == -1) {
		window.history.pushState(currentSearchTab, 'document.title', '?searchTab=' + currentSearchTab);
	} else {//IF BROWSER EQUALS INTERNET EXPLORER
		insertParam('searchTab', currentSearchTab);
	}
}

function insertParam(key, value) {
    key = escape(key); value = escape(value);

    var kvp = document.location.search.substr(1).split('&');

    var i=kvp.length; var x; while(i--) 
    {
        x = kvp[i].split('=');

        if (x[0]==key)
        {
                x[1] = value;
                kvp[i] = x.join('=');
                break;
        }
    }

    if(i<0) {kvp[kvp.length] = [key,value].join('=');}

    //this will reload the page, it's likely better to store this until finished
    document.location.search = kvp.join('&'); 
}

function searchFieldKeyUp(ev, element, searchMethodCall) {

	//Update searchModus
	if(element.className.substr(0, 'searchParam_'.length) === 'searchParam_') {
		currentSearchModus = element.className.substr('searchParam_'.length);
	}
	else {
		currentSearchModus = '';
	}
	//console.log('XXX currentSearchModus = ' + currentSearchModus);
	
	if(element.value == '') {
		// The field has been emptied
	}
	else { 
		// The field has values
		disableEnableInputs( getActionRegion(element), element.className );
	}
	
	if (window.event && window.event.keyCode == 13 || ev.which == 13) {
		//If enter, call search function and return
		if(areButtonsEnabled==true) { doSearch(); }
		return false;
	}
	
	return true;
}


/********************
 *** MISC HELPERS *** 
 *******************/

/* returns the first <div class="actionRegion"> element found by going through parentnode relations from "element" */
function getActionRegion(element) {
	var currentElement = element;
	for(var i=0; i<25 && currentElement.className != 'actionRegion'; i++) {
		currentElement = currentElement.parentNode;
	}
	if(currentElement.className == 'actionRegion') { return currentElement }
	return null;
}
/* returns the first form element found by going through parentnode relations from "element". NOT USED */
function getForm(element) {
	//TODO: check if element is form... then there's a shortcut...
	
	var currentElement = element;
	for(var i=0; i<20 && currentElement.tagName != 'FORM'; i++) {
		currentElement = currentElement.parentNode;
	}
	if(currentElement.tagName == 'FORM') { return currentElement }
	return null;
}
function getPreviousElement(baseElement) {
	var previousSibling = baseElement.previousSibling;
	while(previousSibling && previousSibling.nodeType != 1) {
	    previousSibling = previousSibling.previousSibling
	}
	return previousSibling
}
function resetFieldValue(element) {
	if(element == null) { return; }
	else 				{ element.value = element.defaultValue; }
}

function resetFieldValueById(fieldId) {
	var element = document.getElementById(fieldId);
	return resetFieldValue(element);
} 

function scrollToElement(elementId) {
	//document.getElementByClass(elementId).scrollIntoView(true);
	document.getElementById(elementId).scrollIntoView(true);
}
function clearElement(elementId) {
	document.getElementById(elementId).innerHTML = '';
}
function showElement(elementId) {
	document.getElementById(elementId).style.visibility = 'visible';
}
function hideElement(elementId) {
	document.getElementById(elementId).style.visibility = 'hidden';
}
/**************************
 *** PERFORMANCE TIMING *** 
 *************************/
var startTime;
var stopTime;
function startTimer() {
	startTime = (new Date()).getTime();
}
function stopTimer() {
	stopTime = (new Date()).getTime();
	elementsToUpdate = document.getElementsByClassName('JStimeSpend');
	for(var i=0; i<elementsToUpdate.length; i++) {
		elementsToUpdate[i].innerHTML = (stopTime - startTime) + ' ms.';
	}
}