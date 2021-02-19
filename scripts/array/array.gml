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




/// @arg value
/// @arg [value...]
function log() {
	var str = "";
	for (var i = 0; i < argument_count; i++) {
		str += string(argument[i]) + "::";
	}
	show_debug_message(str);
}

function ds_list_delete_by_value(list, value) {
	var index = ds_list_find_index(list, value);
	if (index != -1) {
		ds_list_delete(list, index);
	}
}