note
	description: "Summary description for {EL_MODULE_STRING_32}."

	

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-18 9:28:15 GMT (Friday 18th August 2017)"
	revision: "2"

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