note
	description: "Module string 32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:16:52 GMT (Monday 12th November 2018)"
	revision: "6"

class
	EL_MODULE_STRING_32

inherit
	EL_MODULE

feature {NONE} -- Constants

	String_32: EL_STRING_32_ROUTINES
			--
		once
			create Result
		end
end
