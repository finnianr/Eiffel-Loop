note
	description: "Summary description for {EL_MODULE_DIRECTORY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-06-27 18:24:54 GMT (Saturday 27th June 2015)"
	revision: "4"

class
	EL_MODULE_DIRECTORY

inherit
	EL_MODULE

feature -- Access

	Directory: EL_DIRECTORY_ROUTINES
			-- Directory routines using utf-8 encoded file paths
		once
			create Result.make
		end

end
