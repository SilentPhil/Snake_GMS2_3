/// @todo См. Ниже
/*
	Обработчик звуков
	Подсчет очков
	Графооон!
*/

function GameController() constructor {
	__map				= new Map();						/// @is {Map}
	__apple_manager		= new AppleManager(__map);			/// @is {AppleManager}
	__render			= new Render(__map);				/// @is {Render}
	__snake 			= undefined;						/// @is {Snake}

	__frames			= 0;
	__game_speed		= 3;	// GameTick per Seconds
	
	pub_sub_subscribe(PS.event_snake_move, self);
	
	static pub_sub_perform = function(_event, _vars) {
		switch (_event) {
			case PS.event_snake_move:
				var snake_head_cell/*:MapCell*/ = _vars[0];
				if (snake_head_cell.get_specific_object("wall") != undefined || snake_head_cell.get_specific_object("snake") != undefined) {
					self.restart();
				} else {
					var apple/*:Apple|undefined*/ = snake_head_cell.get_specific_object("apple");
					if (apple != undefined) {
						__apple_manager.spawn_apple(1);
						__apple_manager.destroy_apple((/*#cast*/ apple /*#as Apple*/));
						pub_sub_event_perform(PS.event_snake_eat_apple);
					}
				}
			break;
		}
	}
	
	static start = function()/*->void*/ {
		var start_cell/*:MapCell*/ = __map.get_cell(1, 1);
		__snake = new Snake(self, start_cell, SIDE.RIGHT);

		__snake.grow_up(2);
		__apple_manager.spawn_apple(2);
	}
	
	static restart = function()/*->void*/ {
		__snake.destroy();
		__apple_manager.destroy_all_apples();
		
		self.start();
	}

	static get_side_cell = function(_cell/*:MapCell*/, _side/*:SIDE*/)/*->MapCell*/ {
		var shift_vector/*:Vector*/;
		switch (_side) {
			case SIDE.UP:
				shift_vector = new Vector(0, -1);
			break;
			
			case SIDE.RIGHT:
				shift_vector = new Vector(1, 0);
			break;
			
			case SIDE.DOWN:
				shift_vector = new Vector(0, 1);
			break;
			
			case SIDE.LEFT:
				shift_vector = new Vector(-1, 0);
			break;
		}
		
		#region Телепорт при пересечении карты
		var new_vector/*:Vector*/ = _cell.get_position().add(shift_vector);
		if (new_vector.x >= __map.get_width()) {
			new_vector.x = 0;
		} else if (new_vector.x < 0) {
			new_vector.x = __map.get_width() - 1;
		}
		
		if (new_vector.y >= __map.get_height()) {
			new_vector.y = 0;
		} else if (new_vector.y < 0) {
			new_vector.y = __map.get_height() - 1;
		}
		#endregion
		
		var cell/*:MapCell|undefined*/ = __map.get_cell(new_vector.x, new_vector.y);
		if (cell != undefined) {
			return (/*#cast*/ cell /*#as MapCell*/);
		} else {
			throw("undefined side cell");
		}
	}
	
	static game_tick = function()/*->void*/ {
		var snake/*:Snake*/ = __snake;
		snake.move_ahead();
	}
	
	static change_game_speed = function(_value/*:number*/)/*->void*/ {
		__game_speed = clamp(__game_speed + _value, 1, 20);
	}
	
	static step = function()/*->void*/ {
		__frames++;
		var one_tick_in_frames = (game_get_speed(gamespeed_fps) / __game_speed);
		if (__frames >= one_tick_in_frames) {
			self.game_tick();
			__frames = __frames - one_tick_in_frames;
		}
	}
	
	static get_render = function()/*->Render*/ {
		return __render;
	}
}