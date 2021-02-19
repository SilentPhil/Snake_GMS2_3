function Render(_map/*:Map*/) constructor {
	__map			= _map;					/// @is {Map}
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
		var map/*:Map*/ = __map;
		for (var i = 0, size_i = map.get_width(); i < size_i; i++) {
			for (var j = 0, size_j = map.get_height(); j < size_j; j++) {
				var cell/*:MapCell*/ = map.get_cell(i, j);
				
				var display_position/*:Vector*/ = self.pos_to_display_pos(cell.get_position());
				var array_of_objects = cell.get_array_of_objects();
				for (var k = 0, size_k = array_length(array_of_objects); k < size_k; k++) {
					var map_object/*:MapObject*/ = array_of_objects[k];
					map_object.draw(display_position, __cell_size);
				}
			}
		}
	}
}

function RenderObject() constructor {
	static draw = function(_position/*:Vector*/, _cell_size/*:number*/)/*->void*/ {}
}