note
	description: "Summary description for {EL_MODULE_URL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-28 10:24:30 GMT (Sunday 28th July 2013)"
	revision: "2"

class
	EL_MODULE_URL

inherit
	EL_MODULE

feature -- Access

	Url: EL_URL_ROUTINES
			-- Url routines using utf-8 encoded file paths
		once
			create Result
		end

end