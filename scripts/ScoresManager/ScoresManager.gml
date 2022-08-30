function ScoresManager() constructor {
	__scores			= 0;
	__display_scores	= 0;
	
	pub_sub_subscribe(PS.event_snake_eat_apple, self);
	pub_sub_subscribe(PS.event_game_start,		self);
	pub_sub_subscribe(PS.event_game_restart,	self);
	
	static pub_sub_perform = function(_event, _vars) {
		switch (_event) {
			case PS.event_snake_eat_apple:
				add_scores(10);
			break;
			
			case PS.event_game_restart:
				clear();
			break;
		}
	}
	
	static add_scores = function(_value/*:number*/)/*->void*/ {
		__scores += _value;
	}
	
	static get_display_scores = function()/*->number*/ {
		return round(__display_scores);
	}
	
	static get_scores = function()/*->number*/ {
		return __scores;
	}
	
	static step = function()/*->void*/ {
		__display_scores = lerp(__display_scores, __scores, 0.35);
	}
	
	static clear = function()/*->void*/ {
		__scores = 0;
		__display_scores = 0;
	}
}