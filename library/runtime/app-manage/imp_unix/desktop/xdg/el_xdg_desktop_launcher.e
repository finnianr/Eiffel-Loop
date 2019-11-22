note
	description: "XDG desktop launcher"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-22 19:02:56 GMT (Friday 22nd November 2019)"
	revision: "8"

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

	make (a_desktop: like desktop; a_output_dir: EL_DIR_PATH)
			--
		do
			desktop := a_desktop
			make_item (a_desktop.launcher, a_output_dir)
		end

feature {NONE} -- Internal attributes

	desktop: EL_MENU_DESKTOP_ENVIRONMENT_I

feature {NONE} -- Evolicity reflection

	Template: STRING = "[
		#!/usr/bin/env xdg-open
		[Desktop Entry]
		Version=1.0
		Encoding=UTF-8
		#across $localized_names as $name loop
			#if $name.key = $en then
		Name=$name.item
			#else
		Name[$name.key]=$name.item
			#end
		#end
		Type=Application
		#across $localized_comments as $comment loop
			#if $comment.key = $en then
		Comment=$comment.item
			#else
		Comment[$comment.key]=$comment.item
			#end
		#end
		Exec=$app.launch_command $app.command_args
		Icon=$icon_path
		Terminal=false
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
