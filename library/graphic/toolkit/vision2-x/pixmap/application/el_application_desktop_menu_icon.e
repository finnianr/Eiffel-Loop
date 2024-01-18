note
	description: "Application desktop menu icon accessible via ${EL_MODULE_DESKTOP_MENU_ICON}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "9"

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