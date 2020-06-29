note
	description: "Gtk2"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-29 10:02:49 GMT (Monday 29th June 2020)"
	revision: "6"

class
	EL_GTK2

inherit
	GTK2

feature -- Access

	frozen widget_get_snapshot (a_widget, a_rectangle: POINTER): POINTER
			-- GdkPixmap * gtk_widget_get_snapshot (GtkWidget *widget, GdkRectangle *clip_rect);		
		external
			"C (GtkWidget*, GdkRectangle*): GdkPixmap* | <ev_gtk.h>"
		alias
			"gtk_widget_get_snapshot"
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

end
