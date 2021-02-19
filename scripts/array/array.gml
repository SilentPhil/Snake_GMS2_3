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