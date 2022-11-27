note
	description: "Shared access to routines of class conforming to [$source EL_FILE_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "10"

deferred class
	EL_MODULE_FILE

inherit
	EL_MODULE

feature {NONE} -- Constants

	File: EL_FILE_ROUTINES_I
		once
			create {EL_FILE_ROUTINES_IMP} Result.make
		end

end