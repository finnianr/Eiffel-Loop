note
	description: "Shared access to routines of class [$source EL_SYSTEM_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "8"

deferred class
	EL_MODULE_SYSTEM

inherit
	EL_MODULE

feature {NONE} -- Constants

	System: EL_SYSTEM_ROUTINES_I
		once
			create {EL_SYSTEM_ROUTINES_IMP} Result
		end
end