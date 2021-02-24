instance_create_depth(0, 0, 0, o_pub_sub_controller);
gml_release_mode(true);
display_set_timing_method(tm_sleep);
game_set_speed(30, gamespeed_fps);

game_controller = new GameController(); /// @is {GameController}
#macro GAME_CONTROLLER o_game.game_controller

input_controller = new InputController(); /// @is {InputController}
#macro INPUT_CONTROLLER o_game.input_controller

GAME_CONTROLLER.start();