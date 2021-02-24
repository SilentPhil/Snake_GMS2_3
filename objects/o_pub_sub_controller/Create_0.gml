#macro PS		o_pub_sub_controller	/// @is {o_pub_sub_controller}
#macro PS_EVENT	ev_user10

delayed_events_list		= ds_list_create();
unsubscribers_list		= ds_list_create();
__array_of_events		= [];
		
event_snake_move		= pub_sub_event_new("snake_move");
event_snake_turn_order	= pub_sub_event_new("snake_turn_order");
event_snake_turn		= pub_sub_event_new("snake_turn");
event_snake_eat_apple	= pub_sub_event_new("snake_eat_apple");
event_gesture_drag_end	= pub_sub_event_new("gesture_drag_end");