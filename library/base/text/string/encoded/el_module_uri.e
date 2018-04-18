note
	description: "Summary description for {EL_MODULE_URI}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-21 12:31:25 GMT (Friday 21st April 2017)"
	revision: "1"

class
	EL_MODULE_URI

inherit
	EL_MODULE

feature -- Access

	URI: EL_URI_ROUTINES
		once
			create Result
		end

end
