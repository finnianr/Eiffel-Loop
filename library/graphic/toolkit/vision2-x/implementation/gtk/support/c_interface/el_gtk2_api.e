note
	description: "Gtk2 api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-13 17:32:52 GMT (Thursday 13th December 2018)"
	revision: "1"

class
	EL_GTK2_API

feature {NONE} -- C externals

	frozen object_unref, g_object_unref (a_c_object: POINTER)
		external
			"C signature (gpointer) use <ev_gtk.h>"
		alias
			"g_object_unref"
		end

end
