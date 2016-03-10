note
	description: "Summary description for {EL_MODULE_GRAPHICS_SYSTEM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-06-24 10:06:54 GMT (Wednesday 24th June 2015)"
	revision: "4"

class
	EL_MODULE_SCREEN

inherit
	EL_MODULE

feature -- Access

	Screen: EL_SCREEN_PROPERTIES
			--
		once ("PROCESS")
			create Result.make
		end

end
