note
	description: "Summary description for {EL_MODULE_DIRECTORY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-14 23:52:23 GMT (Friday 14th June 2013)"
	revision: "2"

class
	EL_MODULE_DIRECTORY

inherit
	EL_MODULE

feature -- Access

	Directory: EL_DIRECTORY_NAMING_ROUTINES
			-- Directory routines using utf-8 encoded file paths
		once
			create Result
		end

end
