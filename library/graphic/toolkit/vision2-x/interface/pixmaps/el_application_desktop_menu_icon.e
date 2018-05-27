note
	description: "Application desktop menu icon"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "4"

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