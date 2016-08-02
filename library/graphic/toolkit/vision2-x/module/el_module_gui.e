note
	description: "Summary description for {EL_MODULE_GUI}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 8:48:16 GMT (Friday 24th June 2016)"
	revision: "1"

class
	EL_MODULE_GUI

inherit
	EL_MODULE

feature -- Access

	GUI: EL_VISION_2_GUI_ROUTINES_I
			--
		once ("PROCESS")
			create {EL_VISION_2_GUI_ROUTINES_IMP} Result.make
		end

end