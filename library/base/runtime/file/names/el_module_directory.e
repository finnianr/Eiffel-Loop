note
	description: "Summary description for {EL_MODULE_DIRECTORY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 8:47:41 GMT (Friday 24th June 2016)"
	revision: "5"

class
	EL_MODULE_DIRECTORY

inherit
	EL_MODULE

feature -- Access

	Directory: EL_STANDARD_DIRECTORY_I
			-- Directory routines using utf-8 encoded file paths
		once
			create {EL_STANDARD_DIRECTORY_IMP} Result
		end

end