note
	description: "Gdk C API"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-07 11:16:16 GMT (Sunday 7th January 2024)"
	revision: "12"

class
	CAIRO_GDK_C_API

inherit
	EL_C_API

	EL_WINDOWS_IMPLEMENTATION

feature -- Access

	frozen g_error_message (error: POINTER): POINTER
		require
			error_attached: is_attached (error)
		external
			"C [struct <gdk/gdk.h>] (GError): EIF_POINTER"
		alias
			"message"
		end

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

	frozen gdk_cairo_set_source_pixbuf (function, context, pixbuf: POINTER; x, y: REAL_64)
		-- C signature (cairo_t *, GdkPixbuf *, double, double)
		external
			"C inline use <gdk/gdk.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *, GdkPixbuf *, double, double))$function
				) (
					(cairo_t *)$context, (GdkPixbuf *)$pixbuf, (double)$x, (double)$y
				)
			]"
		end

end