function GameController() constructor {
	__map	= new Map();					/// @is {Map}
	__snake = undefined;					/// @is {Snake}
	__apple_manager	= new AppleManager();	/// @is {AppleManager}

	__frames			= 0;
	__game_speed		= 3;	// GameTick per Seconds
	
	pub_sub_subscribe(PS.event_snake_move, self);
	
	static pub_sub_perform = function(_event, _vars) {
		switch (_event) {
			case PS.event_snake_move:
				var snake_head_position/*:Vector*/ = _vars[0];
				var map_cell/*:CELL|undefined*/ = __map.get_cell(snake_head_position);
				if (map_cell != undefined) {
					if (map_cell == CELL.WALL) {
						self.restart();
					} else {
						var segment/*:SnakeSegment|undefined*/ = self.get_snake_by_position(snake_head_position);
						if (segment != undefined) {
							self.restart();
						} else {
							var apple/*:Apple|undefined*/ = __apple_manager.get_apple_by_position(snake_head_position);
							if (apple != undefined) {
								__snake.grow_up(1);
								__apple_manager.destroy_apple((/*#cast*/ apple /*#as Apple*/));
								__apple_manager.spawn_apple(self);
							}
						}
					}
				}
			break;
		}
	}
	
	static start = function() {
		__snake = new Snake(new Vector(1, 1), SIDE.RIGHT);
		__snake.grow_up(3);
		__apple_manager.spawn_apple(self);
	}
	
	static get_snake_by_position = function(_position/*:Vector*/)/*->SnakeSegment|undefined*/ {
		for (var i = 0, size_i = array_length(__snake.get_array_of_segments()); i < size_i; i++) {
			var segment/*:SnakeSegment*/ = __snake.get_array_of_segments()[i];
			if (_position.equals(segment.get_position())) {
				return segment;
			}
		}
	}
	
	static is_available_cell = function(_vector/*:Vector*/)/*->bool*/ {
		
	}
	
	static restart = function()/*->void*/ {
		__apple_manager.destroy_all_apples();
		
		self.start();
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
		var one_tick_in_frames = (room_speed / __game_speed);
		if (__frames >= one_tick_in_frames) {
			self.game_tick();
			__frames = __frames - one_tick_in_frames;
		}
	}
	
	static get_snake = function()/*->Snake|undefined*/ {
		return __snake;
	}
	
	static get_map = function()/*->Map*/ {
		return __map;
	}

	
}