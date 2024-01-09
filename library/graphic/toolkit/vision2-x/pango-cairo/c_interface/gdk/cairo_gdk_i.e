note
	description: "Interface to GDK API"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-09 9:21:47 GMT (Tuesday 9th January 2024)"
	revision: "5"

deferred class
	CAIRO_GDK_I

inherit
	EL_MEMORY_ROUTINES

	EL_OS_DEPENDENT

feature -- Access

	default_display: POINTER
			--
		deferred
		end

	default_root_window: POINTER
		deferred
		end

	default_screen (display: POINTER): POINTER
		require
			display_attached: is_attached (display)
		deferred
		end

	window_display (window: POINTER): POINTER
		deferred
		end

	window_screen (window: POINTER): POINTER
		deferred
		end

feature -- Measurement

	monitor_height_mm (screen: POINTER; monitor_num: INTEGER): INTEGER
		require
			screen_attached: is_attached (screen)
		deferred
		end

	monitor_width_mm (screen: POINTER; monitor_num: INTEGER): INTEGER
			-- value returned is too big
		require
			screen_attached: is_attached (screen)
		deferred
		end

	screen_width_mm (screen: POINTER): INTEGER
			-- value returned is too small
		deferred
		end

feature -- Basic operations

	initialize (argc, argv: POINTER)
		deferred
		end

	set_cairo_source_pixbuf (a_context, a_pixbuf: POINTER; a_pixbuf_x, a_pixbuf_y: REAL_64)
		deferred
		end

end