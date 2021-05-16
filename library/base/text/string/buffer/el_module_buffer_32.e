note
	description: "Access to routines of [$source EL_STRING_32_BUFFER_ROUTINES] via `buffer_32'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-16 18:50:19 GMT (Sunday 16th May 2021)"
	revision: "7"

deferred class
	EL_MODULE_BUFFER_32

inherit
	EL_MODULE

feature {NONE} -- Implementation

	Buffer_32: EL_STRING_32_BUFFER
		once
			create Result
		end
end