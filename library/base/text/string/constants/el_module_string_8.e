note
	description: "Summary description for {EL_MODULE_STRING_8}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "3"

class
	EL_MODULE_STRING_8

inherit
	EL_MODULE

feature -- Access

	String_8: EL_STRING_8_ROUTINES
			--
		once
			create Result
		end
end