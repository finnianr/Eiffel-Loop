note
	description: "Summary description for {EL_GTK_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

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