note
	description: "Summary description for {EL_MODULE_TYPING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-03 10:50:58 GMT (Sunday 3rd May 2015)"
	revision: "3"

class
	EL_MODULE_EIFFEL

inherit
	EL_MODULE

feature -- Access

	Eiffel: INTERNAL
			--
		once
			create Result
		end

end
