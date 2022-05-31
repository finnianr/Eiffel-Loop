note
	description: "GTK object interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 12:29:38 GMT (Thursday 30th July 2020)"
	revision: "6"

deferred class
	CAIRO_GOBJECT_I

feature -- Access

--	widget_get_snapshot (a_widget, a_rectangle: POINTER): POINTER
--		deferred
--		end

	object_unref (a_c_object: POINTER)
		deferred
		end

end
