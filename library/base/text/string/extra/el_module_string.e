note
	description: "Shared access to routines of class [$source EL_ZSTRING_ROUTINES_IMP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-05 9:13:40 GMT (Saturday 5th November 2022)"
	revision: "13"

deferred class
	EL_MODULE_STRING

inherit
	EL_MODULE

feature {NONE} -- Constants

	String: EL_ZSTRING_ROUTINES_IMP
			--
		once
			create Result
		end

end