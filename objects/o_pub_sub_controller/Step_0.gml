var list	= PS.delayed_events_list;
var i		= 0;

while (i < ds_list_size(list)) {
	var delayed_event = list[| i];
	delayed_event[@ DELAYED_EVENT_ACCESS.DELAY] -= 1;
	if (delayed_event[DELAYED_EVENT_ACCESS.DELAY] <= 0) {
		pub_sub_event_perform(delayed_event[DELAYED_EVENT_ACCESS.EVENT], delayed_event[DELAYED_EVENT_ACCESS.VARS]);
		ds_list_delete(list, i);
	} else {
		i++;
	}
}

var i = 0;
while (i < ds_list_size(PS.unsubscribers_list)) {
	var unsubscribers	= PS.unsubscribers_list[| i];
	var event_arr		= PS.__array_of_events[unsubscribers[0]];
	ds_list_delete_by_value(event_arr[EVENT_ACCESS.SUBSCRIBERS_LIST], unsubscribers[1]);	
	ds_list_delete(PS.unsubscribers_list, i);
}