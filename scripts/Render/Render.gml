function Render(_map/*:Map*/) constructor {
	__map			= _map;										/// @is {Map}
	__cell_size 	= 21;										/// @is {number}
	__map_margin	= new Vector(34, 70);						/// @is {Vector}
	
	__surf_objects		= noone;								/// @is {surface}
	__surf_blur_1_pass	= noone;
	__surf_blur_2_pass	= noone;
	__surf_bg			= noone;
	
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
			draw_clear_alpha(c_black, 0);
			
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
	
		var screen_ratio	= room_width / room_height;

		#region glow
		var blur_strength	= 0.012;
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

		shader_set(glsl_blur);
			repeat(blur_repeat) {
				surface_set_target(__surf_blur_1_pass);
				 	draw_clear_alpha(c_black, 0);
				 	shader_set_uniform_f(shader_get_uniform(glsl_blur, "u_vOffsetFactor"), 0, blur_strength * screen_ratio * 1.2);
			
				 	draw_surface(__surf_blur_2_pass, 0, 0);
				surface_reset_target();
		 

				surface_set_target(__surf_blur_2_pass);
				 	draw_clear_alpha(c_black, 0);
				 	shader_set_uniform_f(shader_get_uniform(glsl_blur, "u_vOffsetFactor"), blur_strength, 0);
			
				 	draw_surface(__surf_blur_1_pass, 0, 0);
				surface_reset_target();
			}
		shader_reset();
		
		var glow_color_blend			= make_color_rgb(255, 120, 120);
		var glow_alpha					= 1.0;
		
		var glow_flicker_freq			= 20;
		var glow_flicker_strength_min	= 0.2;
		var glow_flicker_strength_max	= 0.3;
		var glow_flicker_amount			= (1 + sin(2 * pi * ((current_time / 20 * glow_flicker_freq) % 100 / 100))) / 2;
		var glow_flicker_alpha			= lerp(glow_flicker_strength_min, glow_flicker_strength_max, glow_flicker_amount);
		#endregion glow
		
		if (!surface_exists(__surf_bg)) {
			__surf_bg = surface_create(room_width + 200, room_height + 200);
		}	
		surface_set_target(__surf_bg);
			draw_clear_alpha(/*#*/0x1b1c1c, 1);
		surface_reset_target();
		
		shader_set(glsl_scanlines);
		var scanlines_shift_speed = 4;
		shader_set_uniform_f(shader_get_uniform(glsl_scanlines, "u_fScanlinePhase"), -current_time / 1000 * scanlines_shift_speed, 0);
		shader_set_uniform_f(shader_get_uniform(glsl_scanlines, "u_fScanlineFreq"),  160);
		shader_set_uniform_f(shader_get_uniform(glsl_scanlines, "u_fDistortionStrength"), 11);
		
		//draw_set_color(/*#*/0x1b1c1c);
		draw_surface(__surf_bg, -100, -100);
		//draw_sprite_stretched_ext(s_white_pixel, 0, -100, -100, room_width + 100, room_height + 100, /*#*/0x1b1c1c, 1);
		
		gpu_set_blendmode(bm_max);
		draw_surface_ext(__surf_blur_2_pass, 0, 0, 1 / blur_scale, 1 / blur_scale, 0, glow_color_blend, glow_alpha);
		draw_surface_ext(__surf_blur_2_pass, 0, 0, 1 / blur_scale, 1 / blur_scale, 0, glow_color_blend, glow_flicker_alpha);
		gpu_set_blendmode(bm_normal);			
		
		
		draw_surface(__surf_objects, 0, 0);
		shader_reset();
	}
}

function RenderObject() constructor {
	static draw = function(_position/*:Vector*/, _cell_size/*:number*/)/*->void*/ {}
}