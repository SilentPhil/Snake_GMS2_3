function Render(_map/*:Map*/) constructor {
	__map			= _map;										/// @is {Map}
	__cell_size 	= 32;										/// @is {number}
	__map_margin	= new Vector(32, 32);						/// @is {Vector}
	__list_of_weak_ref_render_elements = ds_list_create();		/// @is {ds_list}
	
	__surf_objects		= noone;								/// @is {surface}
	__surf_blur_1_pass	= noone;
	__surf_blur_2_pass	= noone;
	
	static pos_to_display_pos = function(_obj_position/*:Vector*/)/*->Vector*/ {
		return new Vector(
							__map_margin.x + _obj_position.x * __cell_size, 
							__map_margin.y + _obj_position.y * __cell_size
						);
	}
	
	static draw = function() {
		if (!surface_exists(__surf_objects)) {
			__surf_objects = surface_create(room_width, room_height);
		}
		surface_set_target(__surf_objects);
			draw_clear_alpha(/*#*/0x080808, 1);
			
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
		surface_reset_target();

		var blur_strength	= 0.013;
		var blur_scale		= 0.25;
		var blur_repeat		= 3;
		
		if (!surface_exists(__surf_blur_1_pass)) {
			__surf_blur_1_pass = surface_create(room_width * blur_scale, room_height * blur_scale);
		}		
		if (!surface_exists(__surf_blur_2_pass)) {
			__surf_blur_2_pass = surface_create(room_width * blur_scale, room_height * blur_scale);
		}
		
		surface_set_target(__surf_blur_2_pass);
			draw_clear_alpha(c_black, 0);
			draw_surface_ext(__surf_objects, 0, 0, blur_scale, blur_scale, 0, c_white, 1);
		surface_reset_target();

		repeat(blur_repeat) {
			surface_set_target(__surf_blur_1_pass);
				draw_clear_alpha(c_black, 0);
				shader_set(glsl_blur);
				shader_set_uniform_f(shader_get_uniform(glsl_blur, "u_vOffsetFactor"), 0, blur_strength);
			
				draw_surface(__surf_blur_2_pass, 0, 0);
			
				shader_reset();
			surface_reset_target();
		

			surface_set_target(__surf_blur_2_pass);
				draw_clear_alpha(c_black, 0);
				shader_set(glsl_blur);
				shader_set_uniform_f(shader_get_uniform(glsl_blur, "u_vOffsetFactor"), blur_strength, 0);
			
				draw_surface(__surf_blur_1_pass, 0, 0);
			
				shader_reset();
			surface_reset_target();
		}
	
		
		draw_surface_ext(__surf_blur_2_pass, 0, 0, 1 / blur_scale, 1 / blur_scale, 0, make_color_rgb(255, 200, 200), 1);
		
		gpu_set_blendmode(bm_max);
		draw_surface(__surf_objects, 0, 0);
		gpu_set_blendmode(bm_normal);
	}
}

function RenderObject() constructor {
	static draw = function(_position/*:Vector*/, _cell_size/*:number*/)/*->void*/ {}
}