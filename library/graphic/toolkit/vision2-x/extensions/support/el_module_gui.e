note
	description: "Module gui"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:16:14 GMT (Monday 12th November 2018)"
	revision: "6"

class
	EL_MODULE_GUI

inherit
	EL_MODULE

feature {NONE} -- Constants

	GUI: EL_VISION_2_GUI_ROUTINES_I
			--
		once ("PROCESS")
			create {EL_VISION_2_GUI_ROUTINES_IMP} Result.make
		end

end
