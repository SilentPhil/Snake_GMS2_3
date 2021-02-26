/// @arg date
function date_build_string(_date) {
	return string(date_get_hour(_date)) + ":" + string(date_get_minute(_date)) + " " + string(date_get_day(_date)) + "." + string(date_get_month(_date)) + "." + string(date_get_year(_date));
}