function InputController() constructor {
	/// @hint {number} TouchProcess:x
	/// @hint {number} TouchProcess:y
	/// @hint {number} TouchStart:x
	/// @hint {number} TouchStart:y
	__array_of_touch_process	= array_create(10, undefined);	/// @is {array<TouchStruct>}
	__array_of_touch_start		= array_create(10, undefined);	/// @is {array<TouchStruct>}
	
	__drag_thrashold_distance = 25;
	
	gesture_drag_time(0.001);
	gesture_drag_distance(0.001);
	
	pub_sub_subscribe(PS.event_gesture_drag_end, self);
	pub_sub_subscribe(PS.event_gesture_dragging, self);
	
	static pub_sub_perform = function(_event, _vars) {
		switch (_event) {
			case PS.event_gesture_drag_end:
				self.step();
				__array_of_touch_process	= array_create(10, undefined);
				__array_of_touch_start		= array_create(10, undefined);
			// 	var diff_x = _vars[0];
			// 	var diff_y = _vars[1];
				
			// 	var drag_sensitivity = 20;
				
			// 	if (abs(diff_x) >= drag_sensitivity || abs(diff_y) >= drag_sensitivity) {
			// 		if (abs(diff_x) > abs(diff_y)) {
			// 			diff_y = 0;
			// 		} else {
			// 			diff_x = 0;
			// 		}
			// 		self.snake_move_order(diff_x, diff_y);
			// 	}
			break;
			
			case PS.event_gesture_dragging:
				var touch_index	= _vars[0];
				var pos_x		= _vars[1];
				var pos_y		= _vars[2];
				
				if (__array_of_touch_start[touch_index] == undefined) {
					__array_of_touch_start[@ touch_index] = {
						x : pos_x,
						y : pos_y,
					}
				} else {
					__array_of_touch_process[@ touch_index] = {
						x : pos_x,
						y : pos_y,
					}
				}
			break;
		}
	}
	
	static step = function() {
		var dx = (keyboard_check(vk_right) - keyboard_check(vk_left));
		var dy = (keyboard_check(vk_down)  - keyboard_check(vk_up));
		self.snake_move_order(dx, dy);
		
		for (var i = 0, size_i = array_length(__array_of_touch_process); i < size_i; i++) {
			if (__array_of_touch_process[i] == undefined) continue;
			if (__array_of_touch_start[i]	== undefined) continue;
			
			var touch_process/*:TouchProcess*/	= __array_of_touch_process[i];
			var touch_start/*:TouchStart*/		= __array_of_touch_start[i];
			
			var diff_x = touch_process.x - touch_start.x;
			var diff_y = touch_process.y - touch_start.y;
			
			if (max(abs(diff_x), abs(diff_y)) >= __drag_thrashold_distance) {
				__array_of_touch_process[@ i]	= undefined;
				__array_of_touch_start[@ i] 	= undefined;
				if (abs(diff_x) > abs(diff_y)) {
					diff_y = 0;	
				} else {
					diff_x = 0;
				}
				self.snake_move_order(diff_x, diff_y);
				break;
			}
		}
		
		// if (mouse_check_button_pressed(mb_left)) {
		// 	var tap_x = mouse_x;
		// 	var tap_y = mouse_y;
			
		// 	var turn:TURN = ((tap_x > room_width / 2) ? TURN.CLOCKWISE : TURN.COUNTERCLOCKWISE);
		// 	pub_sub_event_perform(PS.event_snake_turn_clock, [turn]);
		// }		
	}
	
	static snake_move_order = function(_dx/*:number*/, _dy/*:number*/) {
		if (_dx != 0 || _dy != 0) {
			if (_dx != 0) {
				var side/*:SIDE*/ = (_dx > 0 ? SIDE.RIGHT : SIDE.LEFT);
			} else if (_dy != 0) {
				var side/*:SIDE*/ = (_dy > 0 ? SIDE.DOWN : SIDE.UP);
			}
			pub_sub_event_perform(PS.event_snake_turn_order, [side]);
		}
	}
	
	static debug_draw = function() {
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		for (var i = 0, size_i = array_length(__array_of_touch_process); i < size_i; i++) {
			if (__array_of_touch_process[i] == undefined) continue;
			if (__array_of_touch_start[i]	== undefined) continue;
			
			var touch_process/*:TouchProcess*/	= __array_of_touch_process[i];
			var touch_start/*:TouchStart*/		= __array_of_touch_start[i];
			
			draw_set_color(make_color_hsv(i * 32, 128, 128));
			draw_line_width(touch_start.x, touch_start.y, touch_process.x, touch_process.y, 5);
		}
	}
}