note
	description: "Summary description for {EL_GTK2_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
