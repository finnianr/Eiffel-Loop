note
	description: "Uninstall app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-15 14:39:30 GMT (Friday 15th June 2018)"
	revision: "1"

class
	UNINSTALL_APP

inherit
	EL_STANDARD_UNINSTALL_APP
		undefine
			Desktop_menu_path
		end

	INSTALLABLE_SUB_APPLICATION
		undefine
			name
		end

end
