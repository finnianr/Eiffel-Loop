note
	description: "Summary description for {MODULE_RHYTHMBOX}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	MODULE_RHYTHMBOX

inherit
	EL_MODULE

feature -- Access

	Rhythmbox: RBOX_CONSTANTS
			-- Directory routines using utf-8 encoded file paths
		once
			create Result
		end

end
