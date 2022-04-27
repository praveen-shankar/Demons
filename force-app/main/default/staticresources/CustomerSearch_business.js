var currentSearchModus = '';

/*
 *	This function is fired every time a search field is clicked or a value is entered.
 *	The default search modus is CAESAR, if another search modus is selected and the
 *  field is empty the search will default back to CAESAR
 */
function searchParameterEvent(ev, searchModus) {
	currentSearchModus = searchModus;
	//If enter, call search function and return
	if (window.event && window.event.keyCode == 13 || ev.which == 13) {
		searchAccount(currentSearchModus);
		return false;
	}
	return true;
}

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
/* returns the first <div class="actionRegion"> element found by going through parentnode relations from "element" */
function getActionRegion(element) {
	var currentElement = element;
	for(var i=0; i<25 && currentElement.className != 'actionRegion'; i++) {
		currentElement = currentElement.parentNode;
	}
	if(currentElement.className == 'actionRegion') { return currentElement }
	return null;
}