function StateMachine() constructor {
	__states = {};				/// @is {struct<State>}
	__current_state = "";		/// @is {string}
	__state_links = {};			/// @is {struct<string>}
	
	static add_state = function(_state_name/*:string*/, _state_instance/*:State*/)/*->void*/ {
		__states[$ _state_name] = _state_instance;
	}

	static initial_state = function(_state_name/*:string*/)/*->void*/ {
		__current_state = _state_name;
	}
	
	static switch_to_state = function(_state_name/*:string*/)/*->void*/ {
		var switch_path = [];	/// @is {array<string>}
		var search_state_name = __current_state;
		while (search_state_name != _state_name) {
			array_push(switch_path, search_state_name);
			
			search_state_name = __state_links[$ search_state_name];
			if (search_state_name == undefined) {
				throw (string(_state_name) + " has no link with " + string(__current_state));
			}
			array_push(switch_path, search_state_name);
		}

		var current_state_function/*:State*/ = __states[$ __current_state];
		current_state_function.finish();
		for (var i = 1, size_i = array_length(switch_path) - 1; i < size_i; i++) {
			var next_state_function/*:State*/ = __states[$ switch_path[i]];
			next_state_function.start();
			next_state_function.finish();
		}
		__current_state = array_get_last(switch_path);
		var target_state_function/*:State*/ = __states[$ __current_state];
		target_state_function.start();
		
	}
	
	static link_state_with_other_state = function(_state_name_from/*:string*/, _state_name_to/*:string*/) {
		__state_links[$ _state_name_from] = _state_name_to;
	}
	
	static process = function()/*->void*/ {
		var current_state_function/*:State*/ = __states[$ __current_state];
		if (current_state_function != undefined) {
			current_state_function.step();
		}
	}
	
	static draw = function()/*->void*/ {
		var current_state_function/*:State*/ = __states[$ __current_state];
		if (current_state_function != undefined) {
			current_state_function.draw();
		}
	}
}


function State(_state_machine/*:StateMachine*/) : PubSubHandler() constructor {
	__state_machine = _state_machine; /// @is {StateMachine}
	
	/// @override
	static start = function() {}
	
	/// @override
	static step = function() {}
	
	/// @override
	static draw = function() {}
	
	/// @override
	static pub_sub_perform = function(_event, _vars) {}
	
	/// @override
	static finish = function() {}
}


