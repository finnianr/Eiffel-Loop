note
	description: "[
		Unix implementation of [$source EL_FILE_CONTEXT_MENU_DESKTOP_ENV_I] interface
		Installer for GNOME desktop. Creates Nautilus script program launcher.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	EL_FILE_CONTEXT_MENU_DESKTOP_ENV_IMP

inherit
	EL_FILE_CONTEXT_MENU_DESKTOP_ENV_I
		undefine
			command_path
		end

	EL_DESKTOP_ENVIRONMENT_IMP
		rename
			make as make_installer,
			command_args_template as launch_script_template,
			command_args as script_args
		undefine
			getter_function_table, make_default
		end

create
	make

feature {NONE} -- Constants

	Launch_script_location: DIR_PATH
		once
			Result := ".gnome2/nautilus-scripts"
		end

	Launch_script_template: STRING =
		-- Substitution template

		--| Despite appearances the tab level is 0
		--| All leading tabs are removed by Eiffel compiler to match the first line
	"[
		#!/bin/sh
		
		#if $has_path_argument then
		for FILE_PATH in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
		do
			PATH_ARG=$FILE_PATH
		done
		#end
		
		#if $has_path_argument then
			gnome-terminal --command="$executable_name -$sub_application_option $command_options -$input_path_option_name $PATH_ARG" \
				--geometry 140x50+100+100 --title="$menu_name" \
				--working-directory "$working_directory"
		#else
			gnome-terminal --command="$executable_name -$sub_application_option $command_options" \
				--geometry 140x50+100+100 --title="$menu_name" \
				--working-directory "$working_directory"
		#end
	]"

end