note
	description: "Summary description for {EL_MODULE_ICON}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_MODULE_ICON

inherit
	EL_MODULE

feature -- Access

	Icon: EL_APPLICATION_ICON
			--
		once
			create Result
		end

end
