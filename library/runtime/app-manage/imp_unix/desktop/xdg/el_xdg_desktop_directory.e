note
	description: "Xdg desktop directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "6"

class
	EL_XDG_DESKTOP_DIRECTORY

inherit
	EL_XDG_DESKTOP_MENU_ITEM

create
	make

feature -- Access

	new_file_path: EL_FILE_PATH
		do
			Result := Directories_desktop_dir + file_name
		end

feature {NONE} -- Evolicity reflection

	Template: STRING = "[
		[Desktop Entry]
		Encoding=UTF-8
		Type=Directory
		Comment=$comment
		Icon=$icon_path
		Name=$name
	]"

feature {NONE} -- Constants

	File_name_extension: STRING = "directory"

end
