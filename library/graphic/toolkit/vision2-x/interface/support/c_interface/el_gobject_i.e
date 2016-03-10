note
	description: "Summary description for {EL_GTK_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "3"

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
