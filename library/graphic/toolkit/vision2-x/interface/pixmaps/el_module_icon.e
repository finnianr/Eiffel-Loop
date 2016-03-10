note
	description: "Summary description for {EL_MODULE_ICON}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-21 11:25:46 GMT (Thursday 21st March 2013)"
	revision: "2"

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
