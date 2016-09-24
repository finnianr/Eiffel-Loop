note
	description: "Summary description for {EL_GDK_API_POINTERS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
