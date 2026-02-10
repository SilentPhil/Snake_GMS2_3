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
        // Подписываемся на смерть, чтобы переключить состояние
        pub_sub_subscribe(PS.event_snake_died, self);
		GAME_CONTROLLER.set_pause(false);
	}
	
	static step = function() {
		if (keyboard_check_released(ord("P"))) {
			__state_machine.switch_to_state("pause");
		}
        GAME_CONTROLLER.step(); // Явный вызов шага игры
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
            // --- NEW CASE ---
            case PS.event_snake_died:
                __state_machine.switch_to_state("death");
            break;
		}
	}

	static finish = function() {
		pub_sub_unsubscribe_all(self);
		GAME_CONTROLLER.set_pause(true);
	}	
}

function StateDeath(_state_machine/*:StateMachine*/) : State(_state_machine) constructor {
    __timer = 0;
    __decay_delay_frames = 5; // Скорость исчезновения (каждые 5 кадров)

    static start = function() {
        __timer = 0;
        // Мы НЕ вызываем GAME_CONTROLLER.set_pause(false), 
        // поэтому step() контроллера не работает, движение остановлено.
        // Но Render продолжает работать в o_game Draw event.
    }

    static step = function() {
        if (__timer > 0) {
            __timer--;
            return;
        }

        var snake = GAME_CONTROLLER.__snake;
        
        if (snake != undefined && !snake.is_empty()) {
            // Удаляем голову и получаем координаты удаленного сегмента
            var destroyed_pos = snake.remove_head_segment();
            // Запускаем эффект распада с позицией для визуального эффекта
            if (destroyed_pos != undefined) {
                pub_sub_event_perform(PS.event_snake_decay, [destroyed_pos.x, destroyed_pos.y]);
            } else {
                pub_sub_event_perform(PS.event_snake_decay);
            }
            // Ставим таймер
            __timer = __decay_delay_frames;
        } else {
            // Змейка кончилась
            GAME_CONTROLLER.restart();
            // Возвращаемся в игру или в паузу перед стартом
            // Можно использовать "pause_before_game", если хотите нажатия клавиши
            __state_machine.switch_to_state("gameplay"); 
        }
    }

    static draw = function() {
        // Можно ничего не рисовать, рендер идет из o_game Draw
    }
    
    static finish = function() {}
}
