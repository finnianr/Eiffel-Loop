note
	description: "Gdk api pointers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_GDK_API_POINTERS

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
