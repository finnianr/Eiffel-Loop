note
	description: "Module desktop menu icon"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:19:04 GMT (Monday 12th November 2018)"
	revision: "6"

deferred class
	EL_MODULE_DESKTOP_MENU_ICON

inherit
	EL_MODULE

feature {NONE} -- Constants

	Desktop_menu_icon: EL_APPLICATION_DESKTOP_MENU_ICON
			--
		once
			create Result
		end

end
