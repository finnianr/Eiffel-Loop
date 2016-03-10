note
	description: "Summary description for {EL_MODULE_EXCEPTIONS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-18 19:55:41 GMT (Tuesday 18th December 2012)"
	revision: "1"

class
	EL_MODULE_EXCEPTIONS

inherit
	EL_MODULE

feature -- Access

	Exceptions: EXCEPTIONS
			--
		once
			create Result
		end
end
