note
	description: "File system commands accepting default UTF-8 encoded arguments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_MODULE_FILE_SYSTEM

inherit
	EL_MODULE

feature -- Access

	File_system: EL_FILE_SYSTEM_ROUTINES
			-- File system routines using utf-8 encoded file paths
		once
			create Result
		end

end
