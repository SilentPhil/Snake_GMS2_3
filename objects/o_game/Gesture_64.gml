var pos_x = event_data[? "posX"];
var pos_y = event_data[? "posY"];

pub_sub_event_perform(PS.event_gesture_tap, [pos_x, pos_y]);