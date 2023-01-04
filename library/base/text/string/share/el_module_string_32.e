note
	description: "Shared access to routines of class [$source EL_STRING_32_ROUTINES_IMP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-02 13:12:41 GMT (Friday 2nd December 2022)"
	revision: "15"

deferred class
	EL_MODULE_STRING_32

inherit
	EL_MODULE

feature {NONE} -- Constants

	String_32: EL_STRING_32_ROUTINES_IMP
			--
		once
			create Result
		end

end