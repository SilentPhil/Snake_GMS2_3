/// @description	drag_end
//var diff_x	= event_data[? "posX"] - event_data[? "viewstartposX"];//event_data[? "diffX"];
//var diff_y	= event_data[? "posY"] - event_data[? "viewstartposY"];//event_data[? "diffY"];
var pos_x	= event_data[? "posX"];
var pos_y	= event_data[? "posY"];
var touch	= event_data[? "touch"];

pub_sub_event_perform(PS.event_gesture_dragging, [touch, pos_x, pos_y]);
pub_sub_event_perform(PS.event_gesture_drag_end, [touch, pos_x, pos_y]);

// log("dragging end", touch, pos_x, pos_y);