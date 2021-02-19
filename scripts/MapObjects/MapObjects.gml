function MapObject() constructor {
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
}

function Wall() : MapObject() constructor {
	__type = "wall";
}

function Floor() : MapObject() constructor {
	__type = "floor";
}