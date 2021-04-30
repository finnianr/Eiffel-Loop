note
	description: "Access to routines of [$source EL_STRING_8_BUFFER] via `Buffer_8'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-30 12:17:54 GMT (Friday 30th April 2021)"
	revision: "8"

deferred class
	EL_MODULE_BUFFER_8

inherit
	EL_MODULE

feature {NONE} -- Implementation

	Buffer_8: EL_STRING_8_BUFFER
		once
			create Result
		end

end