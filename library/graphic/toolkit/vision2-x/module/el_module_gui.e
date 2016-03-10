note
	description: "Summary description for {EL_MODULE_GUI}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_MODULE_GUI

inherit
	EL_MODULE

feature -- Access

	GUI: EL_VISION_2_GUI_ROUTINES
			--
		once ("PROCESS")
			create Result.make
		end

end
