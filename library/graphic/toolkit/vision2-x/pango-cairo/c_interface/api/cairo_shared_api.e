note
	description: "Shared Cairo api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 12:39:27 GMT (Thursday 30th July 2020)"
	revision: "8"

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
