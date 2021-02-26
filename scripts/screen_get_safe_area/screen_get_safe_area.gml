function screen_get_safe_area() {
	var safe_area = {
		top 	: 0,
		bottom	: 0,
	}

	if (os_type == os_ios) {
		var safe_area_string	= get_safe_area();
		var safe_area_map		= json_decode(safe_area_string);
		if (ds_exists(safe_area_map, ds_type_map)) {
			var is_detected		= safe_area_map[? "detected"];	
			if (is_detected) {
				safe_area.top		= safe_area_map[? "top"];
				safe_area.bottom	= safe_area_map[? "bottom"];
			}
			ds_map_destroy(safe_area_map);
		}
	} else if (os_type == os_android) {
		log("НЕТ РАСШИРЕНИЯ ПО ОПРЕДЕЛЕНИЮ БЕЗОПАСНОЙ ЗОНЫ НА ANDROID");
	}
	
	return safe_area;
}