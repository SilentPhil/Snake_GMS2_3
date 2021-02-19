function AppleManager() constructor {
	__array_of_apples = []; 				/// @is {array<Apple>}
	
	static get_apple_by_position = function(_position/*:Vector*/)/*->Apple|undefined*/ {
		for (var i = 0, size_i = array_length(__array_of_apples); i < size_i; i++) {
			var apple/*:Apple*/ = __array_of_apples[i];
			if (_position.equals(apple.get_position())) {
				return apple;
			}
		}
	}
	
	static spawn_apple = function(_game_controller/*:GameController*/)/*->void*/ {
		
		var map/*:Map*/ = _game_controller.__map;
		do {
			var i = irandom(map.get_width() - 1);
			var j = irandom(map.get_height() - 1);
			var cell_position/*:Vector*/ = new Vector(i, j);
			var map_cell/*:CELL*/ = map.get_cell(cell_position);
		} until (map_cell != CELL.WALL && self.get_apple_by_position(cell_position) == undefined && _game_controller.get_snake_by_position(cell_position) == undefined);
		
		array_push(__array_of_apples, new Apple(cell_position));
	}
		
	static destroy_apple = function(_apple/*:Apple*/)/*->void*/ {
		array_delete_by_value(__array_of_apples, _apple);
	}
	
	static destroy_all_apples = function()/*->void*/ {
		for (var i = 0, size_i = array_length(__array_of_apples); i < size_i; i++) {
			var apple/*:Apple*/ = __array_of_apples[i];
			self.destroy_apple(apple);
		}
	}
	
	static get_array_of_apples = function()/*->array<Apple>*/ {
		return __array_of_apples;
	}	
}