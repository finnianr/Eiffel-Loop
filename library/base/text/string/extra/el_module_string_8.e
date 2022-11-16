note
	description: "Shared access to routines of class [$source EL_STRING_8_ROUTINES_IMP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "14"

deferred class
	EL_MODULE_STRING_8

inherit
	EL_MODULE

feature {NONE} -- Constants

	String_8: EL_STRING_8_ROUTINES_IMP
			--
		once
			create Result
		end

end