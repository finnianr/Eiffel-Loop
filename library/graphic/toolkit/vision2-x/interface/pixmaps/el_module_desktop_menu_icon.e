note
	description: "Summary description for {EL_MODULE_DESKTOP_MENU}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "3"

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
