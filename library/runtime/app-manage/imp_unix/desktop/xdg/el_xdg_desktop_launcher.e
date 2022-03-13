note
	description: "XDG desktop launcher"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-13 16:59:46 GMT (Sunday 13th March 2022)"
	revision: "10"

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

	make (a_desktop: like desktop; a_output_dir: DIR_PATH)
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
		#across $locale_table as $table loop
			#if $table.key = $en then
		Name=$table.item.name
			#else
		Name[$table.key]=$table.item.name
			#end
		#end
		Type=Application
		#across $locale_table as $table loop
			#if $table.key = $en then
		Comment=$table.item.comment
			#else
		Comment[$table.key]=$table.item.comment
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