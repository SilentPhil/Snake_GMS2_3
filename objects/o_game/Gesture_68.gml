/// @description	drag_end
var diff_x = event_data[? "posX"] - event_data[? "viewstartposX"];//event_data[? "diffX"];
var diff_y = event_data[? "posY"] - event_data[? "viewstartposY"];//event_data[? "diffY"];

pub_sub_event_perform(PS.event_gesture_drag_end, [diff_x, diff_y]);