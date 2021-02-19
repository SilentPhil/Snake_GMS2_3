function Snake(_position/*:Vector*/, _orientation/*:SIDE*/) constructor {
	__head_segment			= new SnakeSegment(_position, true);	/// @is {SnakeSegment}
	__array_of_segments 	= [__head_segment];						/// @is {array<SnakeSegment>}
	__orientation			= _orientation;							/// @is {SIDE}
	__orientation_next_tick	= _orientation;							/// @is {SIDE}
	
	static move_ahead = function()/*->void*/ {
		__orientation = __orientation_next_tick;
		var new_position/*:Vector*/ = __head_segment.get_position().add(self.get_move_vector());
		
		pub_sub_event_perform(PS.event_snake_move, [new_position]);
		
		for (var i = array_length(__array_of_segments) - 1; i > 0; i--) {
			var segment/*:SnakeSegment*/			= __array_of_segments[i];
			var previous_segment/*:SnakeSegment*/	= __array_of_segments[i - 1];
			segment.set_position(previous_segment.get_position());
		}
		__head_segment.set_position(new_position);
	}
	
	static grow_up = function(_grow_strength/*:number*/)/*->void*/ {
		repeat (_grow_strength) {
			var tail_segment/*:SnakeSegment*/	= __array_of_segments[array_length(__array_of_segments) - 1];
			var tail_position/*:Vector*/		= tail_segment.get_position();
			var new_segment/*:SnakeSegment*/	= new SnakeSegment(tail_position, false);
			array_push(__array_of_segments, new_segment);
		}
	}
	
	static turn = function(_side/*:SIDE*/)/*->void*/ {
		var is_opposite_moving = (abs(__orientation - (/*#cast*/ _side)) == 2);
		if (!is_opposite_moving) {
			__orientation_next_tick = _side;
		}
	}
	
	static get_move_vector = function()/*->Vector*/ {
		switch (__orientation) {
			case SIDE.UP:
				return new Vector(0, -1);
			break;
			
			case SIDE.RIGHT:
				return new Vector(1, 0);
			break;
			
			case SIDE.DOWN:
				return new Vector(0, 1);
			break;
			
			case SIDE.LEFT:
				return new Vector(-1, 0);
			break;
		}
	}

	static get_array_of_segments = function()/*->array<SnakeSegment>*/ {
		return __array_of_segments;
	}
}

function SnakeSegment(_position/*:Vector*/, _is_head/*:bool*/) : MapObject(_position) constructor {
	self.set_position(_position);
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

