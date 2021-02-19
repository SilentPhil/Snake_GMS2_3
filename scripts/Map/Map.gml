function Map() constructor {
	var level_template = [];
	var i = 0;
	level_template[i++]	= [1, 1, 1, 1, 0, 0, 1, 1, 1, 1];
	level_template[i++]	= [1, 0, 0, 1, 0, 0, 1, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 0, 1, 0, 0, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 0, 1, 1, 1, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 1, 1, 1, 0, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 0, 0, 1, 0, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 1, 0, 0, 1, 0, 0, 1];
	level_template[i++]	= [1, 1, 1, 1, 0, 0, 1, 1, 1, 1];

	
	__array_of_cells = [];
	for (var i = 0, size_i = array_length(level_template); i < size_i; i++) {
		for (var j = 0, size_j = array_length(level_template[0]); j < size_j; j++) {
			var cell/*:MapCell*/ = new MapCell(new Vector(i, j));
			__array_of_cells[i][j] = cell;
			if (level_template[i][j] == 1) {
				cell.set_object(new Wall());
			} else {
				cell.set_object(new Floor());
			}
		}
	}
	
	static get_cell = function(_x, _y)/*->MapCell|undefined*/ {
		if (point_in_rectangle(_x, _y, 0, 0, self.get_width() - 1, self.get_height() - 1))  {
			return __array_of_cells[_x][_y];
		} else {
			return undefined;
		}
	}
	
	static get_width = function()/*->number*/ {
		return array_length(__array_of_cells);
	}	
	
	static get_height = function()/*->number*/ {
		return array_length(__array_of_cells[0]);
	}
}

function MapCell(_position/*:Vector*/) constructor {
	__position			= _position;		/// @is {Vector}
	__array_of_objects	= [];				/// @is {array<MapObject>}
	
	static get_position = function()/*->Vector*/ {
		return __position;
	}
	
	static get_array_of_objects = function()/*->array<MapObject>*/ {
		return __array_of_objects;
	}
	
	static set_object = function(_object/*:MapObject*/)/*->void*/ {
		array_push_unique(__array_of_objects, _object);
		_object.__cell = self;
	}
	
	static remove_object = function(_object/*:MapObject*/)/*->void*/ {
		array_delete_by_value(__array_of_objects, _object);
		_object.__cell = undefined;
	}
	
	static get_specific_object = function(_object_type/*:string*/)/*->MapObject|undefined*/ {
		for (var i = 0, size_i = array_length(__array_of_objects); i < size_i; i++) {
			var obj/*:MapObject*/ = __array_of_objects[i];
			if (obj.get_type() == _object_type) {
				return obj;
			}
		}
		return undefined;
	}
}

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

function Wall() : MapObject() constructor {
	__type = "wall";
}
function Floor() : MapObject() constructor {
	__type = "floor";
}