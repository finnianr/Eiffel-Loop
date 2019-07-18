note
	description: "Module string 32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 8:56:46 GMT (Monday 1st July 2019)"
	revision: "7"

deferred class
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
