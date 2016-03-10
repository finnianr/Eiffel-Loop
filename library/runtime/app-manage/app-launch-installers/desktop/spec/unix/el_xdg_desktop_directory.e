note
	description: "Summary description for {EL_XDG_DIRECTORY_DESKTOP_ENTRY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-12-06 14:01:35 GMT (Friday 6th December 2013)"
	revision: "3"

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
