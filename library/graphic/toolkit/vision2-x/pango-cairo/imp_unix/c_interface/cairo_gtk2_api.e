note
	description: "GTK 2 API"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 12:41:38 GMT (Thursday 30th July 2020)"
	revision: "2"

class
	CAIRO_GTK2_API

feature {NONE} -- C externals

	frozen object_unref, g_object_unref (a_c_object: POINTER)
		external
			"C signature (gpointer) use <ev_gtk.h>"
		alias
			"g_object_unref"
		end

end
