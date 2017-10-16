note
	description: "Summary description for {EL_MODULE_STRING_32}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "3"

class
	EL_MODULE_STRING_32

inherit
	EL_MODULE

feature -- Access

	String_32: EL_STRING_32_ROUTINES
			--
		once
			create Result
		end
end