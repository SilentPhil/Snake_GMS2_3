/// @desc Отписывает инстанс от всех событий
/// @arg [PubSubListener_struct=id]
function pub_sub_unsubscribe_all() {
	var pub_sub_listener	= argument_count > 0 ? argument[0] : id;	
	
	for (var i = 0, size_i = array_length(PS.__array_of_events); i < size_i; i++) {
		pub_sub_unsubscribe(i, pub_sub_listener);
	}


}
