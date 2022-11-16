note
	description: "Module desktop menu icon"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "8"

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