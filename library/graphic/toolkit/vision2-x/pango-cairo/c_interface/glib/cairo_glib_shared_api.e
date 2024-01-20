note
	description: "Shared access to instance of class conforming to ${CAIRO_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "12"

deferred class
	CAIRO_GLIB_SHARED_API

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	GLIB: CAIRO_GLIB_I
		once
			create {CAIRO_GLIB_API} Result.make
		end

end