note
	description: "Application image"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:04 GMT (Monday 3rd January 2022)"
	revision: "5"

class
	EL_APPLICATION_IMAGE

inherit
	EL_APPLICATION_PIXMAP

feature -- Access

	image_path (relative_path_steps: EL_PATH_STEPS): FILE_PATH
		do
			Result := Mod_image_path.image (relative_path_steps)
		end

end
