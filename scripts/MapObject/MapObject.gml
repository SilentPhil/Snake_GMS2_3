function MapObject() : RenderObject() constructor {
	__cell = undefined;	/// @is {MapCell}
	__type = "";
	
	static get_cell = function()/*->MapCell|undefined*/ {
		return __cell;
	}
	
	static change_cell = function(_new_cell/*:MapCell*/)/*->void*/ {
		if (__cell != undefined) {
			__cell.remove_object(self);
		}
		_new_cell.set_object(self);
	}
	
	static get_type = function()/*->string*/ {
		return __type;
	}
	
	static destroy = function()/*->void*/ {
		if (__cell != undefined) {
			__cell.remove_object(self);
		}
	}
}

function Apple() : MapObject() constructor {
	__type = "apple";
	
	static draw = function(_x/*:number*/, _y/*:number*/, _factor/*:number*/)/*->void*/ {
		draw_sprite_ext(s_graphics, 1, _x, _y, _factor, _factor, 0, /*#*/0x2d54dd, 1);
	}
}

function Wall() : MapObject() constructor {
	__type = "wall";
	
	static draw = function(_x/*:number*/, _y/*:number*/, _factor/*:number*/)/*->void*/ {
		draw_sprite_ext(s_graphics, 0, _x, _y, _factor, _factor, 0, /*#*/0x3783cc, 1);
	}
}

function Floor() : MapObject() constructor {
	__type = "floor";
}

function SnakeSegment(_snake/*:Snake*/, _is_head/*:bool*/) : MapObject() constructor {
	__snake				= _snake;		/// @is {Snake}
	__is_head			= _is_head;
	__orientation		= __snake.__orientation;
	__is_apple_ahead	= false;
	__is_apple_inside	= false;
	
	__type = "snake";
	
	static is_head = function() {
		return __is_head;
	}
	
	static draw = function(_x/*:number*/, _y/*:number*/, _factor/*:number*/)/*->void*/ {
		var subimg;
		if (__is_head) {
			subimg = (__is_apple_ahead ? 17 : 3) + __orientation;
		} else {
			var array_of_segments/*:array<SnakeSegment>*/ = __snake.get_array_of_segments();
			var is_tail = (array_get_last(array_of_segments) == self);
			if (is_tail) {
				subimg = 9 + array_of_segments[array_length(array_of_segments) - 2].get_orientation();
			} else {
				var segment_index/*:number*/			= array_find_index(array_of_segments, self);
				var next_segment/*:SnakeSegment*/		= array_of_segments[segment_index - 1];
				var previous_segment/*:SnakeSegment*/	= array_of_segments[segment_index + 1];
				
				var segment_position/*:Vector*/ 				= self.get_cell().get_position();
				
				var next_segment_cell_position/*:Vector*/		= next_segment.get_cell().get_position();
				var next_segment_offset/*:Vector*/				= next_segment_cell_position.substract(segment_position);
				
				var previous_segment_cell_position/*:Vector*/	= previous_segment.get_cell().get_position();
				var previous_segment_offset/*:Vector*/			= previous_segment_cell_position.substract(segment_position);
				
				if (next_segment_offset.x == 1 && next_segment_offset.y == 0 && previous_segment_offset.x == 0 && previous_segment_offset.y == 1) ||
			      (next_segment_offset.x == 0 && next_segment_offset.y == 1 && previous_segment_offset.x == 1 && previous_segment_offset.y == 0) {
					subimg = __is_apple_inside ? 23 : 13;
				} else if (next_segment_offset.x == 0  && next_segment_offset.y == 1 && previous_segment_offset.x == -1 && previous_segment_offset.y == 0) ||
						  (next_segment_offset.x == -1 && next_segment_offset.y == 0 && previous_segment_offset.x == 0  && previous_segment_offset.y == 1) {
					subimg = __is_apple_inside ? 24 : 14;
				} else if (next_segment_offset.x == -1 && next_segment_offset.y == 0  && previous_segment_offset.x == 0  && previous_segment_offset.y == -1) ||
						  (next_segment_offset.x == 0  && next_segment_offset.y == -1 && previous_segment_offset.x == -1 && previous_segment_offset.y == 0) {
					subimg = __is_apple_inside ? 26 : 16;
				} else if (next_segment_offset.x == 0  && next_segment_offset.y == -1 && previous_segment_offset.x == 1 && previous_segment_offset.y == 0) ||
						  (next_segment_offset.x == 1 && next_segment_offset.y == 0 && previous_segment_offset.x == 0  && previous_segment_offset.y == -1) {
					subimg = __is_apple_inside ? 25 : 15;
				} else {
					subimg = (__is_apple_inside ? 21 : 7) + __orientation % 2;
				}
			}
		}
		draw_sprite_ext(s_graphics, subimg, _x, _y, _factor, _factor, 0, /*#*/0x4cd0f8, 1);
		//draw_text(_position.x, _position.y, __is_apple_inside);
	}	
	
	static set_orientation = function(_orientation/*:SIDE*/)/*->void*/ {
		__orientation = _orientation;
	}
	
	static get_orientation = function()/*->SIDE*/ {
		return __orientation;
	}
}