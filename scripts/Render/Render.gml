function Render(_map/*:Map*/) constructor {
	__map				= _map;				/// @is {Map}
	__symbol_factor 	= 3;				/// @is {number}
	__symbol_size		= sprite_get_width(s_graphics);
	__cell_size			= __symbol_size * __symbol_factor;
	
	__screen_width		= room_width;
	__screen_height		= room_height;
	__level_width_px	= __cell_size * _map.get_width();
	__level_height_px	= __cell_size * _map.get_height();
	
	__map_margin		= new Vector((__screen_width - __level_width_px) / 2, (__screen_height - __level_height_px) / 2); /// @is {Vector}

	__surf_objects		= noone;			/// @is {surface}
	__surf_blur_1_pass	= noone;			/// @is {surface}
	__surf_blur_2_pass	= noone;			/// @is {surface}
	__surf_final		= noone;			/// @is {surface}
	__is_gfx_distortion	= true;
	__is_gfx			= true;
	__is_show_debug		= true;
	
	__font				= font_add_sprite_ext(s_font, "ABCDEFGHIJKLMNOPQRSTUVWXYZ 1234567890_@!?#$%><()^*:;.,", false, 0);	/// @is {font}
	
	__color_bg			= /*#*/0x121212;
	__color_hud			= /*#*/0x86b3d7;
	
	__hud_position		= new Vector(0, -2);
	
	application_surface_enable(false);
	
	
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
			
			draw_set_halign(fa_left);
			draw_set_valign(fa_top);
			draw_set_alpha(1);
			
			gpu_set_tex_filter(false);
			
			var map/*:Map*/ = __map;
			for (var i = 0, size_i = map.get_width(); i < size_i; i++) {
				for (var j = 0, size_j = map.get_height(); j < size_j; j++) {
					var cell/*:MapCell*/ = map.get_cell(i, j);
					
					var display_position/*:Vector*/ = self.pos_to_display_pos(cell.get_position());
					var array_of_objects = cell.get_array_of_objects();
					for (var k = 0, size_k = array_length(array_of_objects); k < size_k; k++) {
						var map_object/*:MapObject*/ = array_of_objects[k];
						map_object.draw(display_position, __symbol_factor);
					}
				}
			}
			draw_set_font(__font);
			draw_set_color(__color_hud);
			
			var hud_position_y/*:number*/ = self.pos_to_display_pos(__hud_position).y;
			draw_text_transformed(__map_margin.x, hud_position_y, "@@@@@", __symbol_factor, __symbol_factor, 0);
			
			draw_set_halign(fa_right);
			draw_text_transformed(room_width - __map_margin.x, hud_position_y, "99999", __symbol_factor, __symbol_factor, 0);
			
			gpu_set_tex_filter(true);
			
		surface_reset_target();
	
		var screen_ratio	= room_width / room_height;

		if (__is_gfx) {
			#region glow
			var blur_strength	= 0.008; // 0.008; mac
			var blur_scale		= 0.25;
			var blur_repeat		= 2;
		
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
					 	shader_set_uniform_f(shader_get_uniform(glsl_blur, "u_vOffsetFactor"), 0, blur_strength * screen_ratio);
			
					 	draw_surface(__surf_blur_2_pass, 0, 0);
					surface_reset_target();
		 

					surface_set_target(__surf_blur_2_pass);
					 	draw_clear_alpha(c_black, 0);
					 	shader_set_uniform_f(shader_get_uniform(glsl_blur, "u_vOffsetFactor"), blur_strength, 0);
			
					 	draw_surface(__surf_blur_1_pass, 0, 0);
					surface_reset_target();
				}
			shader_reset();
			#endregion glow
		
			if (!surface_exists(__surf_final)) {
				__surf_final = surface_create(__screen_width, __screen_height);
			}	
			surface_set_target(__surf_final);
				draw_clear_alpha(__color_bg, 1);
			
				#region draw glow
				var glow_color_blend			= make_color_rgb(255, 110, 110);
				var glow_alpha					= 0.85;
		
				var glow_flicker_freq			= 20;
				var glow_flicker_strength_min	= 0.2;
				var glow_flicker_strength_max	= 0.25;
				var glow_flicker_amount			= (1 + sin(2 * pi * ((current_time / 20 * glow_flicker_freq) % 100 / 100))) / 2;
				var glow_flicker_alpha			= lerp(glow_flicker_strength_min, glow_flicker_strength_max, glow_flicker_amount);
				
				gpu_set_blendmode(bm_max);
				draw_surface_ext(__surf_blur_2_pass, 0, 0, 1 / blur_scale, 1 / blur_scale, 0, glow_color_blend, glow_alpha);
				draw_surface_ext(__surf_blur_2_pass, 0, 0, 1 / blur_scale, 1 / blur_scale, 0, glow_color_blend, glow_flicker_alpha);
				gpu_set_blendmode(bm_normal);			
				#endregion draw glow
		
				draw_surface(__surf_objects, 0, 0);
			surface_reset_target();
		
			#region scanlines && distortion
			shader_set(glsl_scanlines);
			var scanlines_freq			= 160;
			var scanlines_shift_speed	= 4;
			shader_set_uniform_f(shader_get_uniform(glsl_scanlines, "u_fScanlinePhase"), -current_time / 1000 * scanlines_shift_speed, 0);
			shader_set_uniform_f(shader_get_uniform(glsl_scanlines, "u_fScanlineFreq"), scanlines_freq);
			shader_set_uniform_f(shader_get_uniform(glsl_scanlines, "u_fDistortionEnabled"), __is_gfx_distortion);
			shader_set_uniform_f(shader_get_uniform(glsl_scanlines, "u_fDistortionStrength"), 11);
				
			draw_surface(__surf_final, 0, 0);
			shader_reset();
			#endregion scanlines && distortion
		} else {
			draw_clear_alpha(__color_bg, 1);
			draw_surface(__surf_objects, 0, 0);
		}
		self.draw_debug();
	}
	
	static draw_debug = function() {
		show_debug_overlay(__is_show_debug);
		if (__is_show_debug) {
			
			draw_set_alpha(1);
			draw_set_font(__font);
			draw_set_halign(fa_left);
			draw_set_valign(fa_bottom);
			draw_set_color(c_dkgray);
			draw_text(10, __screen_height - 10,	"SHADERS ARE SUPPORTED: " + string_bool(shaders_are_supported()) + "\n" +
												"SHADERS ARE COMPILED: " + "\n" +
												//"GLSL_PASS:      " + string_bool(shader_is_compiled(glsl_pass)) + "\n" +
												"GLSL_BLUR:      " + string_bool(shader_is_compiled(glsl_blur)) + "\n" +
												"GLSL_SCANLINES: " + string_bool(shader_is_compiled(glsl_scanlines)));
												
			draw_set_halign(fa_right);
			draw_text(__screen_width - 10, __screen_height - 10, date_datetime_string(GM_build_date));
		}
		if (keyboard_check_pressed(ord("H"))) {
			__is_gfx_distortion = !__is_gfx_distortion;
		}	
		if (keyboard_check_pressed(ord("G"))) {
			__is_gfx = !__is_gfx;
		}
		if (keyboard_check_pressed(ord("D"))) {
			__is_show_debug = !__is_show_debug;
		}
	}
	
}

function RenderObject() constructor {
	static draw = function(_position/*:Vector*/, _cell_size/*:number*/)/*->void*/ {}
}