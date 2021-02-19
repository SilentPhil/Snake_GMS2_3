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
	
	static draw = function(_position/*:Vector*/, _cell_size/*:number*/)/*->void*/ {
		draw_sprite(s_apple, 0, _position.x, _position.y);
	}
}

function Wall() : MapObject() constructor {
	__type = "wall";
	
	static draw = function(_position/*:Vector*/, _cell_size/*:number*/)/*->void*/ {
		draw_sprite(s_map_cell, 1, _position.x, _position.y);
	}
}

function Floor() : MapObject() constructor {
	__type = "floor";
	
	static draw = function(_position/*:Vector*/, _cell_size/*:number*/)/*->void*/ {
		draw_sprite(s_map_cell, 0, _position.x, _position.y);
	}	
}