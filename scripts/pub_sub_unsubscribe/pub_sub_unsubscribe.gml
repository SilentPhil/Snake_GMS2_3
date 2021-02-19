/// @desc Отписывает инстанс от указанного события
/// @arg event_index
/// @arg [PubSubListener_struct=id]
function pub_sub_unsubscribe() {
	
	var event_index			= argument[0];
	var pub_sub_listener	= argument_count > 1 ? argument[1] : id;	
	//var event_arr	= PS.__array_of_events[event_index];
	
	ds_list_add_unique(PS.unsubscribers_list, [event_index, pub_sub_listener]);
}

/// @arg id
/// @arg value
function ds_list_add_unique(_id, _value) {
	if (ds_list_find_index(_id, _value) == -1) {
		ds_list_add(_id, _value);
	}
}