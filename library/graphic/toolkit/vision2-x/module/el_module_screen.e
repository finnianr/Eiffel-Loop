note
	description: "Summary description for {EL_MODULE_GRAPHICS_SYSTEM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-12 7:44:38 GMT (Monday 12th March 2018)"
	revision: "3"

class
	EL_MODULE_SCREEN

inherit
	EL_MODULE

feature -- Access

	Screen: EL_SCREEN
			--
		once ("PROCESS")
			create Result.make
		end

end
