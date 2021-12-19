note
	description: "Shared instance of object conforming to [$source EL_VISION_2_GUI_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-07 18:06:28 GMT (Tuesday 7th December 2021)"
	revision: "12"

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