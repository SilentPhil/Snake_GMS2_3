/// @desc Вызывает указанное событие с опциональными переменными
/// @arg event
/// @arg [additional_vars=[]]
function pub_sub_event_perform() {

	var event_index	= argument[0];
	var vars		= argument_count > 1 ? argument[1] : [];

	var event_arr	= PS.__array_of_events[event_index];
	var sub_list	= event_arr[EVENT_ACCESS.SUBSCRIBERS_LIST];

	//log("PS", "Event Perform", event_arr[EVENT_ACCESS.CAPTION], vars);

	for (var i = 0, size = ds_list_size(sub_list); i < size; i++) {
		var subscriber_id = sub_list[| i];
		if (is_struct(subscriber_id)) {
			subscriber_id.pub_sub_perform(event_index, vars);
		} else {
			with (subscriber_id) {
				global.__pub_sub_event	= event_index;
				global.__pub_sub_vars	= vars;
				event_perform(ev_other, PS_EVENT);
			}
		}
	}

	global.__pub_sub_event	= undefined;
	global.__pub_sub_vars	= undefined;
}

///@desc Класс, позволяющий своим наследникам подписываться на события
function PubSubHandler() {
	_pub_sub_list = ds_list_create();
	
	/// @interface {PubSubHandler}
	/// @desc Вызывается при срабатывании события, на который подписался класс
	/// @arg PS.event
	/// @arg event_vars_array
	static pub_sub_perform = function(event, vars) {
		log("PubSubHandler", "method 'pub_sub_perform' must be override");	
	}
}