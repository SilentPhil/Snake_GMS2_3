function Map() constructor {
	var level_template = [];
	var i = 0;
	level_template[i++]	= [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
	level_template[i++]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	level_template[i++]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	level_template[i++]	= [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];

	__map_filter = new MapFilter(self);		/// @is {MapFilter}
	__array_of_cells = [];
	__array_of_cells_one_dimensional = [];
	
	for (var i = 0, size_i = array_length(level_template); i < size_i; i++) {
		for (var j = 0, size_j = array_length(level_template[0]); j < size_j; j++) {
			var cell/*:MapCell*/ = new MapCell(new Vector(i, j));
			__array_of_cells[i][j] = cell;
			array_push(__array_of_cells_one_dimensional, cell);
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

function MapFilter(_map/*:Map*/) constructor {
	__map = _map;
	
	static get_array_of_cells = function()/*->MapFilterResult*/ {
		return new MapFilterResult(__map);
	}
}

function MapFilterResult(_map/*:Map*/) constructor {
	__array_of_cells = [];		/// @is {array<MapCell>}
	array_copy(__array_of_cells, 0, _map.__array_of_cells_one_dimensional, 0, array_length(_map.__array_of_cells_one_dimensional));
	
	/// @arg {string} obj_type
	/// @arg {string} [obj_type...]
	static including = function() {
		var i = 0;
		while (i < array_length(__array_of_cells)){
			var cell/*:MapCell*/ = __array_of_cells[i];
			for (var j = 0; j < argument_count; j++) {
				if (cell.get_specific_object(argument[j]) == undefined) {
					array_delete(__array_of_cells, i, 1);
				} else {
					i++;
				}
			}
		}
		return self;
	}
	
	/// @arg {string} obj_type
	/// @arg {string} [obj_type...]
	static excluding = function() {
		var i = 0;
		var is_deleted = false;
		while (i < array_length(__array_of_cells)){
			var cell/*:MapCell*/ = __array_of_cells[i];
			for (var j = 0; j < argument_count; j++) {
				if (cell.get_specific_object(argument[j]) != undefined) {
					array_delete(__array_of_cells, i, 1);
					is_deleted = true;
					break;
				}
			}
			if (!is_deleted) {
				i++;
			} else {
				is_deleted = false;
			}
		}		
		return self;
	}
	
	static get_result_arr = function()/*->array<MapCell>*/ { 
		return __array_of_cells;
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
