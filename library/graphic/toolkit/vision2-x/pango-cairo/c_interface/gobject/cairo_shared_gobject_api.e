note
	description: "Shared access to instance of class conforming to ${CAIRO_GOBJECT_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "11"

deferred class
	CAIRO_SHARED_GOBJECT_API

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	Gobject: CAIRO_GOBJECT_I
		once ("PROCESS")
			create {CAIRO_GOBJECT_API} Result.make
		end

end