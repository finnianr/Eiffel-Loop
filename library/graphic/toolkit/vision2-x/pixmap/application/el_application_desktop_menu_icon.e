note
	description: "Application desktop menu icon accessible via [$source EL_MODULE_DESKTOP_MENU_ICON]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-04-22 9:14:04 GMT (Friday 22nd April 2022)"
	revision: "8"

class
	EL_APPLICATION_DESKTOP_MENU_ICON

inherit
	EL_APPLICATION_PIXMAP

feature -- Access

	image_path (relative_path: READABLE_STRING_GENERAL): FILE_PATH
		do
			Result := Image.desktop_menu_icon (new_file_path (relative_path))
		end

end