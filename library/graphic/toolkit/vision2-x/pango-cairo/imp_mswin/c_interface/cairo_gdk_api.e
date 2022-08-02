note
	description: "Windows implementation of [$source CAIRO_GDK_I]"
	notes: "[
		GDK wrapped to find physical dimensions of monitor, but not returning correct values
		on Windows.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-08-01 14:06:43 GMT (Monday 1st August 2022)"
	revision: "7"

class
	CAIRO_GDK_API

inherit
	EL_DYNAMIC_MODULE [CAIRO_GDK_API_POINTERS]
		rename
			initialize as initialize_api
		end

	CAIRO_GDK_I

	CAIRO_GDK_C_API

create
	make

feature -- Access

	default_display: POINTER
			--
		do
			Result := gdk_display_get_default (api.display_get_default)
		end

	default_root_window: POINTER
		do
			Result := gdk_get_default_root_window (api.get_default_root_window)
		end

	default_screen (display: POINTER): POINTER
		do
			Result := gdk_display_get_default_screen (api.display_get_default_screen,  display)
		end

	window_display (window: POINTER): POINTER
		do
			Result := gdk_window_get_display (api.window_get_display, window)
		end

	window_screen (window: POINTER): POINTER
		do
			Result := gdk_window_get_screen (api.window_get_screen, window)
		end

feature -- Measurement

	monitor_height_mm (screen: POINTER; monitor_num: INTEGER): INTEGER
		do
			Result := gdk_screen_get_monitor_height_mm (api.screen_get_monitor_height_mm, screen, monitor_num)
		end

	monitor_width_mm (screen: POINTER; monitor_num: INTEGER): INTEGER
			-- value returned is too big
		do
			Result := gdk_screen_get_monitor_width_mm (api.screen_get_monitor_width_mm, screen, monitor_num)
		end

	screen_width_mm (screen: POINTER): INTEGER
			-- value returned is too small
		do
			Result := gdk_screen_get_width_mm (api.screen_get_width_mm, screen)
		end

feature -- Basic operations

	initialize (argc, argv: POINTER)
		do
			gdk_init (api.init, argc, argv)
		end

	set_cairo_source_pixbuf (context, pixbuf: POINTER; x, y: REAL_64)
		do
			gdk_cairo_set_source_pixbuf (api.cairo_set_source_pixbuf, context, pixbuf, x, y)
		end

feature {NONE} -- Constants

	Module_name: STRING = "libgdk-3-0"

	Name_prefix: STRING = "gdk_"

end