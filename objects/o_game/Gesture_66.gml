/// @description	drag start
var pos_x	= event_data[? "posX"];
var pos_y	= event_data[? "posY"];
var touch	= event_data[? "touch"];
pub_sub_event_perform(PS.event_gesture_dragging, [touch, pos_x, pos_y]);
// log("dragging start", touch, pos_x, pos_y);