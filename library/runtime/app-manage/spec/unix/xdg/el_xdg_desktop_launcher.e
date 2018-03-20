note
	description: "Summary description for {EL_XDG_APPLICATION_DESKTOP_ENTRY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_XDG_DESKTOP_LAUNCHER

inherit
	EL_XDG_DESKTOP_MENU_ITEM
		rename
			make as make_from_path
		redefine
			getter_function_table
		end

	EL_DESKTOP_LAUNCHER
		rename
			make as make_entry
		undefine
			make_entry
		end

create
	make

feature {NONE} -- Initialization

	make (menu_path: ARRAY [EL_DESKTOP_MENU_ITEM]; entry: EL_DESKTOP_LAUNCHER)
			--
		local
			joined_path: like menu_path
		do
			joined_path := menu_path.twin
			joined_path.grow (joined_path.upper + 1)
			joined_path [joined_path.upper] := entry
			make_from_path (joined_path)
			set_command (entry.command)
			set_command_args (entry.command_args)
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result ["command"] := agent: ZSTRING do Result := command end
			Result ["command_args"] := agent: ZSTRING do Result := command_args end
		end

	Template: STRING_32 = "[
		[Desktop Entry]
		Version=1.0
		Encoding=UTF-8
		Name=$name
		Type=Application
		Comment=$comment
		Exec=$command $command_args
		Icon=$icon_path
		Terminal=false
		Name[en_IE]=$name
	]"

feature {NONE} -- Constants

	File_name_extension: STRING = "desktop"

end