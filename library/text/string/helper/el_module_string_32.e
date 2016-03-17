note
	description: "Summary description for {EL_MODULE_STRING_32}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-10-26 18:14:45 GMT (Monday 26th October 2015)"
	revision: "4"

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
