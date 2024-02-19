/// @todo См. Ниже
/*
	Обработчик звуков
	Подсчет очков
	Графооон!
*/

function GameController() constructor {
	__map				= new Map();						/// @is {Map}
	__apple_manager		= new AppleManager(__map);			/// @is {AppleManager}
	__scores_manager	= new ScoresManager();				/// @is {ScoresManager}
	__render			= new Render(self);					/// @is {Render}
	__snake 			= undefined;						/// @is {Snake?}

	__frames			= 0;
	__game_speed		= 3;	// GameTick per Seconds
	__is_paused			= true;

	static snake_move = function(snake_head_cell/*:MapCell*/)/*->bool*/ {
		if (is_snake_moving_kill(snake_head_cell)) {
			restart();
			return false;
		} else {
			var apple = snake_head_cell.get_specific_object("apple");
			if (apple != undefined) {
				pub_sub_event_perform(PS.event_snake_eat_apple, [apple]);
			}
			return true;
		}
	}
	
	static is_snake_moving_kill = function(snake_head_cell/*:MapCell*/)/*->bool*/ {
		return (snake_head_cell.get_specific_object("wall") != undefined || snake_head_cell.get_specific_object("snake") != undefined);
	}
	
	static start = function()/*->void*/ {
		var start_cell/*:MapCell*/ = __map.get_cell(1, 1);
		__snake = new Snake(self, start_cell, SIDE.RIGHT);
		__snake.grow_up(2);
		
		pub_sub_event_perform(PS.event_game_start);
	}
	
	static restart = function()/*->void*/ {
		__snake.destroy();
		
		pub_sub_event_perform(PS.event_game_restart);
		start();
	}

	static get_side_cell = function(_cell/*:MapCell*/, _side/*:int<SIDE>*/)/*->MapCell*/ {
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
		
		var cell/*:MapCell?*/ = __map.get_cell(new_vector.x, new_vector.y);
		if (cell != undefined) {
			return (/*#cast*/ cell /*#as MapCell*/);
		} else {
			throw("undefined side cell");
		}
	}
	
	static game_tick = function()/*->void*/ {
		__snake.move_ahead();
	}
	
	static change_game_speed = function(_value/*:number*/)/*->void*/ {
		__game_speed = clamp(__game_speed + _value, 1, 20);
	}
	
	static set_pause = function(_is_paused/*:bool*/)/*->void*/ {
		__is_paused = _is_paused;
	}
	
	static step = function()/*->void*/ {
		if (__is_paused) exit;
		
		__frames++;
		var one_tick_in_frames = (game_get_speed(gamespeed_fps) / __game_speed);
		if (__frames >= one_tick_in_frames) {
			game_tick();
			__frames = __frames - one_tick_in_frames;
		}
		
		__scores_manager.step();
	}
	
	static draw = function()/*->void*/ {
		__render.draw();
	}
}