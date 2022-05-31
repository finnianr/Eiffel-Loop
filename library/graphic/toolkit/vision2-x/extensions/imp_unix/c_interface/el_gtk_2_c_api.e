note
	description: "GTK2 C interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-31 15:38:04 GMT (Tuesday 31st May 2022)"
	revision: "7"

class
	EL_GTK_2_C_API

inherit
	EL_C_API_ROUTINES

feature -- Access

    frozen g_error_message (error: POINTER): POINTER
            --
		require
			error_attached: is_attached (error)
      external
      	"C [struct <ev_gtk.h>] (GError): EIF_POINTER"
      alias
      	"message"
      end

	frozen widget_get_snapshot (a_widget, a_rectangle: POINTER): POINTER
			-- GdkPixmap * gtk_widget_get_snapshot (GtkWidget *widget, GdkRectangle *clip_rect);		
		external
			"C (GtkWidget*, GdkRectangle*): GdkPixmap* | <ev_gtk.h>"
		alias
			"gtk_widget_get_snapshot"
		end

	frozen gdk_get_default_root_window: POINTER
			-- GdkWindow * gdk_get_default_root_window (void);
		external
			"C (): GdkWindow* | <ev_gtk.h>"
		alias
			"gdk_get_default_root_window"
		end

	frozen gdk_window_get_display (window: POINTER): POINTER
			-- GdkDisplay * gdk_window_get_display (GdkWindow *window);
		external
			"C (GdkWindow *): GdkDisplay* | <ev_gtk.h>"
		alias
			"gdk_window_get_display"
		end

	frozen gdk_window_get_screen (window: POINTER): POINTER
			-- GdkScreen * gdk_window_get_screen (GdkWindow *window);
		external
			"C (GdkWindow *): GdkScreen* | <ev_gtk.h>"
		alias
			"gdk_window_get_screen"
		end

	frozen gdk_pixbuf_save_jpeg (a_pixbuf, a_file_handle, a_filetype, a_quality: POINTER; a_error: TYPED_POINTER [POINTER])
		external
			"C inline use <ev_gtk.h>"
		alias
			"[
				gdk_pixbuf_save (
					(GdkPixbuf*) $a_pixbuf, (char*) $a_file_handle, (char*) $a_filetype,
					(GError**) $a_error, "quality", (char*)$a_quality, NULL
				)
			]"
		end

feature -- Measurement

	frozen gdk_screen_get_monitor_height_mm (screen: POINTER; monitor_num: INTEGER): INTEGER
			-- gint gdk_screen_get_monitor_height_mm (GdkScreen *screen, gint monitor_num);
		external
			"C (GdkScreen *, gint): gint | <ev_gtk.h>"
		alias
			"gdk_screen_get_monitor_height_mm"
		end

	frozen gdk_screen_get_monitor_width_mm (screen: POINTER; monitor_num: INTEGER): INTEGER
			-- gint gdk_screen_get_monitor_width_mm (GdkScreen *screen, gint monitor_num);
		external
			"C (GdkScreen *, gint): gint | <ev_gtk.h>"
		alias
			"gdk_screen_get_monitor_width_mm"
		end

	frozen gtk_get_useable_screen_area (rectangle: POINTER)
			-- void gtk_get_useable_screen_area (gint *rectangle);
		external
			"C (gint*) | <ev_gtk.h>"
		alias
			"gtk_get_useable_screen_area"
		end

feature -- Basic operations

	frozen gdk_init (argc, argv: POINTER)
			-- void gdk_init (gint *argc, gchar ***argv);
		external
			"C (gint *, gchar ***) | <ev_gtk.h>"
		alias
			"gdk_init"
		end

	frozen gdk_cairo_set_source_pixbuf (a_context, a_pixbuf: POINTER; a_pixbuf_x, a_pixbuf_y: REAL_64)
		external
			"C signature (cairo_t *, GdkPixbuf *, double, double) use %"ev_gtk.h%""
		alias
			"gdk_cairo_set_source_pixbuf"
		end
end