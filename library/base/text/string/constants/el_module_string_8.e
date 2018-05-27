note
	description: "Module string 8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "5"

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