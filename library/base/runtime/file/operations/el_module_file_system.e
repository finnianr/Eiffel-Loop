note
	description: "File system commands accepting default UTF-8 encoded arguments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-03 9:33:10 GMT (Monday 3rd October 2016)"
	revision: "2"

class
	EL_MODULE_FILE_SYSTEM

inherit
	EL_MODULE

feature -- Access

	File_system: EL_FILE_SYSTEM_ROUTINES_I
			-- File system routines using utf-8 encoded file paths
		once
			create {EL_FILE_SYSTEM_ROUTINES_IMP} Result
		end

end
