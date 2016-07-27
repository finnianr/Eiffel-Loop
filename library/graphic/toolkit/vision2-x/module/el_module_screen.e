note
	description: "Summary description for {EL_MODULE_GRAPHICS_SYSTEM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 8:46:58 GMT (Friday 24th June 2016)"
	revision: "5"

class
	EL_MODULE_SCREEN

inherit
	EL_MODULE

feature -- Access

	Screen: EL_SCREEN_PROPERTIES_I
			--
		once ("PROCESS")
			create {EL_SCREEN_PROPERTIES_IMP} Result.make
		end

end