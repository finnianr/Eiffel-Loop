note
	description: "Summary description for {EL_MODULE_STRING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-17 18:00:13 GMT (Wednesday 17th May 2017)"
	revision: "1"

class
	EL_MODULE_ZSTRING

inherit
	EL_MODULE

feature -- Access

	Zstring: EL_ZSTRING_ROUTINES
			--
		once
			create Result
		end
end
