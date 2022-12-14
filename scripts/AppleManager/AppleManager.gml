function AppleManager(_map/*:Map*/) constructor {
	__map = _map;							/// @is {Map}
	__array_of_apples = []; 				/// @is {array<Apple>}
	
	pub_sub_subscribe(PS.event_snake_eat_apple, self);
	pub_sub_subscribe(PS.event_game_start,		self);
	pub_sub_subscribe(PS.event_game_restart,	self);
	
	static pub_sub_perform = function(_event, _vars) {
		switch (_event) {
			case PS.event_snake_eat_apple:
				var apple/*:Apple*/ = _vars[0];
				spawn_apple(1);
				destroy_apple(apple);
			break;
			
			case PS.event_game_start:
				spawn_apple(2);
			break;	
			
			case PS.event_game_restart:
				destroy_all_apples();
			break;
		}
	}
	
	static spawn_apple = function(_count/*:number*/)/*->void*/ {
		var map_filter/*:MapFilter*/ = __map.__map_filter;
		var map_filter_result/*:MapFilterResult*/ = map_filter.result().excluding("wall", "snake", "apple");
		var array_of_free_cells = map_filter_result.get_result_arr();
		
		if (array_length(array_of_free_cells) > 0) {
			repeat (_count) {
				var random_cell/*:MapCell*/ = array_get_random(array_of_free_cells);
				var apple/*:Apple*/ = new Apple();
				random_cell.set_object(apple);
				array_push(__array_of_apples, apple);
				
				array_delete_by_value(array_of_free_cells, random_cell);
			}
		}
	}
		
	static destroy_apple = function(_apple/*:Apple*/)/*->void*/ {
		_apple.destroy();
		array_delete_by_value(__array_of_apples, _apple);
	}
	
	static destroy_all_apples = function()/*->void*/ {
		while (!array_empty(__array_of_apples)) {
			var apple/*:Apple*/ = __array_of_apples[0];
			apple.destroy();
			array_delete(__array_of_apples, 0, 1);
		}
	}
}

