note
	description: "Summary description for {EL_GTK_INIT_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_GTK_INIT_API

feature {NONE} -- C externals	

	frozen c_gtk_get_useable_screen_area (rectangle: POINTER)
			-- void gtk_get_useable_screen_area (gint *rectangle);
		external
			"C (gint*) | <gtk-init.h>"
		alias
			"gtk_get_useable_screen_area"
		end
end