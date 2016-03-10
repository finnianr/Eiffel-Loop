note
	description: "Summary description for {EL_MODULE_GRAPHICS_SYSTEM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:13 GMT (Tuesday 2nd September 2014)"
	revision: "3"

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
