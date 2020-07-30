note
	description: "Gtk init api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 12:41:48 GMT (Thursday 30th July 2020)"
	revision: "6"

class
	CAIRO_GTK_INIT_API

feature {NONE} -- C externals	

	frozen c_gtk_get_useable_screen_area (rectangle: POINTER)
			-- void gtk_get_useable_screen_area (gint *rectangle);
		external
			"C (gint*) | <gtk-init.h>"
		alias
			"gtk_get_useable_screen_area"
		end
end
