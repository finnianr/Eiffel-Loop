note
	description: "Unix implementation of ${CAIRO_GDK_I}"
	notes: "[
		GDK wrapped to find physical dimensions of monitor, but not returning correct values
		on Windows.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-09 9:23:57 GMT (Tuesday 9th January 2024)"
	revision: "8"

class
	CAIRO_GDK_API

inherit
	CAIRO_GDK_I
		rename
			default_create as make
		end

	GTK2
		rename
			default_create as make
		export
			{NONE} all
		end

	EL_GTK_2_C_API
		rename
			default_create as make
		export
			{NONE} all
		end

	EL_UNIX_IMPLEMENTATION
		rename
			default_create as make
		end

create
	make

feature -- Access

	default_display: POINTER
		do
			Result := gdk_display_get_default
		end

	default_screen (display: POINTER): POINTER
		do
			Result := gdk_display_get_default_screen (display)
		end

	default_root_window: POINTER
		do
			Result := gdk_get_default_root_window
		end

	window_display (window: POINTER): POINTER
		do
			Result := gdk_window_get_display (window)
		end

	window_screen (window: POINTER): POINTER
		do
			Result := gdk_window_get_screen (window)
		end

feature -- Measurement

	monitor_height_mm (screen: POINTER; monitor_num: INTEGER): INTEGER
		do
			Result := gdk_screen_get_monitor_height_mm (screen, monitor_num)
		end

	monitor_width_mm (screen: POINTER; monitor_num: INTEGER): INTEGER
		do
			Result := gdk_screen_get_monitor_width_mm (screen, monitor_num)
		end

	screen_width_mm (screen: POINTER): INTEGER
		do
			Result := gdk_screen_get_width_mm (screen)
		end

feature -- Basic operations

	initialize (argc, argv: POINTER)
		do
			gdk_init (argc, argv)
		end

	set_cairo_source_pixbuf (a_context, a_pixbuf: POINTER; a_pixbuf_x, a_pixbuf_y: REAL_64)
		do
			gdk_cairo_set_source_pixbuf (a_context, a_pixbuf, a_pixbuf_x, a_pixbuf_y)
		end

	pixbuf_unref (pixbuf: POINTER)
		do
			gdk_pixbuf_unref (pixbuf)
		end
end