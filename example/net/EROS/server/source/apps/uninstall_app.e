note
	description: "Uninstall app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-10 9:23:07 GMT (Friday 10th January 2020)"
	revision: "2"

class
	UNINSTALL_APP

inherit
	EL_STANDARD_UNINSTALL_APP
		undefine
			Desktop_menu_path
		end

	INSTALLABLE_EROS_SUB_APPLICATION
		undefine
			name
		end

end
