function StatePause(_state_machine/*:StateMachine*/) : State(_state_machine) constructor {
	static start = function() {}
	
	static step = function() {
		if (keyboard_check_released(vk_anykey)) {
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
		if (keyboard_check_released(vk_anykey)) {
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
		log("Gameplay start");
		GAME_CONTROLLER.set_pause(false);
	}
	
	static step = function() {
		if (keyboard_check_released(ord("P"))) {
			__state_machine.switch_to_state("pause");
		}
	}

	static finish = function() {
		log("Gameplay finish");
		GAME_CONTROLLER.set_pause(true);
	}	
}