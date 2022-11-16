note
	description: "Uninstall app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "3"

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