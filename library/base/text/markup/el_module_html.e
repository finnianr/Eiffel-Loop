note
	description: "Summary description for {EL_MODULE_HTML}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-24 12:01:29 GMT (Sunday 24th May 2015)"
	revision: "5"

class
	EL_MODULE_HTML

inherit
	EL_MODULE

feature -- Access

	Html: EL_HTML_ROUTINES
			--
		once
			create Result
		end
end
