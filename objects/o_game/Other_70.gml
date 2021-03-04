var type = async_load[? "type"];
var data = async_load[? "data"];
switch (type) {
	case "ex_foreground_watcher":
		pub_sub_event_perform(PS.event_app_events, [data]);
	break;
}