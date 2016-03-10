note
	description: "Summary description for {EL_GTK_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "4"

deferred class
	EL_GOBJECT_I

feature -- Access

--	widget_get_snapshot (a_widget, a_rectangle: POINTER): POINTER
--		deferred
--		end

	object_unref (a_c_object: POINTER)
		deferred
		end

end
