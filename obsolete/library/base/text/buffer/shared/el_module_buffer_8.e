note
	description: "Access to routines of [$source EL_STRING_8_BUFFER] via `Buffer_8'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "9"

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