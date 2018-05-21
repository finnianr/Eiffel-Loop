note
	description: "Gtk2"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
	revision: "3"

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

end