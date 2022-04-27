({
	doInit: function(component, event, helper) {
        
        var getList = component.get('v.items'); 
        //alert("getList[] " + getList[0].value);
         //alert("getList[] " + getList[1].value);
        var getElement = component.get('v.element');
        var compareList = []; 
       // alert("len"+getList.length);
         for (var i = 0; i < getList.length; i++)
         {
             compareList.push(getList[i].value);
         } 
        
        var getElementIndex = compareList.indexOf(getElement);
       // alert("getElementIndex " + getElementIndex);
       // if getElementIndex is not equal to -1 it's means list contains this element. 
       //alert('Index' +getElementIndex);
        if(getElementIndex != -1){ 
          component.set('v.condition',true);
        }else{
          component.set('v.condition',false);
        }
    }
})