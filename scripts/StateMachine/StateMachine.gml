function StateMachine() constructor {
	enum STATE_MACHINE_RESULT {
		IN_PROCESS,
		END,
	}
	
	__states = {};				/// @is {struct<State>}
	__current_state = "";		/// @is {string}
	
	static add_state = function(_state_name/*:string*/, _state_instance/*:State*/)/*->void*/ {
		__states[$ _state_name] = _state_instance;
	}

	static state_start = function(_state_name/*:string*/)/*->void*/ {
		__current_state = _state_name;
		var current_state_function = __states[$ __current_state];
		log(__current_state);
		current_state_function.start();
	}
	
	static process = function()/*->void*/ {
		var current_state_function = __states[$ __current_state];
		if (current_state_function != undefined) {
			var state_result = current_state_function.step();
			if (state_result == undefined) state_result = STATE_MACHINE_RESULT.IN_PROCESS;
			
			if (state_result == STATE_MACHINE_RESULT.END) {
				current_state_function.finish();
				self.state_control(__current_state);
			}
		}
	}
	
	/// @override
	static state_control = function(_finished_state)/*->void*/ {}
}

function State() constructor {
	/// @override
	static start = function() {}
	
	/// @override
	static step = function() {}
	
	/// @override
	static finish = function() {}
}


