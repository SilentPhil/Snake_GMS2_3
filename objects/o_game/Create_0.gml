view_init(DEVICE.IPHONE_7);

instance_create_depth(0, 0, 0, o_pub_sub_controller);

randomize();
gml_release_mode(true);
display_set_timing_method(tm_sleep);
game_set_speed(30, gamespeed_fps);

game_controller 	= new GameController(); /// @is {GameController}
input_controller	= new InputController(); /// @is {InputController}

#macro GAME_CONTROLLER	o_game.game_controller
#macro INPUT_CONTROLLER o_game.input_controller

GAME_CONTROLLER.start();

global.font = font_add_sprite_ext(s_font, "ABCDEFGHIJKLMNOPQRSTUVWXYZ 1234567890_@!?#$%><()^*:;.,", false, 0);	/// @is {font}

state_machine = new StateMachine();	/// @is {StateMachine}
state_machine.add_state("pause_before_game",	new StatePauseBeforeGame(state_machine));
state_machine.add_state("pause",				new StatePause(state_machine));
state_machine.add_state("gameplay", 			new StateGameplay(state_machine));
state_machine.initial_state("pause_before_game");
state_machine.link_state_with_other_state("pause_before_game", "gameplay");
state_machine.link_state_with_other_state("pause", "gameplay");
state_machine.link_state_with_other_state("gameplay", "pause");

app_foreground_watcher_init();