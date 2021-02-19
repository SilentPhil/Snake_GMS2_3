function Render() constructor {
	__cell_size 	= 32;
	__map_margin	= new Vector(32, 32);	/// @is {Vector}
	
	__list_of_weak_ref_render_elements = ds_list_create();	/// @is {ds_list}
	
	static pos_to_display_pos = function(_obj_position/*:Vector*/)/*->Vector*/ {
		return new Vector(
							__map_margin.x + _obj_position.x * __cell_size, 
							__map_margin.y + _obj_position.y * __cell_size
						);
	}
	
	static draw = function() {
		var map/*:Map*/ = GAME_CONTROLLER.get_map();
		for (var i = 0, size_i = map.get_width(); i < size_i; i++) {
			for (var j = 0, size_j = map.get_height(); j < size_j; j++) {
				var cell_pos/*:Vector*/ 		= new Vector(i, j);
				var cell/*:CELL*/				= map.get_cell(cell_pos);
				var display_position/*:Vector*/ = self.pos_to_display_pos(cell_pos);
				var subimg/*:number*/			= (cell == CELL.EMPTY ? 0 : 1);
				
				draw_sprite(s_map_cell, subimg, display_position.x, display_position.y);
			}
		}
		
		var array_of_apples/*:array<Apple>*/ = GAME_CONTROLLER.__apple_manager.get_array_of_apples();
		for (var i = 0, size_i = array_length(array_of_apples); i < size_i; i++) {
			var apple/*:Apple*/ = array_of_apples[i];
			
			var display_position/*:Vector*/ = self.pos_to_display_pos(apple.get_position());
			draw_sprite(s_apple, 0, display_position.x, display_position.y);
		}
		
		var snake/*:Snake*/ = GAME_CONTROLLER.get_snake();
		if (snake != undefined) {
			var array_of_segments/*:array<SnakeSegment>*/ = snake.get_array_of_segments();
			for (var i = array_length(array_of_segments) - 1; i >= 0; i--) {
				var segment/*:SnakeSegment*/ = array_of_segments[i];
				
				var subimg/*:number*/ = (segment.is_head() ? 0 : 1);
				var display_position/*:Vector*/ = self.pos_to_display_pos(segment.get_position());
				draw_sprite(s_snake_segment, subimg, display_position.x, display_position.y);
			}
		}
	}
	
}


/// @arg value
/// @arg [value...]
function log() {
	var str = "";
	for (var i = 0; i < argument_count; i++) {
		str += string(argument[0]) + "::";
	}
	show_debug_message(str);
}