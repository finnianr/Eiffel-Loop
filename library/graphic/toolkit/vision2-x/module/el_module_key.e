note
	description: "Summary description for {EL_MODULE_KEY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-14 11:51:55 GMT (Sunday 14th December 2014)"
	revision: "3"

class
	EL_MODULE_KEY

feature -- Access

	Key: EV_KEY_CONSTANTS
		once
			create Result
		end

end
