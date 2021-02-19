function Snake(_game_controller/*:GameController*/, _start_cell/*:MapCell*/, _orientation/*:SIDE*/) constructor {
	__game_controller		= _game_controller;						/// @is {GameController}
	__head_segment			= new SnakeSegment(true);				/// @is {SnakeSegment}
	_start_cell.set_object(__head_segment);
	
	__array_of_segments 	= [__head_segment];						/// @is {array<SnakeSegment>}
	__orientation			= _orientation;							/// @is {SIDE}
	__orientation_next_tick	= _orientation;							/// @is {SIDE}
	
	__is_destroyed = false;
	
	static move_ahead = function()/*->void*/ {
		__orientation = __orientation_next_tick;
		
		var head_segment/*:SnakeSegment*/ = __head_segment;
		try {
			var new_cell/*:MapCell*/ = __game_controller.get_side_cell(head_segment.get_cell(), __orientation);
		} catch (e) {
			return;
		}
		
		pub_sub_event_perform(PS.event_snake_move, [new_cell]);
		if (__is_destroyed) return;
		
		for (var i = array_length(__array_of_segments) - 1; i > 0; i--) {
			var segment/*:SnakeSegment*/			= __array_of_segments[i];
			var previous_segment/*:SnakeSegment*/	= __array_of_segments[i - 1];

			segment.change_cell(previous_segment.get_cell());
		}
		head_segment.change_cell(new_cell);
	}

	static grow_up = function(_grow_strength/*:number*/)/*->void*/ {
		repeat (_grow_strength) {
			var tail_segment/*:SnakeSegment*/	= __array_of_segments[array_length(__array_of_segments) - 1];
			var tail_cell/*:MapCell*/			= tail_segment.get_cell();
			var new_segment/*:SnakeSegment*/	= new SnakeSegment(false);
			
			tail_cell.set_object(new_segment);
			
			array_push(__array_of_segments, new_segment);
		}
	}
	
	static turn = function(_side/*:SIDE*/)/*->void*/ {
		var is_opposite_moving = (abs(__orientation - (/*#cast*/ _side)) == 2);
		if (!is_opposite_moving) {
			__orientation_next_tick = _side;
		}
	}
	
	static destroy = function()/*->void*/ {
		for (var i = 0, size_i = array_length(__array_of_segments); i < size_i; i++) {
			var segment/*:SnakeSegment*/ = __array_of_segments[i];
			segment.destroy();
		}
		__is_destroyed = true;
	}
	
	static get_array_of_segments = function()/*->array<SnakeSegment>*/ {
		return __array_of_segments;
	}
}

function SnakeSegment(_is_head/*:bool*/) : MapObject() constructor {
	__type = "snake";
	__is_head = _is_head;
	
	static is_head = function() {
		return __is_head;
	}
}

enum SIDE {
	UP,
	RIGHT,
	DOWN,
	LEFT
}

