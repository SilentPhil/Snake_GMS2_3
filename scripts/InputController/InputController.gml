function InputController() constructor {
	gesture_drag_time(0.08);
	gesture_drag_distance(0.08);
	
	//pub_sub_subscribe(PS.event_gesture_drag_end, self);
	
	static pub_sub_perform = function(_event, _vars) {
		switch (_event) {
			case PS.event_gesture_drag_end:
				var diff_x = _vars[0];
				var diff_y = _vars[1];
				
				var drag_sensitivity = 15;
				
				if (abs(diff_x) >= drag_sensitivity || abs(diff_y) >= drag_sensitivity) {
					if (abs(diff_x) > abs(diff_y)) {
						diff_y = 0;
					} else {
						diff_x = 0;
					}
					self.snake_move_order(diff_x, diff_y);
				}
			break;
			
			case PS.event_gesture_tap:

			break;
		}
	}
	
	static step = function() {
		var dx = (keyboard_check(vk_right) - keyboard_check(vk_left));
		var dy = (keyboard_check(vk_down)  - keyboard_check(vk_up));
		
		self.snake_move_order(dx, dy);
		
		if (mouse_check_button_pressed(mb_left)) {
			var tap_x = mouse_x;
			var tap_y = mouse_y;
			
			var turn/*:TURN*/ = ((tap_x > room_width / 2) ? TURN.CLOCKWISE : TURN.COUNTERCLOCKWISE);
			pub_sub_event_perform(PS.event_snake_turn_clock, [turn]);
		}
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
}