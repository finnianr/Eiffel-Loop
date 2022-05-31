note
	description: "Gdk api pointers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 12:34:00 GMT (Thursday 30th July 2020)"
	revision: "5"

class
	CAIRO_GDK_API_POINTERS

inherit
	EL_DYNAMIC_MODULE_POINTERS

create
	make

feature {EL_DYNAMIC_MODULE} -- Access

	display_get_default: POINTER

	get_default_root_window: POINTER

	display_get_default_screen: POINTER

	init: POINTER

	screen_get_monitor_width_mm: POINTER

	screen_get_monitor_height_mm: POINTER

	screen_get_width_mm: POINTER

	window_get_display: POINTER

	window_get_screen: POINTER

end
