note
	description: "File system commands accepting default UTF-8 encoded arguments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 8:57:45 GMT (Monday 1st July 2019)"
	revision: "5"

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
