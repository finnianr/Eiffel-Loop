note
	description: "Summary description for {EL_XDG_DIRECTORY_DESKTOP_ENTRY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
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