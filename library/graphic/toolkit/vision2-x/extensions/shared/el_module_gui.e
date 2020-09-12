note
	description: "Shared instance of object conforming to [$source EL_VISION_2_GUI_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-11 12:57:55 GMT (Friday 11th September 2020)"
	revision: "11"

deferred class
	EL_MODULE_GUI

inherit
	EL_MODULE

feature {NONE} -- Constants

	GUI: EL_VISION_2_GUI_ROUTINES
			--
		once ("PROCESS")
			create Result.make
		end

end
