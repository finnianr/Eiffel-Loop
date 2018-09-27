note
	description: "Gobject i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

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