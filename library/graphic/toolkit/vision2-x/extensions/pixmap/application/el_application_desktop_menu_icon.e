note
	description: "Application desktop menu icon accessible via [$source EL_MODULE_DESKTOP_MENU_ICON]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-25 9:17:26 GMT (Wednesday   25th   September   2019)"
	revision: "6"

class
	EL_APPLICATION_DESKTOP_MENU_ICON

inherit
	EL_APPLICATION_PIXMAP

feature -- Access

	image_path (relative_path_steps: EL_PATH_STEPS): EL_FILE_PATH
		do
			Result := Mod_image_path.desktop_menu_icon (relative_path_steps)
		end

end
