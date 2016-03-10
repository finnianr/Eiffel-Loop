note
	description: "Summary description for {EL_XDG_DIRECTORY_DESKTOP_ENTRY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-16 18:16:54 GMT (Sunday 16th June 2013)"
	revision: "2"

class
	EL_XDG_DESKTOP_DIRECTORY

inherit
	EL_XDG_DESKTOP_MENU_ITEM

create
	make

feature {NONE} -- Constants

	File_name_extension: STRING = "directory"

feature {NONE} -- Evolicity reflection

	Template: STRING = "[
		[Desktop Entry]
		Encoding=UTF-8
		Type=Directory
		Comment=$comment
		Icon=$icon_path
		Name=$name
	]"

end
