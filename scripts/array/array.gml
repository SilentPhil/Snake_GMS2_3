/// @arg arr
/// @arg value
function array_find_index(arr, value) {
	for (var i = 0; i < array_length(arr); i++) {
		if (arr[i] == value) {
			return i;	
		}
	}
	return -1;
}

/// @arg arr
/// @arg value
function array_delete_by_value(arr, value) {
	var index = array_find_index(arr, value);
	if (index != -1) {
		array_delete(arr, index, 1);
	}
}

/// @arg arr
/// @arg value
function array_push_unique(arr, value) {
	if (array_find_index(arr, value) == -1) {
		array_push(arr, value);
	}
}

/// @arg arr
function array_get_random(arr) {
	return arr[irandom(array_length(arr) - 1)];
}

/// @arg arr
function array_empty(arr) {
	return (array_length(arr) == 0);
}

/// @arg arr
function array_get_last(arr) {
	if (!array_empty(arr)) {
		return arr[array_length(arr) - 1];
	} else {
		return undefined;
	}
}




/// @arg value
/// @arg [value...]
function log() {
	var str = "";
	for (var i = 0; i < argument_count; i++) {
		str += string(argument[i]) + "::";
	}
	show_debug_message(str);
}

/// @function structless_print
/// @description Bind this to a struct's toString method to print the struct without getting into recursive struct checks
function structless_print(){
	var structNames = variable_struct_get_names( self);
	var nbVars = array_length( structNames);
	var ret = "=======================\r\n";
	var thisVal;
	for( var i = 0; i < nbVars; ++i){
		thisVal = variable_struct_get( self, structNames[i]);
		if( is_struct( thisVal)){
			thisVal = "<struct>";
		}
		ret += structNames[i] + ": " + string(thisVal) + "\r\n";
	}
	ret += "=======================";
	
	return ret;
}


function ds_list_delete_by_value(list, value) {
	var index = ds_list_find_index(list, value);
	if (index != -1) {
		ds_list_delete(list, index);
		return true;
	}
	return false;
}