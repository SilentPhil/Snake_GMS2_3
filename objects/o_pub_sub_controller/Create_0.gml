#macro PS		o_pub_sub_controller	/// @is {o_pub_sub_controller}
#macro PS_EVENT	ev_user10

delayed_events_list		= ds_list_create();
unsubscribers_list		= ds_list_create();
__array_of_events		= [];
		
event_snake_move		= pub_sub_event_new("snake_move");