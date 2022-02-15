note
	description: "Application icon"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-15 17:48:22 GMT (Tuesday 15th February 2022)"
	revision: "7"

class
	EL_APPLICATION_ICON

inherit
	EL_APPLICATION_PIXMAP

feature -- Access

	image_path (relative_path_steps: FILE_PATH): FILE_PATH
		do
			Result := Mod_image_path.icon (relative_path_steps)
		end

end