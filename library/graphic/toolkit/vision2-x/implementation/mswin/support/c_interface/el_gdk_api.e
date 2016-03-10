note
	description: "[
		GDK wrapped to find physical dimensions of monitor, but not returning correct values
		on Windows.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_GDK_API

inherit
	EL_DYNAMIC_MODULE

	EL_GDK_C_API
		undefine
			dispose
		end

create
	make

feature -- Access

	default_display: POINTER
			--
		do
			Result := gdk_display_get_default (pointer_default_display)
		end

	default_screen (display: POINTER): POINTER
		require
			display_attached: is_attached (display)
		do
			Result := gdk_display_get_default_screen (pointer_default_screen,  display)
		end

	default_root_window: POINTER
		do
			Result := gdk_get_default_root_window (pointer_default_root_window)
		end

	window_display (window: POINTER): POINTER
		do
			Result := gdk_window_get_display (pointer_window_display, window)
		end

	window_screen (window: POINTER): POINTER
		do
			Result := gdk_window_get_screen (pointer_window_screen, window)
		end

feature -- Measurement

	monitor_height_mm (screen: POINTER; monitor_num: INTEGER): INTEGER
		require
			screen_attached: is_attached (screen)
		do
			Result := gdk_screen_get_monitor_height_mm (pointer_monitor_height_mm, screen, monitor_num)
		end

	monitor_width_mm (screen: POINTER; monitor_num: INTEGER): INTEGER
			-- value returned is too big
		require
			screen_attached: is_attached (screen)
		do
			Result := gdk_screen_get_monitor_width_mm (pointer_monitor_width_mm, screen, monitor_num)
		end

	screen_width_mm (screen: POINTER): INTEGER
			-- value returned is too small
		do
			Result := gdk_screen_get_width_mm (pointer_screen_width_mm, screen)
		end

feature -- Basic operations

	initialize (argc, argv: POINTER)
		do
			gdk_init (pointer_initialize, argc, argv)
		end

feature {NONE} -- Implementation

	assign_pointers
		do
			pointer_default_display :=		function_pointer ("display_get_default")
			pointer_default_root_window:= function_pointer ("get_default_root_window")
			pointer_default_screen :=		function_pointer ("display_get_default_screen")
			pointer_initialize :=			function_pointer ("init")
			pointer_monitor_height_mm :=	function_pointer ("screen_get_monitor_height_mm")
			pointer_monitor_width_mm :=	function_pointer ("screen_get_monitor_width_mm")
			pointer_screen_width_mm :=		function_pointer ("screen_get_width_mm")
			pointer_window_display :=		function_pointer ("window_get_display")
			pointer_window_screen :=		function_pointer ("window_get_screen")
		end

feature {NONE} -- Implementation: attributes

	pointer_default_display: POINTER

	pointer_default_root_window: POINTER

	pointer_default_screen: POINTER

	pointer_initialize: POINTER

	pointer_monitor_width_mm: POINTER

	pointer_monitor_height_mm: POINTER

	pointer_screen_width_mm: POINTER

	pointer_window_display: POINTER

	pointer_window_screen: POINTER

feature {NONE} -- Constants

	Module_name: STRING = "libgdk-3-0"

	Name_prefix: STRING = "gdk_"

end
