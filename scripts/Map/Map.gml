
function Map() constructor {
	__array_of_cells = [];
	__array_of_cells[0]	= [1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
	__array_of_cells[1]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	__array_of_cells[2]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	__array_of_cells[3]	= [1, 0, 0, 0, 1, 0, 0, 0, 0, 1];
	__array_of_cells[4]	= [1, 0, 0, 0, 1, 1, 1, 0, 0, 1];
	__array_of_cells[5]	= [1, 0, 0, 1, 1, 1, 0, 0, 0, 1];
	__array_of_cells[6]	= [1, 0, 0, 0, 0, 1, 0, 0, 0, 1];
	__array_of_cells[7]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	__array_of_cells[8]	= [1, 0, 0, 0, 0, 0, 0, 0, 0, 1];
	__array_of_cells[9]	= [1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
	
	enum CELL {
		EMPTY	= 0,
		WALL	= 1,
	}
	
	static get_cell = function(_position/*:Vector*/)/*->CELL|undefined*/ {
		if (point_in_rectangle(_position.x, _position.y, 0, 0, self.get_width() - 1, self.get_height() - 1))  {
			return __array_of_cells[_position.x, _position.y];
		} else {
			return undefined;
		}
	}
	
	static get_width = function()/*->number*/ {
		return array_length(__array_of_cells[0]);
	}	
	
	static get_height = function()/*->number*/ {
		return array_length(__array_of_cells);
	}
}

// function MapCell(_position:Vector) constructor {
// 	__position = _position;		/// @is {Vector}
// 	__object = undefined;		/// @is {MapObject|undefined}
	
// 	static get_position = function()->Vector {
// 		return __position;
// 	}
	
// 	static get_object = function()->MapObject|undefined {
// 		return __object;
// 	}
// }

function MapObject(_position/*:Vector*/) constructor {
	__position = _position;	/// @is {Vector}
	
	static get_position = function()/*->Vector*/ {
		return __position;
	}
	
	static set_position = function(_vector/*:Vector*/)/*->void*/ {
		__position = new Vector(_vector.x, _vector.y);
	}
	
	// static change_position = function(_vector:Vector)->void {
	// 	__position = __position.add(_vector);
	// }
}