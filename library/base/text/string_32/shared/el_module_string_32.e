note
	description: "Shared access to routines of class ${EL_STRING_32_ROUTINES_IMP}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 12:42:04 GMT (Tuesday 20th August 2024)"
	revision: "17"

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