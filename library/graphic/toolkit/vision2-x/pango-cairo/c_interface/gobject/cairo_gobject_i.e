note
	description: "GTK object interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "8"

deferred class
	CAIRO_GOBJECT_I

feature -- Access

	clear (a_c_object: TYPED_POINTER [POINTER])
		deferred
		end

	unref (a_c_object: POINTER)
		deferred
		end

end