/// @argument [test_device=DEVICE.IPHONE_7]
function view_init() {
	#macro IS_OS_MOBILE (os_type == os_ios || os_type == os_android)
	var test_device = (argument[0] == undefined ? DEVICE.IPHONE_7 : argument[0]);
	
	application_surface_enable(false);
	surface_depth_disable(true);
	//gml_release_mode(true);
	
	var screen_w, screen_h;
	if (IS_OS_MOBILE) {
		screen_w = display_get_width();
		screen_h = display_get_height();
		
		if (screen_w > screen_h) {
			screen_w ^= screen_h;
			screen_h ^= screen_w;
			screen_w ^= screen_h;
		}
	} else {
		#region Определяем соотношение сторон
		var test_ratio;
		switch (test_device) {	
			case DEVICE.IPAD:
				test_ratio = 0.75;
			break;
				
			case DEVICE.IPHONE_4:
				test_ratio = 0.6666;
			break;
			
			case DEVICE.IPHONE_7:
				test_ratio = 0.56;
			break;
	
			case DEVICE.IPHONE_X:
				test_ratio = 0.4618;
			break;
			
			case DEVICE.XIAOMI:
				test_ratio = 0.4736;
			break;
	
			default: 
				test_ratio = 0.56;
			break;
		}
		#endregion
		
		screen_h = 750;
		screen_w = screen_h * test_ratio;
	}
	
	var screen_ratio = screen_w / screen_h;
	global.screen_ratio	= screen_ratio;
	global.scale_factor = lerp(3.3, 1, 0.56 / max(screen_ratio, 0.56));
	log("scale factor", global.scale_factor);
	
	/* Разрешение по горизонтали - референс - это iPhone 5 */
	var reference_screen_width = 640 * global.scale_factor;
	
	var new_screen_width	= floor(reference_screen_width);
	var new_screen_height	= floor(reference_screen_width / screen_ratio);
	
	global.app_surface_width	= new_screen_width;
	global.app_surface_height	= new_screen_height;
	
	global.view_scale_ratio 	= screen_w / reference_screen_width;
	
	#region Настройка вида
	view_enabled = true;
	global.main_view  = camera_create_view(0, 0, new_screen_width, new_screen_height);
	view_set_camera(0, global.main_view);
	view_set_wport(0, screen_w);
	view_set_hport(0, screen_h);
	view_set_visible(0, true);
	#endregion
	
	surface_resize(application_surface, screen_w, screen_h);
	display_set_gui_size(new_screen_width, new_screen_height);
	if (!IS_OS_MOBILE) {
		window_set_size(screen_w, screen_h);
		log("window size", screen_w, screen_h);
	}
	
	global.view_w = new_screen_width;
	global.view_h = new_screen_height;
	
	#region Сдвиги сверху и снизу для айфонов с "челкой"
	if (IS_OS_MOBILE) {

		var safe_area				= screen_get_safe_area();
		var safe_area_ratio			= screen_w / new_screen_width;
		global.screen_shift_top		= safe_area.top / safe_area_ratio;
		global.screen_shift_bottom	= safe_area.bottom / safe_area_ratio;
		log("safe area", global.screen_shift_top, global.screen_shift_bottom);
	} else {
		var is_iphone_x				= (test_device == DEVICE.IPHONE_X);
		global.screen_shift_top		= (is_iphone_x ? 75 : 0);
		global.screen_shift_bottom	= (is_iphone_x ? 58 : 0);
	}
	#endregion
	
	log("resolution", new_screen_width, new_screen_height);
}

enum DEVICE {
	IPAD,
	
	IPHONE_4,
	IPHONE_7,
	IPHONE_X,
	
	XIAOMI,
}