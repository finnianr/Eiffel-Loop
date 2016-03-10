note
	description: "Summary description for {EL_GDK_C_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_GDK_C_API

inherit
	EL_MEMORY

feature -- Access

	frozen gdk_display_get_default (function: POINTER): POINTER
			-- GdkDisplay * gdk_display_get_default (void);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <gdk/gdk.h>"
		alias
			"[
				return (
					FUNCTION_CAST(GdkDisplay *, (void))$function
				) ()
			]"
		end

	frozen gdk_display_get_default_screen (function, display: POINTER): POINTER
			-- GdkScreen * gdk_display_get_default_screen (GdkDisplay *display);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <gdk/gdk.h>"
		alias
			"[
				return (
					FUNCTION_CAST(GdkScreen *, (GdkDisplay *display))$function
				) (
					(GdkDisplay *)$display
				)
			]"
		end

	frozen gdk_get_default_root_window (function: POINTER): POINTER
			-- GdkWindow * gdk_get_default_root_window (void);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <gdk/gdk.h>"
		alias
			"[
				return (
					FUNCTION_CAST(GdkWindow *, (void))$function
				) ()
			]"
		end

	frozen gdk_window_get_display (function, window: POINTER): POINTER
			-- GdkDisplay * gdk_window_get_display (GdkWindow *window);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <gdk/gdk.h>"
		alias
			"[
				return (
					FUNCTION_CAST(GdkDisplay *, (GdkWindow *window))$function
				) (
					(GdkWindow *)$window
				)
			]"
		end

	frozen gdk_window_get_screen (function, window: POINTER): POINTER
			-- GdkScreen * gdk_window_get_screen (GdkWindow *window);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <gdk/gdk.h>"
		alias
			"[
				return (
					FUNCTION_CAST(GdkScreen *, (GdkWindow *window))$function
				) (
					(GdkWindow *)$window
				)
			]"
		end

feature -- Measurement

	frozen gdk_screen_get_monitor_height_mm (function, screen: POINTER; monitor_num: INTEGER): INTEGER
			-- gint gdk_screen_get_monitor_height_mm (GdkScreen *screen, gint monitor_num);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <gdk/gdk.h>"
		alias
			"[
				return (
					FUNCTION_CAST(gint, (GdkScreen *, gint))$function
				) (
					(GdkScreen *)$screen, (gint)$monitor_num
				)
			]"
		end

	frozen gdk_screen_get_monitor_width_mm (function, screen: POINTER; monitor_num: INTEGER): INTEGER
			-- gint gdk_screen_get_monitor_width_mm (GdkScreen *screen, gint monitor_num);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <gdk/gdk.h>"
		alias
			"[
				return (
					FUNCTION_CAST(gint, (GdkScreen *, gint))$function
				) (
					(GdkScreen *)$screen, (gint)$monitor_num
				)
			]"
		end

	frozen gdk_screen_get_width_mm (function, screen: POINTER): INTEGER
			-- gint gdk_screen_get_width_mm (GdkScreen *screen);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <gdk/gdk.h>"
		alias
			"[
				return (
					FUNCTION_CAST(gint, (GdkScreen *))$function
				) (
					(GdkScreen *)$screen
				)
			]"
		end

feature -- Basic operations

	frozen gdk_init (function, argc, argv: POINTER)
			-- void gdk_init (gint *argc, gchar ***argv);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <gdk/gdk.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (gint *, gchar ***))$function
				) (
					(gint *)$argc, (gchar ***)$argv
				)
			]"
		end

end
