/// @description	dragging
var pos_x	= event_data[? "posX"];// - event_data[? "viewstartposX"];
var pos_y	= event_data[? "posY"];// - event_data[? "viewstartposY"];
var touch	= event_data[? "touch"];

pub_sub_event_perform(PS.event_gesture_dragging, [touch, pos_x, pos_y]);

//log(pos_x, pos_y, touch);