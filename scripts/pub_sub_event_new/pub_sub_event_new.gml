/// @desc Инициализирует и возвращает новое событие
/// @arg event_caption
function pub_sub_event_new(argument0) {

	var event = array_create(EVENT_ACCESS.SIZEOF);
	event[EVENT_ACCESS.SUBSCRIBERS_LIST]	= ds_list_create();
	event[EVENT_ACCESS.CAPTION]				= argument0;

	array_push(PS.__array_of_events, event);

	return array_length(PS.__array_of_events) - 1;

	enum EVENT_ACCESS {
	//	INDEX,
		SUBSCRIBERS_LIST,
		CAPTION,
		
		SIZEOF
	}


}
