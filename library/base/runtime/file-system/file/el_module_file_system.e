note
	description: "Shared access to routines of class [$source EL_FILE_SYSTEM_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-07 7:08:01 GMT (Monday 7th February 2022)"
	revision: "9"

deferred class
	EL_MODULE_FILE_SYSTEM

inherit
	EL_MODULE

feature {NONE} -- Constants

	File_system: EL_FILE_SYSTEM_ROUTINES_I
			-- File system routines using utf-8 encoded file paths
		once
			create {EL_FILE_SYSTEM_ROUTINES_IMP} Result
		end

end