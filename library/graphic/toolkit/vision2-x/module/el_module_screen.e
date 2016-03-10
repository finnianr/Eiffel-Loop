note
	description: "Summary description for {EL_MODULE_GRAPHICS_SYSTEM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-13 9:31:57 GMT (Monday 13th May 2013)"
	revision: "2"

class
	EL_MODULE_SCREEN

inherit
	EL_MODULE

feature -- Access

	Screen: EL_SCREEN_PROPERTIES
			--
		once
			create Result
		end

end
