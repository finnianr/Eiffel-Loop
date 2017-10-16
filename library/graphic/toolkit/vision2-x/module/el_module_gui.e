note
	description: "Summary description for {EL_MODULE_GUI}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

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