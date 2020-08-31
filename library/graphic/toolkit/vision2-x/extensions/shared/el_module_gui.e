note
	description: "Shared instance of object conforming to [$source EL_VISION_2_GUI_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-31 13:54:06 GMT (Monday 31st August 2020)"
	revision: "10"

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
