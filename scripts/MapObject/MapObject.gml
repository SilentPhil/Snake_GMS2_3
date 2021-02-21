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
		draw_sprite_ext(s_graphics, 1, _position.x + _cell_size / 2, _position.y + _cell_size / 2, 1, 1, 0, /*#*/0x2d54dd, 1);
	}
}

function Wall() : MapObject() constructor {
	__type = "wall";
	
	static draw = function(_position/*:Vector*/, _cell_size/*:number*/)/*->void*/ {
		draw_sprite_ext(s_graphics, 0, _position.x + _cell_size / 2, _position.y + _cell_size / 2, 1, 1, 0, /*#*/0x3783cc, 1);
	}
}

function Floor() : MapObject() constructor {
	__type = "floor";
	
	static draw = function(_position/*:Vector*/, _cell_size/*:number*/)/*->void*/ {}	
}