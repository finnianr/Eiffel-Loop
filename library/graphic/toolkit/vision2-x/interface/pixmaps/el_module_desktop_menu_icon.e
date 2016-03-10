note
	description: "Summary description for {EL_MODULE_DESKTOP_MENU}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-21 12:11:54 GMT (Thursday 21st March 2013)"
	revision: "2"

class
	EL_MODULE_DESKTOP_MENU_ICON

inherit
	EL_MODULE

feature -- Access

	Desktop_menu_icon: EL_APPLICATION_DESKTOP_MENU_ICON
			--
		once
			create Result
		end

end
