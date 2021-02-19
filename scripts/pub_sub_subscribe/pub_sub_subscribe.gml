/// @desc Подписывает инстанс на указанное событие
/// @arg event_index
/// @arg [PubSubListener_struct=id]
function pub_sub_subscribe() {
	var event_index			= argument[0];
	var pub_sub_listener	= argument_count > 1 ? argument[1] : id;
	
	var event_arr	= PS.__array_of_events[event_index];
	ds_list_add_unique(event_arr[EVENT_ACCESS.SUBSCRIBERS_LIST], pub_sub_listener);

	
	//var subscriber_mask;
	//var subscriber_index	= ds_list_find_index(PS.subscribers_list, id);
	//if (subscriber_index != -1) {
	//	subscriber_mask		= PS.subscribers_mask_list[| subscriber_index];
	//} else {
	//	subscriber_mask		= 0;
	//	ds_list_add(PS.subscribers_list,		id);
	//	ds_list_add(PS.subscribers_mask_list,	subscriber_mask);
	//	subscriber_index	= ds_list_size(PS.subscribers_list) - 1;
	//}

	//PS.subscribers_mask_list[| subscriber_index] = subscriber_mask | event[EVENT_ACCESS.MASK];


}
