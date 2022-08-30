INPUT_CONTROLLER.step();
GAME_CONTROLLER.step();

state_machine.process();

if (os_is_paused()) {
	pub_sub_event_perform(PS.event_app_events, ["foreground"]);
}