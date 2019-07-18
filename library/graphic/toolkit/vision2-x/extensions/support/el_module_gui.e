note
	description: "Module GUI routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:23:11 GMT (Monday 1st July 2019)"
	revision: "9"

deferred class
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
