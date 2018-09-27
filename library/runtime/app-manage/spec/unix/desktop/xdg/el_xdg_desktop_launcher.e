note
	description: "Xdg desktop launcher"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "7"

class
	EL_XDG_DESKTOP_LAUNCHER

inherit
	EL_XDG_DESKTOP_MENU_ITEM
		rename
			make as make_item
		redefine
			getter_function_table
		end

create
	make

feature {NONE} -- Initialization

	make (a_desktop: like desktop)
			--
		do
			desktop := a_desktop
			make_item (a_desktop.launcher)
		end

feature -- Access

	new_file_path: EL_FILE_PATH
		do
			Result := Applications_desktop_dir + file_name
		end

feature {NONE} -- Internal attributes

	desktop: EL_MENU_DESKTOP_ENVIRONMENT_I

feature {NONE} -- Evolicity reflection

	Template: STRING_32 = "[
		#!/usr/bin/env xdg-open
		[Desktop Entry]
		Version=1.0
		Encoding=UTF-8
		Name=$name
		Type=Application
		Comment=$comment
		Exec=$app.launch_command $app.command_args
		Icon=$icon_path
		Terminal=false
		Name[en_IE]=$name
	]"

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result ["app"] := agent: like desktop do Result := desktop end
		end

feature {NONE} -- Constants

	File_name_extension: STRING = "desktop"

end
