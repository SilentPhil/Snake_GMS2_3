var dx = (keyboard_check(vk_right) - keyboard_check(vk_left));
var dy = (keyboard_check(vk_down)  - keyboard_check(vk_up));

if (dx != 0 || dy != 0) {
	if (dx != 0) {
		var side/*:SIDE*/ = (dx == 1 ? SIDE.RIGHT : SIDE.LEFT);
	} else if (dy != 0) {
		var side/*:SIDE*/ = (dy == 1 ? SIDE.DOWN : SIDE.UP);
	}
	var snake/*:Snake*/ = GAME_CONTROLLER.__snake;
	snake.turn(side);
}

if (keyboard_check_pressed(ord("W"))) {
	GAME_CONTROLLER.change_game_speed(+1);
}
if (keyboard_check_pressed(ord("Q"))) {
	GAME_CONTROLLER.change_game_speed(-1);
}

GAME_CONTROLLER.step();