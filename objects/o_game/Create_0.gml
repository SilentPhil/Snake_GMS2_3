instance_create_depth(0, 0, 0, o_pub_sub_controller);

render = new Render();	/// @is {Render}
#macro RENDER o_game.render	

game_controller = new GameController(); /// @is {GameController}
#macro GAME_CONTROLLER o_game.game_controller

GAME_CONTROLLER.start();


// var first_state:State = new State();
// first_state.start = function() {
// 	log("start first state!");
// }
// first_state.step = function() {
// 	log("step first state!");
// 	if (random(1) < 0.2) {
// 		return STATE_MACHINE_RESULT.END;
// 	}
// }
// first_state.finish = function() {
// 	log("finish first state!");
// }

// var second_state:State = new State();
// second_state.start = function() {
// 	log("start second state!");
// }
// second_state.step = function() {
// 	log("step second state!");
// 	if (random(1) < 0.2) {
// 		return STATE_MACHINE_RESULT.END;
// 	}	
// }
// second_state.finish = function() {
// 	log("finish second state!");
// }

// state_machine = new StateMachine();
// state_machine.add_state("first_state",  first_state);
// state_machine.add_state("second_state", second_state);
// state_machine.state_start("first_state");
// state_machine.state_control = function(_finished_state) {
// 	switch (_finished_state) {
// 		case "first_state":
// 			state_machine.state_start("second_state");
// 		break;
		
// 		case "second_state":
// 			state_machine.state_start("first_state");
// 		break;
// 	}
// }
