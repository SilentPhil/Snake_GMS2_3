function Snake(_game_controller/*:GameController*/, _start_cell/*:MapCell*/, _orientation/*:SIDE*/) constructor {
	__game_controller		= _game_controller;				/// @is {GameController}
	__orientation			= _orientation;					/// @is {SIDE}
	__orientation_next_tick	= _orientation;					/// @is {SIDE}
	__head_segment			= new SnakeSegment(self, true);	/// @is {SnakeSegment}
	__array_of_segments 	= [__head_segment];				/// @is {array<SnakeSegment>}
	
	_start_cell.set_object(__head_segment);	
	
	__is_destroyed = false;
	__is_eat_apple = false;
	
	pub_sub_subscribe(PS.event_snake_turn_order,	self);
	pub_sub_subscribe(PS.event_snake_eat_apple,		self);
	
	static pub_sub_perform = function(_event, _vars) {
		switch (_event) {
			case PS.event_snake_turn_order:
				var side/*:SIDE*/ = _vars[0];
				self.turn(side);
			break;
			
			case PS.event_snake_eat_apple:
				self.grow_up(1);
				__is_eat_apple = true;
			break;
		}
	}
	
	static move_ahead = function()/*->void*/ {
		__orientation = __orientation_next_tick;
		
		try {
			var new_cell/*:MapCell*/ = __game_controller.get_side_cell(__head_segment.get_cell(), __orientation);
		} catch (e) {
			return;
		}
		
		pub_sub_event_perform(PS.event_snake_move, [new_cell]);
		if (__is_destroyed) return;
		
		for (var i = array_length(__array_of_segments) - 1; i > 0; i--) {
			var segment/*:SnakeSegment*/			= __array_of_segments[i];
			var previous_segment/*:SnakeSegment*/	= __array_of_segments[i - 1];

			segment.change_cell(previous_segment.get_cell());
			segment.set_orientation(previous_segment.get_orientation());
			
			segment.__is_apple_inside = previous_segment.__is_apple_inside;
			previous_segment.__is_apple_inside = false;
		}
		__head_segment.change_cell(new_cell);
		__head_segment.set_orientation(__orientation);
		
		var ahead_cell/*:MapCell*/ = __game_controller.get_side_cell(__head_segment.get_cell(), __orientation);
		__head_segment.__is_apple_ahead = (ahead_cell.get_specific_object("apple") != undefined);
		
		if (__is_eat_apple) {
			__is_eat_apple = false;
			__head_segment.__is_apple_inside = true;
		}
	}

	static grow_up = function(_grow_strength/*:number*/)/*->void*/ {
		repeat (_grow_strength) {
			var tail_segment/*:SnakeSegment*/	= __array_of_segments[array_length(__array_of_segments) - 1];
			var tail_cell/*:MapCell*/			= tail_segment.get_cell();
			var new_segment/*:SnakeSegment*/	= new SnakeSegment(self, false);
			
			tail_cell.set_object(new_segment);
			
			array_push(__array_of_segments, new_segment);
		}
	}
	
	static turn = function(_side/*:SIDE*/)/*->void*/ {
		var is_opposite_moving			= (abs(__orientation - (/*#cast*/ _side)) == 2);
		var is_same_orientation_moving	= (_side == __orientation_next_tick);
		if (!is_opposite_moving && !is_same_orientation_moving) {
			__orientation_next_tick = _side;
			pub_sub_event_perform(PS.event_snake_turn);
		}
	}
	
	static destroy = function()/*->void*/ {
		for (var i = 0, size_i = array_length(__array_of_segments); i < size_i; i++) {
			var segment/*:SnakeSegment*/ = __array_of_segments[i];
			segment.destroy();
		}
		__is_destroyed = true;
		
		pub_sub_unsubscribe_all(self);
	}
	
	static get_array_of_segments = function()/*->array<SnakeSegment>*/ {
		return __array_of_segments;
	}
}

enum SIDE {
	UP,
	RIGHT,
	DOWN,
	LEFT
}