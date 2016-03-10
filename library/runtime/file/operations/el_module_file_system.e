note
	description: "File system commands accepting default UTF-8 encoded arguments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-14 22:58:19 GMT (Friday 14th June 2013)"
	revision: "2"

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
