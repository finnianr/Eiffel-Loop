note
	description: "Gobject i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
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