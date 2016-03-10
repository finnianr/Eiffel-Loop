note
	description: "Summary description for {EL_MODULE_STRING_8}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 22:12:57 GMT (Friday 18th December 2015)"
	revision: "4"

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
