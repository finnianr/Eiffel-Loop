note
	description: "Summary description for {EL_MODULE_DISPLAY_SCREEN}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-15 12:50:02 GMT (Sunday 15th May 2016)"
	revision: "5"

class
	EL_MODULE_DISPLAY_SCREEN

feature {NONE} -- Constants

	Display_screen: EL_SCREEN
		once
			create Result
		end
end