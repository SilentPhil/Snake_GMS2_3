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
				var cell/*:MapCell*/ = map.get_cell(i, j);
				
				var display_position/*:Vector*/ = self.pos_to_display_pos(cell.get_position());
				var array_of_objects = cell.get_array_of_objects();
				for (var k = 0, size_k = array_length(array_of_objects); k < size_k; k++) {
					var map_object/*:MapObject*/ = array_of_objects[k];
					var subimg/*:number*/;
					var sprite_ind/*:sprite*/;
					switch (map_object.get_type()) {
						case "wall":
							subimg = 1;
							sprite_ind = s_map_cell;
						break;
						
						case "floor":
							subimg = 0;
							sprite_ind = s_map_cell;
						break;
						
						case "snake":
							var snake_segment/*:SnakeSegment*/ = (/*#cast*/ map_object /*#as SnakeSegment*/);
							subimg = (snake_segment.is_head() ? 0 : 1);
							sprite_ind = s_snake_segment;
						break;
						
						case "apple":
							subimg = 0;
							sprite_ind = s_apple;
						break;
					}
					draw_sprite(sprite_ind, subimg, display_position.x, display_position.y);
					//draw_text(display_position.x, display_position.y, string(array_length(cell.get_array_of_objects())));
				}
			}
		}
	
	}
	
}


/// @arg value
/// @arg [value...]
function log() {
	var str = "";
	for (var i = 0; i < argument_count; i++) {
		str += string(argument[i]) + "::";
	}
	show_debug_message(str);
}