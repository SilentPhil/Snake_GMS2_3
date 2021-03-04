function StatePause(_state_machine/*:StateMachine*/) : State(_state_machine) constructor {
	static start = function() {}
	
	static step = function() {
		if (keyboard_check_released(vk_anykey) || mouse_check_button_released(mb_left)) {
			__state_machine.switch_to_state("gameplay");
		}		
	}
	
	static draw = function() {
		gpu_set_texfilter(false);
		draw_set_font(global.font);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_color(c_white);
		draw_text_transformed(global.view_w / 2, global.view_h / 2, "PRESS ANY KEY\nTO CONTINUE", 4.7, 4.7, 0);
	}

	static finish = function() {}
}

function StatePauseBeforeGame(_state_machine/*:StateMachine*/) : State(_state_machine) constructor {
	static start = function() {}
	
	static step = function() {
		if (keyboard_check_released(vk_anykey) || mouse_check_button_released(mb_left)) {
			__state_machine.switch_to_state("gameplay");
		}
	}
	
	static draw = function() {
		gpu_set_texfilter(false);
		draw_set_font(global.font);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_color(c_white);
		draw_text_transformed(global.view_w / 2, global.view_h / 2, "PRESS ANY KEY\nTO START", 4.7, 4.7, 0);
	}

	static finish = function() {}
}


function StateGameplay(_state_machine/*:StateMachine*/) : State(_state_machine) constructor {
	static start = function() {
		pub_sub_subscribe(PS.event_app_events, self);
		GAME_CONTROLLER.set_pause(false);
	}
	
	static step = function() {
		if (keyboard_check_released(ord("P"))) {
			__state_machine.switch_to_state("pause");
		}
	}
	
	static pub_sub_perform = function(_event, _vars) {
		switch (_event) {
			case PS.event_app_events:
				switch (_vars[0]) {
					case "foreground":
						__state_machine.switch_to_state("pause");
					break;
				}
			break;
		}
	}

	static finish = function() {
		pub_sub_unsubscribe_all(self);
		GAME_CONTROLLER.set_pause(true);
	}	
}