note
	description: "Shared access to instance of class conforming to ${CAIRO_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "10"

deferred class
	CAIRO_SHARED_API

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	Cairo: CAIRO_I
		once ("PROCESS")
			create {CAIRO_API} Result.make
		end

end