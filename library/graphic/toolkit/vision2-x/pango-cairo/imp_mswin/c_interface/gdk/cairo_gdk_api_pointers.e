note
	description: "GDK API pointers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-08-01 14:05:44 GMT (Monday 1st August 2022)"
	revision: "7"

class
	CAIRO_GDK_API_POINTERS

inherit
	EL_DYNAMIC_MODULE_POINTERS

create
	make

feature {EL_DYNAMIC_MODULE} -- Access

	cairo_set_source_pixbuf: POINTER

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