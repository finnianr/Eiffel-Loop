note
	description: "GTK object interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-09 9:24:16 GMT (Tuesday 9th January 2024)"
	revision: "9"

deferred class
	CAIRO_GOBJECT_I

inherit
	EL_OS_DEPENDENT

feature -- Access

	clear (a_c_object: TYPED_POINTER [POINTER])
		deferred
		end

	unref (a_c_object: POINTER)
		deferred
		end

end